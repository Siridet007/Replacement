import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class PrintReport {
  pw.Font? pgFont;
  pw.Font? tjFont;
  pw.ImageProvider? logo;

  PrintReport();
  List? list = [];
  String? date;

  Future<Uint8List> genPDF({
    List? list,
    String? date,
  }) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    pgFont = pw.Font.ttf(await rootBundle.load('fonts/pgvim.ttf'));
    tjFont = pw.Font.ttf(await rootBundle.load('fonts/TrajanPro-Regular.ttf'));
    logo = await imageFromAssetBundle('assets/images/tkt.jpg');
    this.list = list;
    this.date = date;
    pdf.addPage(
      pw.MultiPage(
        pageFormat: const PdfPageFormat(
          21 * PdfPageFormat.cm,
          29.7 * PdfPageFormat.cm,
          marginTop: 1.0 * PdfPageFormat.cm,
          marginLeft: 1.0 * PdfPageFormat.cm,
          marginRight: 1.0 * PdfPageFormat.cm,
          marginBottom: 1.0 * PdfPageFormat.cm,
        ),
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (context) {
          return pw.Column(
            children: headReport(context),
          );
        },
        mainAxisAlignment: pw.MainAxisAlignment.start,
        build: (context) {
          return listrow(context);
        },
        footer: (context) {
          return pw.Column(
            children: footerReport(context),
          );
        },
      ),
    );
    return pdf.save();
  }

  List<pw.Widget> headReport(pw.Context context) {
    return [
      pw.Container(
        width: 600,
        //decoration: pw.BoxDecoration(border: pw.Border.all()),
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Container(
                  width: 250,
                  height: 70,
                  //decoration: pw.BoxDecoration(border: pw.Border.all()),
                  child: pw.Image(
                    logo!,
                    dpi: 800,
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(left: 30),
                ),
                pw.Container(
                  width: 300,
                  height: 70,
                  decoration: const pw.BoxDecoration(
                      border: pw.Border(left: pw.BorderSide())),
                  padding: const pw.EdgeInsets.only(left: 30),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text(
                        'ใบทดแทน (บัตรที่สูญหาย)',
                        style: pw.TextStyle(
                          font: pgFont,
                          fontSize: 20,
                          fontWeight: pw.FontWeight.normal,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(top: 10),
                      ),
                      pw.Text(
                        'Replacement Ticket',
                        style: pw.TextStyle(
                          font: tjFont,
                          fontSize: 20,
                          fontWeight: pw.FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 10),
            ),
            pw.Row(
              children: [
                pw.Text(
                  'Date : ',
                  style: pw.TextStyle(
                    font: pgFont,
                    fontSize: 10,
                  ),
                ),
                pw.Text(
                  '$date',
                  style: pw.TextStyle(
                    font: tjFont,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      pw.SizedBox(height: 10),
    ];
  }

  List<pw.Widget> listrow(pw.Context context) {
    List<pw.Widget> rows = [];

    // Header Row
    rows.add(
      pw.Row(
        children: [
          pw.Container(
            width: 30,
            height: 20,
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(),
                top: pw.BorderSide(),
              ),
            ),
            alignment: pw.Alignment.center,
            child: pw.Text(
              'Items',
              style: pw.TextStyle(
                font: pgFont,
                fontSize: 12,
              ),
            ),
          ),
          pw.Container(
            width: 240,
            height: 20,
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(),
                top: pw.BorderSide(),
              ),
            ),
            alignment: pw.Alignment.center,
            child: pw.Text(
              'Agent',
              style: pw.TextStyle(
                font: pgFont,
                fontSize: 12,
              ),
            ),
          ),
          pw.Container(
            width: 60,
            height: 20,
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(),
                top: pw.BorderSide(),
              ),
            ),
            alignment: pw.Alignment.center,
            child: pw.Text(
              'Res.code',
              style: pw.TextStyle(
                font: pgFont,
                fontSize: 12,
              ),
            ),
          ),
          pw.Container(
            width: 60,
            height: 20,
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(),
                top: pw.BorderSide(),
              ),
            ),
            alignment: pw.Alignment.center,
            child: pw.Text(
              'Voucher',
              style: pw.TextStyle(
                font: pgFont,
                fontSize: 12,
              ),
            ),
          ),
          pw.Container(
            width: 50,
            height: 20,
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(),
                top: pw.BorderSide(),
              ),
            ),
            alignment: pw.Alignment.center,
            child: pw.Text(
              'Seat',
              style: pw.TextStyle(
                font: pgFont,
                fontSize: 12,
              ),
            ),
          ),
          pw.Container(
            width: 50,
            height: 20,
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(),
                top: pw.BorderSide(),
              ),
            ),
            alignment: pw.Alignment.center,
            child: pw.Text(
              'Round',
              style: pw.TextStyle(
                font: pgFont,
                fontSize: 12,
              ),
            ),
          ),
          pw.Container(
            width: 50,
            height: 20,
            decoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(),
                top: pw.BorderSide(),
              ),
            ),
            alignment: pw.Alignment.center,
            child: pw.Text(
              'Userid',
              style: pw.TextStyle(
                font: pgFont,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );

    // List Rows
    for (int index = 0; index < list!.length; index++) {
      rows.add(
        pw.Column(
          children: [
            pw.SizedBox(
              height: 5,
            ),
            pw.Row(
              children: [
                pw.Container(
                  width: 30,
                  height: 20,
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    '${index + 1}',
                    style: pw.TextStyle(
                      font: pgFont,
                      fontSize: 11,
                    ),
                  ),
                ),
                pw.Container(
                  width: 240,
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    '${list![index].agentname}',
                    style: pw.TextStyle(
                      font: pgFont,
                      fontSize: 11,
                    ),
                  ),
                ),
                pw.Container(
                  width: 60,
                  height: 20,
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    '${list![index].rsvn}',
                    style: pw.TextStyle(
                      font: pgFont,
                      fontSize: 11,
                    ),
                  ),
                ),
                pw.Container(
                  width: 60,
                  height: 20,
                  //decoration: pw.BoxDecoration(border: pw.Border.all()),
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    '${list![index].voucher}',
                    style: pw.TextStyle(
                      font: pgFont,
                      fontSize: 11,
                    ),
                  ),
                ),
                pw.Container(
                  width: 50,
                  height: 20,
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    '${list![index].seat}',
                    style: pw.TextStyle(
                      font: pgFont,
                      fontSize: 11,
                    ),
                  ),
                ),
                pw.Container(
                  width: 50,
                  height: 20,
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    '${list![index].round}',
                    style: pw.TextStyle(
                      font: pgFont,
                      fontSize: 11,
                    ),
                  ),
                ),
                pw.Container(
                  width: 50,
                  height: 20,
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    '${list![index].userid}',
                    style: pw.TextStyle(
                      font: pgFont,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return [
      pw.Column(
        children: rows,
      ),
    ];
  }

  List<pw.Widget> footerReport(pw.Context context) {
    return [
      pw.Container(
        alignment: pw.Alignment.center,
        margin: const pw.EdgeInsets.only(bottom: 0.0 * PdfPageFormat.cm),
        child: pw.Column(
          children: [
            //pw.SizedBox(height: 5),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                //pw.SizedBox(width: 120),
                pw.Container(
                  width: 150,
                  alignment: pw.Alignment.center,
                  //decoration: pw.BoxDecoration(border: pw.Border.all()),
                  //margin: const pw.EdgeInsets.only(top: 0.3 * PdfPageFormat.cm),
                  child: pw.Text(
                    "Replace",
                    style: pw.TextStyle(
                      font: tjFont,
                      fontSize: 6,
                      fontWeight: pw.FontWeight.normal,
                    ),
                  ),
                ),
                /*pw.Container(
                  height: 25,
                  width: 0.7,
                  decoration: const pw.BoxDecoration(color: PdfColors.black),
                  margin: const pw.EdgeInsets.only(top: 0.3 * PdfPageFormat.cm),
                ),*/
                pw.Container(
                  width: 230,
                  decoration: const pw.BoxDecoration(
                      border: pw.Border(
                          left: pw.BorderSide(), right: pw.BorderSide())),
                  alignment: pw.Alignment.center,
                  margin: const pw.EdgeInsets.only(top: 0.3 * PdfPageFormat.cm),
                  child: pw.Column(
                    children: [
                      pw.Text(
                        "บริษัท คาร์นิวัลเมจิก จำกัด 999 หมู่ 3 ตำบลกมลา อำเภอกะทู้ จังหวัดภูเก็ต 83150",
                        style: pw.TextStyle(
                          font: pgFont,
                          fontSize: 6,
                          fontWeight: pw.FontWeight.normal,
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Text(
                        "Carnival Magic Co., Ltd. 999 Moo 3 Kamala Kathu phuket 83150 Thailand",
                        style: pw.TextStyle(
                          font: tjFont,
                          fontSize: 4.7,
                          fontWeight: pw.FontWeight.normal,
                        ),
                      ),
                      pw.SizedBox(height: 3),
                      pw.Text(
                        "Tel: 076 385222  Email: ticket@carnivalmagic.fun",
                        style: pw.TextStyle(
                          font: tjFont,
                          fontSize: 6,
                          fontWeight: pw.FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                /*pw.Container(
                  height: 25,
                  width: 0.7,
                  decoration: const pw.BoxDecoration(color: PdfColors.black),
                  margin: const pw.EdgeInsets.only(top: 0.3 * PdfPageFormat.cm),
                ),*/
                pw.Container(
                  width: 150,
                  //decoration: pw.BoxDecoration(border: pw.Border.all()),
                  alignment: pw.Alignment.center,
                  //margin: const pw.EdgeInsets.only(top: 0.3 * PdfPageFormat.cm),
                  child: pw.Text(
                    DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now()),
                    style: pw.TextStyle(
                      font: tjFont,
                      fontSize: 7,
                      fontWeight: pw.FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
            //  pw.SizedBox(height: 3),
          ],
        ),
      ),
    ];
  }
}
