import 'dart:convert';

import 'package:billentry/CustomWidgets/appBar.dart';
import 'package:billentry/CustomWidgets/customDrawer.dart';
import 'package:billentry/GlobalVariables.dart';
import 'package:billentry/ItemReport.dart';
import 'package:billentry/LedgerReport.dart';
import 'package:billentry/main.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ItemLedger extends StatefulWidget {
  final dynamic approvedData;
  const ItemLedger({super.key, required this.approvedData});

  @override
  State<ItemLedger> createState() => _LedgerState();
}

class _LedgerState extends State<ItemLedger> {
  final _formKey = GlobalKey<FormState>();
  bool checkBox=false;
  bool updChk=false;



  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(color: Color(0xFF004D40),),
          Container(margin: const EdgeInsets.only(left: 7),child:const Text("..Loading" )),
        ],),
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

  TextEditingController itemNameController = new TextEditingController();
  TextEditingController itemCodeController = new TextEditingController();
  TextEditingController conversionController = new TextEditingController();
  TextEditingController conversion2Controller = new TextEditingController();
  TextEditingController hsnCodeController = new TextEditingController();
  TextEditingController salesRateController = new TextEditingController();
  TextEditingController discountController = new TextEditingController();
  TextEditingController cgstController = new TextEditingController();
  TextEditingController igstController = new TextEditingController();
  TextEditingController sgstController = new TextEditingController();
  TextEditingController gstController = new TextEditingController();
  TextEditingController openingQtyController = new TextEditingController();
  TextEditingController rateController = new TextEditingController();
  TextEditingController amountController = new TextEditingController();
  List<String> itemGroupList=[];
  List<String> itemGroupIdList=[];
  List<String> cgstList=[];
  List<String> sgstList=[];
  List<String> igstList=[];
  List<String> hsnList=[];
  List<String> gstList=[];
  List<String> itemTypeList =[];
  List<String> lookUpList=[];
  List<String> uomList = [];
  List<String> uomIdList=[];
  List<String> altUomList = [];
  String ItemTypeName="";
  String LookUpName="";
  String ItemGroupName="";
  String ItemGroupId="";
  String uomName="";
  String uomId="";
  String altUomName="";
  String altUomId="";

  Future<void> fetchIntialData() async{
    String url= "${ipAddress}api/getItemFetchData";
    try {
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'content-type': 'application/json; charset=UTF-8',
          }, body: jsonEncode({"compId": globalCompId}));
      if (response.statusCode == 200){
        final Map<String,dynamic> result= jsonDecode(response.body);
        if(result['valid']){
          List<dynamic> ItemGroup= result['result']['ItemGroup'];
          List<dynamic> ItemType= result['result']['itemTypeRes'];
          List<dynamic> uomRes= result['result']['uomRes'];
          itemGroupList.clear();
          itemGroupIdList.clear();
          cgstList.clear();
          sgstList.clear();
          igstList.clear();
          gstList.clear();
          hsnList.clear();
          for(int i=0;i<ItemGroup.length;i++){
            itemGroupList.add(ItemGroup[i]['Item_Group'].toString());
            itemGroupIdList.add(ItemGroup[i]['Item_GroupId'].toString());
            cgstList.add(ItemGroup[i]['Cgstp'].toString()=="null" ?"0":ItemGroup[i]['Cgstp'].toString());
            sgstList.add(ItemGroup[i]['Sgstp'].toString()=="null" ? "0":ItemGroup[i]['Sgstp'].toString());
            igstList.add(ItemGroup[i]['Igstp'].toString()=="null" ?"0":ItemGroup[i]['Igstp'].toString() );
            gstList.add(ItemGroup[i]['GstP'].toString()=="null"?"0":ItemGroup[i]['GstP'].toString());
            hsnList.add(ItemGroup[i]['Hsn'].toString()=="null"?"":ItemGroup[i]['Hsn'].toString());
          }
          itemTypeList.clear();
          lookUpList.clear();
          for(int i=0;i<ItemType.length;i++){
            itemTypeList.add(ItemType[i]['ItemType'].toString());
            lookUpList.add(ItemType[i]['LookUp'].toString());
          }
          uomList.clear();
          altUomList.clear();
          uomIdList.clear();
          for(int i=0;i<uomRes.length;i++){
            uomList.add(uomRes[i]['Uom'].toString());
            uomIdList.add(uomRes[i]['UomId'].toString());
            altUomList.add(uomRes[i]['Uom'].toString());
          }

        }else{
          showDialog(context: context, builder: (BuildContext context){
            return AlertDialog(
              title: const Text("Conn Error"),
              content: const Text("Please Reopen this page"),
              actions: [
                TextButton(onPressed: (){
                  Navigator.of(context).pop();
                }, child: Text("Ok"))
              ],
            );
          });
        }
      }else{
        showDialog(context: context, builder: (BuildContext context){
          return AlertDialog(
            title: const Text("Conn Error"),
            content: const Text("Please Reopen this page"),
            actions: [
              TextButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: Text("Ok"))
            ],
          );
        });
      }
    }catch(e){
      showDialog(context: context, builder: (BuildContext context){
        return AlertDialog(
          title: const Text("Conn Error"),
          content: const Text("Please Reopen this page"),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(context).pop();
            }, child: Text("Ok"))
          ],
        );
      });
    }
  }


  Future<void> saveItemData(dynamic itemData)async {
    String cutTableApi ="${ipAddress}api/saveItemData";
    List<dynamic> jsonArray=[];
    jsonArray.add(itemData);
    showLoaderDialog(context);
    try {
      final response = await http.post(Uri.parse(cutTableApi),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          }, body: jsonEncode({
            "itemData": itemData
          }));
      if (response.statusCode == 200) {
        print("Check 1");
        final Map<String, dynamic> data = json.decode(response.body);
        print(data);
        print(data['savChk']);
        var saveChk = data['savChk'];

        if (saveChk) {
          setState(() {
            itemNameController .clear();
            itemCodeController .clear();
            conversionController .clear();
            conversion2Controller .clear();
            hsnCodeController .clear();
            salesRateController .clear();
            discountController .clear();
            cgstController .clear();
            igstController .clear();
            sgstController .clear();
            gstController .clear();
            openingQtyController .clear();
            rateController .clear();
            amountController .clear();
          });
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return
                AlertDialog(
                  title: const Text('REASON'),
                  content: updChk?const Text("Data Updated Successfully"): const Text("Data Insertion Successfully"),
                  // Content of the dialog
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

        } else {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return
                AlertDialog(
                  title: const Text('REASON'),
                  content: updChk?const Text("Item Updation Failed"): const Text("Item Insertion Failed"),
                  // Content of the dialog
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
        print("response.statusCode");
        print(response.statusCode);
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return
              AlertDialog(
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
    }catch(e){
      print(e);
      print("response.statusCode  chk2 ");
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return
            AlertDialog(
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

  @override
  void initState() {
    var updVal= jsonDecode(widget.approvedData);
    print(updVal);
    updChk= updVal["approve"];
    fetchIntialData();
  }


  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(child: Scaffold(
        backgroundColor: Colors.pink[50],
        appBar: CustomAppBar(
          userName: globalUserName,
          emailId: globalEmailId,
          barTitle: "Item Master Creation",
          onMenuPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        drawer: const customDrawer(stkTransferCheck: false, brhTransferCheck: false),
        body: Container(child: 
        SingleChildScrollView(
          child:
          Padding(padding: const EdgeInsets.all(20.0),
          child: Column(children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Center(
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {// Handle tap action here, e.g., navigating to another screen or showing a message
                              setState(() {
                                itemNameController .clear();
                                itemCodeController .clear();
                                conversionController .clear();
                                conversion2Controller .clear();
                                hsnCodeController .clear();
                                salesRateController .clear();
                                discountController .clear();
                                cgstController .clear();
                                igstController .clear();
                                sgstController .clear();
                                gstController .clear();
                                openingQtyController .clear();
                                rateController .clear();
                                amountController .clear();
                              });

                            },
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              color: const Color(0xFF004D40),
                              child: Container(
                                width: 90,  // You can adjust the width as per your needs
                                height: 30, // You can adjust the height as per your needs
                                alignment: Alignment.center, // Center the text within the container
                                child: const Text(
                                  "New",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,  // You can adjust the font size
                                    fontWeight: FontWeight.bold,  // Optional: Add bold style for emphasis
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Handle tap action here, e.g., navigating to another screen or showing a message
                              print('Card tapped!');
                              Navigator.push(context,MaterialPageRoute(builder:(context)=>const itemReportPage()));
                            },
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              color: const Color(0xFF004D40),
                              child: Container(
                                width: 90,  // You can adjust the width as per your needs
                                height: 30, // You can adjust the height as per your needs
                                alignment: Alignment.center, // Center the text within the container
                                child: const Text(
                                  "ItemList",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,  // You can adjust the font size
                                    fontWeight: FontWeight.bold,  // Optional: Add bold style for emphasis
                                  ),
                                ),
                              ),
                            ),
                          ),],)

                  ),
                  const SizedBox(height: 5),

                  Row(
                    children: [
                      Expanded(
                        child:
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child:
                            TextFormField(
                              controller: itemNameController,
                              onChanged: (String newValue){
                                print("newValue onChanged");
                                print(newValue);
                              },
                              decoration: InputDecoration(
                                labelText: 'Item Name',
                                labelStyle: const TextStyle(fontSize: 14),
                                prefixIcon: const Icon(Icons.add_shopping_cart),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a item name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                          const EdgeInsets.only(left: 0.0),
                          child:
                          Card(elevation: 5,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child:
                            TextFormField(
                              controller: itemCodeController,
                              readOnly: false,
                              showCursor: true,
                              onChanged: (String newValue){
                              },
                              decoration: InputDecoration(
                                labelText: 'Item Code',
                                labelStyle: const TextStyle(fontSize: 14),
                                prefixIcon: const Icon(Icons.code),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                              ),
                              validator: (value) {
                                // if (value == null || value.isEmpty) {
                                //   return 'Please enter the led';
                                // }
                                return null;
                              },
                            ),)
                          ,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(children: [
                    Flexible(
                      flex: 10, // Group field will take 80% of the space
                      child:
                      Padding(
                        padding: const EdgeInsets.only(left: 1.0),
                        child:
                        Card(elevation: 5,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child:
                          DropdownSearch(
                            items: (filter, infiniteScrollProps)=>itemGroupList,
                            selectedItem: ItemGroupName,
                            onChanged: (dynamic newValue){
                              int idx=itemGroupList.indexOf(newValue.toString());
                              if(idx != -1){
                                hsnCodeController.text= hsnList[idx];
                                gstController.text = gstList[idx];
                                cgstController.text= cgstList[idx];
                                sgstController.text= sgstList[idx];
                                igstController.text= igstList[idx];
                                ItemGroupName = newValue.toString();
                                ItemGroupId = itemGroupIdList[idx];
                              }

                            },
                            validator: (value){
                              if(!itemGroupList.contains(value.toString())){
                                return 'Please select the Group';
                              }
                              return null;
                            },
                            decoratorProps: DropDownDecoratorProps(
                                expands: false,
                                decoration:InputDecoration(
                                  labelText: "Item Group",
                                    prefixIcon: const Icon(Icons.group),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)) ,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10)
                                )),
                            popupProps: const PopupPropsMultiSelection.menu(showSearchBox: true),
                            compareFn:(item1, item2) => item1 ==item2,
                          ),
                        ),
                      ))],),
                  SizedBox(height: 5,),
                  Row(children: [
                    Flexible(
                        flex: 10, // Group field will take 80% of the space
                        child:
                        Padding(
                          padding: const EdgeInsets.only(left: 1.0),
                          child:
                          Card(elevation: 5,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child:
                            DropdownSearch(
                              items: (filter, infiniteScrollProps)=>itemTypeList,
                              selectedItem: ItemTypeName,
                              onChanged: (dynamic newValue){
                                ItemTypeName= newValue.toString();
                                if(itemTypeList.indexOf(newValue.toString()) != -1){
                                  LookUpName = lookUpList[itemTypeList.indexOf(newValue.toString())];
                                }
                              },
                              validator: (value){
                                if(!itemTypeList.contains(value.toString())){
                                  return 'Please select the Type';
                                }
                                return null;
                              },
                              decoratorProps: DropDownDecoratorProps(
                                  expands: false,
                                  decoration:InputDecoration(
                                      labelText: "Item Type",
                                      prefixIcon: const Icon(Icons.type_specimen),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)) ,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10)
                                  )),
                              popupProps: const PopupPropsMultiSelection.menu(showSearchBox: true),
                              compareFn:(item1, item2) => item1 ==item2,
                            ),
                          ),
                        ))],),
                  SizedBox(height: 5,),
                  Row(children: [
                    Flexible(
                        flex: 5, // Group field will take 80% of the space
                        child:
                        Padding(
                          padding: const EdgeInsets.only(left: 1.0),
                          child:
                          Card(elevation: 5,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child:
                            DropdownSearch(
                              items: (filter, infiniteScrollProps)=>uomList,
                              selectedItem: uomName,
                              onChanged: (dynamic newValue){
                                conversionController.text="1";
                                uomName=newValue.toString();
                                if(uomList.indexOf(uomName) != -1){
                                  uomId = uomIdList[uomList.indexOf(uomName)];
                                }

                              },
                              validator: (value){
                                // if(!uomList.contains(value.toString())){
                                //   return 'Please select the Uom';
                                // }
                                // return null;
                              },
                              decoratorProps: DropDownDecoratorProps(
                                  expands: false,
                                  decoration:InputDecoration(
                                      labelText: "Uom",
                                      prefixIcon: const Icon(Icons.scale),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)) ,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10)
                                  )),
                              popupProps: const PopupPropsMultiSelection.menu(showSearchBox: true),
                              compareFn:(item1, item2) => item1 ==item2,
                            ),
                          ),
                        )),
                    Flexible(
                        flex: 5, // Group field will take 80% of the space
                        child:
                        Padding(
                          padding: const EdgeInsets.only(left: 1.0),
                          child:
                          Card(elevation: 5,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child:
                            DropdownSearch(
                              items: (filter, infiniteScrollProps)=>altUomList,
                              selectedItem: altUomName,
                              onChanged: (dynamic newValue){
                                conversion2Controller.text="1";
                                altUomName=newValue.toString();
                                if(altUomList.indexOf(newValue.toString()) != -1){
                                  altUomId = uomIdList[altUomList.indexOf(newValue.toString())] ;
                                }
                              },
                              validator: (value){
                                // if(!altUomList.contains(value.toString())){
                                //   return 'Please select the Uom';
                                // }
                                // return null;
                              },
                              decoratorProps: DropDownDecoratorProps(
                                  expands: false,
                                  decoration:InputDecoration(
                                      labelText: "Alt.Uom",
                                      prefixIcon: const Icon(Icons.scale),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)) ,
                                      contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10)
                                  )),
                              popupProps: const PopupPropsMultiSelection.menu(showSearchBox: true),
                              compareFn:(item1, item2) => item1 ==item2,
                            ),
                          ),
                        ))],),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Expanded(
                        child:
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child:
                            TextFormField(
                              controller: conversionController,
                              keyboardType: TextInputType.number,
                              onChanged: (String newValue){
                                print("newValue onChanged");
                                print(newValue);
                              },
                              decoration: InputDecoration(
                                labelText: 'Conversion',
                                labelStyle: const TextStyle(fontSize: 14),
                                prefixIcon: const Icon(Icons.transform),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                              ),
                              validator: (value) {
                                // if (value == null || value.isEmpty) {
                                //   return 'Please enter a conversion';
                                // }
                                // return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                          const EdgeInsets.only(left: 0.0),
                          child:
                          Card(elevation: 5,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child:
                            TextFormField(
                              controller: conversion2Controller,
                              keyboardType: TextInputType.number,
                              readOnly: false,
                              showCursor: true,
                              onChanged: (String newValue){
                              },
                              decoration: InputDecoration(
                                labelText: 'Conversion 2',
                                labelStyle: const TextStyle(fontSize: 14),
                                prefixIcon: const Icon(Icons.transform),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                              ),
                              validator: (value) {
                                // if (value == null || value.isEmpty) {
                                //   return 'Please enter the led';
                                // }
                                return null;
                              },
                            ),)
                          ,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child:
                      Card(elevation: 5,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          controller: hsnCodeController,
                          maxLines: 1, // Allows the address to have multiple lines
                          decoration: InputDecoration(
                            labelText: 'Hsn Code',
                            labelStyle: const TextStyle(fontSize: 14),
                            prefixIcon: const Icon(Icons.code),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an hsnCode';
                            }
                            return null;
                          },
                        ),)
                  ),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Expanded(
                        child:
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child:
                            TextFormField(
                              controller: salesRateController,
                              keyboardType: TextInputType.number,
                              onChanged: (String newValue){
                                print("newValue onChanged");
                                print(newValue);
                              },
                              decoration: InputDecoration(
                                labelText: 'Sales Rate',
                                labelStyle: const TextStyle(fontSize: 14),
                                prefixIcon: const Icon(Icons.monetization_on),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                              ),
                              validator: (value) {
                                // if (value == null || value.isEmpty) {
                                //   return 'Please enter a sales Rate';
                                // }
                                // return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                          const EdgeInsets.only(left: 0.0),
                          child:
                          Card(elevation: 5,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child:
                            TextFormField(
                              controller: discountController,
                              keyboardType: TextInputType.number,
                              readOnly: false,
                              showCursor: true,
                              onChanged: (String newValue){
                              },
                              decoration: InputDecoration(
                                labelText: 'Discount',
                                labelStyle: const TextStyle(fontSize: 14),
                                prefixIcon: const Icon(Icons.percent),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                              ),
                              validator: (value) {
                                // if (value == null || value.isEmpty) {
                                //   return 'Please enter the led';
                                // }
                                return null;
                              },
                            ),)
                          ,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Expanded(
                        child:
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child:
                            TextFormField(
                              controller: gstController,
                              keyboardType: TextInputType.number,
                              onChanged: (String newValue){
                                if(newValue != ""){
                                  igstController.text= newValue.toString();
                                  cgstController.text = (double.parse(newValue.toString())/2).toString();
                                  sgstController.text =(double.parse(newValue.toString())/2).toString();
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Gst %',
                                labelStyle: const TextStyle(fontSize: 14),
                                prefixIcon: const Icon(Icons.percent),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                              ),
                              validator: (value) {
                                // if (value == null || value.isEmpty) {
                                //   return 'Please enter a gst percentage';
                                // }
                                // return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                          const EdgeInsets.only(left: 0.0),
                          child:
                          Card(elevation: 5,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child:
                            TextFormField(
                              controller: igstController,
                              readOnly: true,
                              showCursor: false,
                              onChanged: (String newValue){
                              },
                              decoration: InputDecoration(
                                labelText: 'Igst %',
                                labelStyle: const TextStyle(fontSize: 14),
                                prefixIcon: const Icon(Icons.percent),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                              ),
                              validator: (value) {
                                // if (value == null || value.isEmpty) {
                                //   return 'Please enter the led';
                                // }
                                return null;
                              },
                            ),)
                          ,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Expanded(
                        child:
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child:
                            TextFormField(
                              controller: cgstController,
                              readOnly: true,
                              showCursor: false,
                              onChanged: (String newValue){
                                print("newValue onChanged");
                                print(newValue);
                              },
                              decoration: InputDecoration(
                                labelText: 'Cgst %',
                                labelStyle: const TextStyle(fontSize: 14),
                                prefixIcon: const Icon(Icons.percent),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                              ),
                              validator: (value) {
                                // if (value == null || value.isEmpty) {
                                //   return 'Please enter a gst percentage';
                                // }
                                // return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                          const EdgeInsets.only(left: 0.0),
                          child:
                          Card(elevation: 5,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child:
                            TextFormField(
                              controller: sgstController,
                              readOnly: true,
                              showCursor: false,
                              onChanged: (String newValue){
                              },
                              decoration: InputDecoration(
                                labelText: 'Sgst %',
                                labelStyle: const TextStyle(fontSize: 14),
                                prefixIcon: const Icon(Icons.percent),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                              ),
                              validator: (value) {
                                // if (value == null || value.isEmpty) {
                                //   return 'Please enter the led';
                                // }
                                return null;
                              },
                            ),)
                          ,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    children: [
                      Expanded(
                        child:
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child:
                            TextFormField(
                              controller: openingQtyController,
                              keyboardType: TextInputType.number,
                              onChanged: (String newValue){
                                if(newValue != ""){
                                  if(rateController.text.toString()=="") {
                                    rateController.text = "1";
                                  }
                                  amountController.text= (double.parse(newValue)* double.parse(rateController.text.toString())).toString();
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Opening Qty',
                                labelStyle: const TextStyle(fontSize: 14),
                                prefixIcon: const Icon(Icons.scale),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                              ),
                              validator: (value) {
                                // if (value == null || value.isEmpty) {
                                //   return 'Please enter a opening Qty';
                                // }
                                // return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding:
                          const EdgeInsets.only(left: 0.0),
                          child:
                          Card(elevation: 5,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child:
                            TextFormField(
                              controller: rateController,
                              keyboardType: TextInputType.number,
                              readOnly: false,
                              showCursor: true,
                              onChanged: (String newValue){
                                if(newValue !=""){
                                  if(openingQtyController.text.toString() ==""){
                                    openingQtyController.text="1";
                                  }
                                  amountController.text=(double.parse(newValue)* double.parse(openingQtyController.text.toString())).toString();
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Rate',
                                labelStyle: const TextStyle(fontSize: 14),
                                prefixIcon: const Icon(Icons.monetization_on),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                              ),
                              validator: (value) {
                                // if (value == null || value.isEmpty) {
                                //   return 'Please enter the led';
                                // }
                                return null;
                              },
                            ),)
                          ,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Padding(
                      padding: const EdgeInsets.only(top: 0.0),
                      child:
                      Card(elevation: 5,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          controller: amountController,
                          readOnly: true,
                          showCursor: false,
                          maxLines: 1, // Allows the address to have multiple lines
                          decoration: InputDecoration(
                            labelText: 'Amount',
                            labelStyle: const TextStyle(fontSize: 14),
                            prefixIcon: const Icon(Icons.code),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          ),
                          validator: (value) {
                            // if (value == null || value.isEmpty) {
                            //   return 'Please enter an amount';
                            // }
                            // return null;
                          },
                        ),)
                  ),
                  const SizedBox(height: 5),

                  Center(child: Row(
                    mainAxisAlignment : MainAxisAlignment.center,children: [
                    Checkbox(value: checkBox, onChanged: (bool? newValue){
                      setState(() {
                        checkBox= newValue ?? false;
                      });
                    } ), const Text("IsActive")],)
                    ,)
                  ,
                  const SizedBox(height: 5,),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: Card(elevation: 5,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child:
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate() && itemNameController.text.toString() !="") {
                                // print('Form is valid, performing save action');
                               dynamic value= {
                                  "ItemName" : itemNameController.text.toString(),
                                  "ItemCode" : itemCodeController.text.toString(),
                                  "ItemGroupId" : ItemGroupId,
                                  "UomId" : uomId,
                                  "IsActive" : checkBox? "Y":"F",
                                  "ItemType" : LookUpName,
                                  "SecUomId" : altUomId,
                                  "SalesRate" : salesRateController.text.toString(),
                                  "ItemCode" : itemCodeController.text.toString(),
                                  "Discp" : discountController.text.toString(),
                                  "CgstP" : cgstController.text.toString(),
                                  "SgstP" : sgstController.text.toString(),
                                  "Igstp": igstController.text.toString(),
                                  "CompId" : globalCompId,
                                  "HsnCode" : hsnCodeController.text.toString(),
                                  "Gstp" : gstController.text.toString(),
                                  "Conv" : conversionController.text.toString(),
                                  "Conv1" : conversion2Controller.text.toString(),
                                  "opQty" : openingQtyController.text.toString(),
                                  "opRate" : rateController.text.toString(),
                                  "opAmt" : amountController.text.toString(),
                                  "update": false
                                 };
                               saveItemData(value);
                              }else{
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return
                                      AlertDialog(
                                        title: const Text('Alert'),
                                        content: const Text("Please Enter the Required Fields"), // Content of the dialog
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
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFF004D40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              updChk?'Update':'Save',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ))),
                      const SizedBox(width: 5),
                      Expanded(child: Card(elevation: 5,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child:
                          ElevatedButton(
                            onPressed: () {
                              // Reset the form
                              _formKey.currentState!.reset();
                              print('Cancel button pressed');
                              updChk=false;

                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFF004D40),
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          )))
                      ,
                    ],
                  ),

                ],
              ),
            )
          ],),),
        ),),
      ), onWillPop: () async{
        Navigator.pushNamedAndRemoveUntil(context, '/Home',
                (Route<dynamic> route)=>false);
        return true;
      });
  }
}
