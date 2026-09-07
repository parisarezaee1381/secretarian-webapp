import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../documents.dart';
import 'buttons.dart';

class DocumentTable extends StatelessWidget {
  static double get columnWidth => 284.w;
  static double get rowHeight => 64.w;
  static double get rowSpacing => 16.w;

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

            SizedBox(height: rowSpacing),

            ...List.generate(visibleRows.length, (index) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == visibleRows.length - 1 ? 0 : rowSpacing,
                ),
                child: _buildDataRow(context, visibleRows[index]),
              );
            }),

            if (showPagination) ...[SizedBox(height: 32.w), _buildPagination()],
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

  Widget _buildDataRow(BuildContext context, DocumentTableRow row) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDataCell(text: row.number, columnIndex: 0),

        _buildDataCell(text: row.organization, columnIndex: 1),

        _buildDataCell(text: row.title, columnIndex: 2),

        _buildDataCell(text: row.priority, columnIndex: 3),

        _buildOperationCell(
          context,
          hasAttachments: row.hasAttachments,
          onAddAttachment: row.onAddAttachment, // ← اضافه شد
          onEdit: row.onEdit,
          onDelete: row.onDelete,
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

  Widget _buildOperationCell(
    BuildContext context, {
    required bool hasAttachments,
    required int columnIndex,
    VoidCallback? onAddAttachment,
    VoidCallback? onEdit,
    final Future<void> Function()? onDelete,
  }) {
    return Container(
      width: columnWidth,
      height: rowHeight,
      alignment: Alignment.center,
      color: _getColumnColor(columnIndex),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
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

          IconButton(
            onPressed: onDelete == null
                ? null
                : () {
                    _showDeleteConfirmationDialog(context, onDelete);
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

  void _showDeleteConfirmationDialog(
    BuildContext context,
    Future<void> Function() onDelete,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFFF3F3F7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: SizedBox(
            width: 568.w,
            height: 360.w,
            child: Padding(
              padding: EdgeInsets.all(32.w),
              child: Column(
                children: [
                  Text(
                    'حذف سند',
                    style: TextStyle(
                      fontFamily: 'Estedad',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF101018),
                    ),
                  ),

                  SizedBox(height: 32.w),

                  Text(
                    'آیا از حذف سند مطمئن هستید؟',
                    style: TextStyle(
                      fontFamily: 'Estedad',
                      fontSize: 16.sp,
                      color: const Color(0xFF101018),
                    ),
                  ),

                  const Spacer(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        label: 'بله',
                        type: ButtonType.primary,
                        width: 160.w,
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await onDelete();
                        },
                      ),

                      SizedBox(width: 32.w),

                      CustomButton(
                        label: 'خیر',
                        type: ButtonType.secondary,
                        width: 160.w,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
        IconButton(
          onPressed: currentPage > 1 ? onPreviousPage : null,
          icon: Icon(Icons.chevron_left, size: 24.sp),
          color: paginationColor,
        ),

        SizedBox(width: 8.w),

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
                height: 36.w,
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
  final VoidCallback? onAddAttachment; // ← اضافه شد
  final VoidCallback? onEdit;
  final Future<void> Function()? onDelete;

  const DocumentTableRow({
    required this.number,
    required this.organization,
    required this.title,
    required this.priority,
    this.operation,
    this.hasAttachments = false,
    this.onAddAttachment, // ← اضافه شد
    this.onEdit,
    this.onDelete,
  });

  factory DocumentTableRow.fromOutgoing(
    OutgoingLetterDocument doc, {
    Widget? operation,
    VoidCallback? onEdit,
    VoidCallback? onAddAttachment,
    Future<void> Function()? onDelete,
  }) {
    return DocumentTableRow(
      number: doc.letterNumber,
      organization: doc.organization,
      title: doc.subject,
      priority: doc.priority,
      operation: operation,
      hasAttachments: doc.attachments.isNotEmpty,
      onAddAttachment: onAddAttachment, // ← اضافه شد
      onEdit: onEdit,
      onDelete: onDelete, // ← اضافه شد
    );
  }

  factory DocumentTableRow.fromIncoming(
    IncomingLetterDocument doc, {
    Widget? operation,
    VoidCallback? onAddAttachment, // ← اضافه شد
    VoidCallback? onEdit,
    Future<void> Function()? onDelete,
  }) {
    return DocumentTableRow(
      number: doc.letterNumber,
      organization: doc.organization,
      title: doc.subject,
      priority: doc.priority,
      operation: operation,
      hasAttachments: doc.attachments.isNotEmpty,
      onAddAttachment: onAddAttachment, // ← اضافه شد
      onEdit: onEdit,
      onDelete: onDelete,
    );
  }

  factory DocumentTableRow.fromContract(
    ContractDocument doc, {
    Widget? operation,
    VoidCallback? onAddAttachment,
    VoidCallback? onEdit,
    Future<void> Function()? onDelete,
  }) {
    return DocumentTableRow(
      number: doc.letterNumber,
      organization: doc.organization,
      title: doc.subject,
      priority: 'عادی',
      operation: operation,
      hasAttachments: doc.attachments.isNotEmpty,
      onAddAttachment: onAddAttachment, // ← اضافه شد
      onEdit: onEdit,
      onDelete: onDelete,
    );
  }
}
