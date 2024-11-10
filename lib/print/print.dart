import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintPage {
  pw.Font? english;
  pw.Font? thai;
  pw.ImageProvider? logo;
  pw.ImageProvider? rule;
  PrintPage();

  String? date;
  String? time;
  String? type;
  String? transfer;
  String? gate;
  String? seat;
  String? issue;
  String? userId;
  String? res;
  String? code;

  Future<Uint8List> genPDF({
    String? date,
    String? time,
    String? type,
    String? transfer,
    String? gate,
    String? seat,
    String? issue,
    String? userId,
    String? res,
    String? code,
  }) async {
    final pdf = pw.Document(
      version: PdfVersion.pdf_1_5,
      compress: true,
    );
    english = pw.Font.ttf(await rootBundle.load("fonts/TrajanPro-Regular.ttf"));
    thai = pw.Font.ttf(await rootBundle.load('fonts/pgvim.ttf'));
    this.date = date;
    this.time = time;
    this.type = type;
    this.transfer = transfer;
    this.gate = gate;
    this.seat = seat;
    this.issue = issue;
    this.userId = userId;
    this.res = res;
    this.code = code;
    print(date);
    print(time);
    print(type);
    print(transfer);
    print(gate);
    print(seat);
    print(date);
    print(issue);
    print(userId);
    print(res);
    print(code);
    logo = await imageFromAssetBundle('assets/images/logo.png');
    rule = await imageFromAssetBundle('assets/images/rule.png');
    pdf.addPage(pw.Page(
      pageFormat: const PdfPageFormat(
          8.0 * PdfPageFormat.cm, 20.0 * PdfPageFormat.cm,
          marginAll: 0.5 * PdfPageFormat.cm),
      build: (context) {
        return pw.Column(
          children: page(context),
        );
      },
    ));
    return pdf.save();
  }

  List<pw.Widget> page(context) {
    return [
      pw.Column(
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Container(
                width: 70,
                height: 70,
                child: pw.Image(logo!, dpi: 800),
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Date: $date',
                    style: pw.TextStyle(font: english, fontSize: 9),
                  ),
                  pw.Text(
                    'วันที่',
                    style: pw.TextStyle(font: thai, fontSize: 7),
                  ),
                  pw.Text(
                    'Parade Time: $time',
                    style: pw.TextStyle(font: english, fontSize: 9),
                  ),
                  pw.Text(
                    'รอบเวลาการแสดงพาเหรด',
                    style: pw.TextStyle(font: thai, fontSize: 7),
                  ),
                ],
              ),
            ],
          ),
          pw.Padding(
            padding: pw.EdgeInsets.only(top: 10),
          ),
          pw.Text(
            'Replacement Ticket',
            style: pw.TextStyle(font: english, fontSize: 12),
          ),
          pw.Text(
            'ใบทดแทน (บัตรที่สูญหาย)',
            style: pw.TextStyle(font: thai, fontSize: 7),
          ),
          pw.Row(
            children: [
              pw.Column(
                children: [
                  pw.Container(
                    width: 100,
                    child: pw.Text(
                      'Ticket Type:',
                      style: pw.TextStyle(
                        font: english,
                        fontSize: 9,
                      ),
                    ),
                  ),
                  pw.Text(
                    'ประเภทบัตร',
                    style: pw.TextStyle(
                      font: thai,
                      fontSize: 7,
                    ),
                  ),
                ],
              ),
              pw.Container(
                width: 200,
                child: pw.Text(
                  '$type',
                  style: pw.TextStyle(
                    font: english,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ];
  }

  List<pw.Widget> listrow(context) {
    return [];
  }

  List<pw.Widget> footerReport(context) {
    return [
      pw.Text('dfdfd'),
    ];
  }
}
