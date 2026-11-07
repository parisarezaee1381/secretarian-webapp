#ifndef RUNNER_SCANNER_H_
#define RUNNER_SCANNER_H_

#include <flutter/event_channel.h>
#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <atomic>
#include <memory>

// Hosts the "secretarian/scanner" method and progress event channels.
//
// Methods (all args passed as a map):
//   listScanners -> List<Object> of {id, name}
//   scan         -> List<Object> of PNG page bytes; args: {id?, dpi?, color?}
//
// Error codes: "scanner_not_found", "scan_cancelled", "scan_failed",
//              "feeder_empty", "not_implemented", "bad_args".
class ScannerChannel {
 public:
  static constexpr char kChannelName[] = "secretarian/scanner";
  static constexpr char kProgressChannelName[] = "secretarian/scanner/progress";

  // Creates the channels and attaches the method-call handler.
  static void RegisterWithRegistrar(
      FlutterDesktopPluginRegistrarRef registrar);

  ScannerChannel(const ScannerChannel&) = delete;
  ScannerChannel& operator=(const ScannerChannel&) = delete;

 private:
  explicit ScannerChannel(FlutterDesktopPluginRegistrarRef registrar);
  ~ScannerChannel();

  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue>& method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  flutter::MethodChannel<flutter::EncodableValue>* method_channel() {
    return method_channel_.get();
  }

  std::unique_ptr<flutter::PluginRegistrarWindows> registrar_;
  std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>>
      method_channel_;
  std::unique_ptr<flutter::EventChannel<flutter::EncodableValue>>
      progress_channel_;
  std::unique_ptr<flutter::EventSink<flutter::EncodableValue>> progress_sink_;

  // Guards against concurrent scan jobs (touched from the thread pool).
  std::atomic<bool> scan_in_progress_{false};
};

#endif  // RUNNER_SCANNER_H_
