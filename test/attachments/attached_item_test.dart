import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/attachments/attached_item.dart';

void main() {
  group('AttachedItem.isImage', () {
    test('recognises every supported image extension', () {
      for (final name in [
        'photo.jpg',
        'photo.jpeg',
        'scan.png',
        'bitmap.bmp',
        'anim.gif',
        'image.webp',
      ]) {
        expect(AttachedItem(name: name).isImage, isTrue, reason: name);
      }
    });

    test('is case insensitive', () {
      expect(AttachedItem(name: 'SCAN.PNG').isImage, isTrue);
      expect(AttachedItem(name: 'Photo.JpEg').isImage, isTrue);
    });

    test('treats documents and unknown extensions as non-images', () {
      for (final name in ['scan.pdf', 'letter.docx', 'notes.txt', 'README']) {
        expect(AttachedItem(name: name).isImage, isFalse, reason: name);
      }
    });

    test('uses only the last extension segment', () {
      expect(AttachedItem(name: 'archive.pdf.png').isImage, isTrue);
      expect(AttachedItem(name: 'photo.png.pdf').isImage, isFalse);
    });

    test('keeps the fields it was given', () {
      final item = AttachedItem(name: 'a.pdf', path: '/tmp/a.pdf');

      expect(item.name, 'a.pdf');
      expect(item.path, '/tmp/a.pdf');
      expect(item.bytes, isNull);
    });
  });
}
