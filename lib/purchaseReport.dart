import 'dart:convert';

import 'package:billentry/CustomWidgets/appBar.dart';
import 'package:billentry/CustomWidgets/customDrawer.dart';
import 'package:billentry/GlobalVariables.dart';
import 'package:billentry/billEntryMasScreen.dart';
import 'package:billentry/main.dart';
import 'package:intl/intl.dart';
import 'package:billentry/purchaseEntryMasScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;




import 'package:dropdown_button2/dropdown_button2.dart';

class purchaseReportPage extends StatefulWidget{
  const purchaseReportPage({super.key});

  State<purchaseReportPage> createState()=> _stockReport();
}

List<SalesReportMain> SalesReportMainList=[];
List<StockReportDet>  StockReportDetList=[];
class _stockReport extends State<purchaseReportPage>{

  late SalesReportMainSource _salesReportMainSource;
  late StockReportDetSource _stockReportDetSource;
  List<StockReportDet> tempStockReportDet=[];
  String secondGridName="";
  bool mainChk=true;
  bool detChk=false;
  dynamic transData;
  final DataGridController _dataGridController = DataGridController();
  final DataGridController _dataGriddetController = DataGridController();
  void _incrementCounter() {
    setState(() {
    });
  }

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(color: Color(0xFF004D40),),
          Container(margin: EdgeInsets.only(left: 7),child:Text("..Loading" )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return WillPopScope(child: alert, onWillPop: ()=> Future.value(false));
      },
    );
  }

  Future<void> FetchMasData()async {
    String cutTableApi =ipAddress+"api/getPurchaseMonth";
    try {

      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          showLoaderDialog(context);
        } catch (e) {
          print("Error showing loading dialog: ${e.toString()}");
        }
      });
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
          List<dynamic> salesList= data['result'];
          int cnt=1;
          try {
            for (int i = 0; i < salesList.length; i++) {
              SalesReportMainList.add(SalesReportMain(cnt, salesList[i]['SMonth'],
                  salesList[i]['RptType'].toString(),
                  salesList[i]['NetAmt'].toString(),
                  int.parse(salesList[i]['mn'].toString())
              ));
              cnt++;
            }
          }catch(e){
            print(e);
          }
          // SalesReportMainList = [SalesReportMain(1, "check1", "0000", "00000000"),
          //   SalesReportMain(2, "jjt check2", "0000", "00000000"),
          //   SalesReportMain(3, "check3", "0000", "00000000")
          // ];
          _salesReportMainSource = SalesReportMainSource(salesReportMain: SalesReportMainList);
          await FetchDetData();
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return
                AlertDialog(
                  title: Text('REASON'),
                  content: Text("No Data Found"),
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
          SalesReportMainList = [];
          _salesReportMainSource = SalesReportMainSource(salesReportMain: SalesReportMainList);
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
        SalesReportMainList = [];
        _salesReportMainSource = SalesReportMainSource(salesReportMain: SalesReportMainList);
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

  Future<void> FetchDetData()async {
    String cutTableApi =ipAddress+"api/getPurchaseData";
    try {
      // showLoaderDialog(context);
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
          List<dynamic> salesList= data['result'];
          int cnt=1;
          try {
            print(salesList.length);
            for (int i = 0; i < salesList.length; i++) {
              print("check1");
              StockReportDetList.add(StockReportDet(cnt, salesList[i]['Cons_Date'].toString(),
                  salesList[i]['Supplier'].toString(),
                  salesList[i]['RptType'].toString(), salesList[i]['Cons_No'].toString(),
                  salesList[i]['NetAmt'].toString()
                  ,int.parse(salesList[i]['MonthNo'].toString())));
              print(cnt);
              cnt++;
            }
          }catch(e){
            print("Err check 1");
            print(e);
          }
          // SalesReportMainList = [SalesReportMain(1, "check1", "0000", "00000000"),
          //   SalesReportMain(2, "jjt check2", "0000", "00000000"),
          //   SalesReportMain(3, "check3", "0000", "00000000")
          // ];
          _stockReportDetSource= StockReportDetSource(stockReportDet: StockReportDetList);
        } else {
          // Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return
                AlertDialog(
                  title: Text('REASON'),
                  content: Text("No Data Found"),
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
          StockReportDetList =[];
          _stockReportDetSource = StockReportDetSource(stockReportDet: StockReportDetList);
        }

        _incrementCounter();
      } else {
        // Navigator.pop(context);
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
        StockReportDetList =[];
        _stockReportDetSource = StockReportDetSource(stockReportDet: StockReportDetList);
      }
    }catch(e){
      // Navigator.pop(context);
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
      StockReportDetList =[];
      _stockReportDetSource = StockReportDetSource(stockReportDet: StockReportDetList);
    }
  }
  @override
  void initState() {
    super.initState();
    // showLoaderDialog(context);

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight]);
    SalesReportMainList = [];
    _salesReportMainSource = SalesReportMainSource(salesReportMain: SalesReportMainList);
    StockReportDetList =[];
    _stockReportDetSource = StockReportDetSource(stockReportDet: StockReportDetList);
    FetchMasData();
  }



  @override
  Widget build (BuildContext context){
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;


    print(height);
    print(width);

    updateTable(List<SalesReportMain> tempSalesList){
      setState(() {
        _salesReportMainSource =
            SalesReportMainSource(salesReportMain: tempSalesList);
      });
    }
    updateDetTable(List<StockReportDet> tempDetList){
      setState((){
        _stockReportDetSource = StockReportDetSource(stockReportDet: tempDetList);
      });

    }
    return
      WillPopScope(child:
      !detChk?
      Scaffold(
          appBar: CustomAppBar(userName: globalUserName,
              emailId: globalEmailId,
              onMenuPressed: (){
                Scaffold.of(context).openDrawer();
              }, barTitle: "PURCHASE REPORT"),
          drawer: customDrawer(stkTransferCheck: false,
              brhTransferCheck: false),
          body:
          SingleChildScrollView(
              child:Column(children: [
                SizedBox(height: 10,),
                Center(child:
                Text("PURCHASE REPORT - MONTH WISE", style:
                TextStyle(fontWeight:FontWeight.bold,
                    fontSize: 20),
                ),),
                SizedBox(height: 10,),
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    !mainChk ? Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: ElevatedButton.icon(
                        onPressed: (){
                          setState(() {
                            mainChk=true;
                          });
                        },
                        style: ElevatedButton.styleFrom(foregroundColor: Colors.black,
                          backgroundColor: Color(0xFF004D40),),
                        label: Text("Back",style: TextStyle(color: Colors.white),),
                        icon: Icon(Icons.arrow_back, color: Colors.pink,), ),)
                        :SizedBox(width: 1,),
                    Expanded(child: Padding(padding: EdgeInsets.all(15), child:
                    SizedBox(
                      width: width >500?width*0.5: width,
                      child: TextField(
                        decoration: InputDecoration(border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
                            prefixIcon: Icon(Icons.search),
                            hintText: mainChk? "Search Month Here":"Search Party Here",
                            labelText: mainChk? "Search Month":"Search Party"
                        ),
                        onChanged: (String newValue){
                          if(newValue == "") {
                            if(mainChk) {
                              updateTable(SalesReportMainList);
                            }else{
                              updateDetTable(tempStockReportDet);
                            }
                          }else{
                            if(SalesReportMainList.length>0 || tempStockReportDet.length>0) {
                              if(mainChk) {
                                List<SalesReportMain> tempSalesList = [];
                                for (int i = 0; i < SalesReportMainList.length; i++) {
                                  if (SalesReportMainList[i].month.toLowerCase().contains(
                                      newValue.toString().toLowerCase())) {
                                    print("Check Point Working");
                                    tempSalesList.add(SalesReportMainList[i]);
                                  }
                                }
                                updateTable(tempSalesList);
                              }else{
                                List<StockReportDet> tempSearchDet = [];

                                for (int i = 0; i < tempStockReportDet.length; i++) {
                                  if (tempStockReportDet[i].party.toLowerCase().contains(
                                      newValue.toString().toLowerCase())) {
                                    print("Check Point Working");
                                    tempSearchDet.add(tempStockReportDet[i]);
                                  }
                                }
                                updateDetTable(tempSearchDet);
                              }
                            }else{
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return
                                    AlertDialog(
                                      title: Text('REASON'),
                                      content: Text("No Data"), // Content of the dialog
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
                      ),),)) ],),
                mainChk?
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:
                  [
                    Row( mainAxisAlignment:MainAxisAlignment.center,children: [
                      Container(
                        width: width>500? width:width,
                        height: height * 0.65,
                        // alignment:  Alignment.center,
                        //
                        child:
                        SfDataGridTheme(
                          data: SfDataGridThemeData(
                            filterIconColor: Colors.pink,
                            currentCellStyle: DataGridCurrentCellStyle(
                              borderWidth: 2,
                              borderColor: Colors.pinkAccent,
                            ),
                            selectionColor: Colors.lightGreen[50],
                            headerColor: Color(0xFF004D40),
                          ),
                          child: SfDataGrid(
                            allowEditing: true,
                            selectionMode: SelectionMode.single,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            source: _salesReportMainSource,
                            editingGestureType: EditingGestureType.tap,
                            columnWidthCalculationRange: ColumnWidthCalculationRange.visibleRows,
                            gridLinesVisibility: GridLinesVisibility.both,
                            showHorizontalScrollbar: true,
                            allowFiltering: true,
                            columns: [
                              GridColumn(
                                columnName: 'sno',
                                width: width<500?65:width*0.1,
                                allowEditing: false,
                                allowFiltering: false,
                                label: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.centerLeft,
                                  child: Text('SNO', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'month',
                                width: width<500?165:width*0.4,
                                label: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: Text('MONTH', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'type',
                                width: width<500?105:width*0.20,
                                allowFiltering: false,
                                label: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: Text('TYPE', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'amount',
                                width: width<500?135:width*0.30,
                                allowFiltering: false,
                                label: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: Text('AMOUNT', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'monthNo',
                                width: width<500?115:width*0.25,
                                allowFiltering: false,
                                visible: false,
                                label: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: Text('MONTHNO', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ],
                            controller: _dataGridController,
                            onCellDoubleTap: (DataGridCellDoubleTapDetails details) {
                              print(_dataGridController.selectedRow?.getCells()[1].value);
                            },
                            onSelectionChanged: (List<DataGridRow> addedRows, List<DataGridRow> removedRows) {
                              // Handle selection change logic here
                            },
                            columnWidthMode: ColumnWidthMode.fill,
                          ),
                        ),
                      ),
                    ],),

                    ElevatedButton.icon(onPressed: (){
                      print("Check Working");
                      if(_dataGridController.selectedRow?.getCells()[1].value!= null) {
                        print(_dataGridController.selectedRow?.getCells()[4].value);
                        int value=_dataGridController.selectedRow?.getCells()[4].value;
                        tempStockReportDet=[];
                        // int cnt=1;
                        for(int i=0;i<StockReportDetList.length;i++){
                          print(StockReportDetList[i].monthNo);
                          if(value==StockReportDetList[i].monthNo){
                            tempStockReportDet.add(StockReportDetList[i]);
                            // tempStockReportDet[tempStockReportDet.length-1].sno=cnt;
                            // cnt++;
                          }
                        }
                        DateFormat dateFormat = DateFormat('dd/MM/yyyy');
                        // Sort the list by date using DateFormat
                        if(!tempStockReportDet.isEmpty) {
                          tempStockReportDet.sort((a, b) {
                            DateTime dateA = dateFormat.parse(a.vocherDate);
                            DateTime dateB = dateFormat.parse(b.vocherDate);
                            return dateA.compareTo(dateB);
                          });
                        }

                        int cnt=1;
                        for(int i=0;i<tempStockReportDet.length;i++){
                          tempStockReportDet[i].sno=cnt;
                          cnt++;
                        }

                        // Print the sorted list
                        print("Sorted list: $tempStockReportDet");
                        secondGridName=_dataGridController.selectedRow?.getCells()[1].value;
                        setState(() {
                          mainChk=false;
                          _stockReportDetSource = StockReportDetSource(stockReportDet: tempStockReportDet);
                        });

                      }else{
                        showDialog(context: context, builder:(BuildContext context) {
                          return
                            AlertDialog(
                              title: Text('REASON'),
                              content: Text("Please Select The Row"), // Content of the dialog
                              actions: <Widget>[
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                ),
                              ],
                            );
                        } );
                      }
                    },
                      label: const Text("Get Selected Month Data",
                        style: TextStyle(color: Colors.white), ),
                      icon: const Icon(Icons.arrow_forward, color: Colors.pink,),
                      style: ElevatedButton.styleFrom(foregroundColor: Colors.black,
                        backgroundColor: Color(0xFF004D40),),
                    )

                  ],):
                Column(children: [Center(child:
                Text(" ITEM GROUP : ${secondGridName}", style:
                TextStyle(fontWeight:FontWeight.bold,
                    fontSize: 20),
                ),),
                  SizedBox(height: 5,),
                  SizedBox(width: width>500? width:width
                    , height: height*0.5,
                    child: SfDataGridTheme(
                      data: SfDataGridThemeData(
                        filterIconColor: Colors.pink,
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
                          source: _stockReportDetSource,
                          editingGestureType: EditingGestureType.tap,
                          columnWidthCalculationRange: ColumnWidthCalculationRange.visibleRows,
                          gridLinesVisibility: GridLinesVisibility.both,
                          showHorizontalScrollbar: true,
                          allowFiltering: true,
                          columns: [
                            GridColumn(
                              columnName: 'sno',
                              width: width<500?65:width*0.1,
                              allowEditing: false,
                              allowFiltering: false,
                              label: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                alignment: Alignment.centerLeft,
                                child: Text('SNO', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            GridColumn(
                              columnName: 'voucherDate',
                              width: width<500?135:width*0.150,
                              label: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                alignment: Alignment.center,
                                child: Text('DATE', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            GridColumn(
                              columnName: 'party',
                              width: width<500?135:width*0.225,
                              allowFiltering: false,
                              label: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                alignment: Alignment.center,
                                child: Text('PARTY', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            GridColumn(
                              columnName: 'type',
                              width: width<500?105:width*0.100,
                              allowFiltering: false,
                              label: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                alignment: Alignment.center,
                                child: Text('TYPE', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            GridColumn(
                              columnName: 'voucherNo',
                              width: width<500?135:width*0.250,
                              allowFiltering: false,
                              label: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                alignment: Alignment.center,
                                child: Text('VOUCHERNO', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            GridColumn(
                              columnName: 'amount',
                              width: width<500?115:width*0.175,
                              allowFiltering: false,
                              label: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                alignment: Alignment.center,
                                child: Text('AMOUNT', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                              ),
                            ),
                            GridColumn(
                              columnName: 'monthNo',
                              width: width<500?115:width*0.150,
                              allowFiltering: false,
                              visible: false,
                              label: Container(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                alignment: Alignment.center,
                                child: Text('MonthNo', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ],
                          controller : _dataGridController,
                          onCellDoubleTap: (DataGridCellDoubleTapDetails details) {
                            print(_dataGridController.selectedRow?.getCells()[1].value);
                          },
                          onSelectionChanged:
                              (List<DataGridRow> addedRows, List<DataGridRow> removedRows) {
                            // apply your logic
                            // selected=true;
                            // index=_dataGridController.selectedIndex;
                            // DataGridRow? data= _dataGridController.selectedRow;
                            // print(_dataGridController.selectedIndex);
                            //
                            // print(data);
                            // print(data);
                            //
                            // print(data?.getCells()[2].value);
                            // print(data?.getCells()[6].value);
                            // print(data?.getCells()[9].value);
                            // setState(() {
                            //   qty=data?.getCells()[6].value;
                            //   qtyTextController.text=data!.getCells()[6].value.toString();
                            //   _itemController..text=data?.getCells()[2].value;
                            //   discTextController.text=data!.getCells()[9].value.toString();
                            //   rateTextController.text=data!.getCells()[7].value.toString();
                            //   discount=data?.getCells()[9].value;
                            //   itemRate = data?.getCells()[7].value;
                            // });
                          },
                          columnWidthMode: ColumnWidthMode.fill,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton.icon(onPressed: (){
                    // setState(() {
                    //   mainChk=false;
                    //   // _stockReportDetSource = StockReportDetSource(stockReportDet: tempStockReportDet);
                    // });
                    print("Check Working");
                    if(_dataGridController.selectedRow?.getCells()[4].value!= null) {
                      print(_dataGridController.selectedRow?.getCells()[4].value);
                      String value=_dataGridController.selectedRow?.getCells()[4].value;
                      // String value=_dataGridController.selectedRow?.getCells()[4].value;
                      print(value);
                      transData={"transno": value,"valid":true};
                      setState(() {
                        // billEntryFirstScreen(data:transData);
                        detChk=true;
                        // _stockReportDetSource = StockReportDetSource(stockReportDet: tempStockReportDet);
                      });
                      // tempStockReportDet=[];
                      //   int cnt=1;
                      //   // for(int i=0;i<StockReportDetList.length;i++){
                      //   //   if(value==StockReportDetList[i].group){
                      //   //     tempStockReportDet.add(StockReportDetList[i]);
                      //   //     tempStockReportDet[tempStockReportDet.length-1].sno=cnt;
                      //   //     cnt++;
                      //   //   }
                      //   // }
                      //   secondGridName=value;
                      //   setState(() {
                      //     mainChk=false;
                      //     // _stockReportDetSource = StockReportDetSource(stockReportDet: tempStockReportDet);
                      //   });
                      //
                    }
                    else{
                      showDialog(context: context, builder:(BuildContext context) {
                        return
                          AlertDialog(
                            title: Text('REASON'),
                            content: Text("Please Select The Row"), // Content of the dialog
                            actions: <Widget>[
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                },
                              ),
                            ],
                          );
                      } );
                    }
                  },
                    label: Text("Fetch Selected TransNo",style: TextStyle(color: Colors.white), ),
                    icon: Icon(Icons.arrow_forward, color: Colors.pink,),
                    style: ElevatedButton.styleFrom(foregroundColor: Colors.black,
                      backgroundColor: Color(0xFF004D40),),
                  )],)


              ],)
          )


      )
          :
          purchaseEntryFirstScreen(data: transData)
          , onWillPop: () async{
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/Home',
                  (Route<dynamic> route) => false, // This will remove all previous routes
            );
            return true;
          });

  }

}


class SalesReportMain {
  SalesReportMain(
      this.sno,
      this.month,
      this.type,
      this.amount,
      this.monthNo);

  int sno;
  String month;
  String type;
  String amount;
  int monthNo;
}

class StockReportDet {
  StockReportDet(
      this.sno,
      this.vocherDate,
      this.party,
      this.type,
      this.voucherNo,
      this.amount,
      this.monthNo);

  int sno;
  String vocherDate;
  String party;
  String type;
  String voucherNo;
  String amount;
  int monthNo;
}

class StockReportDetSource extends DataGridSource {
  StockReportDetSource({required List<StockReportDet> stockReportDet}) {
    _billEntry = stockReportDet.map<DataGridRow>((dataGridRow) => DataGridRow(
      cells: [
        DataGridCell<int>(columnName: 'id', value: dataGridRow.sno),
        DataGridCell<String>(columnName: 'vocherDate', value: dataGridRow.vocherDate),
        DataGridCell(columnName: 'party', value: dataGridRow.party),
        DataGridCell<String>(columnName: 'type', value: dataGridRow.type),
        DataGridCell<String>(columnName: 'voucherNo', value: dataGridRow.voucherNo),
        DataGridCell<String>(columnName: 'amount', value: dataGridRow.amount),
        DataGridCell<int>(columnName: 'monthNo', value: dataGridRow.monthNo)
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
      // billEntryList[dataRowIndex].quantity=double.parse(newCellValue.toString());
      dynamic value= double.parse(newCellValue.toString())*   double.parse(_billEntry[dataRowIndex].getCells()[rowColumnIndex.columnIndex+1].value.toString());
      // print("Total Amount");
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

class SalesReportMainSource extends DataGridSource {
  SalesReportMainSource({required List<SalesReportMain> salesReportMain}) {
    _billEntry = salesReportMain.map<DataGridRow>((dataGridRow) => DataGridRow(
      cells: [
        DataGridCell<int>(columnName: 'sno', value: dataGridRow.sno),
        DataGridCell<String>(columnName: 'month', value: dataGridRow.month),
        DataGridCell<String>(columnName: 'type', value: dataGridRow.type),
        DataGridCell<String>(columnName: 'amount', value: dataGridRow.amount),
        DataGridCell<int>(columnName: 'monthNo', value: dataGridRow.monthNo)
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
      // billEntryList[dataRowIndex].quantity=double.parse(newCellValue.toString());
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