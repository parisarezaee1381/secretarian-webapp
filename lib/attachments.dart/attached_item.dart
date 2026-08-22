// lib/widgets.dart/attached_item.dart
import 'package:flutter/foundation.dart' show Uint8List;

class AttachedItem {
  final String name;
  final Uint8List? bytes;
  final String? path;
  final bool isImage;

  AttachedItem({required this.name, this.bytes, this.path})
      : isImage = _checkIsImage(name);

  static bool _checkIsImage(String name) {
    final ext = name.contains('.') ? name.split('.').last.toLowerCase() : '';
    return ['jpg', 'jpeg', 'png', 'bmp', 'gif', 'webp'].contains(ext);
  }
}