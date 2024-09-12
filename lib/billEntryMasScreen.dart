import 'dart:convert';
import 'package:billentry/GlobalVariables.dart';
import 'package:billentry/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:collection/collection.dart';

import 'package:syncfusion_flutter_core/theme.dart';


import 'package:dropdown_button2/dropdown_button2.dart';


List<BillEntry> billEntryList=[];
class BillEntryMasScreen extends StatefulWidget {
  const BillEntryMasScreen({super.key} );


  @override
  State<BillEntryMasScreen> createState() => _billEntryMasState();
}

class _billEntryMasState extends State<BillEntryMasScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: billEntryFirstScreen(),
    );
  }
}

class billEntryFirstScreen extends StatefulWidget {
  const billEntryFirstScreen({Key? key}) : super(key: key);

  @override
  _billEntryFirstState createState() => _billEntryFirstState();
}

class _billEntryFirstState extends State<billEntryFirstScreen> {
  List<String> ENAME =[];
  List<String> CustomerList =[];
  List<String> StateCodeList=[];
  List<String> BillTypeList=[];
  List<String> PayTypeList=[];
  List<String> ItemList=[];
  List<double> RateList=[];
  List<String> UomList=[];
  List<String> HsnList=[];
  List<double> StockQtyList=[];
  List<double> CGstList=[];
  List<double>  QtyList=[];
  List<double> DiscList=[];
  List<int> ItemIdList =[];
  String billType="";
  String payType="";
  String customer="";
  String stateCode="";
  String shipTo="";
  String item="";
  double qty=0.0;
  double discount=0.0;
  String invoiceNum="";
  double grandTotalAmount=0.0;

  var selected = false;
  var index  =-1;

  TextEditingController date = new TextEditingController();
  TextEditingController _itemController = new TextEditingController();
  TextEditingController qtyTextController = new TextEditingController();
  TextEditingController itemTextController = new TextEditingController();
  TextEditingController discTextController = new TextEditingController();
  final DataGridController _dataGridController = DataGridController();


  DateTime currentDate = DateTime.now();


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
        List<dynamic> result1 = data['result'][0];
        //print(result1);

        for (var list in result1){
          CustomerList.add(list['Supplier'].toString());
          StateCodeList.add(list['City'].toString());
        }

        print(CustomerList);
        print(StateCodeList);
        customer=CustomerList[0];
        stateCode=StateCodeList[0];
        shipTo=CustomerList[0];


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
          CGstList.add(double.parse(list['GstP'].toString()));
          StockQtyList.add(list['StockQty'].toString() !="null" ? double.parse(list['StockQty'].toString()) : 0 );
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

  Future<void> getInvoiceNumber(String payType) async{
    String cutTableApi =ipAddress+"api/getInvoiceNumber";
    print(cutTableApi);
    final response=await http.post(Uri.parse(cutTableApi),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        }, body: jsonEncode({
          "compId": globalCompId,
          "payType": payType
        }));
    if (response.statusCode == 200) {
      final Map<String,dynamic> data =  json.decode(response.body);
      setState(() {
        invoiceNum=data['result'];
      });
      _incrementCounter();
    }
  }

  late EmployeeDataSource _employeeDataSource;
  @override
  void initState() {
    super.initState();
    BillTypeList.add("Non-GST Bill");
    BillTypeList.add("GST Bill");
    PayTypeList.add("Credit");
    PayTypeList.add("Cash");
    billType=BillTypeList[0];
    getInvoiceNumber("NGST");
    payType = PayTypeList[0];
    date.text= currentDate.toString().split(' ')[0];
    fetchSupplierData();
    fetchItemData();
    _employeeDataSource = EmployeeDataSource(billEntry: []);
    // getGridData();
  }

  Future<void> getGridData( bool delChk) async {
    // billEntryList = [
    //   BillEntry(1, '222', 'ALMOND', 'PCS', '1234', 557.00, 10, 500.00, 5000.00, 5.00, 250.00, 450.00, 5700.00),
    //   BillEntry(2, '888', 'NUTS', 'PCS', '4678', 557.00, 10, 500.00, 5000.00, 5.00, 250.00, 450.00, 5700.00),
    // ];
    // if(item !="") {
      int idx = ItemList.indexOf(item);
      print("idx :- "+ idx.toString());
      double rate =0;
      String uom ="";
      String hsn="";
      double StkQty=0;
      int code=0;
      double gst=0.0;
      if(idx != -1){
        print("Check 0");
        rate = RateList[idx];
        print("Check 1");
        uom = UomList[idx];
        print("Check 2");
        hsn = HsnList[idx];
        print("Check 3");
        StkQty= StockQtyList[idx];
        print("Check 4");
        code = ItemIdList[idx];
        print("Check 5");
        gst=CGstList[idx];
      }
      int val = billEntryList.length + 1;
      double amount = qty * rate;
      double discAmount = ((discount / 100) * rate) * qty;
      double gstAmount;
      if(billType =="Non-GST Bill"){
        gstAmount=0.0;
      }else {
       gstAmount= ((gst/100) * rate)*qty;
      }
      double totalamount = amount - discAmount - gstAmount;

      print("Total Amount");
      print(totalamount);
      if(!selected && !delChk) {
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
            totalamount));
      }else if(delChk) {
        billEntryList.removeAt(index);
        for(int i =0;i<billEntryList.length;i++){
          billEntryList[i].id= i+1;
        }
        selected=false;
      }
      else
      {
        print("Edit Check Point Working");
        print(index);

        for(int i =0;i<billEntryList.length;i++){
          if(index==i) {
            billEntryList[i].designation=item;
            billEntryList[i].quantity =qty;
            billEntryList[i].disc=discount;
            billEntryList[i].amount =amount;
            billEntryList[i].discAmt=discAmount;
            billEntryList[i].GSTAmt = gstAmount;
            billEntryList[i].TotAmt = totalamount;
          }
        }

        // List<BillEntry> tempBillEntryArray=[];
        // billEntryList.removeAt(1);
        // for(int i =0;i<billEntryList.length;i++){
        //   billEntryList[i].id = i+1;
        // }

        selected=false;
      //  print(tempBillEntryArray);
      //   print(billEntryList);
        //billEntryList=tempBillEntryArray;
       // print(billEntryList);
        //print(billEntryList.getRange(0, 1));
      }

      grandTotalAmount=0.0;
      if(billEntryList.length > 0){
        for(int i =0;i<billEntryList.length;i++){
         grandTotalAmount= billEntryList[i].TotAmt+grandTotalAmount;
        }
      }
      print("grandTotalAmount");
      print(grandTotalAmount);
      setState(() {
        _employeeDataSource = EmployeeDataSource(billEntry: billEntryList);
      });
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

    return WillPopScope(
        onWillPop: () async {
          return false; // Prevent default back navigation
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFF004D40),
              title: const Text(" BILL ENTRY ", style: TextStyle(color: Colors.white),),
              centerTitle: true,
            ),
            body:Container(
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
                                        onChanged: (value) {
                                          billType = value!;
                                          print("Check Point Working 2");
                                          if(value.toString()=="Non-GST Bill"){
                                            getInvoiceNumber("NGST");
                                          }else{
                                            print("Check Point Working");
                                            getInvoiceNumber("GST");
                                          }
                                          //Do something when selected item is changed.
                                        },
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
                                              labelText: 'To Date',
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
                                                      // toDateController.text = pickedDate.toString().split(' ')[0];
                                                      // edate = pickedDate.toString().split(' ')[0];
                                                      // print(edate);
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
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("SALES"),
                                ],
                              ),
                              //const Padding(padding:EdgeInsets.all(5)),
                              Padding(
                                padding: EdgeInsets.fromLTRB(25, 0, 25, 5),
                                child:
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children:[
                                      // Row(
                                      //   children: [
                                      //     Text("Customer")
                                      //   ],
                                      // ),
                                      // DropdownButton<String>(
                                      //   value: customer,
                                      //   hint: Text('Customer'),
                                      //   items: CustomerList.map((String newvalue) {
                                      //     return DropdownMenuItem<String>(
                                      //       value: newvalue,
                                      //       child: Text(newvalue),
                                      //     );
                                      //   }).toList(),
                                      //   onChanged: (String? newvalue) {
                                      //     setState(() {
                                      //       customer = newvalue!;
                                      //       int idx = CustomerList.indexOf(customer);
                                      //       stateCode=StateCodeList[idx];
                                      //       shipTo = customer;
                                      //     });
                                      //   },
                                      // ),
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
                                                  customer = value!;
                                                  int idx = CustomerList.indexOf(customer);
                                                  stateCode=StateCodeList[idx];
                                                  shipTo = customer;
                                                });
                                              }
                                            },
                                            decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              filled: true,
                                              labelText: "customer",
                                              hintText: 'Search for a customer',
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
                                                      customer = option!;
                                                      int idx = CustomerList.indexOf(customer);
                                                      stateCode=StateCodeList[idx];
                                                      shipTo = customer;
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

                              Padding(
                                padding: EdgeInsets.fromLTRB(25, 25, 25, 0),
                                child:
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children:[
                                      DropdownButtonFormField2<String>(
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
                                        onChanged: (String? value) {
                                          setState(() {
                                            payType = value!;
                                          });
                                        },
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
                                      ),

                                    ]
                                ),
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
                                    BootstrapRow(
                                      children: <BootstrapCol>[
                                        BootstrapCol(
                                          sizes: 'col-md-12',
                                          child: TextFormField(
                                            showCursor: false,
                                            readOnly: true,
                                            controller: TextEditingController()..text= shipTo,
                                            decoration: InputDecoration(border: OutlineInputBorder(),labelText: 'Ship To',
                                                fillColor: Colors.white, filled: true),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]
                              ),

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
                                              qty=double.parse(newValue);
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
                                          getGridData(false);
                                          _itemController.clear();
                                          qtyTextController.clear();
                                          discTextController.clear();
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
                                          discTextController.clear();
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
                              ),
                              Padding(padding: EdgeInsets.fromLTRB(0, 100, 0, 0)),
                              SfDataGridTheme(
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
                                  child: SfDataGrid(
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
                                            _itemController..text=data?.getCells()[2].value;
                                            discount=data?.getCells()[9].value;
                                          });
                                    },
                                    columnWidthMode: ColumnWidthMode.fill,
                                  ),
                                ),
                              ),
                              Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                              Center(child:
                              Row(children: [
                                SizedBox(width: 20,),Text("Total Amount : - ${grandTotalAmount}"),
                                SizedBox(width: 20,),
                                ElevatedButton(
                                  onPressed: () {

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
                                ),],)
                              )
                            ]
                        ),
                      ),

                    )
                  ]
              ),
            )
        )
    );
    dispose();
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


