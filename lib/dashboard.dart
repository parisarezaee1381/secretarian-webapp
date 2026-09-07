import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_application_1/documents/s_sadere.dart';
import 'package:flutter_application_1/documents/s_varede.dart';
import 'package:flutter_application_1/documents/s_gharardad.dart';
import 'package:flutter_application_1/document_list.dart';

import 'widgets.dart/header.dart';
import 'widgets.dart/buttons.dart';
import 'widgets.dart/table.dart';
import 'widgets.dart/dropdown_menu_items.dart';
import 'widgets.dart/notification.dart';

import '../documents.dart';
import '../document_repository.dart';
import 'package:flutter_application_1/setting.dart/settingview.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _showDocumentMenu = false;

  DocumentTableRow _mapToRow(dynamic doc) {
    if (doc is OutgoingLetterDocument) {
      return DocumentTableRow.fromOutgoing(
        doc,

        operation: const Icon(Icons.more_horiz, color: Color(0xFF101018)),

        onEdit: () => _openOutgoingForm(doc),
        onDelete: () => _deleteOutgoing(doc),

        onAddAttachment: () => _openOutgoingForm(doc),
      );
    }

    if (doc is IncomingLetterDocument) {
      return DocumentTableRow.fromIncoming(
        doc,

        operation: const Icon(Icons.more_horiz, color: Color(0xFF101018)),

        onEdit: () => _openIncomingForm(doc),
        onDelete: () => _deleteIncoming(doc),

        onAddAttachment: () => _openIncomingForm(doc),
      );
    }

    if (doc is ContractDocument) {
      return DocumentTableRow.fromContract(
        doc,

        operation: const Icon(Icons.more_horiz, color: Color(0xFF101018)),

        onEdit: () => _openContractForm(doc),
        onDelete: () => _deleteContract(doc),

        onAddAttachment: () => _openContractForm(doc),
      );
    }

    throw ArgumentError('نوع document ناشناخته است');
  }

  Future<void> _deleteOutgoing(OutgoingLetterDocument doc) async {
    await DocumentRepository.instance.deleteOutgoing(doc.id);

    if (!mounted) return;

    setState(() {});
  }

  Future<void> _deleteIncoming(IncomingLetterDocument doc) async {
    await DocumentRepository.instance.deleteIncoming(doc.id);

    if (!mounted) return;

    setState(() {});
  }

  Future<void> _deleteContract(ContractDocument doc) async {
    await DocumentRepository.instance.deleteContract(doc.id);

    if (!mounted) return;

    setState(() {});
  }

  void _openOutgoingForm(OutgoingLetterDocument doc) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OutgoingLetterFormPage(initialDocument: doc),
      ),
    ).then((_) {
      if (!mounted) return;

      setState(() {});
    });
  }

  void _openIncomingForm(IncomingLetterDocument doc) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IncomingLetterFormPage(initialDocument: doc),
      ),
    ).then((_) {
      if (!mounted) return;

      setState(() {});
    });
  }

  void _openContractForm(ContractDocument doc) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContractFormPage(initialDocument: doc),
      ),
    ).then((_) {
      if (!mounted) return;

      setState(() {});
    });
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
      backgroundColor: const Color(0xFFF5F4F4),

      appBar: AppHeader(
        title: 'داشبورد اصلی',
        leading: HeaderLeading.settings,

        onLeadingPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingsViewPage()),
          );
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DocumentList(),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 64.w),

                Align(
                  alignment: Alignment.center,

                  child: PendingLettersButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const DocumentList(initialPendingOnly: true),
                        ),
                      );
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
                        color: const Color(0xFF101018),
                        fontFamily: 'Estedad',
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

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const OutgoingLetterFormPage(),
                            ),
                          );
                        },
                      ),

                      DropdownMenuItemWidget(
                        label: 'وارده',

                        onTap: () {
                          setState(() {
                            _showDocumentMenu = false;
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const IncomingLetterFormPage(),
                            ),
                          );
                        },
                      ),

                      DropdownMenuItemWidget(
                        label: 'قرارداد',
                        isLast: true,

                        onTap: () {
                          setState(() {
                            _showDocumentMenu = false;
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ContractFormPage(),
                            ),
                          );
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
