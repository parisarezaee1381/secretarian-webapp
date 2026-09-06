import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileSaveWidget extends StatelessWidget {
  final void Function(String path)? onSaved;
  final VoidCallback? onCancel;

  const FileSaveWidget({super.key, this.onSaved, this.onCancel});

  Future<void> _saveFile() async {
    try {
      final path = await FilePicker.platform.saveFile(
        dialogTitle: 'ذخیره فایل',
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (path != null) {
        onSaved?.call(path);
      } else {
        onCancel?.call();
      }
    } catch (e) {
      debugPrint('خطا در ذخیره فایل: $e');
      onCancel?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _saveFile,
      child: const Text('ذخیره فایل'),
    );
  }
}
