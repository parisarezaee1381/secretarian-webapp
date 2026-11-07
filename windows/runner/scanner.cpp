#include "scanner.h"

#include <windows.h>

#include <winrt/Windows.Devices.Enumeration.h>
#include <winrt/Windows.Devices.Scanners.h>
#include <winrt/Windows.Foundation.Collections.h>
#include <winrt/Windows.Foundation.h>
#include <winrt/Windows.Graphics.Imaging.h>
#include <winrt/Windows.Storage.h>
#include <winrt/Windows.Storage.Streams.h>

#include <flutter/encodable_value.h>
#include <flutter/event_stream_handler_functions.h>
#include <flutter/method_result.h>
#include <flutter/standard_method_codec.h>

#include <algorithm>
#include <atomic>
#include <chrono>
#include <exception>
#include <filesystem>
#include <fstream>
#include <functional>
#include <memory>
#include <sstream>
#include <string>
#include <thread>
#include <vector>

namespace fs = std::filesystem;

using flutter::EncodableList;
using flutter::EncodableMap;
using flutter::EncodableValue;

namespace {

using winrt::Windows::Devices::Enumeration::DeviceInformation;
using winrt::Windows::Devices::Enumeration::DeviceInformationCollection;
using winrt::Windows::Devices::Scanners::ImageScanner;
using winrt::Windows::Devices::Scanners::ImageScannerColorMode;
using winrt::Windows::Devices::Scanners::ImageScannerResolution;
using winrt::Windows::Devices::Scanners::ImageScannerScanResult;
using winrt::Windows::Devices::Scanners::ImageScannerScanSource;
using winrt::Windows::Graphics::Imaging::BitmapDecoder;
using winrt::Windows::Graphics::Imaging::BitmapEncoder;
using winrt::Windows::Storage::StorageFolder;
using winrt::Windows::Storage::Streams::DataReader;
using winrt::Windows::Storage::Streams::DataWriter;
using winrt::Windows::Storage::Streams::InMemoryRandomAccessStream;

constexpr int kDefaultDpi = 300;
constexpr int kMaxDpi = 1200;
constexpr int kMinDpi = 100;
constexpr int kMaxPages = 100;
constexpr int kMaxScanSeconds = 600;
constexpr size_t kMaxFileBytes = 512ull * 1024 * 1024;  // 512 MB per page.

// WIA / scanner hresult codes we translate into friendly Dart error codes.
constexpr int32_t kWiaErrorPaperEmpty = 0x80210006;
constexpr int32_t kWiaErrorUserIntervention = 0x8021000E;
constexpr int32_t kWiaErrorOffline = 0x80210015;
constexpr int32_t kWiaErrorBusy = 0x8021000A;

std::string ToUtf8(const std::wstring& wide) {
  if (wide.empty()) {
    return {};
  }
  const int size = ::WideCharToMultiByte(CP_UTF8, 0, wide.c_str(),
                                         static_cast<int>(wide.size()),
                                         nullptr, 0, nullptr, nullptr);
  std::string out(static_cast<size_t>(size), 0);
  ::WideCharToMultiByte(CP_UTF8, 0, wide.c_str(), static_cast<int>(wide.size()),
                        out.data(), size, nullptr, nullptr);
  return out;
}

int32_t GetIntArg(const EncodableMap& map, const char* key, int32_t fallback) {
  const auto it = map.find(EncodableValue(key));
  if (it == map.end()) {
    return fallback;
  }
  if (const auto* value = std::get_if<int32_t>(&it->second)) {
    return *value;
  }
  if (const auto* value = std::get_if<int64_t>(&it->second)) {
    return static_cast<int32_t>(*value);
  }
  return fallback;
}

std::string GetStringArg(const EncodableMap& map, const char* key) {
  const auto it = map.find(EncodableValue(key));
  if (it == map.end()) {
    return {};
  }
  if (const auto* value = std::get_if<std::string>(&it->second)) {
    return *value;
  }
  return {};
}

bool GetBoolArg(const EncodableMap& map, const char* key, bool fallback) {
  const auto it = map.find(EncodableValue(key));
  if (it == map.end()) {
    return fallback;
  }
  if (const auto* value = std::get_if<bool>(&it->second)) {
    return *value;
  }
  return fallback;
}

std::vector<uint8_t> ReadFileBytes(const fs::path& path) {
  std::ifstream file(path, std::ios::binary | std::ios::ate);
  if (!file) {
    return {};
  }
  const std::streamsize size = file.tellg();
  if (size <= 0 || static_cast<size_t>(size) > kMaxFileBytes) {
    return {};
  }
  std::vector<uint8_t> bytes(static_cast<size_t>(size));
  file.seekg(0);
  file.read(reinterpret_cast<char*>(bytes.data()), size);
  if (!file) {
    return {};
  }
  return bytes;
}

bool CreateTempDir(fs::path& out) {
  wchar_t temp[MAX_PATH];
  if (::GetTempPathW(MAX_PATH, temp) == 0) {
    return false;
  }
  wchar_t dir[MAX_PATH];
  swprintf_s(dir, L"%ssecretarian_scan_%lld", temp,
             static_cast<long long>(std::chrono::system_clock::now()
                                        .time_since_epoch()
                                        .count()));
  std::error_code ec;
  if (!fs::create_directories(dir, ec) || ec) {
    return false;
  }
  out = dir;
  return true;
}

bool HasPngMagic(const std::vector<uint8_t>& bytes) {
  return bytes.size() >= 8 && bytes[0] == 0x89 && bytes[1] == 0x50 &&
         bytes[2] == 0x4E && bytes[3] == 0x47;
}

// Reads a completed scan output file and returns its PNG bytes, transcoding
// any non-PNG bitmap (e.g. DIB or JPEG written by the driver) via WIC.
std::vector<uint8_t> PageBytesFromFile(const fs::path& path) {
  const std::vector<uint8_t> raw = ReadFileBytes(path);
  if (raw.empty()) {
    return {};
  }
  if (HasPngMagic(raw)) {
    return raw;
  }

  try {
    // Decode whatever the driver produced.
    InMemoryRandomAccessStream input;
    {
      DataWriter writer(input.GetOutputStreamAt(0));
      writer.WriteBytes(raw);
      writer.StoreAsync().get();
      writer.FlushAsync().get();
      writer.DetachStream();  // Keep the stream alive after writer destruction.
    }
    input.Seek(0);

    BitmapDecoder decoder = BitmapDecoder::CreateAsync(input).get();

    // Re-encode as PNG.
    InMemoryRandomAccessStream output;
    BitmapEncoder encoder =
        BitmapEncoder::CreateAsync(BitmapEncoder::PngEncoderId(), output).get();
    encoder.SetSoftwareBitmap(decoder.GetSoftwareBitmapAsync().get());
    encoder.FlushAsync().get();

    output.Seek(0);
    const UINT64 size = output.Size();
    if (size == 0 || size > kMaxFileBytes) {
      return {};
    }
    DataReader reader(output.GetInputStreamAt(0));
    const UINT32 loaded = reader.LoadAsync(static_cast<UINT32>(size)).get();
    std::vector<uint8_t> out(static_cast<size_t>(loaded));
    reader.ReadBytes(out);
    if (!HasPngMagic(out)) {
      return {};
    }
    return out;
  } catch (...) {
    return {};
  }
}

EncodableValue ScannerListToValue(const DeviceInformationCollection& devices) {
  EncodableList array;
  for (const auto& device : devices) {
    EncodableMap entry;
    entry[EncodableValue("id")] = EncodableValue(ToUtf8(device.Id().c_str()));
    entry[EncodableValue("name")] =
        EncodableValue(ToUtf8(device.Name().c_str()));
    array.push_back(EncodableValue(std::move(entry)));
  }
  return EncodableValue(std::move(array));
}

// Finds a scanner by id (empty id => first available). Throws on failure.
ImageScanner ResolveScanner(const std::string& id) {
  DeviceInformationCollection devices =
      DeviceInformation::FindAllAsync(
          winrt::Windows::Devices::Enumeration::DeviceClass::ImageScanner)
          .get();

  if (devices.Size() == 0) {
    throw std::runtime_error("scanner_not_found");
  }

  if (id.empty()) {
    return ImageScanner::FromIdAsync(devices.GetAt(0).Id()).get();
  }

  for (const auto& device : devices) {
    if (ToUtf8(device.Id().c_str()) == id) {
      return ImageScanner::FromIdAsync(device.Id()).get();
    }
  }
  throw std::runtime_error("scanner_not_found");
}

std::string MapHresultToCode(int32_t code) {
  switch (code) {
    case kWiaErrorPaperEmpty:
      return "feeder_empty";
    case kWiaErrorUserIntervention:
      return "scan_cancelled";
    case kWiaErrorOffline:
      return "scanner_offline";
    case kWiaErrorBusy:
      return "scanner_busy";
    default: {
      std::ostringstream oss;
      oss << "winrt_error_0x" << std::hex << static_cast<uint32_t>(code);
      return oss.str();
    }
  }
}

// Scans all feeder pages (or one flatbed page) into PNG byte arrays.
// Reports progress after each page; exactly one of on_done/on_error fires.
// Scans all feeder pages (or one flatbed page) into PNG byte arrays.
// Reports progress after each page; exactly one of on_done/on_error fires.
// Runs on a background thread, so blocking .get() calls are allowed here.
void RunScanAsync(
    ImageScanner scanner, int dpi, bool color,
    std::function<void(int)> on_progress,
    std::function<void(std::vector<std::vector<uint8_t>>)> on_done,
    std::function<void(const std::string&)> on_error) {
  std::vector<std::vector<uint8_t>> pages;
  fs::path temp_dir;
  int pages_scanned = 0;
  bool finished = false;

  try {
    if (!CreateTempDir(temp_dir)) {
      on_error("temp_dir_failed");
      return;
    }

    const bool has_feeder =
        scanner.IsScanSourceSupported(ImageScannerScanSource::Feeder);
    const ImageScannerScanSource source =
        has_feeder ? ImageScannerScanSource::Feeder
                   : ImageScannerScanSource::Flatbed;

    if (has_feeder) {
      auto feeder = scanner.FeederConfiguration();
      const float lo = std::max(feeder.MinResolution().DpiX, 1.0f);
      const float hi = std::max(feeder.MaxResolution().DpiX, lo);
      feeder.DesiredResolution(
          ImageScannerResolution{std::clamp(static_cast<float>(dpi), lo, hi),
                                 std::clamp(static_cast<float>(dpi), lo, hi)});
      feeder.ColorMode(color ? ImageScannerColorMode::Color
                             : ImageScannerColorMode::Grayscale);
      feeder.AutoDetectPageSize(true);
      feeder.MaxNumberOfPages(kMaxPages);
    } else {
      auto flatbed = scanner.FlatbedConfiguration();
      const float lo = std::max(flatbed.MinResolution().DpiX, 1.0f);
      const float hi = std::max(flatbed.MaxResolution().DpiX, lo);
      flatbed.DesiredResolution(
          ImageScannerResolution{std::clamp(static_cast<float>(dpi), lo, hi),
                                 std::clamp(static_cast<float>(dpi), lo, hi)});
      flatbed.ColorMode(color ? ImageScannerColorMode::Color
                              : ImageScannerColorMode::Grayscale);
    }

    const auto start = std::chrono::steady_clock::now();

    while (true) {
      const auto elapsed = std::chrono::steady_clock::now() - start;
      if (std::chrono::duration_cast<std::chrono::seconds>(elapsed).count() >
          kMaxScanSeconds) {
        on_error("scan_timeout");
        finished = true;
        break;
      }

      StorageFolder folder =
          StorageFolder::GetFolderFromPathAsync(temp_dir.wstring()).get();

      ImageScannerScanResult result =
          scanner.ScanFilesToFolderAsync(source, folder).get();

      const uint32_t count = result.ScannedFiles().Size();
      if (count == 0) {
        if (pages_scanned == 0) {
          on_error("feeder_empty");
          finished = true;
        }
        break;
      }

      for (uint32_t i = 0; i < count; ++i) {
        const auto file = result.ScannedFiles().GetAt(i);
        const std::vector<uint8_t> bytes =
            PageBytesFromFile(fs::path{file.Path().c_str()});
        if (bytes.empty()) {
          on_error("page_read_failed");
          finished = true;
          break;
        }
        pages.push_back(std::move(bytes));
        ++pages_scanned;
        on_progress(pages_scanned);
        if (pages_scanned >= kMaxPages) {
          on_done(std::move(pages));
          finished = true;
          break;
        }
      }
      if (finished) {
        break;
      }

      // Flatbed always yields exactly one page; feeder batches are repeated
      // until ScanFilesToFolderAsync returns an empty batch.
      if (!has_feeder) {
        on_done(std::move(pages));
        finished = true;
        break;
      }
    }
  } catch (const winrt::hresult_error& e) {
    if (!finished) {
      const std::string code = MapHresultToCode(e.code().value);
      if (code == "feeder_empty" && pages_scanned > 0) {
        // The feeder ran dry after delivering the last page: that is the
        // normal end of a multi-page job, not an error.
        on_done(std::move(pages));
      } else {
        on_error(code);
      }
      finished = true;
    }
  } catch (const std::exception& e) {
    if (!finished) {
      on_error(std::string("exception_") + e.what());
      finished = true;
    }
  } catch (...) {
    if (!finished) {
      on_error("unknown_error");
      finished = true;
    }
  }

  // The pages are in memory now, so the temp files are no longer needed.
  if (!temp_dir.empty()) {
    std::error_code ec;
    fs::remove_all(temp_dir, ec);
  }

  // Keep partial results if something failed after at least one page.
  if (!finished && pages_scanned > 0) {
    on_done(std::move(pages));
  }
}

}  // namespace

void ScannerChannel::RegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  // Owned for the lifetime of the process (tied to the runner window).
  static auto* channel = new ScannerChannel(registrar);
  (void)channel;
}

ScannerChannel::ScannerChannel(FlutterDesktopPluginRegistrarRef registrar)
    : registrar_(std::make_unique<flutter::PluginRegistrarWindows>(registrar)) {
  method_channel_ =
      std::make_unique<flutter::MethodChannel<EncodableValue>>(
          registrar_->messenger(), kChannelName,
          &flutter::StandardMethodCodec::GetInstance());

  method_channel_->SetMethodCallHandler(
      [this](const auto& call, auto result) {
        HandleMethodCall(call, std::move(result));
      });

  progress_channel_ =
      std::make_unique<flutter::EventChannel<EncodableValue>>(
          registrar_->messenger(), kProgressChannelName,
          &flutter::StandardMethodCodec::GetInstance());

  progress_channel_->SetStreamHandler(
      std::make_unique<flutter::StreamHandlerFunctions<EncodableValue>>(
          [this](const EncodableValue* arguments,
                 std::unique_ptr<flutter::EventSink<EncodableValue>>&& sink)
              -> std::unique_ptr<flutter::StreamHandlerError<EncodableValue>> {
            progress_sink_ = std::move(sink);
            return nullptr;
          },
          [this](const EncodableValue* arguments)
              -> std::unique_ptr<flutter::StreamHandlerError<EncodableValue>> {
            progress_sink_ = nullptr;
            return nullptr;
          }));
}

ScannerChannel::~ScannerChannel() = default;

void ScannerChannel::HandleMethodCall(
    const flutter::MethodCall<EncodableValue>& method_call,
    std::unique_ptr<flutter::MethodResult<EncodableValue>> result) {
  const std::string& method = method_call.method_name();

  if (method == "listScanners") {
    std::thread(
        [result = std::shared_ptr<flutter::MethodResult<EncodableValue>>(
             result.release())]() mutable {
          try {
            DeviceInformationCollection devices =
                DeviceInformation::FindAllAsync(
                    winrt::Windows::Devices::Enumeration::DeviceClass::
                        ImageScanner)
                    .get();
            result->Success(ScannerListToValue(devices));
          } catch (const winrt::hresult_error& e) {
            result->Error("scan_failed", MapHresultToCode(e.code().value));
          } catch (...) {
            result->Error("scan_failed", "unknown_error");
          }
        })
        .detach();
    return;
  }

  if (method == "scan") {
    if (scan_in_progress_.load()) {
      result->Error("scan_in_progress", "A scan is already running");
      return;
    }

    EncodableMap args;
    if (const auto* arguments = method_call.arguments()) {
      if (const auto* map = std::get_if<EncodableMap>(arguments)) {
        args = *map;
      }
    }

    const std::string id = GetStringArg(args, "id");
    const int32_t dpi =
        std::clamp(GetIntArg(args, "dpi", kDefaultDpi), kMinDpi, kMaxDpi);
    const bool color = GetBoolArg(args, "color", false);

    scan_in_progress_.store(true);
    std::thread([
      this, id, dpi, color,
      result = std::shared_ptr<flutter::MethodResult<EncodableValue>>(
          result.release())
    ]() mutable {
      try {
        ImageScanner scanner = ResolveScanner(id);
        RunScanAsync(
            scanner, dpi, color,
            [this](int page) {
              if (progress_sink_) {
                EncodableMap event;
                event[EncodableValue("page")] = EncodableValue(page);
                progress_sink_->Success(EncodableValue(std::move(event)));
              }
            },
            [this, result](std::vector<std::vector<uint8_t>> pages) mutable {
              scan_in_progress_.store(false);
              EncodableList byte_arrays;
              for (auto& page : pages) {
                byte_arrays.push_back(EncodableValue(std::move(page)));
              }
              result->Success(EncodableValue(std::move(byte_arrays)));
            },
            [this, result](const std::string& code) mutable {
              scan_in_progress_.store(false);
              result->Error(code, "Scan failed: " + code);
            });
      } catch (...) {
        scan_in_progress_.store(false);
        result->Error("scanner_not_found", "scanner_not_found");
      }
    })
    .detach();
    return;
  }

  result->NotImplemented();
}
