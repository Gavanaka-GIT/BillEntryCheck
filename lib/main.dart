import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:billentry/GlobalVariables.dart';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'BillSales.dart';
import 'billEntryMasScreen.dart';

void main() => runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    )
);

var globalUserName="";
var globalCompId=-1;
var globalPrefix="";
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home>  {
  List<String> user = [];
  String userName="";
  String password="";
  bool logChk=false;

  TextEditingController name=TextEditingController();
  TextEditingController pass=TextEditingController();

  var chkCnt = 0;
  void _incrementCounter() {
    setState(() {
      chkCnt++;
    });
  }
  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(color: Color(0xFF004D40),),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Logging In..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }


  Future<void> fetchCheckPassword(String username, String password) async{
    String cutTableApi =ipAddress+"api/postLoginCheck";
    print(username);
    print(password);
    print(cutTableApi);
    showLoaderDialog(context);
    final response= await http.post(Uri.parse(cutTableApi),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }, body: jsonEncode({
          "userName": username,
          "password":password
        }));
    if (response.statusCode == 200) {
      final Map<String,dynamic> data =  json.decode(response.body);
      print(data);
      print(data['authenticated']);
      logChk=data['authenticated'];

      if(logChk) {
        globalUserName=username;
        globalCompId = data['result'];
        globalPrefix = data['result2'];
        print("Prefix Check Point");
        print(globalPrefix);
        Navigator.pop(context);
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => billEntryFirstScreen())
        );
      }else{
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return
              AlertDialog(
                title: Text('REASON'),
                content: Text("Please enter the valid userName/Password"), // Content of the dialog
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
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
    }else{
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return
            AlertDialog(
              title: Text('REASON'),
              content: Text("Conn Err"), // Content of the dialog
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Color(0xFF004D40),
                  Color(0xFF004D40),
                  Color(0xFF004D40)
                ]
            )
        ),
        child: Center(
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FadeInUp( child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 40),)),
                    FadeInUp( child: Text("Welcome Back", style: TextStyle(color: Colors.white, fontSize: 18),)),
                  ],
                ),
              ),
              Expanded(
                  child:

                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(60), topRight: Radius.circular(60))
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(30),
                          child:
                          SingleChildScrollView(
                              child:
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[

                                    FadeInUp( child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [BoxShadow(
                                              color: Color.fromRGBO(225, 95, 27, .3),
                                              blurRadius: 20,
                                              offset: Offset(0, 10)
                                          )]
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                border: Border(bottom: BorderSide(color: Colors.grey.shade200))
                                            ),
                                            child: TextFormField(
                                              onChanged: (String newValue){
                                                userName = newValue ;
                                              },
                                              controller: name,
                                              decoration: InputDecoration(
                                                  hintText: "USERNAME",
                                                  hintStyle: TextStyle(color: Colors.grey),
                                                  border: InputBorder.none
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    ),
                                    Padding(padding: EdgeInsets.all(5)),
                                    FadeInUp( child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [BoxShadow(
                                              color: Color.fromRGBO(225, 95, 27, .3),
                                              blurRadius: 20,
                                              offset: Offset(0, 10)
                                          )]
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                border: Border(bottom: BorderSide(color: Colors.grey.shade200))
                                            ),
                                            child: TextFormField(
                                              onChanged: (String newValue){
                                                password=newValue;
                                              },
                                              obscureText: true,
                                              controller: pass,
                                              decoration: InputDecoration(
                                                  hintText: "PASSWORD",
                                                  hintStyle: TextStyle(color: Colors.grey),
                                                  border: InputBorder.none
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    ),
                                    Padding(padding: EdgeInsets.all(10)),
                                    FadeInUp(child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [BoxShadow(
                                              color: Color.fromRGBO(225, 95, 27, .3),
                                              blurRadius: 20,
                                              offset: Offset(0, 10)
                                          )]
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                              decoration: BoxDecoration(
                                                  border: Border(bottom: BorderSide(color: Colors.grey.shade200))
                                              ),
                                              child: IconButton(
                                                color: Colors.indigo[900],
                                                onPressed: () {
                                                  fetchCheckPassword(userName,password);
                                                  // Navigator.of(context).push(
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) => billEntryFirstScreen())
                                                  // );
                                                }, icon: Icon(Icons.login),
                                              )
                                          ),
                                        ],

                                      ),
                                    ),
                                    )
                                  ]
                              )
                          )
                      )
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}