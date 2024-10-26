import 'dart:convert';

import 'package:billentry/CustomWidgets/appBar.dart';
import 'package:billentry/CustomWidgets/customDrawer.dart';
import 'package:billentry/GlobalVariables.dart';
import 'package:billentry/main.dart';
import 'package:billentry/stockReport.dart';
import 'package:flutter/material.dart'; // to import the material flutter package , package must be in single quotes,
import 'package:flutter/services.dart';
               // In single quotes, type package right next type colon, then type the inbuilt / custom package
               // type semicolon in the end
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;


List<transferEntry> transferList=[];
bool approvalScreen=false;
class branchTranseferPage extends StatefulWidget{  // branchTransferPage is the name of the widget,
   final dynamic approveData;                                                 // this widget is the extension of statesulwidget
   branchTranseferPage({Key? key,required this.approveData} ): super(key:key);


  @override
  _branchStateInstance createState()=> _branchStateInstance(approveData); // create the instance of state it will create only once,
                                                             // this instance will handle the dynamic UI
}


class _branchStateInstance extends State<branchTranseferPage>{
  String invoiceNum="";
  String fromBranch="";
  String toBranch="";
  int toBranchCompId=0;
  String item="";
  double itemRate=0.0;
  int itemId=0;
  double qty=0.0;
  double grandTotalAmount=0.0;
  late DateTime now;
  var edate;
  var approve;
  var transNo;
  var transMasId;
  List<dynamic> approvalList=[];



  _branchStateInstance(approveChk){
    print("approveChk");
    print(approveChk);
    final Map<String,dynamic> data= jsonDecode(approveChk);
    print(data['approve']);
    approve= data['approve'];
    if(approve) {
      final Map<String,dynamic> selectedData = jsonDecode(data['selectedData']);
      transNo = selectedData['transo'];
      transMasId = selectedData['transId'];
      print(selectedData['transo']);
      print(selectedData['transId']);
    }
    now = DateTime.now();
    edate =  DateFormat('yyyy-MM-dd').format(now);
  }
  DateTime currentDate = DateTime.now();
  List<String> fromList =[];
  List<String> toList=[];
  List<int> toListMasId=[];
  List<String> ItemList=[];
  List<double> RateList=[];
  List<int> ItemIdList =[];


  TextEditingController _itemController = new TextEditingController();
  TextEditingController rateTextController = new TextEditingController();
  TextEditingController qtyTextController = new TextEditingController();

  final DataGridController _dataGridController = DataGridController();

  var selected = false;
  var index  =-1;

  TextEditingController date = new TextEditingController();

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(color: Color(0xFF004D40),),
          Container(margin: EdgeInsets.only(left: 7),child:Text("..In Progress" )),
        ],),
    );
    showDialog(
      barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return WillPopScope(child: alert, onWillPop: ()=> Future.value(false));
      },
    );
  }

  Future<void> saveBranchTransferData(List masData, List detData)async {
    String cutTableApi =ipAddress+"api/saveBranchTransfer";
    showLoaderDialog(context);
    try {
      final response = await http.post(Uri.parse(cutTableApi),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          }, body: jsonEncode({
            "masData": masData,
            "detData": detData
          }));
      if (response.statusCode == 200) {
        print("Check 1");
        final Map<String, dynamic> data = json.decode(response.body);
        print(data);
        print(data['valid']);
        var saveChk = data['valid'];

        if (saveChk) {
          print("check1");
          ItemList.clear();
          RateList.clear();
          ItemIdList.clear();
          print("check2");
          edate = DateFormat('yyyy-MM-dd').format(now);
          print("check3");
          item = "";
          qty = 0.0;
          itemRate = 0.0;
          invoiceNum = "";
          grandTotalAmount = 0.0;
          selected = false;
          index = -1;

          date.clear();
          _itemController.clear();
          qtyTextController.clear();
          rateTextController.clear();
          print("check4");

          invoiceNum="";
          fromBranch="";
          toBranch="";
          toBranchCompId=0;
          item="";
          itemRate=0.0;
          itemId=0;
          qty=0.0;
          grandTotalAmount=0.0;
          now = DateTime.now();
          edate =  DateFormat('yyyy-MM-dd').format(now);
          currentDate = DateTime.now();
          fromList.clear();
          toList.clear();
          toListMasId.clear();
          ItemList.clear();
          RateList.clear();
          ItemIdList.clear();
          print("check5");

          _itemController.clear();
          rateTextController.clear();
          qtyTextController.clear();

          // final DataGridController _dataGridController = DataGridController();

          selected = false;
          index  =-1;

          date.clear();
          print("check6");

          getInvoiceNumber(false);
          fromBranch= globalUserName;
          fetchToBranchData();
          // await fetchItemData();
          transferList=[];
          _employeeDataSource = EmployeeDataSource(billEntry: transferList);
          date.text= currentDate.toString().split(' ')[0];

          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return
                AlertDialog(
                  title: Text('REASON'),
                  content: Text("Transferred Successfully"),
                  // Content of the dialog
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


          getInvoiceNumber(true);

          date.text = currentDate.toString().split(' ')[0];
          // fetchItemData();
          _employeeDataSource = EmployeeDataSource(billEntry: []);
        } else {
          // Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return
                AlertDialog(
                  title: Text('REASON'),
                  content: Text("Approval Failed"),
                  // Content of the dialog
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
      } else {
        print("response.statusCode");
        print(response.statusCode);
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
    }catch(e){
      print(e);
      print("response.statusCode  chk2 ");
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

  Future<void> saveBranchApprovalData(List detData)async {
    String cutTableApi =ipAddress+"api/saveApprovalData";
    showLoaderDialog(context);
    try {
      final response = await http.post(Uri.parse(cutTableApi),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          }, body: jsonEncode({
            "detData": detData
          }));
      if (response.statusCode == 200) {
        print("Check 1");
        final Map<String, dynamic> data = json.decode(response.body);
        print(data);
        print(data['valid']);
        var saveChk = data['valid'];

        if (saveChk) {
          if(data['existChk']){
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return
                  AlertDialog(
                    title: Text('REASON'),
                    content: const Text("Transno Approved Already"),
                    // Content of the dialog
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
          }else{
            bool value = await showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Text(
                    "Transferred Sucessfully",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text("OK"),
                    )
                  ],
                );
              },
            );

            if(value){
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/Home/branchApproval',
                    (Route<dynamic> route) => false, // This will remove all previous routes
              );
            }
          }


        } else {
          // Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return
                AlertDialog(
                  title: Text('REASON'),
                  content: Text("Transfer Failed"),
                  // Content of the dialog
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
      } else {
        print("response.statusCode");
        print(response.statusCode);
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
    }catch(e){
      print(e);
      print("response.statusCode  chk2 ");
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

  Future<void> getGridData( bool delChk) async {
    // billEntryList = [
    //   BillEntry(1, '222', 'ALMOND', 'PCS', '1234', 557.00, 10, 500.00, 5000.00, 5.00, 250.00, 450.00, 5700.00),
    //   BillEntry(2, '888', 'NUTS', 'PCS', '4678', 557.00, 10, 500.00, 5000.00, 5.00, 250.00, 450.00, 5700.00),
    // ];
    // if(item !="") {
    bool dupChk=false;
    if(selected && !delChk){
      item = _itemController.text.toString();
    }else{
      if(transferList.length>0) {
        for (int i = 0; i < transferList.length; i++) {
          if (transferList[i].itemName == item) {
            dupChk=true;
            break;
          }
        }
      }
    }
    if(!dupChk) {
      int idx = ItemList.indexOf(item);
      int code = 0;
      print("idx :- " + idx.toString());
      double rate = itemRate;
      if (idx != -1) {
        if (itemRate == 0.0) {
          rate = RateList[idx];
        }

        code = ItemIdList[idx];
      }
      int val = transferList.length + 1;
      double amount = qty * rate;
      // double totalamount = amount;
      // totalamount = totalamount + amount;

      if (!selected && !delChk) {
        transferList.add(transferEntry(
            val,
            code.toString(),
            item,
            qty,
            rate,
            amount));
      }
      else if (delChk) {
        transferList.removeAt(index);
        if (transferList.length > 0) {
          for (int i = 0; i < transferList.length; i++) {
            transferList[i].id = i + 1;
          }
        }
        selected = false;
      }
      else {
        print("Edit Check Point Working");
        print(index);

        for (int i = 0; i < transferList.length; i++) {
          if (index == i) {
            transferList[i].itemId = code.toString();
            transferList[i].itemName = item;
            transferList[i].quantity = qty;
            transferList[i].rate = rate;
            transferList[i].amount = amount;
          }
        }

        // List<BillEntry> tempBillEntryArray=[];
        // billEntryList.removeAt(1);
        // for(int i =0;i<billEntryList.length;i++){
        //   billEntryList[i].id = i+1;
        // }

        selected = false;
        //  print(tempBillEntryArray);
        //   print(billEntryList);
        //billEntryList=tempBillEntryArray;
        // print(billEntryList);
        //print(billEntryList.getRange(0, 1));
      }

      grandTotalAmount = 0.0;
      if (transferList.length > 0) {
        for (int i = 0; i < transferList.length; i++) {
          grandTotalAmount = transferList[i].amount + grandTotalAmount;
        }
      }
      print("grandTotalAmount");
      print(grandTotalAmount);
      setState(() {
        _employeeDataSource = EmployeeDataSource(billEntry: transferList);
      });
    }else{
      print("Dup CheckPoint");
      print(item);
      String valueStr="The following item("+item+") Already exists";
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return
            AlertDialog(
              title: Text('Duplicate Error'),
              content: Text(valueStr), // Content of the dialog
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

  showBillNoLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Color(0xFF004D40),),
            SizedBox(width: 7),
            Expanded(
                child:Text("Invoice Number Loading... Please Wait...." )),
          ],)
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return WillPopScope(child: alert, onWillPop: ()=> Future.value(false));
      },
    );

  }

  void _incrementCounter() {
    setState(() {
    });
  }

  Future<void> fetchToBranchData() async {
    try {
      String url=ipAddress+"api/getToBranchNames";
      String getApi="http://192.168.2.11:3000/api/getSupplierData";
      print("check Point 1");
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          }, body: jsonEncode({
            "compId": globalCompId
          }));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // print(data['valid']);
        bool chk = data['valid'];
        if(chk) {
          toList.clear();
          toListMasId.clear();
          List<dynamic> result1 = data['result'];
          print(result1);


          for (var list in result1) {
            toList.add(list['UserName']);
            toListMasId.add(list['RightsCompId']);
          }

          print("Length Check");

          //shipTo=CustomerIdList[0];


          _incrementCounter();
        }
        else{
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return
                AlertDialog(
                  title: Text('No Valid Sub Branch'),
                  content: Text("No valid sub branch to this userId"), // Content of the dialog
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
      else{
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return
              AlertDialog(
                title: Text('No Valid Sub Branch'),
                content: Text("No valid sub branch to this userId"), // Content of the dialog
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
    } catch (e) {
      print("chkErr");
      print(e);
    }
  }

  Future<void> fetchItemData() async {
    try {
      String url=ipAddress+"api/getBranchTransferItems";
      String getApi="http://192.168.2.11:3000/api/getSupplierData";
      print("check Point 1");
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          }, body: jsonEncode({
            "compId": globalCompId
          }));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        // print(data['valid']);
        bool chk = data['valid'];
        if(chk) {
          ItemList.clear();
          ItemIdList.clear();
          RateList.clear();
          List<dynamic> result1 = data['result'];
          print(result1);


          for (var list in result1) {
            ItemList.add(list['Item']);
            ItemIdList.add(list['ItemId']);
            RateList.add(double.parse(list['SalesRate'].toString()));
          }

          print("Length2 Check");

          //shipTo=CustomerIdList[0];


          _incrementCounter();
        }
        else{
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return
                AlertDialog(
                  title: Text('No Valid Items'),
                  content: Text("No valid items to this userId"), // Content of the dialog
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
      else{
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return
              AlertDialog(
                title: Text('Conn Err'),
                content: Text("Please ReOpen this Page"), // Content of the dialog
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
    } catch (e) {
      print("chkErr");
      print(e);
    }
  }

  Future<void> getApprovalData(dynamic val) async{
    String cutTableApi =ipAddress+"api/getTransferredData";
    print(val);
    // Use addPostFrameCallback to show the dialog

      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          showBillNoLoaderDialog(context);
        } catch (e) {
          print("Error showing loading dialog: ${e.toString()}");
        }
      });

    try {
      final response = await http.post(Uri.parse(cutTableApi),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          }, body:val);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print("Check Point 1");
        print(data);
        if(data['valid']) {

          transferList.clear();
          approvalList = data['result'];
          grandTotalAmount=0.0;
          for(int i=0;i<approvalList.length;i++){
            // approvalList[i]['']
            transferList.add(transferEntry(i+1, approvalList[i]['ItemId'].toString(), approvalList[i]['Item'],
                double.parse(approvalList[i]['Qty'].toString()),
                double.parse(approvalList[i]['Rate'].toString()), double.parse(approvalList[i]['Amount'].toString())));
            grandTotalAmount=grandTotalAmount+approvalList[i]['Amount'];
          }

          setState(() {
            invoiceNum = data['result'][0]['Prod_No'];
            toBranch=globalUserName;
            fromBranch=data['result'][0]['UserName'];
            _employeeDataSource = EmployeeDataSource(billEntry: transferList);
            // if (!chk) {
              Navigator.pop(context);
            // }
          });
        }else{
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return
                AlertDialog(
                  title: const Text('Connection Error'),
                  content: const Text("Conn Err:- Please Reopen this Page"), // Content of the dialog
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
              return
                AlertDialog(
                  title: Text('Connection Error'),
                  content: Text("Conn Err:- Please Reopen this Page"), // Content of the dialog
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
    }catch(e){
        print("error");
        print(e);
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return
              AlertDialog(
                title: Text('Connection Error'),
                content: Text("Conn Err:- Please Reopen this Page"), // Content of the dialog
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

  Future<void> getInvoiceNumber(bool chk) async{
    String cutTableApi =ipAddress+"api/getBranchTransferInvoiceNumber";
    print(cutTableApi);
    // Use addPostFrameCallback to show the dialog
    if(!chk) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          showBillNoLoaderDialog(context);
        } catch (e) {
          print("Error showing loading dialog: ${e.toString()}");
        }
      });
    }
    try {
      final response = await http.post(Uri.parse(cutTableApi),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          }, body: jsonEncode({
            "compId": globalCompId
          }));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print("Check Point 1");
        print(data);
        if(data['valid']) {
          setState(() {
            invoiceNum = data['result'];
            if (!chk) {
              Navigator.pop(context);
            }
          });
        }else{
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return
                AlertDialog(
                  title: const Text('Connection Error'),
                  content: const Text("Conn Err:- Please Reopen this Page"), // Content of the dialog
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
        if(!chk) {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return
                AlertDialog(
                  title: Text('Connection Error'),
                  content: Text("Conn Err:- Please Reopen this Page"), // Content of the dialog
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
        }else{
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return
                AlertDialog(
                  title: Text('Connection Error'),
                  content: Text("Conn Err:- Please Reopen this Page"), // Content of the dialog
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
    }catch(e){
      if(!chk) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return
              AlertDialog(
                title: Text('Connection Error'),
                content: Text("Conn Err:- Please Reopen this Page"), // Content of the dialog
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
      }else{
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return
              AlertDialog(
                title: Text('Connection Error'),
                content: Text("Conn Err:- Please Reopen this Page"), // Content of the dialog
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
  }

  late EmployeeDataSource _employeeDataSource;
  @override
  void initState() {
    super.initState();
    if(approve){
      print("if condition");
      fromBranch = globalUserName;
      dynamic value =jsonEncode({"TRANSNO":transNo, "TRANSID":transMasId});
      getApprovalData(value);
      _employeeDataSource = EmployeeDataSource(billEntry: transferList);
      date.text = currentDate.toString().split(' ')[0];
    }else {
      print("else condition");
      getInvoiceNumber(false);
      fromBranch = globalUserName;
      fetchToBranchData();
      fetchItemData();
      _employeeDataSource = EmployeeDataSource(billEntry: transferList);
      date.text = currentDate.toString().split(' ')[0];
    }
  }

  @override
  Widget build (BuildContext context) {  // overriding the build widget, BuildContext provides the information of location
    double height = MediaQuery.of(context).size.height;
    return WillPopScope(child: Scaffold(
      appBar: CustomAppBar(userName: globalUserName, emailId: globalEmailId,
        onMenuPressed: (){
          Scaffold.of(context).openDrawer();
        }, barTitle: approve?"Approval Screen":"Godown Transfer",),
      drawer: customDrawer(brhTransferCheck: true,stkTransferCheck: false,),
      body: SingleChildScrollView(child: Column(children: [
        const Padding(padding:EdgeInsets.all(5)),
        BootstrapContainer(
            fluid: true,
            children:[
              BootstrapRow(
                children: <BootstrapCol>[
                  BootstrapCol(
                    sizes: 'col-md-12',
                    child: TextFormField(
                      showCursor: false,
                      readOnly: true,
                      controller: TextEditingController()..text= invoiceNum.toString(),
                      decoration: InputDecoration(border: OutlineInputBorder(),labelText: 'Invoice No',
                          fillColor: Colors.white, filled: true),
                    ),
                  ),
                ],
              ),
            ]
        ),

        const Padding(padding:EdgeInsets.all(5)),
        BootstrapContainer(
            fluid: true,
            children:[
              BootstrapRow(
                children: <BootstrapCol>[
                  BootstrapCol(
                    sizes: 'col-md-12',
                    child: TextField(
                      controller: date,
                      // readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Invoice Date',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red), // Change the border color here
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                date.text = pickedDate.toString().split(' ')[0];
                                edate = pickedDate.toString().split(' ')[0];
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]
        ),
        const Padding(padding:EdgeInsets.all(5)),
        BootstrapContainer(
            fluid: true,
            children:[
              BootstrapRow(
                children: <BootstrapCol>[
                  BootstrapCol(
                    sizes: 'col-md-12',
                    child: TextFormField(
                      showCursor: false,
                      readOnly: true,
                      controller: TextEditingController()..text= fromBranch.toString(),
                      decoration: InputDecoration(border: OutlineInputBorder(),labelText: 'From Branch',
                          fillColor: Colors.white, filled: true),
                    ),
                  ),
                ],
              ),
            ]
        ),
        // Padding(padding:EdgeInsets.fromLTRB(25, 10, 25, 0),
        //   child:
        //   Autocomplete<String>(
        //   optionsBuilder: (TextEditingValue textEditingValue) {
        //     if (textEditingValue.text.isEmpty) {
        //       return const Iterable<String>.empty();
        //     } else {
        //       return fromList.where((String item) {
        //         return item.toLowerCase().contains(textEditingValue.text.toLowerCase());
        //       });
        //     }
        //   },
        //   fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        //     return TextField(
        //       controller: controller,
        //       focusNode: focusNode,
        //       onTapOutside: (value) {
        //         // String value=controller.text.toString();
        //         // if(CustomerList.indexOf(value)==-1){
        //         //   controller..text="";
        //         // }else{
        //         //   setState(() {
        //         //     customer = value!;
        //         //     int idx = CustomerList.indexOf(customer);
        //         //     stateCode=StateCodeList[idx];
        //         //     shipTo = customer;
        //         //   });
        //         // }
        //       },
        //       onSubmitted: (value) {
        //         if(fromList.indexOf(value)==-1){
        //           controller..text="";
        //         }else{
        //           setState(() {
        //             // customer = value!;
        //             // int idx = CustomerList.indexOf(customer);
        //             // stateCode=StateCodeList[idx];
        //             // stateCodeId = StateCodeIdList[idx];
        //             // customerId = CustomerIdList[idx];
        //             // shipTo = customer;
        //           });
        //         }
        //       },
        //       decoration: InputDecoration(
        //         fillColor:  Colors.white,
        //         filled: true,
        //         labelText: "From Branch",
        //         hintText: 'Search for a from branch',
        //         border: OutlineInputBorder(),
        //       ),
        //     );
        //   },
        //   optionsViewBuilder: (context, onSelected, options) {
        //     return Material(
        //       elevation: 4.0,
        //       child: ListView.builder(
        //         padding: EdgeInsets.zero,
        //         itemCount: options.length,
        //         itemBuilder: (context, index) {
        //           late final option = options.elementAt(index);
        //           return ListTile(
        //             title: Text(option),
        //             onTap: () {
        //               onSelected(option);
        //               setState(() {
        //                 // customer = option!;
        //                 // int idx = CustomerList.indexOf(customer);
        //                 // stateCode=StateCodeList[idx];
        //                 // stateCodeId = StateCodeIdList[idx];
        //                 // customerId = CustomerIdList[idx];
        //                 // shipTo = customer;
        //               });
        //             },
        //           );
        //         },
        //       ),
        //     );
        //   },
        // ),),

        !approve ?Padding(padding:EdgeInsets.fromLTRB(25, 10, 25, 0),
          child: Autocomplete<String>(
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<String>.empty();
            } else {
              return toList.where((String item) {
                return item.toLowerCase().contains(textEditingValue.text.toLowerCase());
              });
            }
          },
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            return TextField(
              controller: controller,
              focusNode: focusNode,
              onTapOutside: (value) {
                // String value=controller.text.toString();
                // if(CustomerList.indexOf(value)==-1){
                //   controller..text="";
                // }else{
                //   setState(() {
                //     customer = value!;
                //     int idx = CustomerList.indexOf(customer);
                //     stateCode=StateCodeList[idx];
                //     shipTo = customer;
                //   });
                // }
              },
              onSubmitted: (value) {
                if(toList.indexOf(value)==-1){
                  controller..text="";
                }else{
                  setState(() {
                    toBranch = value!;
                    int idx = toList.indexOf(toBranch);
                    toBranchCompId = toListMasId[idx];
                    // customer = value!;
                    // int idx = CustomerList.indexOf(customer);
                    // stateCode=StateCodeList[idx];
                    // stateCodeId = StateCodeIdList[idx];
                    // customerId = CustomerIdList[idx];
                    // shipTo = customer;
                  });
                }
              },
              decoration: InputDecoration(
                fillColor:  Colors.white,
                filled: true,
                labelText: "To Branch",
                hintText: 'Search for a to branch',
                border: OutlineInputBorder(),
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Material(
              elevation: 4.0,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  late final option = options.elementAt(index);
                  return ListTile(
                    title: Text(option),
                    onTap: () {
                      onSelected(option);
                      setState(() {
                        toBranch = option!;
                        int idx = toList.indexOf(toBranch);
                        toBranchCompId = toListMasId[idx];
                        // stateCode=StateCodeList[idx];
                        // stateCodeId = StateCodeIdList[idx];
                        // customerId = CustomerIdList[idx];
                        // shipTo = customer;
                      });
                    },
                  );
                },
              ),
            );
          },
        ),):
        Column(children: [const Padding(padding:EdgeInsets.all(5)),
          BootstrapContainer(
              fluid: true,
              children:[
                BootstrapRow(
                  children: <BootstrapCol>[
                    BootstrapCol(
                      sizes: 'col-md-12',
                      child: TextFormField(
                        showCursor: false,
                        readOnly: true,
                        controller: TextEditingController()..text= toBranch.toString(),
                        decoration: InputDecoration(border: OutlineInputBorder(),labelText: 'To Branch',
                            fillColor: Colors.white, filled: true),
                      ),
                    ),
                  ],
                ),
              ]
          ),],),


        !approve?Column(children: [
          Padding(
          padding: EdgeInsets.fromLTRB(25, 75, 25, 5),
          child:
          Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:[
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("ADD ITEM"),
                  ],
                ),
                Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    } else {
                      return ItemList.where((String item) {
                        return item.toLowerCase().contains(textEditingValue.text.toLowerCase());
                      });
                    }
                  },
                  fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                    _itemController=controller;
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      onTapOutside: (value) {
                        // String value=controller.text.toString();
                        // if(CustomerList.indexOf(value)==-1){
                        //   controller..text="";
                        // }else{
                        //   setState(() {
                        //     customer = value!;
                        //     int idx = CustomerList.indexOf(customer);
                        //     stateCode=StateCodeList[idx];
                        //     shipTo = customer;
                        //   });
                        // }
                      },
                      onChanged: (value){
                        setState(() {
                          item = value!;
                          if(ItemList.indexOf(item) != -1){
                            setState(() {
                              itemRate= RateList[ItemList.indexOf(item)];
                              itemId = ItemIdList[ItemList.indexOf(item)];
                              print("Rate : "+ itemRate.toString());
                              rateTextController.text=itemRate.toString();
                            });

                          }
                        });
                      },
                      onSubmitted: (value) {
                        // if(ItemList.indexOf(value)==-1){
                        //   controller..text="";
                        // }else{
                        setState(() {
                          item = value!;
                          if(ItemList.indexOf(item) != -1){
                            setState(() {
                              itemRate= RateList[ItemList.indexOf(item)];
                              itemId = ItemIdList[ItemList.indexOf(item)];
                              print("Rate : "+ itemRate.toString());
                              rateTextController.text=itemRate.toString();
                            });

                          }
                        });
                        // }
                      },
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        labelText: "Item",
                        hintText: 'Search for a item',
                        border: OutlineInputBorder(),
                      ),
                    );
                  },
                  optionsViewBuilder: (context, onSelected, options) {
                    return Material(
                      elevation: 4.0,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          late final option = options.elementAt(index);
                          return ListTile(
                            title: Text(option),
                            onTap: () {
                              onSelected(option);
                              setState(() {
                                print("Selection : "+option);
                                item = option!;
                                print(ItemList.indexOf(item));
                                if(ItemList.indexOf(item) != -1){
                                  setState(() {
                                    itemRate= RateList[ItemList.indexOf(item)];
                                    itemId = ItemIdList[ItemList.indexOf(item)];
                                    print("Rate : "+ itemRate.toString());
                                    rateTextController.text=itemRate.toString();
                                  });

                                }
                                // int idx = CustomerList.indexOf(customer);
                                // stateCode=StateCodeList[idx];
                                // shipTo = customer;
                              });
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ]
          ),
        ),
          const Padding(padding:EdgeInsets.all(5)),
          BootstrapContainer(
              fluid: true,
              children:[
                BootstrapRow(
                  children: <BootstrapCol>[
                    BootstrapCol(
                      sizes: 'col-md-12',
                      child: TextFormField(
                        // showCursor: false,
                        // readOnly: true,
                        keyboardType: TextInputType.number,
                        onChanged:(String newValue){
                          if(newValue.toString() ==""){
                            qty=0.0;
                          }else {
                            qty = double.parse(newValue);
                          }
                        },
                        controller: qtyTextController,
                        decoration: InputDecoration(border: OutlineInputBorder(),
                            labelText: 'Quantity',
                            fillColor: Colors.white, filled: true),
                      ),
                    ),
                  ],
                ),
              ]
          ),
          const Padding(padding:EdgeInsets.all(5)),
          BootstrapContainer(
              fluid: true,
              children:[
                BootstrapRow(
                  children: <BootstrapCol>[
                    BootstrapCol(
                      sizes: 'col-md-12',
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        // showCursor: false,
                        // readOnly: true,
                        onChanged: (String newValue){
                          itemRate = double.parse(newValue);
                        },
                        controller: rateTextController,
                        decoration: InputDecoration(border: OutlineInputBorder(),labelText: 'Rate',
                            fillColor: Colors.white, filled: true),
                      ),
                    ),
                  ],
                ),
              ]
          ),

          const Padding(padding:EdgeInsets.all(10)),
          Center(
              child:
              Row( mainAxisAlignment: MainAxisAlignment.center,children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigator.pushAndRemoveUntil(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => EmployeeDataGrid()),
                    //       (Route<dynamic> route) => true, // This disables back navigation
                    // );
                    print("qty");
                    print(qty);
                    if(qty != 0.0 && qty != null) {
                      if(ItemList.contains(item) && toList.contains(toBranch)) {
                        getGridData(false);
                        _itemController.clear();
                        qtyTextController.clear();
                        rateTextController.clear();
                        item = "";
                        qty = 0.0;
                        itemRate = 0.0;
                      }
                    }else{
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return
                            AlertDialog(
                              title: Text('REASON'),
                              content: Text("Please Enter The Qty"), // Content of the dialog
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
                  },
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Color(0xFF004D40),
                      textStyle: TextStyle(color: Colors.black,
                          fontWeight: FontWeight.bold)
                  ),
                  child: Text('Save', style: TextStyle(
                      color: Colors.white
                  ),),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    getGridData(true);
                    _itemController.clear();
                    qtyTextController.clear();
                    rateTextController.clear();
                    item="";
                    qty=0.0;
                    itemRate=0.0;
                  },
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Color(0xFF004D40),
                      textStyle: TextStyle(color: Colors.black,
                          fontWeight: FontWeight.bold)
                  ),
                  child: Text('Delete', style: TextStyle(
                      color: Colors.white
                  ),),
                ),
              ],)
          ),],):SizedBox(height: 0,),

        Padding(padding: EdgeInsets.fromLTRB(0, 25, 0, 0)),
        Container(height: height*0.5,
          child:SfDataGridTheme(
          data: SfDataGridThemeData(
            currentCellStyle: DataGridCurrentCellStyle(
              borderWidth: 2,
              borderColor: Colors.pinkAccent,
            ),
            selectionColor: Colors.lightGreen[50],
            headerColor: Color(0xFF004D40),
          ),
          child: Container(
            margin: EdgeInsets.fromLTRB(//width > 1400 ? 75
                0, 0, 0, 0),
            child:
            SfDataGrid(
              allowEditing: true,
              selectionMode: SelectionMode.single,
              headerGridLinesVisibility: GridLinesVisibility.both,
              // navigationMode: GridNavigationMode.cell,
              source: _employeeDataSource,
              editingGestureType: EditingGestureType.tap,
              columnWidthCalculationRange: ColumnWidthCalculationRange.visibleRows,
              gridLinesVisibility: GridLinesVisibility.both,
              showVerticalScrollbar: true,
              isScrollbarAlwaysShown: true,
              columns: [
                GridColumn(
                  columnName: 'id',
                  width: 65,
                  allowEditing: false,
                  label: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.centerLeft,
                    child: Text('SNO', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                  ),
                ),
                GridColumn(
                  columnName: 'itemId',
                  width: 75,
                  visible: false,
                  label: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.center,
                    child: Text('ItemId', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                  ),
                ),
                GridColumn(
                  columnName: 'itemName',
                  width: 250,
                  label: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.center,
                    child: Text('Particular', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                  ),
                ),
                // GridColumn(
                //   columnName: 'uom',
                //   width: 75,
                //   label: Container(
                //     padding: EdgeInsets.symmetric(horizontal: 16.0),
                //     alignment: Alignment.center,
                //     child: Text('Uom', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                //   ),
                // ),
                GridColumn(
                  columnName: 'quantity',
                  width: 100,
                  allowEditing: true,
                  label: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.center,
                    child: Text('Quantity', overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white)),
                  ),
                ),
                GridColumn(
                  columnName: 'rate',
                  width: 100,
                  label: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.center,
                    child: Text('Rate', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                  ),
                ),
                GridColumn(
                  columnName: 'amount',
                  width: 100,
                  label: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    alignment: Alignment.center,
                    child: Text('Amount', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
              controller : _dataGridController,
              onSelectionChanged:
                  (List<DataGridRow> addedRows, List<DataGridRow> removedRows) {
                // apply your logic
                selected=true;
                index=_dataGridController.selectedIndex;
                DataGridRow? data= _dataGridController.selectedRow;
                print(_dataGridController.selectedIndex);

                print(data);
                print(data);

                print(data?.getCells()[2].value);
                print(data?.getCells()[6].value);
                print(data?.getCells()[9].value);
                setState(() {
                  qty=data?.getCells()[6].value;
                  qtyTextController.text=data!.getCells()[6].value.toString();
                  _itemController..text=data?.getCells()[2].value;
                  rateTextController.text=data!.getCells()[7].value.toString();
                  itemRate = data?.getCells()[7].value;
                });
              },
              columnWidthMode: ColumnWidthMode.fill,
            ),
          ),
        ),),
        Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
        Center(child:
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 20,),Text("Total Amount : - ${grandTotalAmount}"),
            SizedBox(width: 20,),
            ElevatedButton(
              onPressed: () {
                if(!approve) {
                  if (transferList.length > 0) {
                    List<dynamic> detList = [];
                    for (int i = 0; i < transferList.length; i++) {
                      detList.add({
                        "ITEMID": transferList[i].itemId,
                        "QTY": transferList[i].quantity,
                        "RATE": transferList[i].rate,
                        "AMOUNT": transferList[i].amount,
                      });
                    }
                    List<dynamic> masList = [];
                    masList.add({
                      "INVOICENO": invoiceNum,
                      "COMPID": globalCompId,
                      "TOCOMPID": toBranchCompId,
                      "dat": edate
                    });
                    print("jsonObject");
                    print(masList.length);
                    print(masList);
                    print(detList);

                    saveBranchTransferData(masList, detList);
                  }
                  else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return
                          AlertDialog(
                            title: Text('ALERT'),
                            content: Text(
                                "Please Save The Item, Before Transfer"),
                            // Content of the dialog
                            actions: <Widget>[
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                              ),
                            ],
                          );
                      },
                    );
                  }
                }else{
                  if(approvalList.isNotEmpty){
                    saveBranchApprovalData(approvalList);
                  }else{
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return
                          AlertDialog(
                            title: Text('ALERT'),
                            content:const Text(
                                "No valid Items to Approve"),
                            // Content of the dialog
                            actions: <Widget>[
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                              ),
                            ],
                          );
                      },
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Color(0xFF004D40),
                  textStyle: TextStyle(color: Colors.black,
                      fontWeight: FontWeight.bold)
              ),
              child: Text(approve?'Approve':'Save', style: TextStyle(
                  color: Colors.white
              ),),
            ),],)
        )
      ],),),
    ), onWillPop: () async{
      if(!approve) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/Home',
              (Route<
              dynamic> route) => false, // This will remove all previous routes
        );
      }else{
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/Home/branchApproval',
              (Route<
              dynamic> route) => false, // This will remove all previous routes
        );
      }
      return true;
    },
    );   //Scaffold is the layout in the flutter
  }

}

class transferEntry {
  transferEntry(
      this.id,
      this.itemId,
      this.itemName,
      this.quantity,
      this.rate,
      this.amount
      );

  int id;
  String itemId;
  String itemName;
  double quantity;
  double rate;
  double amount;
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List<transferEntry> billEntry}) {
    _billEntry = billEntry.map<DataGridRow>((dataGridRow) => DataGridRow(
      cells: [
        DataGridCell<int>(columnName: 'id', value: dataGridRow.id),
        DataGridCell<String>(columnName: 'itemId', value: dataGridRow.itemId),
        DataGridCell<String>(columnName: 'itemName', value: dataGridRow.itemName),
        DataGridCell<double>(columnName: 'quantity', value: dataGridRow.quantity),
        DataGridCell<double>(columnName: 'rate', value: dataGridRow.rate),
        DataGridCell<double>(columnName: 'amount', value: dataGridRow.amount)
      ],
    )).toList();
  }

  late List<DataGridRow> _billEntry;

  @override
  List<DataGridRow> get rows => _billEntry;

  // List<Employee> _employees = [];

  // List<DataGridRow> dataGridRows = [];

  /// Helps to hold the new value of all editable widget.
  /// Based on the new value we will commit the new value into the corresponding
  /// [DataGridCell] on [onSubmitCell] method.
  dynamic newCellValue;

  /// Help to control the editable text in [TextField] widget.
  TextEditingController editingController = TextEditingController();

  // @override
  // List<DataGridRow> get rows => dataGridRows;


  @override
  Future<void> onCellSubmit(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column) async {
    late final dynamic oldValue = dataGridRow
        .getCells()
        .firstWhereOrNull((DataGridCell dataGridCell) =>
    dataGridCell.columnName == column.columnName)
        ?.value ??
        '';
    print("onCellSubmit working");
    late  final int dataRowIndex = _billEntry.indexOf(dataGridRow);
    if (newCellValue == null || oldValue == newCellValue) {
      return;
    }
    if (column.columnName == 'quantity') {
      print("Check Point 1");
      print(_billEntry[dataRowIndex].getCells()[rowColumnIndex.columnIndex].value);
      _billEntry[dataRowIndex].getCells()[rowColumnIndex.columnIndex]=DataGridCell<int>(columnName: 'quantity', value: newCellValue);
      //_billEntry[dataRowIndex].quantity = newCellValue as int;
      transferList[dataRowIndex].quantity=double.parse(newCellValue.toString());
      dynamic value= double.parse(newCellValue.toString())*   double.parse(_billEntry[dataRowIndex].getCells()[rowColumnIndex.columnIndex+1].value.toString());
      print("Total Amount");
      _billEntry[dataRowIndex].getCells()[rowColumnIndex.columnIndex+2]=DataGridCell<int>(columnName: 'amount', value: value);

      // print(value);
      print(dataRowIndex);
      print(rowColumnIndex.columnIndex);
      // _billEntry[dataRowIndex].getCells()[rowColumnIndex.columnIndex]=DataGridCell<int>(columnName: 'quantity', value: newCellValue);
      // billEntryList[dataRowIndex].quantity=double.parse(newCellValue.toString());

    }

    /*if (column.columnName == 'id') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<int>(columnName: 'id', value: newCellValue);
      _employees[dataRowIndex].id = newCellValue as int;
    } else if (column.columnName == 'name') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'name', value: newCellValue);
      _employees[dataRowIndex].name = newCellValue.toString();
    } else if (column.columnName == 'designation') {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<String>(columnName: 'designation', value: newCellValue);
      _employees[dataRowIndex].designation = newCellValue.toString();
    } else {
      dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
          DataGridCell<dynamic>(columnName: column.columnName, value: newCellValue);
    }*/
    // Add any additional logic to handle the cell submission
  }

  @override
  Future<bool> canSubmitCell(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column) async {
    print("canSubmitCell");
    // if (column.columnName == 'quantity' && newCellValue == null) {
    //   // Return false, to retain in edit mode.
    //   // To avoid null value for cell
    //   return Future.value(false);
    // } else {
    return Future.value(true);
    // }
  }

  @override
  Widget? buildEditWidget(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    // Text going to display on editable widget
    late final String displayText = dataGridRow
        .getCells()
        .firstWhereOrNull((DataGridCell dataGridCell) =>
    dataGridCell.columnName == column.columnName)
        ?.value
        ?.toString() ??
        '';

    // The new cell value must be reset.
    // To avoid committing the [DataGridCell] value that was previously edited
    // into the current non-modified [DataGridCell].
    newCellValue = null;

    late final bool isNumericType =
        column.columnName == 'quantity' || column.columnName == 'salary';

    // Holds regular expression pattern based on the column type.
    late final RegExp regExp = _getRegExp(isNumericType, column.columnName);

    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: isNumericType ? Alignment.centerRight : Alignment.centerLeft,
      child: TextField(
        autofocus: true,
        controller: editingController..text = displayText,
        textAlign: isNumericType ? TextAlign.right : TextAlign.left,
        autocorrect: false,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
        ),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(regExp)
        ],
        keyboardType: isNumericType ? TextInputType.number : TextInputType.text,
        onChanged: (String value) {
          if (value.isNotEmpty) {
            if (isNumericType) {
              newCellValue = int.parse(value);
            } else {
              newCellValue = value;
            }
          } else {
            newCellValue = null;
          }
        },
        onSubmitted: (String value) {
          print("widget working");
          /// Call [CellSubmit] callback to fire the canSubmitCell and
          /// onCellSubmit to commit the new value in single place.
          submitCell();
        },
      ),
    );
  }
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
          return Container(
              alignment: (dataGridCell.columnName == 'id' ||
                  dataGridCell.columnName == 'salary')
                  ? Alignment.center
                  : Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                dataGridCell.value.toString(),
                overflow: TextOverflow.ellipsis,
              ));
        }).toList());
  }

  RegExp _getRegExp(bool isNumericKeyBoard, String columnName) {
    return isNumericKeyBoard ? RegExp('[0-9]') : RegExp('[a-zA-Z ]');
  }
}


