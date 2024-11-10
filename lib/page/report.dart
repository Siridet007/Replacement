import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:replacement/print/prereport.dart';

import '../model/model.dart';
import 'firstpage.dart';

class ReportPage extends StatefulWidget {
  final String userID;
  const ReportPage({super.key, required this.userID});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  double? width;
  double? height;
  TextEditingController docDate = TextEditingController();
  var formattedDate;
  TextEditingController dateChoose = TextEditingController();
  DateTime dateTime = DateTime.now();
  List<GetReport>? reportList = [];

  Future<List<GetReport>?> getReport(date) async {
    FormData formData = FormData.fromMap(
      {
        "param": "report_replacementticket",
        "datesave": date,
      },
    );

    String domain2 =
        "http://172.2.200.200/cmfrontapp/ticketing/ticketapi/datamodule/selfticketing.php";

    String urlAPI = domain2;

    Response response = await Dio().post(urlAPI, data: formData);
    var result = GetReport.fromJsonList(response.data);
    return result;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    docDate.text = DateFormat('dd/MM/yyyy').format(dateTime);
    dateChoose.text = DateFormat('yyyy-MM-dd').format(dateTime);
    getReport(dateChoose.text).then((value) {
      setState(() {
        reportList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * .98,
              height: MediaQuery.of(context).size.height * .98,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.pink[50],
              ),
              padding: const EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  headButton(),
                  reportForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget headButton() {
    return Container(
      width: width! * .98,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * .95,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 150,
                          height: 70,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            color: const Color.fromRGBO(237, 0, 140, 1),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Report',
                                  style: TextStyle(
                                    fontFamily: 'th',
                                    fontSize: 25,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'รายงาน',
                                  style: TextStyle(
                                    fontFamily: 'th',
                                    fontSize: 25,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                        ),
                        const Text(
                          'Date',
                          style: TextStyle(
                            fontFamily: 'th',
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                        ),
                        Container(
                          width: 250,
                          height: 60,
                          padding: const EdgeInsets.only(left: 10, bottom: 0),
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                            color: Colors.white,
                          ),
                          child: TextField(
                            controller: docDate,
                            style: const TextStyle(
                              fontFamily: 'th',
                              fontSize: 25,
                            ),
                            //editing controller of this TextField
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none),
                              icon: const Icon(Icons.calendar_today),
                              hoverColor:
                                  Colors.lightBlue[50], //icon of text field
                              labelText:
                                  docDate.text.isEmpty ? "Choose Date" : '',
                              labelStyle: const TextStyle(
                                fontFamily: 'th',
                                fontSize: 25,
                              ),
                            ),
                            readOnly: true,
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1800),
                                lastDate: DateTime.now(),
                              );
                              if (pickedDate != null) {
                                formattedDate =
                                    DateFormat('dd/MM/yyyy').format(pickedDate);
                                dateChoose.text =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                setState(() {
                                  docDate.text = formattedDate;
                                });
                              } else {}
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          width: 150,
                          height: 40,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.pink,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                //print('${dateChoose.text} ${dateChoose2.text} $takeType');
                                getReport(dateChoose.text).then((value) {
                                  setState(() {
                                    reportList = value;
                                  });
                                });
                              });
                            },
                            icon: const Icon(Icons.search),
                            label: const Text(
                              'Search',
                              style: TextStyle(
                                fontFamily: 'th',
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          width: 150,
                          height: 40,
                          child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlue,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: reportList!.isEmpty
                                  ? null
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PreviewReportPage(
                                            detail: reportList!,
                                            date: docDate.text,
                                          ),
                                        ),
                                      );
                                    },
                              icon: const Icon(Icons.print),
                              label: const Text(
                                'Print',
                                style: TextStyle(
                                  fontFamily: 'th',
                                  fontSize: 23,
                                ),
                              )),
                        ),
                        const Padding(padding: EdgeInsets.only(left: 10)),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          width: 150,
                          height: 40,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.exit_to_app),
                            label: const Text(
                              'Back',
                              style: TextStyle(
                                fontFamily: 'th',
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget reportForm() {
    return Container(
      width: width! * .98,
      height: height! * .85,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(),
              color: const Color.fromRGBO(237, 0, 140, 1),
            ),
            child: Row(
              children: [
                Container(
                  width: width! * .072,
                  height: 50,
                  alignment: Alignment.center,
                  child: const Text(
                    'Items',
                    style: TextStyle(
                      fontFamily: 'th',
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  width: width! * .3,
                  height: 50,
                  alignment: Alignment.center,
                  child: const Text(
                    'Agent',
                    style: TextStyle(
                      fontFamily: 'th',
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  width: width! * .12,
                  height: 50,
                  alignment: Alignment.center,
                  child: const Text(
                    'RSVN',
                    style: TextStyle(
                      fontFamily: 'th',
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  width: width! * .12,
                  height: 50,
                  alignment: Alignment.center,
                  child: const Text(
                    'Voucher',
                    style: TextStyle(
                      fontFamily: 'th',
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  width: width! * .12,
                  height: 50,
                  alignment: Alignment.center,
                  child: const Text(
                    'Seat',
                    style: TextStyle(
                      fontFamily: 'th',
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  width: width! * .12,
                  height: 50,
                  alignment: Alignment.center,
                  child: const Text(
                    'Round',
                    style: TextStyle(
                      fontFamily: 'th',
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  width: width! * .12,
                  height: 50,
                  alignment: Alignment.center,
                  child: const Text(
                    'Userid',
                    style: TextStyle(
                      fontFamily: 'th',
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: width! * .98,
            height: height! * .78,
            decoration: BoxDecoration(
              border: Border.all(),
              color: Colors.white,
            ),
            child: ListView.builder(
              itemCount: reportList!.length,
              itemBuilder: (context, index) {
                return Container(
                  color: index % 2 == 0 ? Colors.pink[100] : Colors.pink[50],
                  child: Row(
                    children: [
                      Container(
                        width: width! * .072,
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(
                            fontFamily: 'th',
                            fontSize: 25,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        width: width! * .3,
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          '${reportList![index].agentname}',
                          style: const TextStyle(
                            fontFamily: 'th',
                            fontSize: 25,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        width: width! * .12,
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          '${reportList![index].rsvn}',
                          style: const TextStyle(
                            fontFamily: 'th',
                            fontSize: 25,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        width: width! * .12,
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          '${reportList![index].voucher}',
                          style: const TextStyle(
                            fontFamily: 'th',
                            fontSize: 25,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        width: width! * .12,
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          '${reportList![index].seat}',
                          style: const TextStyle(
                            fontFamily: 'th',
                            fontSize: 25,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        width: width! * .12,
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          '${reportList![index].round}',
                          style: const TextStyle(
                            fontFamily: 'th',
                            fontSize: 25,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        width: width! * .12,
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          '${reportList![index].userid}',
                          style: const TextStyle(
                            fontFamily: 'th',
                            fontSize: 25,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
