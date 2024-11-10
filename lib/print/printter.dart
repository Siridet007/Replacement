// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:typed_data';

import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:pdf/pdf.dart';
import 'package:replacement/print/print.dart';

class PrintterPage extends StatefulWidget {
  final String date;
  final String time;
  final String type;
  final String transfer;
  final String gate;
  final String seat;
  final String issue;
  final String userId;
  final String res;
  final String code;
  const PrintterPage({
    super.key,
    required this.date,
    required this.time,
    required this.type,
    required this.transfer,
    required this.gate,
    required this.seat,
    required this.issue,
    required this.userId,
    required this.res,
    required this.code,
  });

  @override
  State<PrintterPage> createState() => _PrintterPageState();
}

class _PrintterPageState extends State<PrintterPage> {
  late PDFDocument document;
  Uint8List? report;
  var date;
  var time;
  var type;
  var transfer;
  var gate;
  var seat;
  var issue;
  var userId;
  var res;
  var code;

  @override
  void initState() {
    super.initState();
    date = widget.date;
    time = widget.time;
    type = widget.type;
    transfer = widget.transfer;
    gate = widget.transfer;
    seat = widget.seat;
    issue = widget.issue;
    userId = widget.userId;
    res = widget.res;
    code = widget.code;
    PrintPage()
        .genPDF(
      code: code,
      date: date,
      gate: gate,
      issue: issue,
      res: res,
      seat: seat,
      time: time,
      transfer: transfer,
      type: type,
      userId: userId,
    )
        .then((value) {
      setState(() {
        report = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: Colors.red),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        title: const Text("Preview"),
      ),
      body: PdfPreview(
        build: (format) => report!,
        allowSharing: true,
        allowPrinting: true,
        initialPageFormat: PdfPageFormat.a4,
        pdfFileName: "myBill.pdf",
      ),
    );
  }
}
