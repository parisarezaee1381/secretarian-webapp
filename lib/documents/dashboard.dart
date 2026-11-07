import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_application_1/documents/s_sadere.dart';
import 'package:flutter_application_1/documents/s_varede.dart';
import 'package:flutter_application_1/documents/s_gharardad.dart';
import 'package:flutter_application_1/documents/document_list.dart';

import '../widgets/header.dart';
import '../widgets/buttons.dart';
import '../widgets/table.dart';
import '../widgets/dropdown_menu_items.dart';
import '../widgets/notification.dart';

import '../domain/documents.dart';
import '../data/document_repository.dart';
import 'package:flutter_application_1/core/routes.dart';
import 'package:flutter_application_1/core/theme.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _showDocumentMenu = false;

  @override
  void initState() {
    super.initState();
    DocumentRepository.instance.addListener(_onRepositoryChanged);
  }

  @override
  void dispose() {
    DocumentRepository.instance.removeListener(_onRepositoryChanged);
    super.dispose();
  }

  void _onRepositoryChanged() {
    if (!mounted) return;
    setState(() {});
  }

  DocumentTableRow _mapToRow(Document doc) {
    return switch (doc) {
      OutgoingLetterDocument() => DocumentTableRow.fromOutgoing(
        doc,
        onEdit: () => _openForm(doc),
        onDelete: () => _confirmDelete(doc),
        onAddAttachment: () => _openForm(doc, openToAttachments: true),
      ),
      IncomingLetterDocument() => DocumentTableRow.fromIncoming(
        doc,
        onEdit: () => _openForm(doc),
        onDelete: () => _confirmDelete(doc),
        onAddAttachment: () => _openForm(doc, openToAttachments: true),
      ),
      ContractDocument() => DocumentTableRow.fromContract(
        doc,
        onEdit: () => _openForm(doc),
        onDelete: () => _confirmDelete(doc),
        onAddAttachment: () => _openForm(doc, openToAttachments: true),
      ),
    };
  }

  Future<void> _deleteDocument(Document doc) async {
    try {
      switch (doc) {
        case OutgoingLetterDocument(:final id):
          await DocumentRepository.instance.deleteOutgoing(id);
        case IncomingLetterDocument(:final id):
          await DocumentRepository.instance.deleteIncoming(id);
        case ContractDocument(:final id):
          await DocumentRepository.instance.deleteContract(id);
      }
    } catch (e) {
      debugPrint('Delete failed: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حذف سند انجام نشد')),
      );
    }
  }

  Future<void> _confirmDelete(Document doc) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف سند'),
        content: const Text('آیا از حذف این سند مطمئن هستید؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('انصراف'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await _deleteDocument(doc);
  }

  void _openForm(Document doc, {bool openToAttachments = false}) {
    final page = switch (doc) {
      OutgoingLetterDocument() => OutgoingLetterFormPage(
        initialDocument: doc,
        openToAttachments: openToAttachments,
      ),
      IncomingLetterDocument() => IncomingLetterFormPage(
        initialDocument: doc,
        openToAttachments: openToAttachments,
      ),
      ContractDocument() => ContractFormPage(
        initialDocument: doc,
        openToAttachments: openToAttachments,
      ),
    };

    _openPage(page);
  }

  void _openPage(Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void _toggleDocumentMenu() {
    setState(() {
      _showDocumentMenu = !_showDocumentMenu;
    });
  }

  void _closeDocumentMenu() {
    if (!_showDocumentMenu) {
      return;
    }

    setState(() {
      _showDocumentMenu = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final rows = DocumentRepository.instance
        .getLatest(5)
        .map(_mapToRow)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundMuted,

      appBar: AppHeader(
        title: 'داشبورد اصلی',
        leading: HeaderLeading.settings,

        onLeadingPressed: () {
          Navigator.pushNamed(context, AppRoutes.settings);
        },
      ),

      body: Stack(
        clipBehavior: Clip.none,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,

            child: Column(
              children: [
                SizedBox(height: 64.w),

                Align(
                  alignment: Alignment.center,

                  child: CustomButton(
                    label: '+ ثبت سند جدید',
                    type: ButtonType.primary,
                    width: 204.w,
                    onPressed: _toggleDocumentMenu,
                  ),
                ),

                SizedBox(height: 32.w),

                Align(
                  alignment: Alignment.center,

                  child: CustomButton(
                    label: 'لیست اسناد',
                    type: ButtonType.secondary,
                    width: 204.w,

                    onPressed: () {
                      _openPage(const DocumentList());
                    },
                  ),
                ),

                SizedBox(height: 64.w),

                Align(
                  alignment: Alignment.center,

                  child: PendingLettersButton(
                    onPressed: () {
                      _openPage(const DocumentList(initialPendingOnly: true));
                    },
                  ),
                ),

                SizedBox(height: 64.w),

                Align(
                  alignment: Alignment.centerRight,

                  child: Padding(
                    padding: EdgeInsets.only(right: 32.w),

                    child: Text(
                      'آخرین اسناد',

                      textAlign: TextAlign.right,

                      style: TextStyle(
                        color: AppColors.text,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 32.w),

                DocumentTable(
                  rows: rows,
                  rowsPerPage: 5,
                  showPagination: false,
                ),

                SizedBox(height: 128.w),
              ],
            ),
          ),

          if (_showDocumentMenu)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _closeDocumentMenu,

                child: const SizedBox(),
              ),
            ),

          if (_showDocumentMenu)
            Positioned(
              top: 128.w,
              left: 0,
              right: 0,

              child: Center(
                child: SizedBox(
                  width: 204.w,

                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      DropdownMenuItemWidget(
                        label: 'صادره',
                        isFirst: true,

                        onTap: () {
                          setState(() {
                            _showDocumentMenu = false;
                          });

                          _openPage(const OutgoingLetterFormPage());
                        },
                      ),

                      DropdownMenuItemWidget(
                        label: 'وارده',

                        onTap: () {
                          setState(() {
                            _showDocumentMenu = false;
                          });

                          _openPage(const IncomingLetterFormPage());
                        },
                      ),

                      DropdownMenuItemWidget(
                        label: 'قرارداد',
                        isLast: true,

                        onTap: () {
                          setState(() {
                            _showDocumentMenu = false;
                          });

                          _openPage(const ContractFormPage());
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
