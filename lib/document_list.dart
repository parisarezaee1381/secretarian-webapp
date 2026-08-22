import 'package:flutter/material.dart';

import 'widgets.dart/header.dart';
import 'widgets.dart/notification.dart';
import 'widgets.dart/filter_button.dart';
import 'widgets.dart/buttons.dart';
import 'widgets.dart/table.dart';
import '../document_repository.dart';

class DocumentList extends StatefulWidget {
  const DocumentList({super.key});

  @override
  State<DocumentList> createState() => _DocumentListState();
}

class _DocumentListState extends State<DocumentList> {
  @override
  Widget build(BuildContext context) {
    final rows = DocumentRepository.instance.outgoingLetters.map((doc) {
      return DocumentTableRow.fromOutgoing(
        doc,
        operation: const Icon(
          Icons.more_horiz,
          color: Color(0xFF101018),
        ),
      );
    }).toList();


    return Scaffold(
      backgroundColor: const Color(0xFFF5F4F4),
      appBar: const AppHeader(
        title: 'لیست اسناد',
        leading: HeaderLeading.back,
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
                      // عملیات فیلتر
                    },
                  ),
                ),
              ),

              const SizedBox(height: 32),

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