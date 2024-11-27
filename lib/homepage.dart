import 'dart:convert';

import 'package:billentry/CustomWidgets/appBar.dart';
import 'package:billentry/CustomWidgets/customDrawer.dart';
import 'package:billentry/GlobalVariables.dart';
import 'package:billentry/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class homeScreen extends StatefulWidget{
  const homeScreen({super.key});
  @override
  State<homeScreen> createState() => _homeScreen();
}

class _homeScreen extends State<homeScreen> {

  String messageTitle = "Empty";
  String notificationAlert = "alert";


  Future<void> FetchMasData()async {
    String cutTableApi =ipAddress+"api/getBranchTransferReciptDatas";
    try {

      final response = await http.post(Uri.parse(cutTableApi),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          }, body: jsonEncode({
            "compId" : globalCompId
          }));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print("check point");
        print(data);
        print(data['valid']);
        var chk = data['valid'];

        if (chk) {
          List<dynamic> transferList= data['result'];
          approvalCnt =transferList.length;
        }

      }
    }catch(e){

    }
  }

  @override
  void initState() {
    super.initState();
    FetchMasData();
    print("home check working");

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: CustomAppBar(
          userName: globalUserName,
          emailId: globalEmailId,
          onMenuPressed: () {
            Scaffold.of(context).openDrawer();
          },
          barTitle: "Home",
        ),
        drawer: customDrawer(
          stkTransferCheck: false,
          brhTransferCheck: false,
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image Logo
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    'assets/icon/logo.png',  // Path to your image
                    height: 250,  // Adjust the size of the logo
                    width: 250,
                  ),
                ),

                // Title with animation
                AnimatedContainer(
                  duration: Duration(seconds: 1),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "VISION TECH - SOFTWARES",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004D40),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onWillPop: () async {
        bool value = await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(
                "Are you sure you want to logout?",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text("YES"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("NO"),
                ),
              ],
            );
          },
        );

        if (value) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Home()), // Replace with your home widget
            ModalRoute.withName('/'),
          );
          return true;
        } else {
          return false;
        }
      },
    );
  }
}
