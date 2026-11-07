import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// Builds the Windows application icon — the picture Explorer, the taskbar and
/// a desktop shortcut show — from `assets/images/logo.png`.
///
/// Windows icons are square, so the logo is centred on a square canvas of its
/// own background colour first: padding keeps the picture from being stretched
/// at the sizes Windows asks for. Frames are written as plain bitmaps rather
/// than PNG inside the ICO, because the older icon APIs still used by the shell
/// and by shortcuts cannot read PNG-compressed frames.
void main() {
  final img.Image source = img.decodePng(
    File('assets/images/logo.png').readAsBytesSync(),
  )!;

  final int side = math.max(source.width, source.height);

  final img.Pixel corner = source.getPixel(0, 0);

  final img.Image square = img.Image(width: side, height: side, numChannels: 3);

  img.fill(
    square,
    color: img.ColorRgb8(corner.r.toInt(), corner.g.toInt(), corner.b.toInt()),
  );

  img.compositeImage(
    square,
    source,
    dstX: (side - source.width) ~/ 2,
    dstY: (side - source.height) ~/ 2,
  );

  // The sizes Windows asks for: list view, Explorer, taskbar, Alt+Tab, large
  // icons and the 256px extra-large view.
  const List<int> sizes = [16, 24, 32, 48, 64, 128, 256];

  final List<img.Image> frames = [
    for (final int size in sizes)
      img.copyResize(
        square,
        width: size,
        height: size,
        interpolation: img.Interpolation.average,
      ),
  ];

  final File target = File('windows/runner/resources/app_icon.ico');

  target.writeAsBytesSync(_buildIco(frames));

  stdout.writeln(
    'wrote ${target.path} (${sizes.join(', ')}) from '
    '${source.width}x${source.height} logo',
  );
}

/// Assembles a multi-size ICO file: a directory of entries followed by one
/// bitmap per entry.
Uint8List _buildIco(List<img.Image> frames) {
  final List<Uint8List> bitmaps = [for (final f in frames) _bitmapEntry(f)];

  final int headerSize = 6 + 16 * frames.length;

  final ByteData header = ByteData(headerSize)
    ..setUint16(0, 0, Endian.little) // reserved
    ..setUint16(2, 1, Endian.little) // 1 = icon
    ..setUint16(4, frames.length, Endian.little);

  int offset = headerSize;

  for (int i = 0; i < frames.length; i++) {
    final img.Image frame = frames[i];
    final int base = 6 + i * 16;

    // 256 is stored as 0, the only value one byte can hold for it.
    header
      ..setUint8(base + 0, frame.width >= 256 ? 0 : frame.width)
      ..setUint8(base + 1, frame.height >= 256 ? 0 : frame.height)
      ..setUint8(base + 2, 0) // palette colours
      ..setUint8(base + 3, 0) // reserved
      ..setUint16(base + 4, 1, Endian.little) // colour planes
      ..setUint16(base + 6, 32, Endian.little) // bits per pixel
      ..setUint32(base + 8, bitmaps[i].length, Endian.little)
      ..setUint32(base + 12, offset, Endian.little);

    offset += bitmaps[i].length;
  }

  final BytesBuilder file = BytesBuilder(copy: false)
    ..add(header.buffer.asUint8List());

  for (final Uint8List bitmap in bitmaps) {
    file.add(bitmap);
  }

  return file.toBytes();
}

/// One icon frame as a BITMAPINFOHEADER, its BGRA pixels and its AND mask.
Uint8List _bitmapEntry(img.Image image) {
  final int size = image.width;

  // 1 bit per pixel, each row padded to 4 bytes.
  final int maskRowBytes = ((size + 31) ~/ 32) * 4;
  final int maskSize = maskRowBytes * size;
  final int pixelSize = size * size * 4;

  final ByteData data = ByteData(40 + pixelSize + maskSize);

  data
    ..setUint32(0, 40, Endian.little) // header size
    ..setInt32(4, size, Endian.little) // width
    ..setInt32(8, size * 2, Endian.little) // height: image + mask
    ..setUint16(12, 1, Endian.little) // colour planes
    ..setUint16(14, 32, Endian.little) // bits per pixel
    ..setUint32(16, 0, Endian.little) // compression: none
    ..setUint32(20, pixelSize + maskSize, Endian.little)
    ..setInt32(24, 0, Endian.little) // x pixels per metre
    ..setInt32(28, 0, Endian.little) // y pixels per metre
    ..setUint32(32, 0, Endian.little) // colours used
    ..setUint32(36, 0, Endian.little); // important colours

  int position = 40;

  // Bitmap rows run bottom-up.
  for (int y = size - 1; y >= 0; y--) {
    for (int x = 0; x < size; x++) {
      final img.Pixel pixel = image.getPixel(x, y);

      data
        ..setUint8(position++, pixel.b.toInt())
        ..setUint8(position++, pixel.g.toInt())
        ..setUint8(position++, pixel.r.toInt())
        ..setUint8(position++, 255);
    }
  }

  // The AND mask stays zero, which means every pixel is drawn from the image.
  return data.buffer.asUint8List();
}
