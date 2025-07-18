import 'dart:convert';

import 'package:billentry/CustomWidgets/appBar.dart';
import 'package:billentry/CustomWidgets/customDrawer.dart';
import 'package:billentry/GlobalVariables.dart';
import 'package:billentry/main.dart';
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
    String cutTableApi ="${ipAddress}api/getBranchTransferReciptDatas";
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
  @override
  Widget build(BuildContext context) {
    // Getting screen height and width using MediaQuery
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

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
        drawer: const customDrawer(
          stkTransferCheck: false,
          brhTransferCheck: false,
        ),
        body:
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image Logo
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(
                  'assets/icon/logo.png', // Path to your image
                  width: screenWidth * 0.5,  // Set image width dynamically based on screen width
                  height: screenHeight * 0.3,  // Set image height dynamically based on screen height
                  fit: BoxFit.contain,  // Ensure the image scales well
                ),
              ),

              // Title with animation
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(20),
                child: const Text(
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
      onWillPop: () async {
        bool value = await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text(
                "Are you sure you want to logout?",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text("YES"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("NO"),
                ),
              ],
            );
          },
        );

        if (value) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Home()), // Replace with your home widget
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
