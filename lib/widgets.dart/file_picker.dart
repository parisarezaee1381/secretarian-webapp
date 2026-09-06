import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileSavePickerPage extends StatefulWidget {
  const FileSavePickerPage({super.key, required this.suggestedFileName});

  final String suggestedFileName;

  @override
  State<FileSavePickerPage> createState() => _FileSavePickerPageState();
}

class _FileSavePickerPageState extends State<FileSavePickerPage> {
  @override
  void initState() {
    super.initState();
    // بعد از اولین فریم دیالوگ رو باز می‌کنیم تا context کامل آماده باشه
    WidgetsBinding.instance.addPostFrameCallback((_) => _openPicker());
  }

  Future<void> _openPicker() async {
    String? result;
    bool hadError = false;

    try {
      result = await FilePicker.platform.saveFile(
        dialogTitle: 'محل ذخیره PDF را انتخاب کنید',
        fileName: '${widget.suggestedFileName}.pdf',
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
    } catch (e) {
      hadError = true;
    }

    if (!mounted) return;
    Navigator.pop(context, hadError ? '__error__' : result);
  }

  @override
  Widget build(BuildContext context) {
    // چون این صفحه فقط واسطه‌ست، یه لودینگ ساده کافیه
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
