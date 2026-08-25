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

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // وضعیت منوی «ثبت سند جدید»
  bool _showDocumentMenu = false;
  DocumentTableRow _mapToRow(dynamic doc) {
    if (doc is OutgoingLetterDocument) {
      return DocumentTableRow.fromOutgoing(
        doc,
        operation: const Icon(Icons.more_horiz, color: Color(0xFF101018)), onEdit: () {  }, onAddAttachment: () {  },
      );
    } else if (doc is IncomingLetterDocument) {
      return DocumentTableRow.fromIncoming(
        doc,
        operation: const Icon(Icons.more_horiz, color: Color(0xFF101018)),
      );
    } else if (doc is ContractDocument) {
      return DocumentTableRow.fromContract(
        doc,
        operation: const Icon(Icons.more_horiz, color: Color(0xFF101018)),
      );
    }
    throw ArgumentError('نوع document ناشناخته');
  }

  // باز و بسته کردن منو با کلیک روی دکمه
  void _toggleDocumentMenu() {
    setState(() {
      _showDocumentMenu = !_showDocumentMenu;
    });
  }

  // بستن منو با کلیک خارج از آن
  void _closeDocumentMenu() {
    if (!_showDocumentMenu) return;

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
      MaterialPageRoute(
        builder: (context) => SettingsViewPage(
  username: 'کاربر',
  email: 'example@email.com',
),
      ),
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

                const SizedBox(height: 64),

                Align(
                  alignment: Alignment.center,
                  child: CustomButton(
                    label: '+ ثبت سند جدید',
                    type: ButtonType.primary,
                    width: 204,
                    onPressed: _toggleDocumentMenu,
                  ),
                ),

                const SizedBox(height: 32),

                Align(
  alignment: Alignment.center,
  child: CustomButton(
    label: 'لیست اسناد',
    type: ButtonType.secondary,
    width: 204,
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

                const SizedBox(height: 64),

                Align(
  alignment: Alignment.center,
  child: PendingLettersButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DocumentList(initialPendingOnly: true),
        ),
      );
    },
  ),
),

                const SizedBox(height: 64),

                const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 32),
                    child: Text(
                      'آخرین اسناد',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color(0xFF101018),
                        fontFamily: 'Estedad',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                                DocumentTable(
                  rows: rows,
                  rowsPerPage: 5,
                  showPagination: false,
                ),

                const SizedBox(height: 128),
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
              top: 128,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 204,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      
                      DropdownMenuItemWidget(
                        label: 'صادره',
                        isFirst: true,

                        onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const OutgoingLetterFormPage(),
    ),
  );
},
                      ),

                      DropdownMenuItemWidget(
                        label: 'وارده',

                        onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const IncomingLetterFormPage(),
    ),
  );
},
                      ),

                      DropdownMenuItemWidget(
                        label: 'قرارداد',
                        isLast: true,

                        onTap: () {
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