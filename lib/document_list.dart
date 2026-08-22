import 'package:flutter/material.dart';

import 'widgets.dart/header.dart';
import 'widgets.dart/notification.dart';
import 'widgets.dart/filter_button.dart';
import 'widgets.dart/buttons.dart';
import 'widgets.dart/table.dart';
import 'filter.dart';
import '../document_repository.dart';
import '../documents.dart';

class DocumentList extends StatefulWidget {
  const DocumentList({super.key});

  @override
  State<DocumentList> createState() => _DocumentListState();
}

class _DocumentListState extends State<DocumentList> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  FilterValues? _filterValues;

  bool _matchesFilter(OutgoingLetterDocument doc, FilterValues f) {
    if (f.letterNumber.trim().isNotEmpty &&
        !doc.letterNumber.contains(f.letterNumber.trim())) {
      return false;
    }

    if (f.fromDate.trim().isNotEmpty &&
        doc.date.compareTo(f.fromDate.trim()) < 0) {
      return false;
    }

    if (f.toDate.trim().isNotEmpty &&
        doc.date.compareTo(f.toDate.trim()) > 0) {
      return false;
    }

    if (f.title.trim().isNotEmpty &&
        !doc.subject.contains(f.title.trim())) {
      return false;
    }

    if (f.organization.trim().isNotEmpty &&
        !doc.organization.contains(f.organization.trim())) {
      return false;
    }

    if (f.priority != null && doc.priority != f.priority) {
      return false;
    }

    if (f.keywords.isNotEmpty) {
      final matchesAllKeywords = f.keywords.every(
        (keyword) => doc.tags.any((tag) => tag.contains(keyword)),
      );
      if (!matchesAllKeywords) return false;
    }

    return true;
  }

  void _removeFilterField(String field, {String? keyword}) {
    final f = _filterValues;
    if (f == null) return;

    final updated = FilterValues(
      letterNumber: field == 'letterNumber' ? '' : f.letterNumber,
      fromDate: field == 'fromDate' ? '' : f.fromDate,
      toDate: field == 'toDate' ? '' : f.toDate,
      title: field == 'title' ? '' : f.title,
      organization: field == 'organization' ? '' : f.organization,
      priority: field == 'priority' ? null : f.priority,
      keywords: field == 'keyword'
          ? f.keywords.where((k) => k != keyword).toList()
          : f.keywords,
    );

    setState(() => _filterValues = updated.isEmpty ? null : updated);
  }

  Widget _filterChip(String label, VoidCallback onDeleted) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(
          color: Color(0xFFF3F3F7),
          fontFamily: 'Estedad',
        ),
      ),
      backgroundColor: const Color(0xFF3863A8),
      deleteIcon: const Icon(
        Icons.close,
        size: 16,
        color: Color(0xFFF3F3F7),
      ),
      onDeleted: onDeleted,
    );
  }

  List<Widget> _buildActiveFilterChips() {
    final f = _filterValues;
    if (f == null) return [];

    final chips = <Widget>[];

    if (f.letterNumber.isNotEmpty) {
      chips.add(_filterChip(
        'شماره نامه: ${f.letterNumber}',
        () => _removeFilterField('letterNumber'),
      ));
    }
    if (f.fromDate.isNotEmpty) {
      chips.add(_filterChip(
        'از تاریخ: ${f.fromDate}',
        () => _removeFilterField('fromDate'),
      ));
    }
    if (f.toDate.isNotEmpty) {
      chips.add(_filterChip(
        'تا تاریخ: ${f.toDate}',
        () => _removeFilterField('toDate'),
      ));
    }
    if (f.title.isNotEmpty) {
      chips.add(_filterChip(
        'عنوان: ${f.title}',
        () => _removeFilterField('title'),
      ));
    }
    if (f.organization.isNotEmpty) {
      chips.add(_filterChip(
        'سازمان/شرکت: ${f.organization}',
        () => _removeFilterField('organization'),
      ));
    }
    if (f.priority != null) {
      chips.add(_filterChip(
        'اولویت: ${f.priority}',
        () => _removeFilterField('priority'),
      ));
    }
    for (final keyword in f.keywords) {
      chips.add(_filterChip(
        'کلمات کلیدی: $keyword',
        () => _removeFilterField('keyword', keyword: keyword),
      ));
    }

    return chips;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filterValues == null
        ? DocumentRepository.instance.outgoingLetters
        : DocumentRepository.instance.outgoingLetters
            .where((doc) => _matchesFilter(doc, _filterValues!))
            .toList();

    final rows = filtered.map((doc) {
      return DocumentTableRow.fromOutgoing(
        doc,
        operation: const Icon(
          Icons.more_horiz,
          color: Color(0xFF101018),
        ),
      );
    }).toList();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF5F4F4),
      appBar: const AppHeader(
        title: 'لیست اسناد',
        leading: HeaderLeading.back,
      ),
      drawer: FilterPanel(
        initialValues: _filterValues,
        onApply: (values) {
          setState(() => _filterValues = values);
        },
        onClear: () {
          setState(() => _filterValues = null);
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              const SizedBox(height: 64),

              Align(
                alignment: Alignment.center,
                child: PendingLettersButton(
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

              const SizedBox(height: 32),

              const DocumentTypeFilterButtons(),

              const SizedBox(height: 64),

              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 32),
                  child: CustomButton(
                    label: 'فیلتر',
                    type: ButtonType.primary,
                    icon: const Icon(Icons.filter_alt),
                    width: 144,
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                ),
              ),

              const SizedBox(height: 32),

              if (_filterValues != null) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Wrap(
                      alignment: WrapAlignment.end,
                      spacing: 8,
                      runSpacing: 8,
                      children: _buildActiveFilterChips(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              DocumentTable(
                rows: rows,
                rowsPerPage: 10,
                showPagination: true,
                currentPage: 1,
                totalPages: 3,
                onPreviousPage: () {
                  // صفحه قبل
                },
                onNextPage: () {
                  // صفحه بعد
                },
                onPageSelected: (page) {
                  // انتخاب صفحه
                },
              ),

              const SizedBox(height: 128),
            ],
          ),
        ),
      ),
    );
  }
}