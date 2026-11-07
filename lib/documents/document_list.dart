import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_application_1/documents/s_varede.dart';
import 'package:flutter_application_1/documents/s_sadere.dart';
import 'package:flutter_application_1/documents/s_gharardad.dart';

import '../widgets/header.dart';
import '../widgets/notification.dart';
import '../widgets/filter_button.dart';
import '../widgets/buttons.dart';
import '../widgets/table.dart';
import 'filter.dart';
import '../data/document_repository.dart';
import '../domain/documents.dart';
import 'package:flutter_application_1/core/theme.dart';

/// Identifies a single filter field so active-filter chips can clear it
/// without relying on fragile magic strings.
enum _FilterField {
  letterNumber,
  fromDate,
  toDate,
  title,
  organization,
  priority,
  keyword,
}

class DocumentList extends StatefulWidget {
  const DocumentList({super.key, this.initialPendingOnly = false});

  final bool initialPendingOnly;

  @override
  State<DocumentList> createState() => _DocumentListState();
}

class _DocumentListState extends State<DocumentList> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  FilterValues? _filterValues;

  Set<DocumentType> _selectedTypes = {};

  bool _pendingOnly = false;

  int _currentPage = 1;

  static const int _mobileBreakpoint = 600;
  static const int _tabletBreakpoint = 1000;
  static const int _rowsPerPage = 10;
  static const int _maxPages = 999;

  @override
  void initState() {
    super.initState();
    DocumentRepository.instance.addListener(_onRepositoryChanged);
    _pendingOnly = widget.initialPendingOnly;
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

  bool _isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width < _mobileBreakpoint;
  }

  bool _isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return width >= _mobileBreakpoint && width < _tabletBreakpoint;
  }

  double _horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < _mobileBreakpoint) {
      return 16.w;
    }

    if (width < _tabletBreakpoint) {
      return 24.w;
    }

    return 32.w;
  }

  String _docPriority(Document doc) => switch (doc) {
        OutgoingLetterDocument(:final priority) => priority,
        IncomingLetterDocument(:final priority) => priority,
        ContractDocument() => kNormalPriority,
      };

  bool _docNeedsFollowUp(Document doc) => switch (doc) {
        OutgoingLetterDocument(:final needsFollowUp) => needsFollowUp,
        IncomingLetterDocument(:final needsFollowUp) => needsFollowUp,
        ContractDocument() => false,
      };

  List<Document> get _typedDocuments {
    final repo = DocumentRepository.instance;

    final types = _selectedTypes.isEmpty
        ? DocumentType.values.toSet()
        : _selectedTypes;

    final docs = <Document>[];

    if (types.contains(DocumentType.outgoing)) {
      docs.addAll(repo.outgoingLetters);
    }

    if (types.contains(DocumentType.incoming)) {
      docs.addAll(repo.incomingLetters);
    }

    if (types.contains(DocumentType.contract)) {
      docs.addAll(repo.contracts);
    }

    return docs;
  }

  /// True when [docDate] is on or after [from]. Uses a numeric Jalali compare
  /// when both sides parse, otherwise falls back to a string compare.
  bool _dateMeetsLowerBound(String docDate, String from) {
    final a = jalaliToComparable(docDate);
    final b = jalaliToComparable(from);
    if (a != null && b != null) return a >= b;
    return docDate.compareTo(from) >= 0;
  }

  /// True when [docDate] is on or before [to].
  bool _dateMeetsUpperBound(String docDate, String to) {
    final a = jalaliToComparable(docDate);
    final b = jalaliToComparable(to);
    if (a != null && b != null) return a <= b;
    return docDate.compareTo(to) <= 0;
  }

  bool _matchesFilter(Document doc, FilterValues f) {
    if (f.letterNumber.trim().isNotEmpty &&
        !doc.letterNumber.contains(f.letterNumber.trim())) {
      return false;
    }

    if (f.fromDate.trim().isNotEmpty &&
        !_dateMeetsLowerBound(doc.date, f.fromDate.trim())) {
      return false;
    }

    if (f.toDate.trim().isNotEmpty &&
        !_dateMeetsUpperBound(doc.date, f.toDate.trim())) {
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

    if (f.priority != null && _docPriority(doc) != f.priority) {
      return false;
    }

    if (f.keywords.isNotEmpty) {
      final matchesAllKeywords = f.keywords.every(
        (keyword) => doc.tags.any((tag) => tag.contains(keyword)),
      );

      if (!matchesAllKeywords) {
        return false;
      }
    }

    return true;
  }

  bool _matchesPending(Document doc) {
    if (!_pendingOnly) {
      return true;
    }

    return _docNeedsFollowUp(doc);
  }

  List<Document> get _filteredDocuments {
    return _typedDocuments.where((doc) {
      if (_filterValues != null && !_matchesFilter(doc, _filterValues!)) {
        return false;
      }

      return _matchesPending(doc);
    }).toList();
  }

  DocumentTableRow _mapToRow(Document doc) {
    return switch (doc) {
      OutgoingLetterDocument() => DocumentTableRow.fromOutgoing(
        doc,
        onEdit: () => _openForm(doc),
        onAddAttachment: () => _openForm(doc, openToAttachments: true),
        onDelete: () => _confirmDelete(doc),
      ),
      IncomingLetterDocument() => DocumentTableRow.fromIncoming(
        doc,
        onEdit: () => _openForm(doc),
        onAddAttachment: () => _openForm(doc, openToAttachments: true),
        onDelete: () => _confirmDelete(doc),
      ),
      ContractDocument() => DocumentTableRow.fromContract(
        doc,
        onEdit: () => _openForm(doc),
        onAddAttachment: () => _openForm(doc, openToAttachments: true),
        onDelete: () => _confirmDelete(doc),
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

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  void _removeFilterField(_FilterField field, {String? keyword}) {
    final f = _filterValues;

    if (f == null) return;

    final updated = FilterValues(
      letterNumber: field == _FilterField.letterNumber ? '' : f.letterNumber,

      fromDate: field == _FilterField.fromDate ? '' : f.fromDate,

      toDate: field == _FilterField.toDate ? '' : f.toDate,

      title: field == _FilterField.title ? '' : f.title,

      organization: field == _FilterField.organization ? '' : f.organization,

      priority: field == _FilterField.priority ? null : f.priority,

      keywords: field == _FilterField.keyword
          ? f.keywords.where((k) => k != keyword).toList()
          : f.keywords,
    );

    setState(() {
      _filterValues = updated.isEmpty ? null : updated;

      _currentPage = 1;
    });
  }

  Widget _filterChip(String label, VoidCallback onDeleted) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          color: AppColors.background,
          fontSize: 13.sp,
        ),
      ),
      backgroundColor: AppColors.primary,
      deleteIcon: Icon(
        Icons.close,
        size: 16.sp,
        color: AppColors.background,
      ),
      onDeleted: onDeleted,
    );
  }

  List<Widget> _buildActiveFilterChips() {
    final chips = <Widget>[];

    for (final type in _selectedTypes) {
      chips.add(
        _filterChip(
          type.label,
          () => setState(
            () => _selectedTypes = {..._selectedTypes}..remove(type),
          ),
        ),
      );
    }

    if (_pendingOnly) {
      chips.add(
        _filterChip(
          'نیازمند پیگیری',
          () => setState(() => _pendingOnly = false),
        ),
      );
    }

    final f = _filterValues;

    if (f == null) {
      return chips;
    }

    if (f.letterNumber.isNotEmpty) {
      chips.add(
        _filterChip(
          'شماره نامه: ${f.letterNumber}',
          () => _removeFilterField(_FilterField.letterNumber),
        ),
      );
    }

    if (f.fromDate.isNotEmpty) {
      chips.add(
        _filterChip(
          'از تاریخ: ${f.fromDate}',
          () => _removeFilterField(_FilterField.fromDate),
        ),
      );
    }

    if (f.toDate.isNotEmpty) {
      chips.add(
        _filterChip(
          'تا تاریخ: ${f.toDate}',
          () => _removeFilterField(_FilterField.toDate),
        ),
      );
    }

    if (f.title.isNotEmpty) {
      chips.add(
        _filterChip('عنوان: ${f.title}', () => _removeFilterField(_FilterField.title)),
      );
    }

    if (f.organization.isNotEmpty) {
      chips.add(
        _filterChip(
          'سازمان/شرکت: ${f.organization}',
          () => _removeFilterField(_FilterField.organization),
        ),
      );
    }

    if (f.priority != null) {
      chips.add(
        _filterChip(
          'اولویت: ${f.priority}',
          () => _removeFilterField(_FilterField.priority),
        ),
      );
    }

    for (final keyword in f.keywords) {
      chips.add(
        _filterChip(
          'کلمات کلیدی: $keyword',
          () => _removeFilterField(_FilterField.keyword, keyword: keyword),
        ),
      );
    }

    return chips;
  }

  bool get _hasAnyActiveFilter =>
      _selectedTypes.isNotEmpty || _pendingOnly || _filterValues != null;

  Widget _buildPendingButton(BuildContext context) {
    final isMobile = _isMobile(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _horizontalPadding(context)),
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: isMobile ? double.infinity : null,
          child: PendingLettersButton(
            onPressed: () {
              setState(() {
                _pendingOnly = !_pendingOnly;

                _currentPage = 1;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentTypeButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _horizontalPadding(context)),
      child: DocumentTypeFilterButtons(
        selected: _selectedTypes,
        onChanged: (selected) {
          setState(() {
            _selectedTypes = selected;

            _currentPage = 1;
          });
        },
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    final isMobile = _isMobile(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _horizontalPadding(context)),
      child: Align(
        alignment: Alignment.centerRight,
        child: CustomButton(
          label: 'فیلتر',
          type: ButtonType.primary,
          icon: Icon(Icons.filter_alt, size: 20.sp),
          width: isMobile ? double.infinity : 144.w,
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
    );
  }

  Widget _buildActiveFilters(BuildContext context) {
    if (!_hasAnyActiveFilter) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _horizontalPadding(context)),
      child: Align(
        alignment: Alignment.centerRight,
        child: Wrap(
          alignment: WrapAlignment.end,
          spacing: 8.w,
          runSpacing: 8.h,
          children: _buildActiveFilterChips(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rows = _filteredDocuments.map(_mapToRow).toList();

    const rowsPerPage = _rowsPerPage;

    final totalPages = (rows.length / rowsPerPage).ceil().clamp(1, _maxPages);

    return Scaffold(
      key: _scaffoldKey,

      backgroundColor: AppColors.backgroundMuted,

      appBar: const AppHeader(title: 'لیست اسناد', leading: HeaderLeading.back),

      drawer: FilterPanel(
        initialValues: _filterValues,

        onApply: (values) {
          setState(() {
            _filterValues = values.isEmpty ? null : values;
            _currentPage = 1;
          });
        },

        onClear: () {
          setState(() {
            _filterValues = null;
            _currentPage = 1;
          });
        },
      ),

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),

              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,

                  children: [
                    SizedBox(
                      height: _isMobile(context)
                          ? 24.h
                          : _isTablet(context)
                          ? 40.h
                          : 64.h,
                    ),

                    _buildPendingButton(context),

                    SizedBox(height: _isMobile(context) ? 20.h : 32.h),

                    _buildDocumentTypeButtons(context),

                    SizedBox(height: _isMobile(context) ? 32.h : 64.h),

                    _buildFilterButton(context),

                    SizedBox(height: _isMobile(context) ? 20.h : 32.h),

                    _buildActiveFilters(context),

                    if (_hasAnyActiveFilter)
                      SizedBox(height: _isMobile(context) ? 16.h : 24.h),

                    DocumentTable(
                      rows: rows,
                      rowsPerPage: rowsPerPage,
                      showPagination: true,
                      currentPage: _currentPage,
                      totalPages: totalPages,

                      onPreviousPage: () {
                        if (_currentPage > 1) {
                          setState(() => _currentPage--);
                        }
                      },

                      onNextPage: () {
                        if (_currentPage < totalPages) {
                          setState(() => _currentPage++);
                        }
                      },

                      onPageSelected: (page) {
                        setState(() => _currentPage = page);
                      },
                    ),

                    SizedBox(height: _isMobile(context) ? 64.h : 128.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
