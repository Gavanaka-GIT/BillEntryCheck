import 'dart:convert';
import 'package:billentry/CustomWidgets/appBar.dart';
import 'package:billentry/CustomWidgets/customDrawer.dart';
import 'package:billentry/GlobalVariables.dart';
import 'package:billentry/billEntryMasScreen.dart';
import 'package:billentry/main.dart';
import 'package:billentry/stockReport.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

import 'package:syncfusion_flutter_core/theme.dart';


import 'package:dropdown_button2/dropdown_button2.dart';


List<BillEntry> billEntryList=[];
class PurchaseEntryMasScreen extends StatefulWidget {
  const PurchaseEntryMasScreen({super.key} );


  @override
  State<PurchaseEntryMasScreen> createState() => _purchaseEntryMasState();
}

class _purchaseEntryMasState extends State<PurchaseEntryMasScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: purchaseEntryFirstScreen(),
    );
  }
}

class purchaseEntryFirstScreen extends StatefulWidget {
  final dynamic data;
  const purchaseEntryFirstScreen({Key? key, this.data}) : super(key: key);

  @override
  _billEntryFirstState createState() => _billEntryFirstState();
}

class _billEntryFirstState extends State<purchaseEntryFirstScreen> {
  List<String> ENAME =[];
  List<String> CustomerList =[];
  List<int> CustomerIdList=[];
  List<String> StateCodeList=[];
  List<int> StateCodeIdList=[];
  List<String> BillTypeList=[];
  List<String> PayTypeList=[];
  List<String> ItemList=[];
  List<double> RateList=[];
  List<String> UomList=[];
  List<String> HsnList=[];
  List<double> StockQtyList=[];
  List<double> CGstList=[];
  List<double> SGstList=[];
  List<double> IGstList=[];
  List<double>  QtyList=[];
  List<double> DiscList=[];
  List<int> ItemIdList =[];
  String billType="";
  String payType="";
  String customer="";
  int stateCodeId=0;
  int customerId=0;
  String stateCode="";
  int shipTo=0;
  String item="";
  double qty=0.0;
  double discount=0.0;
  double itemRate=0.0;
  String invoiceNum="";
  String supInvNumber="";
  String savedShipToName="";
  String narration="";
  String customerName="";
  double grandTotalAmount=0.0;
  bool approvalValue=false;
  double savedTotalAmount=0.0;
  List<String> SalesType=["Purchase"];
  int salesTypeidx=0;
  late DateTime now;
  var edate;
  var sdate;
  _billEntryFirstState(){
    now = DateTime.now();
    edate =  DateFormat('dd/MM/yyyy').format(now);
    sdate = DateFormat('dd/MM/yyyy').format(now);
  }

  var selected = false;
  var index  =-1;

  TextEditingController date = new TextEditingController();
  TextEditingController supplierInDateController = new TextEditingController();
  TextEditingController _itemController = new TextEditingController();
  TextEditingController _shipToController = new TextEditingController();
  TextEditingController _customerController = new TextEditingController();
  TextEditingController qtyTextController = new TextEditingController();
  TextEditingController itemTextController = new TextEditingController();
  TextEditingController discTextController = new TextEditingController();
  TextEditingController rateTextController = new TextEditingController();
  TextEditingController gstTextController = new TextEditingController();
  TextEditingController narrationController = new TextEditingController();
  final DataGridController _dataGridController = DataGridController();


  DateTime currentDate = DateTime.now();

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(color: Color(0xFF004D40),),
          Container(margin: EdgeInsets.only(left: 7),child:Text("..In Progress" )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return WillPopScope(child: alert, onWillPop: ()=> Future.value(false));
      },
    );
  }

  showPurchaseNoLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Color(0xFF004D40),),
            SizedBox(width: 7),
            Expanded(
                child:Text("Purchase Number Loading... Please Wait...." )),
          ],)
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return WillPopScope(child: alert,onWillPop: ()=> Future.value(false));
      },
    );

  }


  Future<void> fetchSupplierData() async {
    try {
      // String tempResult=docId;
      // docId = docId.replaceAll("/","%2F");
      //String getLayPrep = "http://${ipAddress}:5025/api/getLayprep/" + docId ;
      String url=ipAddress+"api/getSupplierData/"+globalCompId.toString();
      String getApi="http://192.168.2.11:3000/api/getSupplierData";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        CustomerList.clear();
        CustomerIdList.clear();
        StateCodeList.clear();
        StateCodeIdList.clear();
        List<dynamic> result1 = data['result'];
        print(result1);

        for (var list in result1){
          CustomerList.add(list['Supplier'].toString());
          CustomerIdList.add(list['SupplierId']);
          StateCodeList.add(list['City'].toString());
          StateCodeIdList.add(list['CityId']);
        }

        print("Length Check");
        print(CustomerList.length);
        print(CustomerIdList.length);
        print(StateCodeList.length);
        print(CustomerIdList.length);
        customer=CustomerList[0];
        stateCode=StateCodeList[0];
        stateCodeId = StateCodeIdList[0];
        customerId = CustomerIdList[0];
        // shipTo=CustomerList[0];


        _incrementCounter();
      }
    } catch (e) {
      print("chkErr");
      print(e);
    }
  }


  Future<void> fetchItemData() async {
    try {
      // String tempResult=docId;
      // docId = docId.replaceAll("/","%2F");
      //String getLayPrep = "http://${ipAddress}:5025/api/getLayprep/" + docId ;
      String getApi=ipAddress+"api/getItemData/"+globalCompId.toString();;
      final response = await http.get(Uri.parse(getApi));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        ItemList.clear();
        RateList.clear();
        CGstList.clear();
        IGstList.clear();
        SGstList.clear();
        UomList.clear();
        HsnList.clear();
        StockQtyList.clear();
        ItemIdList.clear();
        List<dynamic> result1 = data['result'][0];
        print(result1);

        for (var list in result1){
          ItemList.add(list['Item'].toString());
          RateList.add(double.parse(list['SalesRate'].toString()));
          UomList.add(list['UOM'].toString());
          HsnList.add(list['Hsn'].toString());
          CGstList.add(double.parse(list['Cgstp'].toString()));
          IGstList.add(double.parse(list['Igstp'].toString()));
          SGstList.add(double.parse(list['Sgstp'].toString()));
          StockQtyList.add(list['STK'].toString() !="null" ? double.parse(list['STK'].toString()) : 0 );
          ItemIdList.add(list['ItemId']);
        }

        // _itemController..text=ItemList[0];


        _incrementCounter();
      }
    } catch (e) {
      print("chkErr");
      print(e);
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
                child:Text("Bill Number Loading... Please Wait...." )),
          ],)
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return WillPopScope(child: alert, onWillPop: ()=> Future.value(false));
      },
    );

  }

  Future<void> fetchSavedData(String Transno) async {
    try {
      // String tempResult=docId;
      // docId = docId.replaceAll("/","%2F");
      //String getLayPrep = "http://${ipAddress}:5025/api/getLayprep/" + docId ;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          showBillNoLoaderDialog(context);
        } catch (e) {
          print("Error showing loading dialog: ${e.toString()}");
        }
      });
      String url=ipAddress+"api/getPurchaseEntryData";
      String getApi="http://192.168.2.11:3000/api/getSupplierData";
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          }, body: jsonEncode({
            "TRANSNO":Transno
          }));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print("data");
        print(data);
        List<dynamic> result = data['result'];
        invoiceNum= result[0]['Cons_No'];
        print(result[0]['BillType'].toString());
        int idx= result[0]['IsVat'].toString() == 'N'?0:1;
        print(idx);
        billType = BillTypeList[idx];
        idx=result[0]['PayType'].toString() == "C"? 1:0;
        payType= PayTypeList[idx];
        customerName=result[0]['Person'].toString();
        savedShipToName= result[0]['Supplier'].toString();
        String dat;
        // supplierInDateController.text
        dat= result[0]['SupInvDate'].toString() == "null"? "":result[0]['SupInvDate'].toString();
        if(dat != "") {
          DateTime constTime = DateTime.parse(dat);
          dat = DateFormat("yyyy-MM-dd THH:mm:ss.SSS").format(constTime);
          dat = dat.split(' ')[0];
          supplierInDateController.text = dat;
        }else{
          supplierInDateController.text = "";
        }


        supInvNumber= result[0]['SupInvNo'].toString()== "null"?"":result[0]['SupInvNo'].toString();
        narrationController.text= result[0]['Narration'].toString()=="null"?"":result[0]['Narration'].toString();
        try {
          billEntryList.clear();
          savedTotalAmount=0.0;
          for(int i=0;i<result.length;i++) {
            billEntryList.add(BillEntry(
                i+1,
                result[i]['ItemId'].toString(),
                result[i]['Item'].toString(),
                result[i]['Uomid'].toString(),
                result[i]['Hsn'].toString(),
                result[i]['StockQty'].toString() != "null" ? double.parse(
                    result[i]['StockQty'].toString()) : 0.0,
                result[i]['Quantity'].toString() != "null" ? double.parse(
                    result[i]['Quantity'].toString()) : 0.0,
                result[i]['Rate'].toString() != "null" ? double.parse(
                    result[i]['Rate'].toString()) : 0.0,
                result[i]['Amount'].toString() != "null" ? double.parse(
                    result[i]['Amount'].toString()) : 0.0,
                result[i]['Discp'].toString() != "null" ? double.parse(
                    result[i]['Discp'].toString()) : 0.0,
                result[i]['DiscAmt'].toString() != "null" ? double.parse(
                    result[i]['DiscAmt'].toString()) : 0.0,
                result[i]['GSTA'].toString() != "null" ? double.parse(
                    result[i]['GSTA'].toString()) : 0.0,
                result[i]['TotAmt'].toString() != "null" ? double.parse(
                    result[i]['TotAmt'].toString()) : 0.0,
                result[i]['Amount'].toString() != "null" ? double.parse(
                    result[i]['Amount'].toString()) : 0.0,
                result[i]['AssAmt'].toString() != "null" ? double.parse(
                    result[i]['AssAmt'].toString()) : 0.0,
                result[i]['CGSTP'].toString() != "null" ? double.parse(
                    result[i]['CGSTP'].toString()) : 0.0,
                result[i]['CGSTA'].toString() != "null" ? double.parse(
                    result[i]['CGSTA'].toString()) : 0.0,
                result[i]['SGSTP'].toString() != "null" ? double.parse(
                    result[i]['SGSTP'].toString()) : 0.0,
                result[i]['SGSTA'].toString() != "null" ? double.parse(
                    result[i]['SGSTA'].toString()) : 0.0,
                result[i]['IGSTP'].toString() != "null" ? double.parse(
                    result[i]['IGSTP'].toString()) : 0.0,
                result[i]['IGSTA'].toString() != "null" ? double.parse(
                    result[i]['IGSTA'].toString()) : 0.0,
                result[i]['Discp'].toString() != "null" ? double.parse(
                    result[i]['Discp'].toString()) : 0.0,
                result[i]['City'].toString()));
            savedTotalAmount = savedTotalAmount +double.parse(
                result[i]['TotAmt'].toString());
          }
          _employeeDataSource = EmployeeDataSource(billEntry: billEntryList);
        }catch(e){
          print("GridErr :- "+e.toString());
        }
        Navigator.pop(context);
        String tempDate;
        try {
          print(result[0]['Cons_Date']);
          DateTime consDateTime = DateTime.parse(result[0]['Cons_Date']);
          tempDate =DateFormat('yyyy-MM-dd THH:mm:ss.SSS').format(consDateTime);
          print("tempDate");
          print(tempDate);
          print(currentDate);
          date.text=tempDate.toString().split(' ')[0];
        }catch(e){
          print(e);
        }

        _incrementCounter();
      }else{
        Navigator.pop(context);
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
      Navigator.pop(context);
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
  }

  Future<void> updateBillEntryData(List masData,List detData)async {
    String cutTableApi =ipAddress+"api/updatePurchaseEntryData";
    showLoaderDialog(context);
    try {
      final response = await http.post(Uri.parse(cutTableApi),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          }, body: jsonEncode({
            "masData" : masData,
            "detData": detData
          }));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print(data);
        print(data['savChk']);
        var saveChk = data['savChk'];

        if (saveChk) {

          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return
                AlertDialog(
                  title: const Text('REASON'),
                  content: const Text("Data updated Successfully"),
                  // Content of the dialog
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        fetchSavedData(widget.data['transno']);
                        Navigator.of(context).pop(); // Close the dialog
                      },
                    ),
                  ],
                );
            },
          );


        } else {
          // Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return
                AlertDialog(
                  title: Text('REASON'),
                  content: const Text("Update Failed, Please Try Again"),
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

  Future<void> saveBillEntryData(List masData, List detData)async {
    String cutTableApi =ipAddress+"api/savePurchaseEntry";
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
        final Map<String, dynamic> data = json.decode(response.body);
        print(data);
        print(data['savChk']);
        var saveChk = data['savChk'];

        if (saveChk) {
          ENAME.clear();
          CustomerList.clear();
          CustomerIdList.clear();
          StateCodeList.clear();
          StateCodeIdList.clear();
          BillTypeList.clear();
          PayTypeList.clear();
          ItemList.clear();
          RateList.clear();
          UomList.clear();
          HsnList.clear();
          StockQtyList.clear();
          CGstList.clear();
          SGstList.clear();
          IGstList.clear();
          QtyList.clear();
          DiscList.clear();
          ItemIdList.clear();
          billType = "";
          payType = "";
          customer = "";
          stateCodeId = 0;
          customerId = 0;
          stateCode = "";
          shipTo = 0;
          item = "";
          qty = 0.0;
          discount = 0.0;
          itemRate = 0.0;
          invoiceNum = "";
          supInvNumber ="";
          narration="";
          grandTotalAmount = 0.0;
          SalesType = ["Sales", "Sales B"];
          salesTypeidx = 0;

          selected = false;
          index = -1;

          date.clear();
          supplierInDateController.clear();
          edate =  DateFormat('dd/MM/yyyy').format(now);
          sdate =  DateFormat('dd/MM/yyyy').format(now);
          narrationController.clear();

          _itemController.clear();
          _shipToController.clear();
          _customerController.clear();
          qtyTextController.clear();
          itemTextController.clear();
          discTextController.clear();
          rateTextController.clear();
          gstTextController.clear();


          currentDate = DateTime.now();

          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return
                AlertDialog(
                  title: Text('REASON'),
                  content: Text("Purchase Bill Generated Successfully"),
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

          BillTypeList.add("Non-GST Bill");
          BillTypeList.add("GST Bill");
          PayTypeList.add("Credit");
          PayTypeList.add("Cash");
          billType = BillTypeList[0];
          getInvoiceNumber("NGST",true);
          payType = PayTypeList[0];
          date.text = currentDate.toString().split(' ')[0];
          supplierInDateController.text = currentDate.toString().split(' ')[0];
          fetchSupplierData();
          fetchItemData();
          billEntryList = [];
          _employeeDataSource = EmployeeDataSource(billEntry: []);
        } else {
          // Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return
                AlertDialog(
                  title: Text('REASON'),
                  content: Text("Bill Entry Generation Failed"),
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

  Future<void> getInvoiceNumber(String payType, bool chk) async{
    String cutTableApi =ipAddress+"api/getPurchaseInvoiceNumber";
    print(cutTableApi);
    // Use addPostFrameCallback to show the dialog
    if(!chk) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          showPurchaseNoLoaderDialog(context);
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
            "compId": globalCompId,
            "payType": payType
          }));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
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
                title: Text('Connection Error'),
                content: Text("Please Reselect the Bill Type to Update Invoice"), // Content of the dialog
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
        if(!chk) {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return
                AlertDialog(
                  title: Text('Connection Error'),
                  content: Text("Please Reselect the Bill Type to Update Invoice"), // Content of the dialog
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
                  content: Text("Please Reselect the Bill Type to Update Invoice"), // Content of the dialog
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
                content: Text("Please Reselect the Bill Type to Update Invoice"), // Content of the dialog
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
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return
              AlertDialog(
                title: Text('Connection Error'),
                content: Text("Please Reselect the Bill Type to Update Invoice"), // Content of the dialog
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
    billEntryList = [];
    _employeeDataSource = EmployeeDataSource(billEntry: []);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown, DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    try {
      print(widget.data['valid']);
      approvalValue=widget.data['valid'];
    }catch(e){
      approvalValue=false;
    }
    if(!approvalValue){
      BillTypeList.add("Non-GST Bill");
      BillTypeList.add("GST Bill");
      PayTypeList.add("Credit");
      PayTypeList.add("Cash");
      billType=BillTypeList[0];
      getInvoiceNumber("NGST",false);
      payType = PayTypeList[0];
      date.text= currentDate.toString().split(' ')[0];
      supplierInDateController.text= currentDate.toString().split(' ')[0];
      fetchSupplierData();
      fetchItemData();
      _employeeDataSource = EmployeeDataSource(billEntry: []);
      // getGridData();
    }else{
      BillTypeList.add("Non-GST Bill");
      BillTypeList.add("GST Bill");
      PayTypeList.add("Credit");
      PayTypeList.add("Cash");
      billType=BillTypeList[0];
      // getInvoiceNumber("NGST",false);
      payType = PayTypeList[0];
      // date.text= currentDate.toString().split(' ')[0];
      fetchSavedData(widget.data['transno']);
      // supplierInDateController.text= currentDate.toString().split(' ')[0];
      // fetchSupplierData();
      // fetchItemData();
      _employeeDataSource = EmployeeDataSource(billEntry: []);
      // getGridData();
    }

  }

  Future<void> getGridData( bool delChk, bool apprChk) async {
    // billEntryList = [
    //   BillEntry(1, '222', 'ALMOND', 'PCS', '1234', 557.00, 10, 500.00, 5000.00, 5.00, 250.00, 450.00, 5700.00),
    //   BillEntry(2, '888', 'NUTS', 'PCS', '4678', 557.00, 10, 500.00, 5000.00, 5.00, 250.00, 450.00, 5700.00),
    // ];
    // if(item !="") {
    bool dupChk=false;
    if(selected && !delChk){
      item = _itemController.text.toString();
    }else{
      if(billEntryList.length>0) {
        for (int i = 0; i < billEntryList.length; i++) {
          if (billEntryList[i].designation == item) {
            dupChk=true;
            break;
          }
        }
      }
    }
    if(!dupChk) {
      print("item :- " + item);
      int idx = !approvalValue ? ItemList.indexOf(item):0;
      print("idx :- " + idx.toString());
      double rate = itemRate;
      String uom = "";
      String hsn = "";
      double StkQty = 0;
      int code = 0;
      double cgstp = 0.0;
      double igstp = 0.0;
      double sgstp = 0.0;
      double cgstA = 0.0;
      double sgstA = 0.0;
      double igstA = 0.0;
      int stateCodeMasId = 0;
      if (idx != -1) {
        if (itemRate == 0.0) {
          rate = !approvalValue ? RateList[idx]: billEntryList[index].rate;
        }
        uom = !approvalValue ? UomList[idx] : billEntryList[index].uom;
        hsn = !approvalValue ? HsnList[idx] : billEntryList[index].hsnCode;
        StkQty = !approvalValue ? StockQtyList[idx] : billEntryList[index].stock;
        code = !approvalValue ? ItemIdList[idx] : int.parse(billEntryList[index].name.toString());
      }
      int val = billEntryList.length + 1;
      double amount = qty * rate;
      double discAmount = ((discount / 100) * rate) * qty;
      double gstAmount;
      double totalamount = amount - discAmount;

      stateCodeId = !approvalValue ? stateCodeId: int.parse(billEntryList[index].scode.toString());
      if (billType == "Non-GST Bill") {
        gstAmount = 0.0;
      } else {
        if(!delChk){
        if (stateCodeId == 68) { //checking TN Gst
          print("State Code "+stateCodeId.toString());
          cgstp = !approvalValue ?CGstList[idx]: billEntryList[index].CgstP;
          sgstp = !approvalValue ?SGstList[idx]: billEntryList[index].SgstP;
          print("State Code "+stateCodeId.toString());
          cgstA = (cgstp / 100) * totalamount;
          sgstA = (sgstp / 100) * totalamount;
          gstAmount = cgstA + sgstA;
        } else {
          igstp = !approvalValue ?IGstList[idx]: billEntryList[index].IgstP;
          igstA = (igstp / 100) * totalamount;
          gstAmount = igstA;
        }
      }else{
      gstAmount=0.0;
    }
      }
      totalamount = totalamount + gstAmount;
      double amountWOGst = totalamount - gstAmount +
          discAmount; //amount without Gst and Disc
      double amountWDisc = totalamount - gstAmount;

      print("Total Amount");
      print(totalamount);
      if (!selected && !delChk) {
        billEntryList.add(BillEntry(
            val,
            code.toString(),
            item,
            uom,
            hsn,
            StkQty,
            qty,
            rate,
            amount,
            discount,
            discAmount,
            gstAmount,
            totalamount,
            amountWOGst,
            amountWDisc,
            cgstp,
            cgstA,
            sgstp,
            sgstA,
            igstp,
            igstA,
            discount,
        "0"));
      }
      else if (delChk) {
        billEntryList.removeAt(index);
        if (billEntryList.length > 0) {
          for (int i = 0; i < billEntryList.length; i++) {
            billEntryList[i].id = i + 1;
          }
        }
        selected = false;
      }
      else {
        print("Edit Check Point Working");
        print(index);

        for (int i = 0; i < billEntryList.length; i++) {
          if (index == i) {
            billEntryList[i].name = code.toString();
            billEntryList[i].designation = item;
            billEntryList[i].uom = uom;
            billEntryList[i].hsnCode = hsn;
            billEntryList[i].stock = StkQty;
            billEntryList[i].quantity = qty;
            billEntryList[i].rate = rate;
            billEntryList[i].disc = discount;
            billEntryList[i].amount = amount;
            billEntryList[i].discAmt = discAmount;
            billEntryList[i].GSTAmt = gstAmount;
            billEntryList[i].TotAmt = totalamount;
            billEntryList[i].AmtWOGst = amountWOGst;
            billEntryList[i].AmtWDisc = amountWDisc;
            billEntryList[i].CgstP = cgstp;
            billEntryList[i].CgstA = cgstA;
            billEntryList[i].SgstP = sgstp;
            billEntryList[i].SgstA = sgstA;
            billEntryList[i].IgstP = igstp;
            billEntryList[i].IgstA = igstA;
            billEntryList[i].discP = discount;
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
      savedTotalAmount = 0.0;
      if (billEntryList.length > 0) {
        for (int i = 0; i < billEntryList.length; i++) {
          grandTotalAmount = billEntryList[i].TotAmt + grandTotalAmount;
          savedTotalAmount = billEntryList[i].TotAmt + savedTotalAmount;
          print(billEntryList[i].name + " ," +
              billEntryList[i].designation + " ," +
              billEntryList[i].uom + " ," +
              billEntryList[i].hsnCode + " ," +
              billEntryList[i].stock.toString() + " ," +
              billEntryList[i].quantity.toString() + " ," +
              billEntryList[i].rate.toString() + " ," +
              billEntryList[i].disc.toString() + " ," +
              billEntryList[i].amount.toString() + " ," +
              billEntryList[i].discAmt.toString() + " ," +
              billEntryList[i].GSTAmt.toString() + " ," +
              billEntryList[i].TotAmt.toString() + " ," +
              billEntryList[i].AmtWOGst.toString() + " ," +
              billEntryList[i].AmtWDisc.toString() + " ," +
              billEntryList[i].CgstP.toString() + " ," +
              billEntryList[i].CgstA.toString() + " ," +
              billEntryList[i].SgstP.toString() + " ," +
              billEntryList[i].SgstA.toString() + " ," +
              billEntryList[i].IgstP.toString() + " ," +
              billEntryList[i].IgstA.toString() + " ," +
              billEntryList[i].discP.toString() + " ,");
        }
      }
      print("grandTotalAmount");
      print(grandTotalAmount);
      setState(() {
        _employeeDataSource = EmployeeDataSource(billEntry: billEntryList);
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
  // }

  void _incrementCounter() {
    setState(() {
    });
  }

  @override
  void dispose(){
    super.dispose();
  }

  setSelectedData(){
    DataGridRow? data= _dataGridController.selectedRow;
    print(data);
    // print(data);
    //
    // print(data?.getCells()[2].value);
    // print(data?.getCells()[6].value);
    // print(data?.getCells()[9].value);
    // setState(() {
    //   qty=data?.getCells()[6].value;
    //   _itemController..text=data?.getCells()[2].value;
    //   discount=data?.getCells()[9].value;
    // });
  }




  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    double gridHeight=0.0;
    double initialHeight=104.47;
    double initialHeightPercent = initialHeight/height;
    double rowHeight=49.02;
    double rowHeightPercent = rowHeight/height;
    double headerHeight= 55.45;
    double headerHeightPercent= headerHeight/height;
    double gridHeightPercent= headerHeightPercent+(billEntryList.length * rowHeightPercent);
    if(gridHeightPercent>0.50){
      gridHeight= height*0.5;
    }else{
      double length= billEntryList.length==0?initialHeightPercent:gridHeightPercent;
      gridHeight= height*length;
    }

    return WillPopScope(child: Scaffold(
        appBar: CustomAppBar(userName: globalUserName,
            emailId: globalEmailId, onMenuPressed: (){
              Scaffold.of(context).openDrawer();
            },
            barTitle: "PURCHASE ENTRY"),
        drawer: customDrawer(stkTransferCheck: false, brhTransferCheck: false), body:  Container(
      color: Colors.pink[50],
      child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child:
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(25, 25, 25, 0),
                        child:
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children:[
                              DropdownButtonFormField2<String>(
                                isExpanded: true,
                                value: billType,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: "Bill Type",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  // Add more decoration..
                                ),
                                hint: const Text(
                                  'Select your bill type',
                                  style: TextStyle(fontSize: 14),
                                ),
                                items: BillTypeList
                                    .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                ))
                                    .toList(),
                                validator: (value) {
                                  if (value == null) {
                                    return 'Please bill type.';
                                  }
                                  return null;
                                },
                                onChanged: !approvalValue ?
                                    (value) {
                                  if(billType.toString() == value.toString()){
                                    return;
                                  }
                                  billType = value!;
                                  print("Check Point Working 2");
                                  if(value.toString()=="Non-GST Bill"){
                                    getInvoiceNumber("NGST",false);
                                    setState(() {
                                      billEntryList=[];
                                      _employeeDataSource = EmployeeDataSource(billEntry: billEntryList);
                                    });
                                  }else{
                                    print("Check Point Working");
                                    getInvoiceNumber("GST",false);
                                    setState(() {
                                      billEntryList=[];
                                      _employeeDataSource = EmployeeDataSource(billEntry: billEntryList);
                                    });
                                  }
                                  //Do something when selected item is changed.
                                } : null,
                                onSaved: (value) {
                                  // selectedValue = value.toString();

                                },
                                buttonStyleData: const ButtonStyleData(
                                  // padding: EdgeInsets.only(right: 8),
                                ),
                                iconStyleData: const IconStyleData(
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.black45,
                                  ),
                                  iconSize: 24,
                                ),
                                dropdownStyleData: DropdownStyleData(
                                  decoration: BoxDecoration(
                                    // borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                menuItemStyleData: const MenuItemStyleData(
                                  //  padding: EdgeInsets.symmetric(horizontal: 16),
                                ),
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
                                  child:
                                  TextFormField(
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
                                  child:
                                  TextField(
                                    controller: date,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      labelText: 'To Date',
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.red), // Change the border color here
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      suffixIcon: IconButton(
                                        icon: Icon(Icons.calendar_today),
                                        onPressed:
                                        !approvalValue ?
                                            () async {
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
                                              print("edate");
                                              print(edate);
                                            });
                                          }
                                        } : null,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]
                      ),

                      const Padding(padding:EdgeInsets.all(5)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(onLongPress: () {
                            setState(() {
                              // if(salesTypeidx == 0){
                              //   salesTypeidx=1;
                              // }else{
                              //   salesTypeidx=0;
                              // }
                            });
                          },
                            child: Text(SalesType[salesTypeidx] ),
                          ),
                        ],
                      ),
                      //const Padding(padding:EdgeInsets.all(5)),
                      !approvalValue ?
                      Padding(
                        padding: EdgeInsets.fromLTRB(25, 0, 25, 5),
                        child:
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children:[
                              Autocomplete<String>(
                                optionsBuilder: (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text.isEmpty) {
                                    return const Iterable<String>.empty();
                                  } else {
                                    return CustomerList.where((String item) {
                                      return item.toLowerCase().contains(textEditingValue.text.toLowerCase());
                                    });
                                  }
                                },
                                fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                                  _customerController=controller;
                                  return
                                    TextField(
                                      controller: controller,
                                      focusNode: focusNode,
                                      // textAlign: TextAlign.center,
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
                                        if(CustomerList.indexOf(value)==-1){
                                          controller..text="";
                                        }else{
                                          setState(() {
                                            customer = value!;
                                            int idx = CustomerList.indexOf(customer);
                                            stateCode=StateCodeList[idx];
                                            stateCodeId = StateCodeIdList[idx];
                                            customerId = CustomerIdList[idx];
                                            // shipTo = customer;
                                            shipTo = CustomerIdList[idx];
                                            _shipToController.text=customer;
                                          });
                                        }
                                      },
                                      decoration: InputDecoration(
                                          fillColor: salesTypeidx==0? Colors.white :Colors.greenAccent[100],
                                          filled: true,
                                          labelText: "customer",
                                          hintText: 'Search for a customer',
                                          border: OutlineInputBorder(),
                                          // contentPadding: EdgeInsets.symmetric(
                                          //     vertical: height*0.015),
                                          isDense: true
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
                                              customer = option!;
                                              int idx = CustomerList.indexOf(customer);
                                              stateCode=StateCodeList[idx];
                                              stateCodeId = StateCodeIdList[idx];
                                              customerId = CustomerIdList[idx];
                                              // shipTo = customer;
                                              shipTo = CustomerIdList[idx];
                                              _shipToController.text=customer;
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
                      ) :
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
                                    // textAlign: TextAlign.center,
                                    controller: TextEditingController()..text= customerName.toString(),
                                    decoration: InputDecoration(border: OutlineInputBorder(),labelText: 'Customer',
                                      fillColor: Colors.white, filled: true,
                                      // contentPadding: EdgeInsets.symmetric(vertical: height*0.01),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]
                      ),
                      // const Padding(padding:EdgeInsets.all(5)),
                      // BootstrapContainer(
                      //     fluid: true,
                      //     children:[
                      //       BootstrapRow(
                      //         children: <BootstrapCol>[
                      //           BootstrapCol(
                      //             sizes: 'col-md-12',
                      //             child: TextFormField(
                      //               // showCursor: false,
                      //               // readOnly: true,
                      //               //controller: TextEditingController()..text= OcnnoVal,
                      //               decoration: InputDecoration(border: OutlineInputBorder(),labelText: 'TRANSPORT',
                      //                   fillColor: Colors.pink[50], filled: true ,
                      //               labelStyle: TextStyle(color: Colors.black)),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ]
                      // ),
                      // const Padding(padding:EdgeInsets.all(5)),
                      // BootstrapContainer(
                      //     fluid: true,
                      //     children:[
                      //       BootstrapRow(
                      //         children: <BootstrapCol>[
                      //           BootstrapCol(
                      //             sizes: 'col-md-6',
                      //             child: TextFormField(
                      //               // showCursor: false,
                      //               // readOnly: true,
                      //               //controller:  TextEditingController()..text= ACTDIA.toString(),
                      //               decoration: InputDecoration(border: OutlineInputBorder(),labelText: 'Bundles ',
                      //                   fillColor: Colors.pink[50],filled: true),
                      //             ),
                      //           ),
                      //           BootstrapCol(
                      //             sizes: 'col-md-6',
                      //             child: TextFormField(
                      //               // showCursor: false,
                      //               // readOnly: true,
                      //              // controller:  TextEditingController()..text= ACTGSM.toString(),
                      //               decoration: InputDecoration(border: OutlineInputBorder(),labelText: 'Vehicle No',
                      //                   fillColor: Colors.pink[50], filled: true),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ]
                      // ),
                      // const Padding(padding:EdgeInsets.all(5)),
                      // BootstrapContainer(
                      //     fluid: true,
                      //     children:[
                      //       BootstrapRow(
                      //         children: <BootstrapCol>[
                      //           BootstrapCol(
                      //             sizes: 'col-md-6',
                      //             child: TextFormField(
                      //               // showCursor: false,
                      //               // readOnly: true,
                      //               //controller:  TextEditingController()..text= ACTDIA.toString(),
                      //               decoration: InputDecoration(border: OutlineInputBorder(),labelText: 'PO Number ',
                      //                   fillColor: Colors.pink[50],filled: true),
                      //             ),
                      //           ),
                      //           BootstrapCol(
                      //             sizes: 'col-md-6',
                      //             child: TextFormField(
                      //               // showCursor: false,
                      //               // readOnly: true,
                      //               // controller:  TextEditingController()..text= ACTGSM.toString(),
                      //               decoration: InputDecoration(border: OutlineInputBorder(),labelText: '',
                      //                   fillColor: Colors.pink[50], filled: true),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ]
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.fromLTRB(25, 25, 25, 0),
                      //   child:
                      //   Column(
                      //       crossAxisAlignment: CrossAxisAlignment.stretch,
                      //       children:[
                      //         DropdownButtonFormField2<String>(
                      //           isExpanded: true,
                      //           value: payType,
                      //           decoration: InputDecoration(
                      //             //alignLabelWithHint: true,
                      //             fillColor: Colors.white,
                      //             filled: true,
                      //             labelText: "Pay Type",
                      //             border: OutlineInputBorder(
                      //             ),
                      //             // Add more decoration..
                      //           ),
                      //           hint: const Text(
                      //             'Select your pay type',
                      //             style: TextStyle(fontSize: 14),
                      //           ),
                      //           items: PayTypeList
                      //               .map((item) => DropdownMenuItem<String>(
                      //             value: item,
                      //             child: Text(
                      //               item,
                      //               style: const TextStyle(
                      //                 fontSize: 14,
                      //               ),
                      //             ),
                      //           ))
                      //               .toList(),
                      //           validator: (value) {
                      //             //print("Check Point Working 2");
                      //             if (value == null) {
                      //               return 'Please pay type.';
                      //             }
                      //             return null;
                      //           },
                      //           onChanged: !approvalValue ?
                      //               (String? value) {
                      //             setState(() {
                      //               payType = value!;
                      //             });
                      //           }:
                      //           null,
                      //           onSaved: (String? value) {
                      //             payType = value!;
                      //           },
                      //           buttonStyleData: const ButtonStyleData(
                      //             padding: EdgeInsets.only(right: 0),
                      //           ),
                      //           iconStyleData: const IconStyleData(
                      //             icon: Icon(
                      //               Icons.arrow_drop_down,
                      //               color: Colors.black45,
                      //             ),
                      //             iconSize: 24,
                      //           ),
                      //           dropdownStyleData: DropdownStyleData(
                      //             decoration: BoxDecoration(
                      //               // borderRadius: BorderRadius.circular(15),
                      //             ),
                      //           ),
                      //           menuItemStyleData: const MenuItemStyleData(
                      //             //padding: EdgeInsets.symmetric(horizontal: 16),
                      //           ),
                      //         ),
                      //
                      //       ]
                      //   ),
                      // ),

                      // const Padding(padding:EdgeInsets.all(5)),
                      // BootstrapContainer(
                      //     fluid: true,
                      //     children:[
                      //       BootstrapRow(
                      //         children: <BootstrapCol>[
                      //           BootstrapCol(
                      //             sizes: 'col-md-12',
                      //             child: TextFormField(
                      //               showCursor: false,
                      //               readOnly: true,
                      //               controller: TextEditingController()..text= stateCode,
                      //               decoration: InputDecoration(border: OutlineInputBorder(),labelText: 'State Code',
                      //                   fillColor: Colors.pink[50], filled: true),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ]
                      // ),



                      const Padding(padding:EdgeInsets.all(5)),
                      BootstrapContainer(
                          fluid: true,
                          children:[
                            !approvalValue ?
                            BootstrapRow(
                              children: <BootstrapCol>[
                                !approvalValue ?
                                BootstrapCol(
                                  sizes: 'col-md-12',
                                  child:
                                  Row(children: [
                                    Expanded(child:DropdownButtonFormField2<String>(
                                      isExpanded: true,
                                      value: payType,
                                      decoration: InputDecoration(
                                        //alignLabelWithHint: true,
                                        fillColor: Colors.white,
                                        filled: true,
                                        labelText: "Pay Type",
                                        border: OutlineInputBorder(
                                        ),
                                        // Add more decoration..
                                      ),
                                      hint: const Text(
                                        'Select your pay type',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      items: PayTypeList
                                          .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                          .toList(),
                                      validator: (value) {
                                        //print("Check Point Working 2");
                                        if (value == null) {
                                          return 'Please pay type.';
                                        }
                                        return null;
                                      },
                                      onChanged: !approvalValue ?
                                          (String? value) {
                                        setState(() {
                                          payType = value!;
                                        });
                                      }:null,
                                      onSaved: (String? value) {
                                        payType = value!;

                                      },
                                      buttonStyleData: const ButtonStyleData(
                                        padding: EdgeInsets.only(right: 0),
                                      ),
                                      iconStyleData: const IconStyleData(
                                        icon: Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.black45,
                                        ),
                                        iconSize: 24,
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                        decoration: BoxDecoration(
                                          // borderRadius: BorderRadius.circular(15),
                                        ),
                                      ),
                                      menuItemStyleData: const MenuItemStyleData(
                                        //padding: EdgeInsets.symmetric(horizontal: 16),
                                      ),
                                    ) ),
                                    SizedBox(width: 20,),
                                    Expanded(child: Autocomplete<String>(
                                      optionsBuilder: (TextEditingValue textEditingValue) {
                                        if (textEditingValue.text.isEmpty) {
                                          return const Iterable<String>.empty();
                                        } else {
                                          return CustomerList.where((String item) {
                                            return item.toLowerCase().contains(textEditingValue.text.toLowerCase());
                                          });
                                        }
                                      },
                                      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                                        _shipToController= controller;
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
                                            if(CustomerList.indexOf(value)==-1){
                                              controller..text="";
                                            }else{
                                              setState(() {
                                                int idx = CustomerList.indexOf(value.toString());
                                                shipTo = CustomerIdList[idx];
                                              });
                                            }
                                          },
                                          decoration: InputDecoration(
                                            fillColor: salesTypeidx==0? Colors.white :Colors.greenAccent[100],
                                            filled: true,
                                            labelText: "Ship To",
                                            hintText: 'Please search for a ship to [destination]',
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
                                                    int idx = CustomerList.indexOf(option.toString());
                                                    shipTo = CustomerIdList[idx];
                                                  });
                                                },
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ))],),
                                ):
                                BootstrapCol(
                                  sizes: 'col-md-12',
                                  child:
                                  Row(children: [
                                    Expanded(child:DropdownButtonFormField2<String>(
                                      isExpanded: true,
                                      value: payType,
                                      decoration: InputDecoration(
                                        //alignLabelWithHint: true,
                                        fillColor: Colors.white,
                                        filled: true,
                                        labelText: "Pay Type",
                                        border: OutlineInputBorder(
                                        ),
                                        // Add more decoration..
                                      ),
                                      hint: const Text(
                                        'Select your pay type',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      items: PayTypeList
                                          .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                          .toList(),
                                      validator: (value) {
                                        //print("Check Point Working 2");
                                        if (value == null) {
                                          return 'Please pay type.';
                                        }
                                        return null;
                                      },
                                      onChanged: !approvalValue ?
                                          (String? value) {
                                        setState(() {
                                          payType = value!;
                                        });
                                      }:null,
                                      onSaved: (String? value) {
                                        payType = value!;

                                      },
                                      buttonStyleData: const ButtonStyleData(
                                        padding: EdgeInsets.only(right: 0),
                                      ),
                                      iconStyleData: const IconStyleData(
                                        icon: Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors.black45,
                                        ),
                                        iconSize: 24,
                                      ),
                                      dropdownStyleData: DropdownStyleData(
                                        decoration: BoxDecoration(
                                          // borderRadius: BorderRadius.circular(15),
                                        ),
                                      ),
                                      menuItemStyleData: const MenuItemStyleData(
                                        //padding: EdgeInsets.symmetric(horizontal: 16),
                                      ),
                                    ) ),
                                    SizedBox(width: 20,),
                                    Expanded(child: TextFormField(
                                      showCursor: false,
                                      readOnly: true,
                                      // textAlign: TextAlign.center,
                                      controller: TextEditingController()..text= savedShipToName.toString(),
                                      decoration: const InputDecoration(border: OutlineInputBorder(),labelText: 'Ship To',
                                        fillColor: Colors.white, filled: true,
                                        // contentPadding: EdgeInsets.symmetric(vertical: height*0.01),
                                      ),
                                    ),)
                                  ],),
                                ),
                              ],
                            )
                            :BootstrapCol(
                              sizes: 'col-md-12',
                              child:Row(children: [
                                Expanded(child:DropdownButtonFormField2<String>(
                                  isExpanded: true,
                                  value: payType,
                                  decoration: InputDecoration(
                                    //alignLabelWithHint: true,
                                    fillColor: Colors.white,
                                    filled: true,
                                    labelText: "Pay Type",
                                    border: OutlineInputBorder(
                                    ),
                                    // Add more decoration..
                                  ),
                                  hint: const Text(
                                    'Select your pay type',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  items: PayTypeList
                                      .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ))
                                      .toList(),
                                  validator: (value) {
                                    //print("Check Point Working 2");
                                    if (value == null) {
                                      return 'Please pay type.';
                                    }
                                    return null;
                                  },
                                  onChanged: !approvalValue ?
                                      (String? value) {
                                    setState(() {
                                      payType = value!;
                                    });
                                  }:null,
                                  onSaved: (String? value) {
                                    payType = value!;

                                  },
                                  buttonStyleData: const ButtonStyleData(
                                    padding: EdgeInsets.only(right: 0),
                                  ),
                                  iconStyleData: const IconStyleData(
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.black45,
                                    ),
                                    iconSize: 24,
                                  ),
                                  dropdownStyleData: DropdownStyleData(
                                    decoration: BoxDecoration(
                                      // borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  menuItemStyleData: const MenuItemStyleData(
                                    //padding: EdgeInsets.symmetric(horizontal: 16),
                                  ),
                                ) ),
                                SizedBox(width: 20,),
                                Expanded(child: TextFormField(
                                  showCursor: false,
                                  readOnly: true,
                                  // textAlign: TextAlign.center,
                                  controller: TextEditingController()..text= savedShipToName.toString(),
                                  decoration: const InputDecoration(border: OutlineInputBorder(),labelText: 'Ship To',
                                    fillColor: Colors.white, filled: true,
                                    // contentPadding: EdgeInsets.symmetric(vertical: height*0.01),
                                  ),
                                ),)
                              ],),
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
                                    child:
                                    Row(children: [
                                      Expanded(child:
                                      TextField(
                                        controller: supplierInDateController,
                                        showCursor: !approvalValue?true:false,
                                        readOnly: !approvalValue?false: true,
                                        decoration: InputDecoration(
                                          labelText: 'Supplier Date',
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.red), // Change the border color here
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          suffixIcon: IconButton(
                                            icon: Icon(Icons.calendar_today),
                                            onPressed:
                                            !approvalValue ?
                                                () async {
                                              DateTime? pickedDate = await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2000),
                                                lastDate: DateTime(2101),
                                              );
                                              if (pickedDate != null) {
                                                setState(() {
                                                  supplierInDateController.text = pickedDate.toString().split(' ')[0];
                                                  sdate = pickedDate.toString().split(' ')[0];
                                                  print("sdate");
                                                  print(sdate);
                                                });
                                              }
                                            }: null,
                                          ),
                                        ),
                                      )),
                                      SizedBox(width: 20,),
                                      Expanded(child:TextFormField(
                                        showCursor: !approvalValue?true:false,
                                        readOnly: !approvalValue?false: true,
                                        onChanged: (String newValue){
                                          supInvNumber= newValue.toString();
                                        },
                                        controller: TextEditingController()..text= supInvNumber.toString(),
                                        decoration: InputDecoration(border: OutlineInputBorder(),labelText: 'Supplier Inv No',
                                            fillColor: Colors.white, filled: true),
                                      ), )

                                    ],)
                                ),
                              ],
                            ),
                          ]
                      ),

                      Padding(
                        padding: EdgeInsets.fromLTRB( !approvalValue ?25:0, 30,
                            !approvalValue ?25:0, 5),
                        child:
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children:[
                               Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(!approvalValue ? "ADD ITEM": "UPDATE ITEM"),
                                ],
                              ),
                              !approvalValue ?
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
                                      });
                                    },
                                    onSubmitted: (value) {
                                      // if(ItemList.indexOf(value)==-1){
                                      //   controller..text="";
                                      // }else{
                                      setState(() {
                                        item = value!;
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
                                                  print("Rate : "+ itemRate.toString());
                                                  rateTextController.text=itemRate.toString();
                                                  if(billType=="GST Bill") {
                                                    int gstIdx = ItemList
                                                        .indexOf(item);
                                                    if (stateCodeId == 68) {
                                                      double Gst = CGstList[gstIdx] +
                                                          SGstList[gstIdx];
                                                      gstTextController
                                                          .text =
                                                          Gst.toString();
                                                    } else {
                                                      gstTextController
                                                          .text =
                                                          IGstList[gstIdx]
                                                              .toString();
                                                    }
                                                  }else{
                                                    gstTextController
                                                        .text ="0.0";
                                                  }
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
                              )
                              :BootstrapContainer(
                                  fluid: true,
                                  children:[
                                    BootstrapRow(
                                      children: <BootstrapCol>[
                                        BootstrapCol(
                                          sizes: 'col-md-12',
                                          child: TextFormField(
                                            // showCursor: false,
                                            readOnly: true,
                                            keyboardType: TextInputType.name,
                                            onChanged:(String newValue){
                                            },
                                            controller: _itemController,
                                            decoration: const InputDecoration(border: OutlineInputBorder(),
                                                labelText: 'Item',
                                                fillColor: Colors.white, filled: true),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]
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
                                  child:
                                  Row(children: [
                                    Expanded(child: TextFormField(
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
                                    ))
                                    ,SizedBox(width: 20,),
                                    Expanded(child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      showCursor: false,
                                      readOnly: true,
                                      // onChanged: (String newValue){
                                      //   itemRate = double.parse(newValue);
                                      // },
                                      controller: gstTextController,
                                      decoration: InputDecoration(border: OutlineInputBorder(),labelText: 'Gst',
                                          fillColor: Colors.white, filled: true),
                                    )),],),
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
                                      discount = double.parse(newValue);
                                    },
                                    controller: discTextController,
                                    decoration: InputDecoration(border: OutlineInputBorder(),labelText: 'Disc',
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
                                  !approvalValue? getGridData(false, false):getGridData(false, true) ;
                                  _itemController.clear();
                                  qtyTextController.clear();
                                  discTextController.clear();
                                  rateTextController.clear();
                                  gstTextController.clear();
                                  item = "";
                                  qty = 0.0;
                                  discount = 0.0;
                                  itemRate = 0.0;
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
                            !approvalValue ? SizedBox(width: 10): SizedBox(height: 0.01,),
                            !approvalValue ? ElevatedButton(
                              onPressed: () {
                                getGridData(true, false);
                                _itemController.clear();
                                qtyTextController.clear();
                                discTextController.clear();
                                rateTextController.clear();
                                gstTextController.clear();
                                item="";
                                qty=0.0;
                                discount=0.0;
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
                            ) : SizedBox(height: 0.01,),
                          ],)
                      ),

                      Padding(padding: EdgeInsets.fromLTRB(0, 30, 0, 0)),
                      Container(
                        height: gridHeight,
                        child: SfDataGridTheme(
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
                                columnName: 'name',
                                width: 75,
                                visible: false,
                                label: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: Text('Code', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'designation',
                                width: 250,
                                label: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: Text('Particular', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'uom',
                                width: 75,
                                label: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: Text('Uom', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'hsnCode',
                                width: 100,
                                visible: false,
                                label: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: Text('HsnCode', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'stock',
                                width: 100,
                                label: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: Text('Stock', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                ),
                              ),
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
                              GridColumn(
                                columnName: 'disc',
                                visible: false,
                                width: 100,
                                label: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: Text('Disc', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'discAmt',
                                width: 100,
                                label: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: Text('DiscAmt', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'GSTAmt',
                                width: 100,
                                label: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: Text('GSTAmt', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'TotAmt',
                                width: 100,
                                label: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: Text('TotAmt', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
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
                                discTextController.text=data!.getCells()[9].value.toString();
                                rateTextController.text=data!.getCells()[7].value.toString();
                                if(billType=="GST Bill") {
                                  int gstIdx= billEntryList.indexWhere((entry){
                                    return entry.designation==data?.getCells()[2].value.toString();
                                  });
                                  if(gstIdx!=-1){
                                    if(int.parse(billEntryList[gstIdx].scode) == 68 ){
                                      double gst= billEntryList[gstIdx].CgstP+  billEntryList[gstIdx].SgstP;
                                      gstTextController.text=gst.toString();
                                    }else{
                                      gstTextController.text= billEntryList[gstIdx].IgstP.toString();
                                    }
                                  }
                                }else{
                                  gstTextController.text="0.0";
                                }
                                discount=data?.getCells()[9].value;
                                itemRate = data?.getCells()[7].value;
                              });
                            },
                            columnWidthMode: ColumnWidthMode.fill,
                          ),
                        ),
                      ),),
                      const Padding(padding:EdgeInsets.all(5)),
                      BootstrapContainer(
                          fluid: true,
                          children:[
                            BootstrapRow(
                              children: <BootstrapCol>[
                                BootstrapCol(
                                  sizes: 'col-md-12',
                                  child: TextFormField(
                                    readOnly: !approvalValue?false:true,
                                    controller: narrationController,
                                    onChanged: (String newvalue){
                                      setState(() {
                                        if(newvalue != "") {
                                          narration = newvalue.toString();
                                        }
                                      });
                                    },
                                    decoration: InputDecoration(border: OutlineInputBorder(),labelText: 'Narration',
                                        fillColor: Colors.white, filled: true),
                                  ),
                                ),
                              ],
                            ),
                          ]
                      ),
                      const Padding(padding:EdgeInsets.all(10)),
                      Center(child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 20,),Text("Total Amount : - ${!approvalValue?grandTotalAmount:savedTotalAmount}"),
                          SizedBox(width: 20,),
                          ElevatedButton(
                            onPressed: () {
                              if(!approvalValue){
                                if(billEntryList.length>0 && shipTo !=0){
                                  List<dynamic> detList=[];
                                  double totalAmount=0.0;
                                  double totalQty=0.0;
                                  double totalAmountWOGst=0.0;
                                  double vatAmt=0.0;
                                  double discAmt=0.0;
                                  double cGst=0.0;
                                  double sGst=0.0;
                                  double iGst=0.0;
                                  double Gst=0.0;
                                  for(int i=0;i<billEntryList.length;i++){
                                    detList.add({
                                      "id": billEntryList[i].id,
                                      "itemId": billEntryList[i].name,
                                      "item": billEntryList[i].designation,
                                      "uom": billEntryList[i].uom,
                                      "hsnCode": billEntryList[i].hsnCode,
                                      "stock": billEntryList[i].stock,
                                      "quantity" : billEntryList[i].quantity,
                                      "rate" : billEntryList[i].rate,
                                      "amount" : billEntryList[i].amount,
                                      "disc" : billEntryList[i].disc,
                                      "discAmt" : billEntryList[i].discAmt,
                                      "GSTAmt" : billEntryList[i].GSTAmt,
                                      "TotAmt" : billEntryList[i].TotAmt,
                                      "AmtWOGst" : billEntryList[i].AmtWOGst,
                                      "AmtWDisc" : billEntryList[i].AmtWDisc,
                                      "CgstP" : billEntryList[i].CgstP,
                                      "CgstA" : billEntryList[i].CgstA,
                                      "SgstP" : billEntryList[i].SgstP,
                                      "SgstA" : billEntryList[i].SgstA,
                                      "IgstP" : billEntryList[i].IgstP,
                                      "IgstA" : billEntryList[i].IgstA,
                                      "discP" : billEntryList[i].discP,
                                    });
                                    totalAmount = totalAmount + billEntryList[i].TotAmt;
                                    totalQty = totalQty + billEntryList[i].quantity;
                                    totalAmountWOGst=totalAmountWOGst + billEntryList[i].AmtWOGst;
                                    vatAmt = vatAmt + billEntryList[i].GSTAmt;
                                    discAmt = discAmt + billEntryList[i].discAmt;
                                    cGst= cGst+billEntryList[i].CgstA;
                                    sGst = sGst + billEntryList[i].SgstA;
                                    iGst = iGst +billEntryList[i].IgstA;
                                  }
                                  double roundAmt = vatAmt.toInt()-vatAmt;
                                  roundAmt = double.parse(roundAmt.toStringAsFixed(2));
                                  Gst=cGst+sGst+iGst;
                                  List<dynamic> masList=[];
                                  masList.add({
                                    "InvoiceNo" : invoiceNum,
                                    "Narration" : narration,
                                    "SupplierId" : customerId,
                                    "Person" : customer,
                                    "NetAmount" : totalAmount,
                                    "TotQty" : totalQty,
                                    "TotAmountWOGst": totalAmountWOGst,
                                    "PayType" : payType=="Cash"? "C":"D",
                                    "CompId" : globalCompId,
                                    "VatAmt" : vatAmt,
                                    "RoundAmt" : roundAmt<0.50 && roundAmt!=0.0? -(roundAmt):roundAmt,
                                    "discAmt" : discAmt,
                                    "isVat" : vatAmt ==0.0? "N":"Y",
                                    "Cgst" : cGst,
                                    "Sgst" : sGst,
                                    "Igst" : iGst,
                                    "Gst" : Gst,
                                    "ShipTo" : shipTo,
                                    "dat" : edate,
                                    "sdate" : sdate,
                                    "supInvNo" :supInvNumber
                                  });
                                  print("jsonObject");
                                  print(masList.length);
                                  print(masList);

                                  saveBillEntryData(masList,detList);
                                }
                                else{
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return
                                        AlertDialog(
                                          title: Text('ALERT'),
                                          content: shipTo==0?Text("Please select/Reselect the shipTo"):Text("Please Save The Item, Before Generating The Purchase Bill"), // Content of the dialog
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
                              }else{
                                if(billEntryList.length>0 ){
                                  List<dynamic> detList=[];
                                  double totalAmount=0.0;
                                  double totalQty=0.0;
                                  double totalAmountWOGst=0.0;
                                  double vatAmt=0.0;
                                  double discAmt=0.0;
                                  double cGst=0.0;
                                  double sGst=0.0;
                                  double iGst=0.0;
                                  double Gst=0.0;
                                  for(int i=0;i<billEntryList.length;i++){
                                    detList.add({
                                      "id": billEntryList[i].id,
                                      "itemId": billEntryList[i].name,
                                      "item": billEntryList[i].designation,
                                      "uom": billEntryList[i].uom,
                                      "hsnCode": billEntryList[i].hsnCode,
                                      "stock": billEntryList[i].stock,
                                      "quantity" : billEntryList[i].quantity,
                                      "rate" : billEntryList[i].rate,
                                      "amount" : billEntryList[i].amount,
                                      "disc" : billEntryList[i].disc,
                                      "discAmt" : billEntryList[i].discAmt,
                                      "GSTAmt" : billEntryList[i].GSTAmt,
                                      "TotAmt" : billEntryList[i].TotAmt,
                                      "AmtWOGst" : billEntryList[i].AmtWOGst,
                                      "AmtWDisc" : billEntryList[i].AmtWDisc,
                                      "CgstP" : billEntryList[i].CgstP,
                                      "CgstA" : billEntryList[i].CgstA,
                                      "SgstP" : billEntryList[i].SgstP,
                                      "SgstA" : billEntryList[i].SgstA,
                                      "IgstP" : billEntryList[i].IgstP,
                                      "IgstA" : billEntryList[i].IgstA,
                                      "discP" : billEntryList[i].discP,
                                    });
                                    totalAmount = totalAmount + billEntryList[i].TotAmt;
                                    totalQty = totalQty + billEntryList[i].quantity;
                                    totalAmountWOGst=totalAmountWOGst + billEntryList[i].AmtWOGst;
                                    vatAmt = vatAmt + billEntryList[i].GSTAmt;
                                    discAmt = discAmt + billEntryList[i].discAmt;
                                    cGst= cGst+billEntryList[i].CgstA;
                                    sGst = sGst + billEntryList[i].SgstA;
                                    iGst = iGst +billEntryList[i].IgstA;
                                  }
                                  double roundAmt = vatAmt.toInt()-vatAmt;
                                  roundAmt = double.parse(roundAmt.toStringAsFixed(2));
                                  Gst=cGst+sGst+iGst;
                                  List<dynamic> masList=[];
                                  masList.add({
                                    "InvoiceNo" : invoiceNum,
                                    "NetAmount" : totalAmount,
                                    "TotQty" : totalQty,
                                    "TotAmountWOGst": totalAmountWOGst,
                                    "CompId" : globalCompId,
                                    "VatAmt" : vatAmt,
                                    "RoundAmt" : roundAmt<0.50 && roundAmt!=0.0? -(roundAmt):roundAmt,
                                    "discAmt" : discAmt,
                                    "Cgst" : cGst,
                                    "Sgst" : sGst,
                                    "Igst" : iGst,
                                    "Gst" : Gst,
                                    "dat" : edate,
                                  });
                                  print("jsonObject");
                                  print(masList.length);
                                  print(masList);

                                  updateBillEntryData(masList,detList);
                                }
                                else{
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return
                                        AlertDialog(
                                          title: Text('ALERT'),
                                          content: const Text("No Valid Item To Update"), // Content of the dialog
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
                              }

                            },
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Color(0xFF004D40),
                                textStyle: TextStyle(color: Colors.black,
                                    fontWeight: FontWeight.bold)
                            ),
                            child: Text(!approvalValue?'Save': 'Update', style: TextStyle(
                                color: Colors.white
                            ),),
                          ),],)
                      )
                    ]
                ),
              ),

            )
          ]
      ),
    )), onWillPop: () async{
      billEntryList = [];
      _employeeDataSource = EmployeeDataSource(billEntry: []);
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/Home',
            (Route<dynamic> route) => false, // This will remove all previous routes
      );
      return true;
    });
  }
}

class BillEntry {
  BillEntry(
      this.id,
      this.name,
      this.designation,
      this.uom,
      this.hsnCode,
      this.stock,
      this.quantity,
      this.rate,
      this.amount,
      this.disc,
      this.discAmt,
      this.GSTAmt,
      this.TotAmt,
      this.AmtWOGst,
      this.AmtWDisc,
      this.CgstP,
      this.CgstA,
      this.SgstP,
      this.SgstA,
      this.IgstP,
      this.IgstA,
      this.discP,
      this.scode
      );

  int id;
  String name;
  String designation;
  String uom;
  String hsnCode;
  double stock;
  double quantity;
  double rate;
  double amount;
  double disc;
  double discAmt;
  double GSTAmt;
  double TotAmt;
  double AmtWOGst;
  double AmtWDisc;
  double CgstP;
  double CgstA;
  double SgstP;
  double SgstA;
  double IgstP;
  double IgstA;
  double discP;
  String scode;
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List<BillEntry> billEntry}) {
    _billEntry = billEntry.map<DataGridRow>((dataGridRow) => DataGridRow(
      cells: [
        DataGridCell<int>(columnName: 'id', value: dataGridRow.id),
        DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
        DataGridCell<String>(columnName: 'designation', value: dataGridRow.designation),
        DataGridCell<String>(columnName: 'uom', value: dataGridRow.uom),
        DataGridCell<String>(columnName: 'hsnCode', value: dataGridRow.hsnCode),
        DataGridCell<double>(columnName: 'stock', value: dataGridRow.stock),
        DataGridCell<double>(columnName: 'quantity', value: dataGridRow.quantity),
        DataGridCell<double>(columnName: 'rate', value: dataGridRow.rate),
        DataGridCell<double>(columnName: 'amount', value: dataGridRow.amount),
        DataGridCell<double>(columnName: 'disc', value: dataGridRow.disc),
        DataGridCell<double>(columnName: 'discAmt', value: dataGridRow.discAmt),
        DataGridCell<double>(columnName: 'GSTAmt', value: dataGridRow.GSTAmt),
        DataGridCell<double>(columnName: 'TotAmt', value: dataGridRow.TotAmt),
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
      billEntryList[dataRowIndex].quantity=double.parse(newCellValue.toString());
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


