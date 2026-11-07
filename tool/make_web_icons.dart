import 'dart:io';
import 'dart:math' as math;

import 'package:image/image.dart' as img;

/// Pixels at least this far from pure white become fully opaque; pixels
/// closer to white fade out smoothly (this keeps anti-aliased edges clean).
/// Raise it if you still see a white halo, lower it if parts of the logo vanish.
const int kWhiteTolerance = 60;

/// Fraction of the maskable icon that the logo may occupy (safe zone is ~80%).
const double kMaskableContentRatio = 0.70;

/// Background color of the maskable icons (R, G, B). Change to your brand color.
const List<int> kMaskableBackground = [255, 255, 255];

void main() {
  final source = File('assets/images/logo.png').readAsBytesSync();
  final decoded = img.decodeImage(source);
  if (decoded == null) {
    stderr.writeln('failed to decode logo');
    exit(1);
  }

  // Normalize to 8-bit RGBA so pixel math is predictable.
  final logo = decoded.convert(format: img.Format.uint8, numChannels: 4);

  final transparent = removeWhiteBackground(logo);
  final square = padToSquare(transparent);

  final iconsDir = Directory('web/icons');
  if (!iconsDir.existsSync()) {
    iconsDir.createSync(recursive: true);
  }

  const icons = [
    (192, 'icons/Icon-192.png', 'icons/Icon-maskable-192.png'),
    (512, 'icons/Icon-512.png', 'icons/Icon-maskable-512.png'),
  ];

  for (final (size, path, maskablePath) in icons) {
    // Regular icon: transparent background, logo fills the square.
    final regular = img.copyResize(
      square,
      width: size,
      height: size,
      interpolation: img.Interpolation.cubic,
    );
    writePng('web/$path', regular);

    // Maskable icon: solid background with the logo inside the safe zone.
    writePng('web/$maskablePath', buildMaskable(square, size));
  }
}

/// Returns a copy of [src] where white-ish pixels are transparent and
/// everything else keeps its color with a soft alpha ramp on the edges.
img.Image removeWhiteBackground(img.Image src) {
  final out = img.Image(width: src.width, height: src.height, numChannels: 4);
  for (int y = 0; y < src.height; y++) {
    for (int x = 0; x < src.width; x++) {
      final p = src.getPixel(x, y);
      final r = p.r.toInt();
      final g = p.g.toInt();
      final b = p.b.toInt();

      // 0 = pure white, 255 = pure black (based on the darkest channel).
      final darkness = 255 - math.min(r, math.min(g, b));
      var alpha = (darkness * 255 / kWhiteTolerance).round().clamp(0, 255);

      // Respect any transparency the source already had.
      alpha = (alpha * p.a.toInt() / 255).round();

      out.setPixel(x, y, img.ColorRgba8(r, g, b, alpha));
    }
  }
  return out;
}

/// Centers [src] on a transparent square canvas so resizing never distorts it.
img.Image padToSquare(img.Image src) {
  final side = math.max(src.width, src.height);
  if (src.width == src.height) return src;

  final canvas = img.Image(width: side, height: side, numChannels: 4);
  img.fill(canvas, color: img.ColorRgba8(0, 0, 0, 0));
  img.compositeImage(
    canvas,
    src,
    dstX: (side - src.width) ~/ 2,
    dstY: (side - src.height) ~/ 2,
  );
  return canvas;
}

/// Builds a full-bleed square with a solid background and [content] centered
/// inside the maskable safe zone.
img.Image buildMaskable(img.Image content, int size) {
  final canvas = img.Image(width: size, height: size, numChannels: 4);
  img.fill(
    canvas,
    color: img.ColorRgba8(
      kMaskableBackground[0],
      kMaskableBackground[1],
      kMaskableBackground[2],
      255,
    ),
  );

  final inner = (size * kMaskableContentRatio).round();
  final scaled = img.copyResize(
    content,
    width: inner,
    height: inner,
    interpolation: img.Interpolation.cubic,
  );
  img.compositeImage(
    canvas,
    scaled,
    dstX: (size - inner) ~/ 2,
    dstY: (size - inner) ~/ 2,
  );
  return canvas;
}

void writePng(String filePath, img.Image image) {
  File(filePath).writeAsBytesSync(img.encodePng(image));
  stdout.writeln('wrote $filePath (${image.width} x ${image.height})');
}
