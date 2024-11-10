import 'dart:convert';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:replacement/page/firstpage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double? width;
  double? height;
  TextEditingController userName = TextEditingController();
  TextEditingController passWord = TextEditingController();
  String name = '';
  bool remember = false;

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', userName.text);
    await prefs.setBool('remember', remember);
    if (remember) {
      await prefs.setString('passWord', passWord.text);
    } else {
      await prefs.remove('passWord');
    }
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //print(prefs);
    setState(() {
      userName.text = prefs.getString('userName') ?? '';
      name = userName.text;
      remember = prefs.getBool('remember') ?? false;
      if (remember) {
        passWord.text = prefs.getString('passWord') ?? '';
      }
    });
  }

  Future<void> checklogin() async {
    String urlAPI =
        "http://172.2.200.15/fos3/fosmail/fos25_data.php?select=check_login&usercode=${userName.text}&passwords=${passWord.text}";
    Response response = await Dio().post(urlAPI);
    //print("dsdsds ${response.data}");
    var result;
    if (response.data.trim().isEmpty) {
      result = null;
    } else {
      result = jsonDecode(response.data);
      //print(result.first['name_eng']);
    }
    if (result != null) {
      saveData();
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => FirstPage(userId: userName.text),
        ),
      );
      /*if (result.first['positions'] == '006' ||
          result.first['positions'] == '007' ||
          result.first['positions'] == '012' || result.first['positions'] == '013' || result.first['usercode'] == 'F01192') {
        print('ok');
        saveData();
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FirstPage(userId: userName.text),
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black),
                    color: const Color.fromRGBO(90, 119, 128, 1),
                  ),
                  child: const Icon(
                    Icons.error_outline,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  '  Alert',
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'en',
                  ),
                ),
              ],
            ),
            content: const Text(
              'คุณไม่มีสิทธิ์ใช้โปรแกรมนี้',
              style: TextStyle(
                fontSize: 25,
                fontFamily: 'th',
              ),
            ),
            actions: [
              Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: const Color.fromRGBO(90, 119, 128, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'เข้าใจแล้ว',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: 'th',
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }*/
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black),
                  color: const Color.fromRGBO(90, 119, 128, 1),
                ),
                child: const Icon(
                  Icons.error_outline,
                  color: Colors.white,
                ),
              ),
              const Text(
                '  Alert',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'en',
                ),
              ),
            ],
          ),
          content: const Text(
            'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง',
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'th',
            ),
          ),
          actions: [
            Container(
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: const Color.fromRGBO(90, 119, 128, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'เข้าใจแล้ว',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: 'th',
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.pink[100],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 10,
                child: Container(
                  width: width! * .8,
                  height: height! * .8,
                  color: Colors.pink[50],
                  child: Row(
                    children: [
                      Container(
                        width: width! * .4,
                        decoration: const BoxDecoration(
                          border: Border(right: BorderSide()),
                        ),
                        //padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset('assets/images/logo.png', scale: 1.5),
                            SizedBox(
                              width: width! * .2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Username',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontFamily: 'en',
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: TextField(
                                      controller: userName,
                                      style: const TextStyle(
                                          fontSize: 30, fontFamily: 'en'),
                                      inputFormatters: [
                                        UpperCaseTextFormatter(),
                                      ],
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          name = userName.text;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: width! * .2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Password',
                                    style: TextStyle(
                                        fontSize: 30, fontFamily: 'en,'),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                    child: TextField(
                                      controller: passWord,
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontFamily: 'en',
                                      ),
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    color: Colors.white,
                                    child: Checkbox(
                                      fillColor:
                                          MaterialStateProperty.resolveWith(
                                              (states) {
                                        if (states
                                            .contains(MaterialState.selected)) {
                                          return Colors.pink;
                                        }
                                        return Colors.pink;
                                      }),
                                      value: remember,
                                      onChanged: (value) {
                                        setState(() {
                                          remember = value!;
                                        });
                                      },
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        remember = !remember;
                                      });
                                    },
                                    child: const Text(
                                      'REMEMBER USERNAME',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                          fontFamily: 'en'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: width! * .2,
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(5)),
                              height: 60,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  setState(() {
                                    checklogin();
                                  });
                                },
                                icon: const Icon(Icons.login),
                                label: const Text(
                                  'เข้าสู่ระบบ',
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontFamily: 'th',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: width! * .4,
                        child: ClipRRect(
                          child: Image.network(
                            'http://172.2.200.15/fos3/personpic/$name.jpg',
                            errorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                              'assets/images/notperson.png',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
