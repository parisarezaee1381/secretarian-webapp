import 'package:flutter/material.dart';

import 'package:flutter_application_1/documents/s_sadere.dart';
import 'package:flutter_application_1/documents/s_varede.dart';
import 'package:flutter_application_1/documents/s_gharardad.dart';

import 'widgets.dart/header.dart';
import 'widgets.dart/buttons.dart';
import 'widgets.dart/table.dart';
import 'widgets.dart/dropdown_menu_items.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // وضعیت منوی «ثبت سند جدید»
  bool _showDocumentMenu = false;

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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4F4),

      appBar: const AppHeader(
        title: 'داشبورد اصلی',
        leading: HeaderLeading.settings,
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
                    onPressed: () {},
                  ),
                ),

                const SizedBox(height: 64),

                Align(
                  alignment: Alignment.center,
                  child: CustomButton(
                    label: '۲ نامه نیازمند پیگیری برای امروز',
                    type: ButtonType.secondary,
                    width: 336,
                    icon: const Icon(
                      Icons.notifications_none_outlined,
                      color: Color(0xFF3863A8),
                    ),
                    onPressed: () {},
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
                  rows: const [
                    DocumentTableRow(
                      number: '۱',
                      organization: 'شرکت نمونه',
                      title: 'قرارداد همکاری',
                      priority: 'بالا',
                    ),
                    DocumentTableRow(
                      number: '۲',
                      organization: 'سازمان نمونه',
                      title: 'نامه اداری',
                      priority: 'متوسط',
                    ),
                    DocumentTableRow(
                      number: '۳',
                      organization: 'شرکت نمونه',
                      title: 'درخواست همکاری',
                      priority: 'پایین',
                    ),
                    DocumentTableRow(
                      number: '۴',
                      organization: 'سازمان نمونه',
                      title: 'نامه پیگیری',
                      priority: 'بالا',
                    ),
                    DocumentTableRow(
                      number: '۵',
                      organization: 'سازمان نمونه',
                      title: 'گزارش عملکرد',
                      priority: 'متوسط',
                    ),
                  ],
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

                        // فعلاً هیچ کاری نمی‌کند
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

                        // فعلاً هیچ کاری نمی‌کند
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

                        // فعلاً هیچ کاری نمی‌کند
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