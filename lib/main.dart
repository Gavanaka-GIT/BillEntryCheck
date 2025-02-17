import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:billentry/GlobalVariables.dart';
import 'package:billentry/Item.dart';
import 'package:billentry/PartyStatement.dart';
import 'package:billentry/branchApproval.dart';
import 'package:billentry/branchTransfer.dart';
import 'package:billentry/homepage.dart';
import 'package:billentry/ledger.dart';
import 'package:billentry/purchaseEntryMasScreen.dart';
import 'package:billentry/purchaseReport.dart';
import 'package:billentry/salesReport.dart';
import 'package:billentry/settings.dart';
import 'package:billentry/stockReport.dart';
import 'package:billentry/Receipt.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'payment.dart';
import 'billEntryMasScreen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Future.delayed(const Duration(milliseconds: 10));
  FlutterNativeSplash.remove();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: const Home(),
    routes: {
      '/Home': (context) => const homeScreen(),
      '/Home/billEntry': (context) =>
          billEntryFirstScreen(data: jsonEncode({"valid": false})),
      '/Home/stock': (context) => const stockReportPage(),
      '/Home/purchaseEntry': (context) =>
          purchaseEntryFirstScreen(data: jsonEncode({"valid": false})),
      '/Home/branchTransfer': (context) => branchTranseferPage(
          approveData: jsonEncode({"approve": false, "selectedData": ""})),
      '/Home/branchApproval': (context) => const approvalReportPage(),
      '/Home/sales': (context) => const salesReportPage(),
      '/Home/purchase': (context) => const purchaseReportPage(),
      '/Home/ledger': (context) => Ledger(
          approvedData: jsonEncode({"approve": false, "selectedData": ""})),
      '/Home/settings': (context) => const SettingsPage(),
      '/Home/Item': (context) => ItemLedger(
          approvedData: jsonEncode({"approve": false, "selectedData": ""})),
      '/Home/Party': (context) => partyReportPage(),
      '/Home/Receipt': (context) => const ReceiptPage(),
      '/Home/Payment': (context) => const PaymentPage()
    },
  ));
}

var globalUserName = "";
var globalEmailId = "";
var globalCompId = -1;
var globalPrefix = "";
var globalAddress1 = "";
var globalAddress2 = "";
var globalAddress3 = "";
var globalPinCode = "";
var globalPhoneNumber = "";
var globalMobileNumber = "";
var globalCompMailId = "";
var globalCompanyName = "";

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> user = [];
  String userName = "";
  String password = "";
  bool logChk = false;

  TextEditingController name = TextEditingController();
  TextEditingController pass = TextEditingController();

  var chkCnt = 0;
  void _incrementCounter() {
    setState(() {
      chkCnt++;
    });
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(
            color: Color(0xFF004D40),
          ),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text("Logging In...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(child: alert, onWillPop: () => Future.value(false));
      },
    );
  }

  Future<void> fetchCheckPassword(String username, String password) async {
    String cutTableApi = "${ipAddress}api/postLoginCheck";
    print(username);
    print(password);
    print(cutTableApi);
    showLoaderDialog(context);
    try {
      final response = await http.post(Uri.parse(cutTableApi),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({"userName": username, "password": password}));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print(data);
        print(data['authenticated']);
        logChk = data['authenticated'];

        if (logChk) {
          globalUserName = username;
          globalCompId = data['result'];
          globalEmailId = data['EMAIL'];
          globalPrefix = data['result2'];
          print(data['compDetails']);
          // if(data['compDetails'].length()>0) {
          print("Prefix Check Point 1");
          globalAddress1 =
              data['compDetails']['CompanyAddress1'].toString() != "null"
                  ? data['compDetails']['CompanyAddress1'].toString()
                  : "";
          globalAddress2 =
              data['compDetails']['CompanyAddress2'].toString() != "null"
                  ? data['compDetails']['CompanyAddress2'].toString()
                  : "";
          globalAddress3 =
              data['compDetails']['CompanyAddress3'].toString() != "null"
                  ? data['compDetails']['CompanyAddress3'].toString()
                  : "";
          globalPinCode =
              data['compDetails']['CompanyPinCode'].toString() != "null"
                  ? data['compDetails']['CompanyPinCode'].toString()
                  : "";
          print("Prefix Check Point 2");
          globalPhoneNumber = data['compDetails']['Phone'].toString() != "null"
              ? data['compDetails']['Phone'].toString()
              : "";
          globalMobileNumber =
              data['compDetails']['Mobile'].toString() != "null"
                  ? data['compDetails']['Mobile'].toString()
                  : "";
          globalCompMailId = data['compDetails']['Email'].toString() != "null"
              ? data['compDetails']['Email'].toString()
              : "";
          globalCompanyName =
              data['compDetails']['CompanyName'].toString() != "null"
                  ? data['compDetails']['CompanyName'].toString()
                  : "";
          print(globalAddress1);
          print("Prefix Check Point 3");

          // }
          print("Prefix Check Point");
          print(globalPrefix);
          Navigator.pop(context);
          Navigator.pushNamed(context, '/Home');
        } else {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('REASON'),
                content: const Text(
                    "Please enter the valid userName/Password"), // Content of the dialog
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ],
              );
            },
          );
        }

        _incrementCounter();
      } else {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('REASON'),
              content: const Text("Conn Err"), // Content of the dialog
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('REASON'),
            content: const Text("Conn Err"), // Content of the dialog
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  bool _passwordVisible = false;
  @override
  void initState() {
    _passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Color(0xFF004D40),
          Color(0xFF004D40),
          Color(0xFF004D40)
        ])),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FadeInUp(
                        child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    )),
                    FadeInUp(
                        child: const Text(
                      "Welcome Back",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    )),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60))),
                      child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: SingleChildScrollView(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                FadeInUp(
                                    child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                            color:
                                                Color.fromRGBO(225, 95, 27, .3),
                                            blurRadius: 20,
                                            offset: Offset(0, 10))
                                      ]),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color:
                                                        Colors.grey.shade200))),
                                        child: TextFormField(
                                          onChanged: (String newValue) {
                                            userName = newValue;
                                          },
                                          controller: name,
                                          decoration: const InputDecoration(
                                              hintText: "USERNAME",
                                              hintStyle:
                                                  TextStyle(color: Colors.grey),
                                              border: InputBorder.none,
                                              prefixIcon: Icon(Icons.person)),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                                const Padding(padding: EdgeInsets.all(5)),
                                FadeInUp(
                                    child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                            color:
                                                Color.fromRGBO(225, 95, 27, .3),
                                            blurRadius: 20,
                                            offset: Offset(0, 10))
                                      ]),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    color:
                                                        Colors.grey.shade200))),
                                        child: TextFormField(
                                          onChanged: (String newValue) {
                                            password = newValue;
                                          },
                                          obscureText: _passwordVisible,
                                          controller: pass,
                                          decoration: InputDecoration(
                                              hintText: "PASSWORD",
                                              hintStyle: const TextStyle(
                                                  color: Colors.grey),
                                              border: InputBorder.none,
                                              suffixIcon: IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _passwordVisible =
                                                          !_passwordVisible;
                                                    });
                                                  },
                                                  icon: Icon(!_passwordVisible
                                                      ? Icons.visibility
                                                      : Icons.visibility_off)),
                                              prefixIcon:
                                                  const Icon(Icons.lock)),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                                const Padding(padding: EdgeInsets.all(10)),
                                FadeInUp(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Color.fromRGBO(
                                                    225, 95, 27, .3),
                                                blurRadius: 20,
                                                offset: Offset(0, 10))
                                          ]),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Colors
                                                              .grey.shade200))),
                                              child: IconButton(
                                                color: Colors.indigo[900],
                                                onPressed: () {
                                                  fetchCheckPassword(
                                                      userName, password);
                                                  // Navigator.of(context).push(
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) => billEntryFirstScreen())
                                                  // );
                                                },
                                                icon: const Icon(Icons.login),
                                              )),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: const [
                                            BoxShadow(
                                                color: Color.fromRGBO(
                                                    225, 95, 27, .3),
                                                blurRadius: 20,
                                                offset: Offset(0, 10))
                                          ]),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Colors
                                                              .grey.shade200))),
                                              child: IconButton(
                                                  onPressed: () {
                                                    Navigator.pushNamed(context,
                                                        '/Home/settings');
                                                  },
                                                  icon: const Icon(
                                                      Icons.settings))),
                                        ],
                                      ),
                                    )
                                  ],
                                ))
                              ])))))
            ],
          ),
        ),
      ),
    );
  }
}
