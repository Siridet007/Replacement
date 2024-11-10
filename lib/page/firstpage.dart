import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:replacement/model/model.dart';
import 'package:replacement/page/genimage.dart';
import 'package:replacement/page/report.dart';
import 'package:replacement/print/print.dart';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;
import 'package:shared_preferences/shared_preferences.dart';

import '../print/printter.dart';
import 'loginpage.dart';

class FirstPage extends StatefulWidget {
  final String userId;
  const FirstPage({super.key, required this.userId});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  double? width;
  double? height;
  TextEditingController search = TextEditingController();
  DateTime now = DateTime.now();
  String current = '';
  String myDate = '';
  List<SearchTicker>? ticketList = [];
  String paradeTime = '';
  String type = '';
  String royal = '';
  int tabList = 0;

  int calculateCrossAxisCount(double screenWidth) {
    // Adjust these values based on your design requirements
    if (screenWidth > 1200) {
      return 4; // 4 columns for large screens
    } else if (screenWidth > 600) {
      return 3; // 3 columns for medium screens
    } else {
      return 2; // 2 columns for small screens
    }
  }

  Future<List<SearchTicker>?> getBill(searchCode) async {
    FormData formData = FormData.fromMap(
      {
        "param": "replacementticket",
        "code": searchCode,
      },
    );

    String domain2 =
        "http://172.2.200.200/cmfrontapp/ticketing/ticketapi/datamodule/selfticketing.php";

    String urlAPI = domain2;

    Response response = await Dio().post(urlAPI, data: formData);
    var result = SearchTicker.fromJsonList(response.data);
    return result;
  }

  Future<List<SearchTicker>?> saveBill(
    bookId,
    userId,
    res,
    voucher,
    seat,
    round,
    agent,
  ) async {
    FormData formData = FormData.fromMap(
      {
        "param": "ins_replacement",
        "bookid": bookId,
        "userid": userId,
        "rsvn": res,
        "voucher": voucher,
        "seat": seat,
        "round": round,
        "agentname": agent,
      },
    );

    String domain2 =
        "http://172.2.200.200/cmfrontapp/ticketing/ticketapi/datamodule/selfticketing.php";

    String urlAPI = domain2;

    Response response = await Dio().post(urlAPI, data: formData);
    var result = SearchTicker.fromJsonList(response.data);
    return result;
  }

  Future removePass() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('passWord');
  }

  Future exitFuture(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text(
            'Do you want to Logout',
            style: TextStyle(
              fontFamily: 'cm',
              fontSize: 30,
            ),
          ),
          actions: [
            SizedBox(
              width: 140,
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.red,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    removePass();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  });
                },
                icon: const Icon(Icons.exit_to_app),
                label: const Text(
                  "Yes",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: 'cm',
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 140,
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.black,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
                label: const Text(
                  "No",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: 'cm',
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Future reportFuture(BuildContext context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text(
            'Comingsoon...',
            style: TextStyle(
              fontFamily: 'cm',
              fontSize: 30,
            ),
          ),
          actions: [
            SizedBox(
              width: 140,
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.black,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
                label: const Text(
                  "Close",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: 'cm',
                  ),
                ),
              ),
            ),
          ],
        ),
      );
  void changeDate(date1) {
    DateTime date2 = DateTime.parse(date1);
    String date = DateFormat('dd').format(date2);
    String month = DateFormat("MM").format(date2);
    String year = DateFormat("yy").format(date2);
    String mm = '';
    if (month == '01') {
      mm = 'Jan';
    } else if (month == '02') {
      mm = 'Feb';
    } else if (month == '03') {
      mm = 'Mar';
    } else if (month == '04') {
      mm = 'Apr';
    } else if (month == '05') {
      mm = 'May';
    } else if (month == '06') {
      mm = 'Jun';
    } else if (month == '07') {
      mm = 'Jul';
    } else if (month == '08') {
      mm = 'Aug';
    } else if (month == '09') {
      mm = 'Seb';
    } else if (month == '10') {
      mm = 'Oct';
    } else if (month == '11') {
      mm = 'Nov';
    } else if (month == '12') {
      mm = 'Dec';
    }
    myDate = '$date/$mm/$year';
    //print(myDate);
  }

  void checkRound(parade) {
    if (parade == 'A') {
      paradeTime = '8:30';
    } else if (parade == 'B') {
      paradeTime = '6:30';
    } else {
      paradeTime = '';
    }
  }

  void checkType(t, r) {
    if (t == 'AD') {
      type = 'Adult';
    } else {
      type = 'Child';
    }
    if (r == 'Y') {
      royal = '(Royal Seat)';
    } else {
      royal = '';
    }
  }

  @override
  void initState() {
    super.initState();
    current = DateFormat("dd/MM/yyyy").format(now);
    String date = DateFormat('dd').format(now);
    String month = DateFormat("MM").format(now);
    String year = DateFormat("yy").format(now);
    String mm = '';
    if (month == '01') {
      mm = 'Jan';
    } else if (month == '02') {
      mm = 'Feb';
    } else if (month == '03') {
      mm = 'Mar';
    } else if (month == '04') {
      mm = 'Apr';
    } else if (month == '05') {
      mm = 'May';
    } else if (month == '06') {
      mm = 'Jun';
    } else if (month == '07') {
      mm = 'Jul';
    } else if (month == '08') {
      mm = 'Aug';
    } else if (month == '09') {
      mm = 'Seb';
    } else if (month == '10') {
      mm = 'Oct';
    } else if (month == '11') {
      mm = 'Nov';
    } else if (month == '12') {
      mm = 'Dec';
    }
    myDate = '$date/$mm/$year';
    print(myDate);
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.pink[100],
      body: Center(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 10)),
            Card(
              elevation: 10,
              child: Container(
                width: width! * .9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: const Color.fromRGBO(237, 0, 140, 1),
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width! * .2,
                          child: Row(
                            children: [
                              const Padding(padding: EdgeInsets.only(left: 20)),
                              const Text(
                                'Date ',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'th',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                current,
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'en',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          'Replacement',
                          style: TextStyle(
                            fontSize: 40,
                            fontFamily: 'th',
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: width! * .2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 160,
                                height: 50,
                                child: ElevatedButton.icon(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                      (states) => Colors.blue,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ReportPage(
                                            userID: widget.userId,
                                          ),
                                        ),
                                      );
                                    });
                                  },
                                  icon: const Icon(Icons.feed),
                                  label: const Text(
                                    'Report',
                                    style: TextStyle(
                                        fontFamily: 'en', fontSize: 20),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 20),
                              ),
                              SizedBox(
                                width: 160,
                                height: 50,
                                child: ElevatedButton.icon(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith(
                                      (states) => Colors.red[200],
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      exitFuture(context);
                                    });
                                  },
                                  icon: const Icon(Icons.logout),
                                  label: const Text(
                                    'Logout',
                                    style: TextStyle(
                                      fontFamily: 'en',
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 40),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                        ),
                        Container(
                          width: width! * .2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: TextField(
                            controller: search,
                            style: const TextStyle(fontSize: 30),
                            inputFormatters: [
                              UpperCaseTextFormatter(),
                            ],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              hintText: 'Seat,Rescode',
                              hintStyle: TextStyle(
                                fontFamily: 'en',
                                fontSize: 25,
                              ),
                            ),
                            onSubmitted: (value) {
                              setState(() {
                                getBill(search.text).then((value) {
                                  setState(() {
                                    ticketList = value;
                                  });
                                });
                              });
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                        ),
                        SizedBox(
                          width: 160,
                          height: 50,
                          child: ElevatedButton.icon(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith(
                                (states) => Colors.pink,
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                getBill(search.text).then((value) {
                                  setState(() {
                                    ticketList = value;
                                  });
                                });
                              });
                            },
                            icon: const Icon(Icons.search),
                            label: const Text(
                              'Search',
                              style: TextStyle(fontFamily: 'en', fontSize: 25),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 10,
              child: Container(
                width: width! * .9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.pink[50],
                ),
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                    ),
                    Container(
                      width: width! * .85,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        color: const Color.fromRGBO(237, 0, 140, 1),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: width! * .07,
                            alignment: Alignment.center,
                            child: const Text(
                              'Items',
                              style: TextStyle(
                                fontFamily: 'th',
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            width: width! * .1,
                            alignment: Alignment.center,
                            child: const Text(
                              'RSVN',
                              style: TextStyle(
                                fontFamily: 'th',
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            width: width! * .1,
                            alignment: Alignment.center,
                            child: const Text(
                              'Seat',
                              style: TextStyle(
                                fontFamily: 'th',
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            width: width! * .2,
                            alignment: Alignment.center,
                            child: const Text(
                              'Agent Name',
                              style: TextStyle(
                                fontFamily: 'th',
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            width: width! * .25,
                            alignment: Alignment.center,
                            child: const Text(
                              'Customer Name',
                              style: TextStyle(
                                fontFamily: 'th',
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            width: width! * .1,
                            alignment: Alignment.center,
                            child: const Text(
                              'Round',
                              style: TextStyle(
                                fontFamily: 'th',
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: width! * .85,
                      height: height! * .65,
                      decoration: BoxDecoration(border: Border.all()),
                      child: ListView.builder(
                        itemCount: ticketList!.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              setState(() {
                                tabList = index;
                              });
                            },
                            child: Container(
                              color: tabList == index
                                  ? Colors.pink[300]
                                  : (index % 2 == 0)
                                      ? Colors.pink[100]
                                      : Colors.pink[50],
                              padding:
                                  const EdgeInsets.only(bottom: 10, top: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: width! * .07,
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        fontFamily: 'th',
                                        fontSize: 28,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: width! * .1,
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${ticketList![index].rsvn}',
                                      style: const TextStyle(
                                        fontFamily: 'th',
                                        fontSize: 28,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: width! * .1,
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${ticketList![index].seat}',
                                      style: const TextStyle(
                                        fontFamily: 'th',
                                        fontSize: 28,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: width! * .2,
                                    child: Text(
                                      '${ticketList![index].agentname}',
                                      style: const TextStyle(
                                        fontFamily: 'th',
                                        fontSize: 28,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: width! * .25,
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text(
                                      '${ticketList![index].customername}',
                                      style: const TextStyle(
                                        fontFamily: 'th',
                                        fontSize: 28,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: width! * .1,
                                    alignment: Alignment.center,
                                    child: ticketList![index].round == 'A'
                                        ? const Text(
                                            '20:30',
                                            style: TextStyle(
                                              fontFamily: 'th',
                                              fontSize: 28,
                                            ),
                                          )
                                        : const Text(
                                            '18:30',
                                            style: TextStyle(
                                              fontFamily: 'th',
                                              fontSize: 28,
                                            ),
                                          ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          changeDate(
                                              ticketList![index].showdate);
                                          checkRound(ticketList![index].round);
                                          checkType(
                                              ticketList![index].typeguest,
                                              ticketList![index].rs);
                                          var r;
                                          if (ticketList![index].round == 'A') {
                                            r = '20:30';
                                          } else if (ticketList![index].round ==
                                              'B') {
                                            r = '18:30';
                                          } else {
                                            r = '17.00';
                                          }
                                          /*saveBill(
                                            ticketList![index].id,
                                            widget.userId,
                                            ticketList![index].rsvn,
                                            ticketList![index].voucher,
                                            ticketList![index].seat,
                                            r,
                                            ticketList![index].name,
                                          );*/
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  GenImagePage(
                                                code:
                                                    '*${ticketList![index].rsvn}*',
                                                date: myDate,
                                                gate:
                                                    '${ticketList![index].gate}',
                                                issue:
                                                    '${ticketList![index].issue} PM',
                                                res:
                                                    '${ticketList![index].rsvn}',
                                                seat:
                                                    '${ticketList![index].seat}',
                                                time: '$paradeTime PM',
                                                transfer:
                                                    '${ticketList![index].hotelname}',
                                                type: '$type $royal',
                                                userId: widget.userId,
                                                type2:
                                                    '${ticketList![index].accode}',
                                                zone:
                                                    '${ticketList![index].backZone}',
                                              ),
                                            ),
                                          );
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.print_rounded,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                          /*return Card(
                            elevation: 10,
                            child: Container(
                              width: 100,
                              height: 100,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    /*Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PrintterPage(
                                          code: 'L9W61',
                                          date: '20/Mar/15',
                                          gate: '12',
                                          issue: '5:15',
                                          res: 'B9690',
                                          seat: 'ZA104',
                                          time: '9:00 PM',
                                          transfer: 'Zone 4 Best Western Bangtao Beach Resort & Spa',
                                          type: 'Adult (Royal Seat) Park Admission & Buffer Dinner',
                                          userId: 'F0000',
                                        ),
                                      ),
                                    );*/
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const GenImagePage(
                                          code: '*L9W61*',
                                          date: '20/Mar/15',
                                          gate: '12',
                                          issue: '5:15 PM',
                                          res: 'B9690',
                                          seat: 'ZA104',
                                          time: '9:00 PM',
                                          transfer:
                                              'Zone 4 Best Western Bangtao Beach Resort & Spa',
                                          type:
                                              'Adult (Royal Seat) Park Admission & Buffer Dinner',
                                          userId: 'F0000',
                                        ),
                                      ),
                                    );
                                    /*Future.delayed(const Duration(seconds: 2), () {
                                      printTicket();
                                    });*/
                                  });
                                },
                              ),
                            ),
                          );*/
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
