import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../domain/documents.dart';
import 'buttons.dart';
import 'package:flutter_application_1/core/theme.dart';

/// A fixed five-column document table (number, organization, subject,
/// priority, operations) with Persian headers and alternating column
/// colors, optionally with a page bar.
///
/// Rows are always sliced to [rowsPerPage] starting at [currentPage];
/// [showPagination] only controls the page bar's visibility. Callers
/// wanting "the first N rows" therefore pass rowsPerPage alone — the
/// dashboard shows its five most recent documents this way.
class DocumentTable extends StatelessWidget {
  static double get columnWidth => 284.w;
  static double get rowHeight => 64.w;
  static double get rowSpacing => 16.w;

  static const Color lightColumnColor = AppColors.border;
  static const Color darkColumnColor = AppColors.mutedText;
  static const Color textColor = AppColors.text;
  static const Color paginationColor = AppColors.primary;

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
          onAddAttachment: row.onAddAttachment,
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
    Future<void> Function()? onDelete,
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
            Icon(
              Icons.attach_file,
              size: 20.sp,
              color: AppColors.primary,
              semanticLabel: 'دارای پیوست',
            )
          else
            IconButton(
              onPressed: onAddAttachment,
              tooltip: 'افزودن پیوست',
              icon: Icon(Icons.add_circle_outline, size: 20.sp),
              color: AppColors.primary,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),

          SizedBox(width: 12.w),

          // آیکون ویرایش
          IconButton(
            onPressed: onEdit,
            tooltip: 'ویرایش',
            icon: Icon(Icons.edit_outlined, size: 20.sp),
            color: AppColors.primary,
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
            tooltip: 'حذف',
            icon: Icon(Icons.delete_outline, size: 20.sp),
            color: AppColors.primary,
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
          backgroundColor: AppColors.background,
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
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),

                  SizedBox(height: 32.w),

                  Text(
                    'آیا از حذف سند مطمئن هستید؟',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.text,
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
          tooltip: 'صفحه قبل',
          icon: Icon(Icons.chevron_left, size: 24.sp),
          color: paginationColor,
        ),

        SizedBox(width: 8.w),

        ...List.generate(totalPages, (index) {
          final pageNumber = index + 1;
          final isCurrentPage = pageNumber == currentPage;

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Tooltip(
              message: 'صفحه $pageNumber',
              child: InkWell(
                // The current page does nothing; no ripple, no refire.
                onTap: isCurrentPage
                    ? null
                    : () {
                        onPageSelected?.call(pageNumber);
                      },
                borderRadius: BorderRadius.circular(6.r),
                child: Container(
                  width: 36.w,
                  height: 36.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    color: isCurrentPage
                        ? paginationColor
                        : Colors.transparent,
                  ),
                  child: Text(
                    '$pageNumber',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: isCurrentPage
                          ? Colors.white
                          : paginationColor,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),

        SizedBox(width: 8.w),

        IconButton(
          onPressed: currentPage < totalPages ? onNextPage : null,
          tooltip: 'صفحه بعد',
          icon: Icon(Icons.chevron_right, size: 24.sp),
          color: paginationColor,
        ),
      ],
    );
  }
}

/// One row of a [DocumentTable]: the four text cells plus the callbacks
/// the operations cell is built from.
///
/// The three factories map each document type onto those cells; contracts
/// have no priority of their own and fall back to [kNormalPriority].
class DocumentTableRow {
  final String number;
  final String organization;
  final String title;
  final String priority;
  final bool hasAttachments;
  final VoidCallback? onAddAttachment;
  final VoidCallback? onEdit;
  final Future<void> Function()? onDelete;

  const DocumentTableRow({
    required this.number,
    required this.organization,
    required this.title,
    required this.priority,
    this.hasAttachments = false,
    this.onAddAttachment,
    this.onEdit,
    this.onDelete,
  });

  factory DocumentTableRow.fromOutgoing(
    OutgoingLetterDocument doc, {
    VoidCallback? onEdit,
    VoidCallback? onAddAttachment,
    Future<void> Function()? onDelete,
  }) {
    return DocumentTableRow(
      number: doc.letterNumber,
      organization: doc.organization,
      title: doc.subject,
      priority: doc.priority,
      hasAttachments: doc.attachments.isNotEmpty,
      onAddAttachment: onAddAttachment,
      onEdit: onEdit,
      onDelete: onDelete,
    );
  }

  factory DocumentTableRow.fromIncoming(
    IncomingLetterDocument doc, {
    VoidCallback? onAddAttachment,
    VoidCallback? onEdit,
    Future<void> Function()? onDelete,
  }) {
    return DocumentTableRow(
      number: doc.letterNumber,
      organization: doc.organization,
      title: doc.subject,
      priority: doc.priority,
      hasAttachments: doc.attachments.isNotEmpty,
      onAddAttachment: onAddAttachment,
      onEdit: onEdit,
      onDelete: onDelete,
    );
  }

  factory DocumentTableRow.fromContract(
    ContractDocument doc, {
    VoidCallback? onAddAttachment,
    VoidCallback? onEdit,
    Future<void> Function()? onDelete,
  }) {
    return DocumentTableRow(
      number: doc.letterNumber,
      organization: doc.organization,
      title: doc.subject,
      priority: kNormalPriority,
      hasAttachments: doc.attachments.isNotEmpty,
      onAddAttachment: onAddAttachment,
      onEdit: onEdit,
      onDelete: onDelete,
    );
  }
}
