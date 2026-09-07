import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'attached_item.dart';
import 'package:flutter_application_1/widgets.dart/buttons.dart';
import 'package:flutter_application_1/widgets.dart/hoverablecontainer.dart';

class AttachmentsPanel extends StatefulWidget {
  final ValueChanged<List<AttachedItem>> onChanged;

  final List<AttachedItem> initialItems;

  const AttachmentsPanel({
    super.key,
    required this.onChanged,
    this.initialItems = const [],
  });

  @override
  State<AttachmentsPanel> createState() => _AttachmentsPanelState();
}

class _AttachmentsPanelState extends State<AttachmentsPanel> {
  static const double _a4Width = 793.7;
  static const double _a4Height = 1122.5;

  static const double _thumbnailWidth = _a4Width / 4;
  static const double _thumbnailHeight = _a4Height / 4;

  late List<AttachedItem> _attachedItems;

  @override
  void initState() {
    super.initState();

    _attachedItems = List<AttachedItem>.from(widget.initialItems);
  }

  void _notifyParent() {
    widget.onChanged(List<AttachedItem>.from(_attachedItems));
  }

  Future<void> _pickAttachment() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
        withData: true,
      );

      if (result != null) {
        final file = result.files.first;

        setState(() {
          _attachedItems.add(
            AttachedItem(name: file.name, bytes: file.bytes, path: file.path),
          );
        });

        _notifyParent();
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'خطا در انتخاب فایل',
            style: TextStyle(fontFamily: 'Estedad'),
          ),
          backgroundColor: Color(0xFFA85838),
        ),
      );
    }
  }

  Future<void> _scanDocument() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'اتصال به اسکنر هنوز پیاده‌سازی نشده است. '
          'برای اتصال واقعی به یک پکیج/درایور اسکنر مخصوص پلتفرم نیاز است.',
          style: TextStyle(fontFamily: 'Estedad'),
        ),
        backgroundColor: Color(0xFFA85838),
      ),
    );
  }

  void _removeAttachedItem(int index) {
    setState(() {
      _attachedItems.removeAt(index);
    });

    _notifyParent();
  }

  Widget _buildFileIconPlaceholder(String name) {
    return Container(
      color: const Color(0xFFF3F3F7),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.insert_drive_file,
            color: Color(0xFF828288),
            size: 40,
          ),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF101018),
              fontSize: 11,
              fontFamily: 'Estedad',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnail(AttachedItem item, int index) {
    Widget preview;

    // اگر فایل تصویر است و bytes دارد
    if (item.isImage && item.bytes != null) {
      preview = Image.memory(item.bytes!, fit: BoxFit.cover);
    }
    // اگر فایل تصویر است و فقط path دارد
    else if (item.isImage && item.path != null) {
      preview = Image.file(File(item.path!), fit: BoxFit.cover);
    }
    // فایل‌های غیرتصویری مثل PDF و Word
    else {
      preview = _buildFileIconPlaceholder(item.name);
    }

    return Container(
      width: _thumbnailWidth,
      height: _thumbnailHeight,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFBBBBC0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox.expand(child: preview),
          ),

          // دکمه حذف
          Positioned(
            top: 6,
            left: 6,
            child: HoverableContainer(
              width: 24,
              height: 24,
              borderRadius: 12,
              normalColor: const Color(0xFFA85838),
              hoverColor: const Color(0xFFA85838),
              hoverOpacity: 0.8,
              onTap: () {
                _removeAttachedItem(index);
              },
              child: const Icon(
                Icons.close,
                size: 16,
                color: Color(0xFFF3F3F7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // نمایش پیوست‌ها
        if (_attachedItems.isNotEmpty) ...[
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: List.generate(_attachedItems.length, (index) {
              return _buildThumbnail(_attachedItems[index], index);
            }),
          ),

          const SizedBox(height: 16),
        ],

        // دکمه‌های پایین
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              label: 'اسکن سند',
              type: ButtonType.secondary,
              icon: const Icon(Icons.print_outlined),
              width: 204,
              onPressed: _scanDocument,
            ),

            const SizedBox(width: 16),

            CustomButton(
              label: '+ افزودن پیوست',
              type: ButtonType.secondary,
              width: 204,
              onPressed: _pickAttachment,
            ),
          ],
        ),
      ],
    );
  }
}
