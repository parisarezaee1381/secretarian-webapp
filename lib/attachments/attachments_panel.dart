import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import 'attached_item.dart';
import 'scanner_pdf.dart';
import 'scanner_service.dart';
import 'package:flutter_application_1/widgets/buttons.dart';
import 'package:flutter_application_1/widgets/hoverablecontainer.dart';
import 'package:flutter_application_1/core/theme.dart';

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

  bool _isScanning = false;
  String? _preferredScannerId;
  StreamSubscription<int>? _progressSub;
  void Function(int scannedPages)? _onProgressPage;

  @override
  void initState() {
    super.initState();

    _attachedItems = List<AttachedItem>.from(widget.initialItems);
  }

  @override
  void dispose() {
    _progressSub?.cancel();
    super.dispose();
  }

  void _notifyParent() {
    widget.onChanged(List<AttachedItem>.from(_attachedItems));
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
        backgroundColor: AppColors.error,
      ),
    );
  }

  Future<void> _pickAttachment() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
        withData: true,
      );

      if (!mounted) return;

      if (result != null) {
        final file = result.files.first;

        setState(() {
          _attachedItems.add(
            AttachedItem(name: file.name, bytes: file.bytes, path: file.path),
          );
        });

        _notifyParent();
      }
    } catch (e, stackTrace) {
      debugPrint('PICK ATTACHMENT ERROR: $e');
      debugPrint('$stackTrace');

      if (!mounted) return;

      _showErrorSnackBar('خطا در انتخاب فایل');
    }
  }

  Future<String?> _pickScanner(List<ScannerDeviceInfo> scanners) {
    return showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'انتخاب اسکنر',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            textDirection: TextDirection.rtl,
            children: [
              for (final scanner in scanners)
                ListTile(
                  title: Text(
                    scanner.name,
                  ),
                  onTap: () => Navigator.of(dialogContext).pop(scanner.id),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text(
                'انصراف',
              ),
            ),
          ],
        );
      },
    );
  }

  /// Shows a non-dismissable progress dialog that counts scanned pages and
  /// returns a callback that closes it again.
  void Function() _showProgressDialog() {
    var dialogOpen = true;
    NavigatorState? dialogNavigator;
    var scannedPages = 0;

    void close() {
      if (!dialogOpen) return;
      dialogOpen = false;
      _progressSub?.cancel();
      _progressSub = null;
      _onProgressPage = null;
      if (dialogNavigator != null && dialogNavigator!.canPop()) {
        dialogNavigator!.pop();
      }
    }

    if (!mounted) return close;

    unawaited(
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          dialogNavigator = Navigator.of(dialogContext, rootNavigator: true);

          return PopScope(
            canPop: false,
            child: StatefulBuilder(
              builder: (context, setDialogState) {
                _onProgressPage = (pages) {
                  if (dialogOpen && pages > scannedPages) {
                    setDialogState(() => scannedPages = pages);
                  }
                };

                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    textDirection: TextDirection.rtl,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 24),
                      Text(
                        scannedPages > 0
                            ? 'در حال اسکن... صفحه $scannedPages'
                            : 'در حال اسکن...',
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ).whenComplete(() {
        dialogOpen = false;
      }),
    );

    return close;
  }

  /// Runs the scan and stitches the pages into one PDF.
  Future<Uint8List> _scanAndBuildPdf(String? deviceId) async {
    final closeDialog = _showProgressDialog();

    try {
      _progressSub = ScannerService.onProgress.listen((page) {
        _onProgressPage?.call(page);
      });

      final pages = await ScannerService.scan(deviceId: deviceId);
      closeDialog();

      if (pages.isEmpty) {
        throw ScanFailed('no_pages');
      }

      return await ScannerPdf.buildPdf(pages);
    } catch (_) {
      closeDialog();
      rethrow;
    }
  }

  Future<void> _scanDocument() async {
    if (_isScanning) return;

    setState(() => _isScanning = true);

    try {
      final scanners = await ScannerService.listScanners();
      if (!mounted) return;

      if (scanners.isEmpty) {
        _showErrorSnackBar(
          'اسکنری یافت نشد. لطفاً اسکنر را روشن و متصل کرده و دوباره تلاش کنید.',
        );
        return;
      }

      String? deviceId = _preferredScannerId;

      if (scanners.length > 1) {
        final selectedId = await _pickScanner(scanners);
        if (!mounted) return;
        if (selectedId == null) return; // کاربر انصراف داد

        deviceId = selectedId;
        _preferredScannerId = selectedId;
      }

      final pdfBytes = await _scanAndBuildPdf(deviceId);
      if (!mounted) return;

      setState(() {
        _attachedItems.add(
          AttachedItem(
            name: 'scan-${DateTime.now().millisecondsSinceEpoch}.pdf',
            bytes: pdfBytes,
          ),
        );
      });

      _notifyParent();
    } on ScannerNotFound {
      if (mounted) {
        _showErrorSnackBar('اسکنری یافت نشد. اتصال اسکنر را بررسی کنید.');
      }
    } on ScanCancelled {
      if (mounted) {
        _showErrorSnackBar('اسکن لغو شد.');
      }
    } on ScanFailed catch (e) {
      if (mounted) {
        _showErrorSnackBar('خطا در اسکن سند (${e.code}).');
      }
    } catch (e, stackTrace) {
      debugPrint('SCAN DOCUMENT ERROR: $e');
      debugPrint('$stackTrace');

      if (mounted) {
        _showErrorSnackBar('خطا در اسکن سند.');
      }
    } finally {
      if (mounted) {
        setState(() => _isScanning = false);
      }
    }
  }

  void _removeAttachedItem(int index) {
    setState(() {
      _attachedItems.removeAt(index);
    });

    _notifyParent();
  }

  Widget _buildFileIconPlaceholder(String name) {
    return Container(
      color: AppColors.background,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.insert_drive_file,
            color: AppColors.mutedText,
            size: 40,
          ),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 11,
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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
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
              normalColor: AppColors.error,
              hoverColor: AppColors.error,
              hoverOpacity: 0.8,
              onTap: () {
                _removeAttachedItem(index);
              },
              child: const Icon(
                Icons.close,
                size: 16,
                color: AppColors.background,
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
              isLoading: _isScanning,
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
