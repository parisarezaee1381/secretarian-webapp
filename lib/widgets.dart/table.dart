import 'package:flutter/material.dart';
import '../documents.dart';

class DocumentTable extends StatelessWidget {

  static const double columnWidth = 284.0;
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

    final visibleRows = rows.take(rowsPerPage).toList();

    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),

            const SizedBox(height: rowSpacing),

            ...List.generate(
              visibleRows.length,
              (index) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == visibleRows.length - 1
                        ? 0
                        : rowSpacing,
                  ),
                  child: _buildDataRow(visibleRows[index]),
                );
              },
            ),

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
        _buildHeaderCell(
          text: 'شماره',
          columnIndex: 0,
        ),

        _buildHeaderCell(
          text: 'سازمان/شرکت',
          columnIndex: 1,
        ),

        _buildHeaderCell(
          text: 'عنوان/خلاصه',
          columnIndex: 2,
        ),

        _buildHeaderCell(
          text: 'اولویت',
          columnIndex: 3,
        ),

        _buildHeaderCell(
          text: 'عملیات',
          columnIndex: 4,
        ),
      ],
    );
  }

  Widget _buildDataRow(DocumentTableRow row) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDataCell(
          text: row.number,
          columnIndex: 0,
        ),

        _buildDataCell(
          text: row.organization,
          columnIndex: 1,
        ),

        _buildDataCell(
          text: row.title,
          columnIndex: 2,
        ),

        _buildDataCell(
          text: row.priority,
          columnIndex: 3,
        ),

        _buildOperationCell(
          operation: row.operation,
          columnIndex: 4,
        ),
      ],
    );
  }

  Widget _buildHeaderCell({
    required String text,
    required int columnIndex,
  }) {
    return Container(
      width: columnWidth,
      height: rowHeight,
      alignment: Alignment.center,
      color: _getColumnColor(columnIndex),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Estedad',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildDataCell({
    required String text,
    required int columnIndex,
  }) {
    return Container(
      width: columnWidth,
      height: rowHeight,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      color: _getColumnColor(columnIndex),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontFamily: 'Estedad',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildOperationCell({
    required Widget? operation,
    required int columnIndex,
  }) {
    return Container(
      width: columnWidth,
      height: rowHeight,
      alignment: Alignment.center,
      color: _getColumnColor(columnIndex),
      child: operation ?? const SizedBox(),
    );
  }

  Color _getColumnColor(int columnIndex) {
    // ستون‌های ۱، ۳ و ۵
    if (columnIndex == 0 ||
        columnIndex == 2 ||
        columnIndex == 4) {
      return lightColumnColor;
    }

    // ستون‌های ۲ و ۴
    return darkColumnColor;
  }

  Widget _buildPagination() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // دکمه صفحه قبل
          IconButton(
            onPressed:
                currentPage > 1 ? onPreviousPage : null,
            icon: const Icon(
              Icons.chevron_right,
              size: 24,
            ),
            color: paginationColor,
          ),

          const SizedBox(width: 8),

          // شماره صفحات
          ...List.generate(
            totalPages,
            (index) {
              final pageNumber = index + 1;
              final isCurrentPage =
                  pageNumber == currentPage;

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 4,
                ),
                child: InkWell(
                  onTap: () {
                    onPageSelected?.call(pageNumber);
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: isCurrentPage
                          ? paginationColor
                          : Colors.transparent,
                    ),
                    child: Text(
                      '$pageNumber',
                      style: TextStyle(
                        fontFamily: 'Estedad',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isCurrentPage
                            ? Colors.white
                            : paginationColor,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(width: 8),

          // دکمه صفحه بعد
          IconButton(
            onPressed:
                currentPage < totalPages
                    ? onNextPage
                    : null,
            icon: const Icon(
              Icons.chevron_left,
              size: 24,
            ),
            color: paginationColor,
          ),
        ],
      ),
    );
  }
}

class DocumentTableRow {
  final String number;
  final String organization;
  final String title;
  final String priority;
  final Widget? operation;

  const DocumentTableRow({
    required this.number,
    required this.organization,
    required this.title,
    required this.priority,
    this.operation,
  });

  factory DocumentTableRow.fromOutgoing(
    OutgoingLetterDocument doc, {
    Widget? operation,
  }) {
    return DocumentTableRow(
      number: doc.letterNumber,
      organization: doc.organization,
      title: doc.subject,
      priority: doc.priority,
      operation: operation,
    );
  }

  factory DocumentTableRow.fromIncoming(
    IncomingLetterDocument doc, {
    Widget? operation,
  }) {
    return DocumentTableRow(
      number: doc.letterNumber,
      organization: doc.organization,
      title: doc.subject,
      priority: doc.priority,
      operation: operation,
    );
  }

  factory DocumentTableRow.fromContract(
    ContractDocument doc, {
    Widget? operation,
  }) {
    return DocumentTableRow(
      number: doc.letterNumber,
      organization: doc.organization,
      title: doc.subject,
      priority: 'عادی', // همیشه ثابت برای قرارداد
      operation: operation,
    );
  }
}