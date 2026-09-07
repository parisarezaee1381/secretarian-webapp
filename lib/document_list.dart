import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_application_1/documents/s_varede.dart';

import 'widgets.dart/header.dart';
import 'widgets.dart/notification.dart';
import 'widgets.dart/filter_button.dart';
import 'widgets.dart/buttons.dart';
import 'widgets.dart/table.dart';
import 'filter.dart';
import '../document_repository.dart';
import '../documents.dart';

import 'documents/s_sadere.dart';
import 'documents/s_gharardad.dart';

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

  @override
  void initState() {
    super.initState();
    _pendingOnly = widget.initialPendingOnly;
  }

  bool _isMobile(BuildContext context) {
    return MediaQuery.sizeOf(context).width < 600;
  }

  bool _isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    return width >= 600 && width < 1000;
  }

  double _horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < 600) {
      return 16.w;
    }

    if (width < 1000) {
      return 24.w;
    }

    return 32.w;
  }

  String _docLetterNumber(dynamic doc) {
    if (doc is OutgoingLetterDocument) {
      return doc.letterNumber;
    }

    if (doc is IncomingLetterDocument) {
      return doc.letterNumber;
    }

    if (doc is ContractDocument) {
      return doc.letterNumber;
    }

    return '';
  }

  String _docDate(dynamic doc) {
    if (doc is OutgoingLetterDocument) {
      return doc.date;
    }

    if (doc is IncomingLetterDocument) {
      return doc.date;
    }

    if (doc is ContractDocument) {
      return doc.date;
    }

    return '';
  }

  String _docSubject(dynamic doc) {
    if (doc is OutgoingLetterDocument) {
      return doc.subject;
    }

    if (doc is IncomingLetterDocument) {
      return doc.subject;
    }

    if (doc is ContractDocument) {
      return doc.subject;
    }

    return '';
  }

  String _docOrganization(dynamic doc) {
    if (doc is OutgoingLetterDocument) {
      return doc.organization;
    }

    if (doc is IncomingLetterDocument) {
      return doc.organization;
    }

    if (doc is ContractDocument) {
      return doc.organization;
    }

    return '';
  }

  String _docPriority(dynamic doc) {
    if (doc is OutgoingLetterDocument) {
      return doc.priority;
    }

    if (doc is IncomingLetterDocument) {
      return doc.priority;
    }

    if (doc is ContractDocument) {
      return 'عادی';
    }

    return '';
  }

  List<String> _docTags(dynamic doc) {
    if (doc is OutgoingLetterDocument) {
      return doc.tags;
    }

    if (doc is IncomingLetterDocument) {
      return doc.tags;
    }

    if (doc is ContractDocument) {
      return doc.tags;
    }

    return const [];
  }

  bool _docNeedsFollowUp(dynamic doc) {
    if (doc is OutgoingLetterDocument) {
      return doc.needsFollowUp;
    }

    if (doc is IncomingLetterDocument) {
      return doc.needsFollowUp;
    }

    return false;
  }

  List<dynamic> get _typedDocuments {
    final repo = DocumentRepository.instance;

    final types = _selectedTypes.isEmpty
        ? DocumentType.values.toSet()
        : _selectedTypes;

    final docs = <dynamic>[];

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

  bool _matchesFilter(dynamic doc, FilterValues f) {
    if (f.letterNumber.trim().isNotEmpty &&
        !_docLetterNumber(doc).contains(f.letterNumber.trim())) {
      return false;
    }

    if (f.fromDate.trim().isNotEmpty &&
        _docDate(doc).compareTo(f.fromDate.trim()) < 0) {
      return false;
    }

    if (f.toDate.trim().isNotEmpty &&
        _docDate(doc).compareTo(f.toDate.trim()) > 0) {
      return false;
    }

    if (f.title.trim().isNotEmpty &&
        !_docSubject(doc).contains(f.title.trim())) {
      return false;
    }

    if (f.organization.trim().isNotEmpty &&
        !_docOrganization(doc).contains(f.organization.trim())) {
      return false;
    }

    if (f.priority != null && _docPriority(doc) != f.priority) {
      return false;
    }

    if (f.keywords.isNotEmpty) {
      final tags = _docTags(doc);

      final matchesAllKeywords = f.keywords.every(
        (keyword) => tags.any((tag) => tag.contains(keyword)),
      );

      if (!matchesAllKeywords) {
        return false;
      }
    }

    return true;
  }

  bool _matchesPending(dynamic doc) {
    if (!_pendingOnly) {
      return true;
    }

    return _docNeedsFollowUp(doc);
  }

  List<dynamic> get _filteredDocuments {
    return _typedDocuments.where((doc) {
      if (_filterValues != null && !_matchesFilter(doc, _filterValues!)) {
        return false;
      }

      return _matchesPending(doc);
    }).toList();
  }

  DocumentTableRow _mapToRow(dynamic doc) {
    const operation = Icon(Icons.more_horiz, color: Color(0xFF101018));

    if (doc is OutgoingLetterDocument) {
      return DocumentTableRow.fromOutgoing(
        doc,
        operation: operation,
        onEdit: () => _openOutgoingForm(doc),
        onAddAttachment: () => _openOutgoingForm(doc),
        onDelete: () => _deleteOutgoing(doc),
      );
    }

    if (doc is IncomingLetterDocument) {
      return DocumentTableRow.fromIncoming(
        doc,
        operation: operation,
        onEdit: () => _openincomingForm(doc),
        onAddAttachment: () => _openincomingForm(doc),
        onDelete: () => _deleteIncoming(doc),
      );
    }

    if (doc is ContractDocument) {
      return DocumentTableRow.fromContract(
        doc,
        operation: operation,
        onEdit: () => _opencontractForm(doc),
        onAddAttachment: () => _opencontractForm(doc),
        onDelete: () => _deleteContract(doc),
      );
    }

    throw ArgumentError('نوع سند ناشناخته');
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
    ).then((_) => setState(() {}));
  }

  void _openincomingForm(IncomingLetterDocument doc) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IncomingLetterFormPage(initialDocument: doc),
      ),
    ).then((_) => setState(() {}));
  }

  void _opencontractForm(ContractDocument doc) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContractFormPage(initialDocument: doc),
      ),
    ).then((_) => setState(() {}));
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
          color: const Color(0xFFF3F3F7),
          fontFamily: 'Estedad',
          fontSize: 13.sp,
        ),
      ),
      backgroundColor: const Color(0xFF3863A8),
      deleteIcon: Icon(
        Icons.close,
        size: 16.sp,
        color: const Color(0xFFF3F3F7),
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
          () => _removeFilterField('letterNumber'),
        ),
      );
    }

    if (f.fromDate.isNotEmpty) {
      chips.add(
        _filterChip(
          'از تاریخ: ${f.fromDate}',
          () => _removeFilterField('fromDate'),
        ),
      );
    }

    if (f.toDate.isNotEmpty) {
      chips.add(
        _filterChip(
          'تا تاریخ: ${f.toDate}',
          () => _removeFilterField('toDate'),
        ),
      );
    }

    if (f.title.isNotEmpty) {
      chips.add(
        _filterChip('عنوان: ${f.title}', () => _removeFilterField('title')),
      );
    }

    if (f.organization.isNotEmpty) {
      chips.add(
        _filterChip(
          'سازمان/شرکت: ${f.organization}',
          () => _removeFilterField('organization'),
        ),
      );
    }

    if (f.priority != null) {
      chips.add(
        _filterChip(
          'اولویت: ${f.priority}',
          () => _removeFilterField('priority'),
        ),
      );
    }

    for (final keyword in f.keywords) {
      chips.add(
        _filterChip(
          'کلمات کلیدی: $keyword',
          () => _removeFilterField('keyword', keyword: keyword),
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
        initialSelected: _selectedTypes,
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

    const rowsPerPage = 10;

    final totalPages = (rows.length / rowsPerPage).ceil().clamp(1, 999);

    return Scaffold(
      key: _scaffoldKey,

      backgroundColor: const Color(0xFFF5F4F4),

      appBar: const AppHeader(title: 'لیست اسناد', leading: HeaderLeading.back),

      drawer: FilterPanel(
        initialValues: _filterValues,

        onApply: (values) {
          setState(() {
            _filterValues = values;
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
