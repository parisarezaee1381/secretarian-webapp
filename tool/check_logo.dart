import 'dart:io';

import 'package:image/image.dart' as img;

void main() {
  final data = File('assets/images/logo.png').readAsBytesSync();
  final image = img.decodeImage(data);
  if (image == null) {
    stderr.writeln('failed to decode');
    exit(1);
  }
  stdout.writeln('width=${image.width} height=${image.height}');

  final corners = [
    ('top-left', image.getPixel(0, 0)),
    ('top-right', image.getPixel(image.width - 1, 0)),
    ('bottom-left', image.getPixel(0, image.height - 1)),
    ('bottom-right', image.getPixel(image.width - 1, image.height - 1)),
  ];
  for (final (name, p) in corners) {
    stdout.writeln('$name pixel: r=${p.r} g=${p.g} b=${p.b} a=${p.a}');
  }
}
