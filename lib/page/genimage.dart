import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

import 'package:flutter/services.dart';
import 'package:replacement/page/firstpage.dart';

class GenImagePage extends StatefulWidget {
  final String date;
  final String time;
  final String type;
  final String type2;
  final String zone;
  final String transfer;
  final String gate;
  final String seat;
  final String issue;
  final String userId;
  final String res;
  final String code;
  const GenImagePage(
      {super.key,
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
      required this.type2,
      required this.zone});

  @override
  State<GenImagePage> createState() => _GenImagePageState();
}

class _GenImagePageState extends State<GenImagePage> {
  GlobalKey globalKey = GlobalKey();
  Uint8List? imageData;
  bool pp = false;

  Future<void> capturePng() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        setState(() {
          imageData = byteData.buffer.asUint8List();
          //print(imageData);
          printTicket(imageData);
        });
      }
    } catch (e) {
      print('dsdsds $e');
    }
  }

  Future<void> printTicket(image) async {
    //mm80
    const PaperSize paper = PaperSize.mm80;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);

    final PosPrintResult res =
        await printer.connect('172.2.5.24', port: 9100);//220.200.30.138

    if (res == PosPrintResult.success) {
      final img.Image? imageTest = img.decodeImage(image);
      //width:620
      final img.Image resizeLogo = img.copyResize(imageTest!, width: 620);

      testReceipt(printer, resizeLogo);
    }

    print('Print result: ${res.msg}');
  }

  Future<void> testReceipt(NetworkPrinter printer, image) async {
    /*printer.text(
        'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    printer.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
        styles: const PosStyles(codeTable: 'CP1252'));
    printer.text('Special 2: blåbærgrød',
        styles: const PosStyles(codeTable: 'CP1252'));

    printer.text('Bold text', styles: const PosStyles(bold: true));
    printer.text('Reverse text', styles: const PosStyles(reverse: true));
    printer.text('Underlined text',
        styles: const PosStyles(underline: true), linesAfter: 1);
    printer.text('Align left', styles: const PosStyles(align: PosAlign.left));
    printer.text('Align center',
        styles: const PosStyles(align: PosAlign.center));
    printer.text('Align right',
        styles: const PosStyles(align: PosAlign.right), linesAfter: 1);

    printer.text(
      'Text size 200%',
      styles: const PosStyles(
        height: PosTextSize.size2,
        width: PosTextSize.size2,
      ),
    );*/

    printer.image(image, align: PosAlign.left);
    //printer.text('Test');
    //print('dfdfdf');
    //printer.feed(2);
    Future.delayed(const Duration(seconds: 2), () {
      printer.cut();
      printer.disconnect();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FirstPage(userId: widget.userId),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
      () {
        setState(() {
          capturePng();
          pp = true;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Preview",
          style: TextStyle(fontFamily: 'en'),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            imageData != null ? Container(
              child: Image.memory(imageData!),
            ) : Stack(
              children: [
                Container(
                  width: 390,
                ),
                AnimatedPositioned(
                  duration: const Duration(seconds: 2),
                  top: !pp ? 50 : -800,
                  left: 0,
                  child: RepaintBoundary(
                    key: globalKey,
                    child: Container(
                      //decoration: BoxDecoration(border: Border.all()),
                      padding: const EdgeInsets.only(left: 0),
                      width: 390,
                      height: 760,
                      child: Column(
                        children: [
                          Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 180,
                                child: Image.asset(
                                  'assets/images/logob.png',
                                ),
                              ),
                              const Padding(padding: EdgeInsets.only(left: 10)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Date: ${widget.date}',
                                    style: const TextStyle(
                                      fontFamily: 'en',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'วันที่',
                                    style: TextStyle(
                                      fontFamily: 'th',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Parade Time: ${widget.time}',
                                    style: const TextStyle(
                                      fontFamily: 'en',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'รอบเวลาการแสดงพาเหรด',
                                    style: TextStyle(
                                      fontFamily: 'th',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          const Padding(padding: EdgeInsets.only(top: 20)),
                          const Text(
                            'Replacement Ticket',
                            style: TextStyle(
                              fontFamily: 'en',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'ใบทดแทน (บัตรที่สูญหาย)',
                            style: TextStyle(
                              fontFamily: 'th',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 20)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 120,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Ticket Type:',
                                      style: TextStyle(
                                        fontFamily: 'en',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'ประเภทบัตร',
                                      style: TextStyle(
                                        fontFamily: 'th',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      widget.type,
                                      style: const TextStyle(
                                        fontFamily: 'en',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      widget.type2,
                                      style: const TextStyle(
                                        fontFamily: 'en',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 120,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Transfer:',
                                      style: TextStyle(
                                        fontFamily: 'en',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'บริการรับส่ง',
                                      style: TextStyle(
                                        fontFamily: 'th',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      widget.zone,
                                      style: const TextStyle(
                                        fontFamily: 'en',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 240,
                                    child: widget.zone != '-' ? Text(
                                      widget.transfer,
                                      style: const TextStyle(
                                        fontFamily: 'en',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ):const Text(''),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.only(top: 20)),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Gate No. ${widget.gate}',
                                    style: const TextStyle(
                                      fontFamily: 'en',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'ประตูโรงละคร',
                                    style: TextStyle(
                                      fontFamily: 'th',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(padding: EdgeInsets.only(left: 130)),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Seat No. ${widget.seat}',
                                    style: const TextStyle(
                                      fontFamily: 'en',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Text(
                                    'หมายเลขที่นั่งโรงละคร',
                                    style: TextStyle(
                                      fontFamily: 'th',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.only(top: 20)),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black, width: 2),
                                ),
                                padding: const EdgeInsets.all(5),
                                width: 220,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Not For Resale',
                                      style: TextStyle(
                                        fontFamily: 'en',
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: const [
                                        Text(
                                          'ไม่สามารถจำหน่ายต่อได้  ',
                                          style: TextStyle(
                                            fontFamily: 'th',
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '不可转售',
                                          style: TextStyle(
                                            fontFamily: 'en',
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: const [
                                        Text(
                                          '再販不可  ',
                                          style: TextStyle(
                                            fontFamily: 'en',
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Не для перепродажи",
                                          style: TextStyle(
                                            fontFamily: 'en',
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'Issue: ${widget.issue}',
                                      style: const TextStyle(
                                        fontFamily: 'en',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'User ID. ${widget.userId} ',
                                          style: const TextStyle(
                                            fontFamily: 'en',
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Resv. ${widget.res}',
                                          style: const TextStyle(
                                            fontFamily: 'en',
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Padding(padding: EdgeInsets.only(left: 10)),
                              Text(
                                widget.code,
                                style: const TextStyle(
                                  fontFamily: 'en',
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 363,
                                child: Image.asset('assets/images/rule.png'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            /*imageData != null
                ? SizedBox(
                    width: 400,
                    height: 780,
                    child: Image.memory(
                      imageData!,
                    ),
                  )
                : Container()*/
          ],
        ),
      ),
    );
  }
}
