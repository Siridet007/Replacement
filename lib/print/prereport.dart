import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:replacement/print/printreport.dart';

class PreviewReportPage extends StatefulWidget {
  final String date;
  final List detail;
  const PreviewReportPage({super.key, required this.detail, required this.date});

  @override
  State<PreviewReportPage> createState() => _PreviewReportPageState();
}

class _PreviewReportPageState extends State<PreviewReportPage> {

  Uint8List? report;
  List detail = [];
  String date = '';

  @override
  void initState() {
    super.initState();
    detail = widget.detail;
    date = widget.date;
    PrintReport().genPDF(date: date,list: detail,).then((value) {
      setState(() {
        report = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        title: const Text(
          'Preview',
          style: TextStyle(fontFamily: 'th'),
        ),
      ),
      body: PdfPreview(
        build: (format) => report!,
        allowSharing: true,
        allowPrinting: true,
        initialPageFormat: PdfPageFormat.a4,
        pdfFileName: 'report.pdf',
      ),
    );
  }
}
