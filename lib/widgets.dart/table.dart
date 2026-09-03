import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../documents.dart';

class DocumentTable extends StatelessWidget {
  // عرض ستون‌ها ریسپانسیو است (بر اساس عرض صفحه).
  // ارتفاع ردیف‌ها و فاصله بین ردیف‌ها ثابت می‌مانند.
  static double get columnWidth => 284.w;
  static const double rowHeight = 64.0;
  static const double rowSpacing = 16.0;

  static const Color lightColumnColor = Color(0xFFBBBBC0);
  static const Color darkColumnColor = Color(0xFF828288);
  static const Color textColor = Color(0xFF101018);
  static const Color paginationColor = Color(0xFF3863A8);

  final List<DocumentTableRow> rows;

  final int rowsPerPage;

  final bool showPagination;

  final int currentPage;

  final int totalPages;

  final VoidCallback? onPreviousPage;

  final VoidCallback? onNextPage;

  final void Function(int page)? onPageSelected;

  const DocumentTable({
    super.key,
    required this.rows,
    this.rowsPerPage = 10,
    this.showPagination = false,
    this.currentPage = 1,
    this.totalPages = 1,
    this.onPreviousPage,
    this.onNextPage,
    this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final startIndex = (currentPage - 1) * rowsPerPage;
    final visibleRows = rows.skip(startIndex).take(rowsPerPage).toList();

    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),

            const SizedBox(height: rowSpacing),

            ...List.generate(visibleRows.length, (index) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == visibleRows.length - 1 ? 0 : rowSpacing,
                ),
                child: _buildDataRow(visibleRows[index]),
              );
            }),

            if (showPagination) ...[
              const SizedBox(height: 32),
              _buildPagination(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeaderCell(text: 'شماره', columnIndex: 0),

        _buildHeaderCell(text: 'سازمان/شرکت', columnIndex: 1),

        _buildHeaderCell(text: 'عنوان/خلاصه', columnIndex: 2),

        _buildHeaderCell(text: 'اولویت', columnIndex: 3),

        _buildHeaderCell(text: 'عملیات', columnIndex: 4),
      ],
    );
  }

  Widget _buildDataRow(DocumentTableRow row) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDataCell(text: row.number, columnIndex: 0),

        _buildDataCell(text: row.organization, columnIndex: 1),

        _buildDataCell(text: row.title, columnIndex: 2),

        _buildDataCell(text: row.priority, columnIndex: 3),

        _buildOperationCell(
          hasAttachments: row.hasAttachments,
          onAddAttachment: row.onAddAttachment,
          onEdit: row.onEdit,
          columnIndex: 4,
        ),
      ],
    );
  }

  Widget _buildHeaderCell({required String text, required int columnIndex}) {
    return Container(
      width: columnWidth,
      height: rowHeight,
      alignment: Alignment.center,
      color: _getColumnColor(columnIndex),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Estedad',
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildDataCell({required String text, required int columnIndex}) {
    return Container(
      width: columnWidth,
      height: rowHeight,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      color: _getColumnColor(columnIndex),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Estedad',
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildOperationCell({
    required bool hasAttachments,
    required int columnIndex,
    VoidCallback? onAddAttachment,
    VoidCallback? onEdit,
  }) {
    return Container(
      width: columnWidth,
      height: rowHeight,
      alignment: Alignment.center,
      color: _getColumnColor(columnIndex),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // آیکون پیوست: اگر پیوست وجود داشته باشه، آیکون گیره
          // (غیرقابل‌کلیک) نشون داده می‌شه. در غیر این صورت، آیکون
          // + آبی و قابل‌کلیک برای افزودن پیوست نشون داده می‌شه.
          if (hasAttachments)
            Icon(Icons.attach_file, size: 20.sp, color: const Color(0xFF3863A8))
          else
            IconButton(
              onPressed: onAddAttachment,
              icon: Icon(Icons.add_circle_outline, size: 20.sp),
              color: const Color(0xFF3863A8),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),

          SizedBox(width: 12.w),

          // آیکون ویرایش
          IconButton(
            onPressed: onEdit,
            icon: Icon(Icons.edit_outlined, size: 20.sp),
            color: const Color(0xFF3863A8),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),

          SizedBox(width: 12.w),

          // آیکون حذف
          IconButton(
            onPressed: () {
              // بعداً تکمیل می‌شه: حذف سند
            },
            icon: Icon(Icons.delete_outline, size: 20.sp),
            color: const Color(0xFF3863A8),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Color _getColumnColor(int columnIndex) {
    // ستون‌های ۱، ۳ و ۵
    if (columnIndex == 0 || columnIndex == 2 || columnIndex == 4) {
      return lightColumnColor;
    }

    // ستون‌های ۲ و ۴
    return darkColumnColor;
  }

  Widget _buildPagination() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // دکمه صفحه قبل
        IconButton(
          onPressed: currentPage > 1 ? onPreviousPage : null,
          icon: Icon(Icons.chevron_left, size: 24.sp),
          color: paginationColor,
        ),

        SizedBox(width: 8.w),

        // شماره صفحات
        ...List.generate(totalPages, (index) {
          final pageNumber = index + 1;
          final isCurrentPage = pageNumber == currentPage;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: InkWell(
              onTap: () {
                onPageSelected?.call(pageNumber);
              },
              borderRadius: BorderRadius.circular(6.r),
              child: Container(
                width: 36.w,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.r),
                  color: isCurrentPage ? paginationColor : Colors.transparent,
                ),
                child: Text(
                  '$pageNumber',
                  style: TextStyle(
                    fontFamily: 'Estedad',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: isCurrentPage ? Colors.white : paginationColor,
                  ),
                ),
              ),
            ),
          );
        }),

        SizedBox(width: 8.w),

        // دکمه صفحه بعد
        IconButton(
          onPressed: currentPage < totalPages ? onNextPage : null,
          icon: Icon(Icons.chevron_right, size: 24.sp),
          color: paginationColor,
        ),
      ],
    );
  }
}

class DocumentTableRow {
  final String number;
  final String organization;
  final String title;
  final String priority;
  final Widget? operation;
  final bool hasAttachments;
  final VoidCallback? onAddAttachment;
  final VoidCallback? onEdit;

  const DocumentTableRow({
    required this.number,
    required this.organization,
    required this.title,
    required this.priority,
    this.operation,
    this.hasAttachments = false,
    this.onAddAttachment,
    this.onEdit,
  });

  factory DocumentTableRow.fromOutgoing(
    OutgoingLetterDocument doc, {
    Widget? operation,
    VoidCallback? onEdit,
    VoidCallback? onAddAttachment,
  }) {
    return DocumentTableRow(
      number: doc.letterNumber,
      organization: doc.organization,
      title: doc.subject,
      priority: doc.priority,
      operation: operation,
      hasAttachments: doc.attachments.isNotEmpty,
      onAddAttachment: onAddAttachment,
      onEdit: onEdit,
    );
  }

  factory DocumentTableRow.fromIncoming(
    IncomingLetterDocument doc, {
    Widget? operation,
    VoidCallback? onAddAttachment,
    VoidCallback? onEdit,
  }) {
    return DocumentTableRow(
      number: doc.letterNumber,
      organization: doc.organization,
      title: doc.subject,
      priority: doc.priority,
      operation: operation,
      hasAttachments: doc.attachments.isNotEmpty,
      onAddAttachment: onAddAttachment,
      onEdit: onEdit,
    );
  }

  factory DocumentTableRow.fromContract(
    ContractDocument doc, {
    Widget? operation,
    VoidCallback? onAddAttachment,
    VoidCallback? onEdit,
  }) {
    return DocumentTableRow(
      number: doc.letterNumber,
      organization: doc.organization,
      title: doc.subject,
      priority: 'عادی',
      operation: operation,
      hasAttachments: doc.attachments.isNotEmpty,
      onAddAttachment: onAddAttachment,
      onEdit: onEdit,
    );
  }
}
