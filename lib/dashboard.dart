import 'package:flutter/material.dart';

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
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // ============================================================
  // وضعیت منوی «ثبت سند جدید»
  // ============================================================

  bool _showDocumentMenu = false;

  // ============================================================
  // تبدیل سند به ردیف جدول
  // ============================================================

  DocumentTableRow _mapToRow(dynamic doc) {
    // ----------------------------------------------------------
    // نامه صادره
    // ----------------------------------------------------------

    if (doc is OutgoingLetterDocument) {
      return DocumentTableRow.fromOutgoing(
        doc,

        operation: const Icon(Icons.more_horiz, color: Color(0xFF101018)),

        onEdit: () => _openOutgoingForm(doc),

        onAddAttachment: () => _openOutgoingForm(doc),
      );
    }

    // ----------------------------------------------------------
    // نامه وارده
    // ----------------------------------------------------------

    if (doc is IncomingLetterDocument) {
      return DocumentTableRow.fromIncoming(
        doc,

        operation: const Icon(Icons.more_horiz, color: Color(0xFF101018)),

        onEdit: () => _openIncomingForm(doc),

        onAddAttachment: () => _openIncomingForm(doc),
      );
    }

    // ----------------------------------------------------------
    // قرارداد
    // ----------------------------------------------------------

    if (doc is ContractDocument) {
      return DocumentTableRow.fromContract(
        doc,

        operation: const Icon(Icons.more_horiz, color: Color(0xFF101018)),

        onEdit: () => _openContractForm(doc),

        onAddAttachment: () => _openContractForm(doc),
      );
    }

    throw ArgumentError('نوع document ناشناخته است');
  }

  // ============================================================
  // باز کردن فرم نامه صادره برای ویرایش
  // ============================================================

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

  // ============================================================
  // باز کردن فرم نامه وارده برای ویرایش
  // ============================================================

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

  // ============================================================
  // باز کردن فرم قرارداد برای ویرایش
  // ============================================================

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

  // ============================================================
  // باز و بسته کردن منوی ثبت سند جدید
  // ============================================================

  void _toggleDocumentMenu() {
    setState(() {
      _showDocumentMenu = !_showDocumentMenu;
    });
  }

  // ============================================================
  // بستن منو با کلیک خارج از آن
  // ============================================================

  void _closeDocumentMenu() {
    if (!_showDocumentMenu) {
      return;
    }

    setState(() {
      _showDocumentMenu = false;
    });
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    // ----------------------------------------------------------
    // دریافت ۵ سند آخر
    // ----------------------------------------------------------

    final rows = DocumentRepository.instance
        .getLatest(5)
        .map(_mapToRow)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F4F4),

      // ========================================================
      // Header
      // ========================================================
      appBar: AppHeader(
        title: 'داشبورد اصلی',
        leading: HeaderLeading.settings,

        onLeadingPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingsViewPage(
                username: 'کاربر',
                email: 'example@email.com',
              ),
            ),
          );
        },
      ),

      // ========================================================
      // Body
      // ========================================================
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // ======================================================
          // محتوای اصلی
          // ======================================================

          SingleChildScrollView(
            scrollDirection: Axis.vertical,

            child: Column(
              children: [
                // ==================================================
                // فاصله از Header
                // ==================================================

                const SizedBox(height: 64),

                // ==================================================
                // ثبت سند جدید
                // ==================================================
                Align(
                  alignment: Alignment.center,

                  child: CustomButton(
                    label: '+ ثبت سند جدید',
                    type: ButtonType.primary,
                    width: 204.w,
                    onPressed: _toggleDocumentMenu,
                  ),
                ),

                // ==================================================
                // فاصله
                // ==================================================
                const SizedBox(height: 32),

                // ==================================================
                // لیست اسناد
                // ==================================================
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

                // ==================================================
                // فاصله
                // ==================================================
                const SizedBox(height: 64),

                // ==================================================
                // اسناد نیازمند پیگیری
                // ==================================================
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

                // ==================================================
                // فاصله
                // ==================================================
                const SizedBox(height: 64),

                // ==================================================
                // عنوان آخرین اسناد
                // ==================================================
                Align(
                  alignment: Alignment.centerRight,

                  child: Padding(
                    padding: EdgeInsets.only(right: 32.w),

                    child: Text(
                      'آخرین اسناد',

                      textAlign: TextAlign.right,

                      style: TextStyle(
                        color: Color(0xFF101018),
                        fontFamily: 'Estedad',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // ==================================================
                // فاصله عنوان تا جدول
                // ==================================================
                const SizedBox(height: 32),

                // ==================================================
                // جدول آخرین ۵ سند
                // ==================================================
                DocumentTable(
                  rows: rows,
                  rowsPerPage: 5,
                  showPagination: false,
                ),

                // ==================================================
                // فاصله پایین صفحه
                // ==================================================
                const SizedBox(height: 128),
              ],
            ),
          ),

          // ======================================================
          // لایه بستن منو با کلیک خارج از منو
          // ======================================================
          if (_showDocumentMenu)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _closeDocumentMenu,

                child: const SizedBox(),
              ),
            ),

          // ======================================================
          // منوی ثبت سند جدید
          // ======================================================
          if (_showDocumentMenu)
            Positioned(
              top: 128,
              left: 0,
              right: 0,

              child: Center(
                child: SizedBox(
                  width: 204.w,

                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      // ==========================================
                      // صادره
                      // ==========================================

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

                      // ==========================================
                      // وارده
                      // ==========================================
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

                      // ==========================================
                      // قرارداد
                      // ==========================================
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
