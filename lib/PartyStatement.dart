import 'dart:convert';

import 'package:billentry/CustomWidgets/appBar.dart';
import 'package:billentry/CustomWidgets/customDrawer.dart';
import 'package:billentry/GlobalVariables.dart';
import 'package:billentry/billEntryMasScreen.dart';
import 'package:billentry/ledger.dart';
import 'package:billentry/main.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;
import 'package:billentry/main.dart';

import 'Item.dart';





class partyReportPage extends StatefulWidget{
  const partyReportPage({super.key});

  @override
  _partyReport createState()=> _partyReport();
}

List<BranchTransferReceiptPending> BranchTransferReceiptList=[];
class _partyReport extends State<partyReportPage>{

  late BranchTransefrReceiptSource _BranchTransefrReceiptSource;
  bool mainChk=true;
  dynamic ledgerData;
  List<dynamic> transferList=[];
  final DataGridController _dataGridController = DataGridController();
  void _incrementCounter() {
    setState(() {
    });
  }

  late DateTime now;
  var startDate;


  TextEditingController sDate = new TextEditingController();
  TextEditingController eDate = new TextEditingController();
  String party="";
  String partyMasId="";
  List partyList =[];
  List partyMasIdList=[];

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

  List<List<dynamic>> splitTransferList(List<dynamic> transferList, int chunkSize) {
    List<List<dynamic>> paginatedList = [];

    for (int i = 0; i < transferList.length; i += chunkSize) {
      int end = (i + chunkSize > transferList.length) ? transferList.length : i + chunkSize;
      paginatedList.add(transferList.sublist(i, end));
    }

    return paginatedList;
  }

  Future<void> FetchMasData()async {
    String cutTableApi ="${ipAddress}api/getSupplierNames/${globalCompId}";
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          showLoaderDialog(context);
        } catch (e) {
          print("Error showing loading dialog: ${e.toString()}");
        }
      });
      final response = await http.get(Uri.parse(cutTableApi));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print("check point");
        print(data);
        print(data['valid']);
        var chk = data['valid'];

        if (chk) {
          List<dynamic> partyTempList= data['result'];
          print(partyTempList);
          try {
            for (int i = 0; i < partyTempList.length; i++) {
              partyList.add(partyTempList[i]['Supplier'].toString());
              partyMasIdList.add(partyTempList[i]['SupplierId'].toString());
            }
          }catch(e){
            print(e);
          }
          // SalesReportMainList = [SalesReportMain(1, "check1", "0000", "00000000"),
          //   SalesReportMain(2, "jjt check2", "0000", "00000000"),
          //   SalesReportMain(3, "check3", "0000", "00000000")
          // ];
          // _BranchTransefrReceiptSource = BranchTransefrReceiptSource(salesReportMain: BranchTransferReceiptList);
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return
                AlertDialog(
                  title: const Text('REASON'),
                  content: const Text("No Data Found"),
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
          BranchTransferReceiptList = [];
          _BranchTransefrReceiptSource =
              BranchTransefrReceiptSource(salesReportMain: BranchTransferReceiptList);
        }

        _incrementCounter();
      } else {
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
        BranchTransferReceiptList = [];
        _BranchTransefrReceiptSource = BranchTransefrReceiptSource(salesReportMain: BranchTransferReceiptList);
      }
    }catch(e){
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


  Future<void> fetchTableData()async {
    String cutTableApi ="${ipAddress}api/getPartyLedgerGridData";
    try {

      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          showLoaderDialog(context);
        } catch (e) {
          print("Error showing loading dialog: ${e.toString()}");
        }
      });
      print(partyMasId);
      print(sDate.text.toString());
      print(eDate.text.toString());
      print('------------------------------');
      final response = await http.post(Uri.parse(cutTableApi),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          }, body: jsonEncode({
            "supplierId" : partyMasId,
            "fromDt" : sDate.text.toString(),
            "toDt" : eDate.text.toString()
          }));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print("check point");
        print(data);
        print(data['valid']);
        var chk = data['valid'];

        if (chk) {
          transferList= data['result'];
          if(transferList.length>=48){
            transferList= transferList.sublist(0,48);
          }
          approvalCnt =transferList.length;
          int cnt=1;
          try {
            BranchTransferReceiptList.clear();
            var debitAmountTotal=0.0;
            var creditAmountTotal=0.0;
            for (int i = 0; i < transferList.length; i++) {
              BranchTransferReceiptList.add(BranchTransferReceiptPending(
                  cnt, transferList[i]['Cons_Date'],
                  transferList[i]['Narration'].toString(),
                  transferList[i]['Cons_No'].toString(),
                  transferList[i]['DrAmt'].toString(),
                  transferList[i]['CrAmt'].toString()
              ));
              debitAmountTotal = double.parse(transferList[i]['DrAmt'].toString())+debitAmountTotal;
              creditAmountTotal = double.parse(transferList[i]['CrAmt'].toString())+creditAmountTotal;
              cnt++;
            }
            BranchTransferReceiptList.add(BranchTransferReceiptPending(cnt, '', 'TOTAL',
                '', debitAmountTotal.toString(), creditAmountTotal.toString()));
            transferList.add({"Cons_Date":"", "Narration":"TOTAL","Cons_No":"",
              "DrAmt":debitAmountTotal.toString(),"CrAmt":creditAmountTotal.toString()});
            cnt++;
            var closingBalance=creditAmountTotal-debitAmountTotal;
            if(closingBalance<0) {
              closingBalance = -closingBalance;
            }
            BranchTransferReceiptList.add(BranchTransferReceiptPending(cnt, '', 'CLOSING BALANCE',
                '','', closingBalance.toString()));
            transferList.add({"Cons_Date":"", "Narration":"CLOSING BALANCE","Cons_No":"",
              "DrAmt":"","CrAmt":closingBalance.toString()});
          }catch(e){
            print(e);
          }
          // SalesReportMainList = [SalesReportMain(1, "check1", "0000", "00000000"),
          //   SalesReportMain(2, "jjt check2", "0000", "00000000"),
          //   SalesReportMain(3, "check3", "0000", "00000000")
          // ];
          _BranchTransefrReceiptSource = BranchTransefrReceiptSource(salesReportMain: BranchTransferReceiptList);
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return
                AlertDialog(
                  title: const Text('REASON'),
                  content: const Text("No Data Found"),
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
          BranchTransferReceiptList = [];
          _BranchTransefrReceiptSource =
              BranchTransefrReceiptSource(salesReportMain: BranchTransferReceiptList);
        }

        _incrementCounter();
      } else {
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
        BranchTransferReceiptList = [];
        _BranchTransefrReceiptSource = BranchTransefrReceiptSource(salesReportMain: BranchTransferReceiptList);
      }
    }catch(e){
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
    super.initState();
    // showLoaderDialog(context);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight]);
    BranchTransferReceiptList = [];
    _BranchTransefrReceiptSource = BranchTransefrReceiptSource(salesReportMain: BranchTransferReceiptList);
    now = DateTime.now();
    startDate =  DateFormat('yyyy-MM-dd THH:mm:ss.SSS').format(now);


    int currentYear = now.year;
    DateTime financialYearStart;

    print(now.month);
    print("--------------------");
    // if (now.month == 4) {
      financialYearStart = DateTime(currentYear - 1, 4, 1); // Previous FY starts on April 1 of last year
    // } else {
    //   financialYearStart = DateTime(currentYear - 2, 4, 1); // Previous FY starts on April 1 of two years ago
    // }

    // Format the date to the desired format
    String formattedDate = DateFormat('yyyy-MM-dd').format(financialYearStart);
    sDate.text= formattedDate.toString().split(' ')[0];
    eDate.text= startDate.toString().split(' ')[0];
    FetchMasData();
  }



  @override
  Widget build (BuildContext context){
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;


    print(height);
    print(width);

    updateTable(List<BranchTransferReceiptPending> branchTransferList){
      setState(() {
        _BranchTransefrReceiptSource =
            BranchTransefrReceiptSource(salesReportMain: branchTransferList);
      });
    }

    return
      WillPopScope(child:
      Scaffold(
          appBar: CustomAppBar(userName: globalUserName,
              emailId: globalEmailId,
              onMenuPressed: (){
                Scaffold.of(context).openDrawer();
              }, barTitle: "PARTY STATEMENT"),
          drawer: const customDrawer(stkTransferCheck: true,
              brhTransferCheck: false),
          body:
          SingleChildScrollView(
              child:Column(children: [
                Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // !mainChk ? Padding(padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    //   child: ElevatedButton.icon(
                    //     onPressed: (){
                    //       setState(() {
                    //         mainChk=true;
                    //       });
                    //     },
                    //     style: ElevatedButton.styleFrom(foregroundColor: Colors.black,
                    //       backgroundColor: Color(0xFF004D40),),
                    //     label: Text("Back",style: TextStyle(color: Colors.white),),
                    //     icon: Icon(Icons.arrow_back, color: Colors.pink,), ),)
                    //     :SizedBox(width: 1,),
                    Expanded(child: Padding(padding: const EdgeInsets.all(15),
                      child:
                    SizedBox(
                      width: width >500?width*0.5: width,
                      child:
                      // TextField(
                      //   decoration: InputDecoration(border:
                      //   OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
                      //       contentPadding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      //       prefixIcon: const Icon(Icons.search),
                      //       hintText: "Search Party Name here",
                      //       labelText: "Search Party Name"
                      //   ),
                      //   onChanged: (String newValue){
                      //     if(newValue == "") {
                      //       if(mainChk) {
                      //         updateTable(BranchTransferReceiptList);
                      //       }else{
                      //         // updateDetTable(tempStockReportDet);
                      //       }
                      //     }else{
                      //       if(BranchTransferReceiptList.isNotEmpty ) {
                      //         if(mainChk) {
                      //           // List<BranchTransferReceiptPending> tempSalesList = [];
                      //           // for (int i = 0; i < BranchTransferReceiptList.length; i++) {
                      //           //   if (BranchTransferReceiptList[i].itemName.toLowerCase().contains(
                      //           //       newValue.toString().toLowerCase())) {
                      //           //     print("Check Point Working");
                      //           //     tempSalesList.add(BranchTransferReceiptList[i]);
                      //           //   }
                      //           // }
                      //           // updateTable(tempSalesList);
                      //         }else{
                      //           // List<StockReportDet> tempSearchDet = [];
                      //           //
                      //           // for (int i = 0; i < tempStockReportDet.length; i++) {
                      //           //   if (tempStockReportDet[i].itemname.toLowerCase().contains(
                      //           //       newValue.toString().toLowerCase())) {
                      //           //     print("Check Point Working");
                      //           //     tempSearchDet.add(tempStockReportDet[i]);
                      //           //   }
                      //           // }
                      //           // updateDetTable(tempSearchDet);
                      //         }
                      //       }else{
                      //         showDialog(
                      //           context: context,
                      //           builder: (BuildContext context) {
                      //             return
                      //               AlertDialog(
                      //                 title: const Text('REASON'),
                      //                 content: const Text("No Data"), // Content of the dialog
                      //                 actions: <Widget>[
                      //                   TextButton(
                      //                     child: const Text('OK'),
                      //                     onPressed: () {
                      //                       Navigator.of(context).pop(); // Close the dialog
                      //                     },
                      //                   ),
                      //                 ],
                      //               );
                      //           },
                      //         );
                      //       }
                      //     }
                      //   },
                      // ),
                      DropdownSearch(
                        items: (filter, infiniteScrollProps)=>partyList,
                        selectedItem: party,
                        onChanged: (dynamic newValue){
                          int idx=partyList.indexOf(newValue.toString());
                          party = partyList[idx];
                          partyMasId = partyMasIdList[idx];
                          print("partyMasId");
                          print(partyMasId);
                        },
                        validator: (value){
                          // if(!partyList.contains(value.toString())){
                          //   return 'Please select the Group';
                          // }
                          // return null;
                        },
                        decoratorProps: DropDownDecoratorProps(
                            expands: false,
                            decoration:InputDecoration(
                                labelText: "Party",
                                prefixIcon: const Icon(Icons.group),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)) ,
                                contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 10)
                            )),
                        popupProps: const PopupPropsMultiSelection.menu(showSearchBox: true),
                        compareFn:(item1, item2) => item1 ==item2,
                      ),
                    ),
                    )) ],),

                    SizedBox(
                    width: width>500?width*0.5:width,
                    child: Row(children: [
                    Expanded(child:
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                      child:TextField(
                        controller: sDate,
                        // textAlign: TextAlign.center,
                        readOnly: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                          labelText: 'From Date',
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red), // Change the border color here
                          ),
                          // contentPadding: EdgeInsets.symmetric(vertical: height*0.01),
                          filled: true,
                          fillColor: Colors.transparent,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  sDate.text = pickedDate.toString().split(' ')[0];
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),),
                      Expanded(child:
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                        child: TextField(
                          controller: eDate,
                          // textAlign: TextAlign.center,
                          readOnly: true,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                            labelText: 'To Date',
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red), // Change the border color here
                            ),
                            // contentPadding: EdgeInsets.symmetric(vertical: height*0.01),
                            filled: true,
                            fillColor: Colors.transparent,
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                );
                                if (pickedDate != null) {
                                  setState(() {
                                    eDate.text = pickedDate.toString().split(' ')[0];
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ),),],)
                    ),

                    ElevatedButton.icon(onPressed: (){
                      if(partyMasId != ""){
                        fetchTableData();
                      }else{
                        showDialog(context: context, builder:(BuildContext context) {
                          return
                            AlertDialog(
                              title: const Text('REASON'),
                              content: const Text("Please Select The Party Name"), // Content of the dialog
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                ),
                              ],
                            );
                        } );
                      }
                    },  label:
                    const Text("Search",style: TextStyle(color: Colors.white), ),
                      icon: const Icon(Icons.search, color: Colors.white,),
                      style: ElevatedButton.styleFrom(foregroundColor: Colors.black,
                        backgroundColor: const Color(0xFF004D40),),),
                SizedBox(height: 5,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:
                  [
                    Row( mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                      SizedBox(
                        width: width>500? width:width,
                        height: height * 0.55,
                        // alignment:  Alignment.center,
                        //
                        child:
                        SfDataGridTheme(
                          data: SfDataGridThemeData(
                            filterIconColor: Colors.pink,
                            currentCellStyle: const DataGridCurrentCellStyle(
                              borderWidth: 2,
                              borderColor: Colors.pinkAccent,
                            ),
                            selectionColor: Colors.lightGreen[50],
                            headerColor: const Color(0xFF004D40),
                          ),
                          child: SfDataGrid(
                            allowEditing: true,
                            selectionMode: SelectionMode.single,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            source: _BranchTransefrReceiptSource,
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
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.centerLeft,
                                  child: const Text('SNO', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'date',
                                width: width<500?166:width*0.4,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: const Text('DATE', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'narration',
                                width: width<500?163:width*0.25,
                                allowFiltering: false,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: const Text('NARRATION', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'vNo',
                                width: width<500?130:width*0.25,
                                allowFiltering: false,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: const Text('VNO', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'deboit',
                                width: width<500?115:width*0.25,
                                allowFiltering: false,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: const Text('DEBIT', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'credit',
                                width: width<500?115:width*0.25,
                                allowFiltering: false,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: const Text('CREDIT', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                ),
                              )
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
                      if(transferList.length>0){
                        final pdf = pw.Document();
                        double pdfWidth =PdfPageFormat.a4.width-40;
                        List<dynamic> firstPageTransferList=[];
                        List<dynamic> secondPageTransferList=[];
                        if(transferList.length>47){
                          firstPageTransferList=transferList.sublist(0,48);
                          secondPageTransferList= transferList.sublist(48,transferList.length);
                        }else{
                          firstPageTransferList=transferList;
                        }
                        int chunkSize = 48;

                        List<List<dynamic>> paginatedList = splitTransferList(transferList, chunkSize);
                        for (int i = 0; i < paginatedList.length; i++) {
                          pdf.addPage(
                            pw.Page(
                              pageFormat: PdfPageFormat.a4,
                              margin: pw.EdgeInsets.zero,
                              build: (pw.Context context) {
                                return
                                  pw.Stack(
                                  children: [
                                    // Outer border ensuring full visibility
                                    pw.Positioned(
                                      top: 0,
                                      left: 0,
                                      child: pw.Container(
                                        width: PdfPageFormat.a4.width,
                                        height: PdfPageFormat.a4.height,
                                        decoration: const pw.BoxDecoration(
                                          border: pw.Border(
                                            top: pw.BorderSide(width: 2),
                                            left: pw.BorderSide(width: 2),
                                            right: pw.BorderSide(width: 2),
                                            bottom: pw.BorderSide(width: 2),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Header rectangle with text
                                    pw.Positioned(
                                      top: 20,
                                      left: 20,
                                      child: pw.Container(
                                        width: PdfPageFormat.a4.width - 40, // Adjusted for margins
                                        height: PdfPageFormat.a4.height - 40,
                                        decoration: pw.BoxDecoration(
                                          border: pw.Border.all(width: 1),
                                        ),
                                        child: pw.Column(
                                            children: [
                                              pw.Container(
                                                  width: PdfPageFormat.a4.width - 40,
                                                  height: 70,
                                                  decoration: const pw.BoxDecoration(
                                                      border: pw.Border(bottom: pw.BorderSide(
                                                          width: 1, color: PdfColors.black))
                                                  ),
                                                  child: pw.Column(

                                                      children: [
                                                        pw.Text(globalCompanyName,
                                                            style: pw.TextStyle(
                                                                fontWeight: pw.FontWeight.bold)),
                                                        pw.Text(
                                                            "${globalAddress1}, ${globalAddress2}, ${globalAddress3} - ${globalPinCode}",
                                                            style: pw.TextStyle(
                                                                fontWeight: pw.FontWeight.bold)),
                                                        pw.Text("Phone : ${globalPhoneNumber}" +
                                                            ", Cell : ${globalMobileNumber}" +
                                                            ", Email : ${globalEmailId}"
                                                            , style: pw.TextStyle(
                                                                fontWeight: pw.FontWeight.bold))
                                                      ],
                                                      mainAxisAlignment: pw.MainAxisAlignment
                                                          .center,
                                                      crossAxisAlignment: pw.CrossAxisAlignment
                                                          .center)
                                              ),
                                              pw.Container(
                                                  width: PdfPageFormat.a4.width - 40,
                                                  height: 20,
                                                  decoration: const pw.BoxDecoration(
                                                      border: pw.Border(bottom: pw.BorderSide(
                                                          width: 1, color: PdfColors.black))
                                                  ),
                                                  child:
                                                  pw.Column(
                                                    children: [
                                                      pw.Text(
                                                          "Account Ledger Of ${party} ( From ${DateFormat(
                                                              'dd-MMM-yy').format(DateTime.parse(
                                                              sDate.text))} To ${DateFormat(
                                                              'dd-MMM-yy').format(
                                                              DateTime.parse(eDate.text))} )",
                                                          style: pw.TextStyle(
                                                              fontWeight: pw.FontWeight.bold)),


                                                    ],
                                                    mainAxisAlignment: pw.MainAxisAlignment.center,)

                                              ),
                                              pw.Container(width: PdfPageFormat.a4.width - 40,
                                                  decoration: const pw.BoxDecoration(
                                                      border: pw.Border(
                                                          bottom: pw.BorderSide(
                                                              width: 1, color: PdfColors.black))),
                                                  child:
                                                  pw.Column(
                                                      children: [
                                                        pw.Table(
                                                          border: const pw.TableBorder(
                                                              right: pw.BorderSide(
                                                                  width: 1, color: PdfColors.black),
                                                              left: pw.BorderSide(
                                                                  width: 1, color: PdfColors.black),
                                                              top: pw.BorderSide(
                                                                  width: 1, color: PdfColors.black),
                                                              verticalInside: pw.BorderSide(
                                                                  width: 1, color: PdfColors.black)
                                                          ),
                                                          columnWidths: {
                                                            0: const pw.FlexColumnWidth(0.15),
                                                            1: const pw.FlexColumnWidth(0.3),
                                                            2: const pw.FlexColumnWidth(0.15),
                                                            3: const pw.FlexColumnWidth(0.2),
                                                            4: const pw.FlexColumnWidth(0.2)
                                                          },
                                                          children: [
                                                            // Header Row
                                                            pw.TableRow(
                                                              decoration: const pw.BoxDecoration(
                                                                  color: PdfColors.grey300,
                                                                  border: pw.Border(
                                                                      bottom: pw.BorderSide(
                                                                          width: 1,
                                                                          color: PdfColors.black))
                                                              ),
                                                              children: [
                                                                pw.Padding(
                                                                  padding: const pw.EdgeInsets.all(
                                                                      5),
                                                                  child: pw.Text("Date",
                                                                      style: pw.TextStyle(
                                                                          fontWeight: pw.FontWeight
                                                                              .bold, fontSize: 10),
                                                                      textAlign: pw.TextAlign
                                                                          .center),
                                                                ),
                                                                pw.Padding(
                                                                  padding: const pw.EdgeInsets.all(
                                                                      5),
                                                                  child: pw.Text("Narration",
                                                                      style: pw.TextStyle(
                                                                          fontWeight: pw.FontWeight
                                                                              .bold, fontSize: 10),
                                                                      softWrap: false,
                                                                      textAlign: pw.TextAlign
                                                                          .center),
                                                                ),
                                                                pw.Padding(
                                                                  padding: const pw.EdgeInsets.all(
                                                                      5),
                                                                  child: pw.Text("V.No",
                                                                      style: pw.TextStyle(
                                                                          fontWeight: pw.FontWeight
                                                                              .bold, fontSize: 10),
                                                                      textAlign: pw.TextAlign
                                                                          .center),
                                                                ),
                                                                pw.Padding(
                                                                  padding: const pw.EdgeInsets.all(
                                                                      5),
                                                                  child: pw.Text("Debit",
                                                                      style: pw.TextStyle(
                                                                          fontWeight: pw.FontWeight
                                                                              .bold, fontSize: 10),
                                                                      softWrap: true,
                                                                      textAlign: pw.TextAlign
                                                                          .center),
                                                                ),
                                                                pw.Padding(
                                                                  padding: const pw.EdgeInsets.all(
                                                                      5),
                                                                  child: pw.Text("Credit",
                                                                      style: pw.TextStyle(
                                                                          fontWeight: pw.FontWeight
                                                                              .bold, fontSize: 10),
                                                                      textAlign: pw.TextAlign
                                                                          .center),
                                                                )
                                                              ],
                                                            ),
                                                            // Data Rows (Dynamically generated)
                                                            for (var item in paginatedList[i])
                                                              pw.TableRow(
                                                                children: [
                                                                  pw.Padding(
                                                                    padding: const pw.EdgeInsets
                                                                        .fromLTRB(5, 1, 5, 1),
                                                                    child: pw.Text(item['Cons_Date']
                                                                        .toString(),
                                                                        style: pw.TextStyle(
                                                                            fontWeight: pw
                                                                                .FontWeight.normal,
                                                                            fontSize: 10),
                                                                        softWrap: false,
                                                                        textAlign: pw.TextAlign
                                                                            .center),
                                                                  ),
                                                                  pw.Padding(
                                                                    padding: const pw.EdgeInsets
                                                                        .fromLTRB(5, 1, 5, 1),
                                                                    child: pw.Text(item['Narration']
                                                                        .toString(),
                                                                        style: pw.TextStyle(
                                                                            fontWeight: pw
                                                                                .FontWeight.normal,
                                                                            fontSize: 10),
                                                                        softWrap: false,
                                                                        textAlign: pw.TextAlign
                                                                            .center),
                                                                  ),
                                                                  pw.Padding(
                                                                    padding: const pw.EdgeInsets
                                                                        .fromLTRB(5, 1, 5, 1),
                                                                    child: pw.Expanded(
                                                                      child: pw.Text(item['Cons_No']
                                                                          .toString(),
                                                                          style: pw.TextStyle(
                                                                              fontWeight: pw
                                                                                  .FontWeight
                                                                                  .normal,
                                                                              fontSize: 10),
                                                                          softWrap: false,
                                                                          textAlign: pw.TextAlign
                                                                              .center),),
                                                                  ),
                                                                  pw.Padding(
                                                                    padding: const pw.EdgeInsets
                                                                        .fromLTRB(5, 1, 5, 1),
                                                                    child: pw.Text(
                                                                        item['DrAmt'].toString(),
                                                                        style: pw.TextStyle(
                                                                            fontWeight: pw
                                                                                .FontWeight.normal,
                                                                            fontSize: 10),
                                                                        softWrap: false,
                                                                        textAlign: pw.TextAlign
                                                                            .right),
                                                                  ),
                                                                  pw.Padding(
                                                                    padding: const pw.EdgeInsets
                                                                        .fromLTRB(5, 1, 5, 1),
                                                                    child: pw.Text(
                                                                        item['CrAmt'].toString(),
                                                                        style: pw.TextStyle(
                                                                            fontWeight: pw
                                                                                .FontWeight.normal,
                                                                            fontSize: 10),
                                                                        softWrap: false,
                                                                        textAlign: pw.TextAlign
                                                                            .right),
                                                                  )
                                                                ],
                                                              ),
                                                          ],
                                                        )
                                                      ]
                                                  )
                                              )
                                            ]
                                        ),
                                      ),
                                    ),
                                    // Subheader rectangle with text

                                  ],
                                );
                              },
                            ),
                          );
                        }

                        // if(secondPageTransferList.length>0){
                        //   pdf.addPage(
                        //     pw.Page(
                        //       pageFormat: PdfPageFormat.a4,
                        //       margin: pw.EdgeInsets.zero,
                        //       build: (pw.Context context) {
                        //         return pw.Stack(
                        //           children: [
                        //             // Outer border ensuring full visibility
                        //             pw.Positioned(
                        //               top: 0,
                        //               left: 0,
                        //               child: pw.Container(
                        //                 width: PdfPageFormat.a4.width,
                        //                 height: PdfPageFormat.a4.height,
                        //                 decoration: const pw.BoxDecoration(
                        //                   border: pw.Border(
                        //                     top: pw.BorderSide(width: 2),
                        //                     left: pw.BorderSide(width: 2),
                        //                     right: pw.BorderSide(width: 2),
                        //                     bottom: pw.BorderSide(width: 2),
                        //                   ),
                        //                 ),
                        //               ),
                        //             ),
                        //             // Header rectangle with text
                        //             pw.Positioned(
                        //               top: 20,
                        //               left: 20,
                        //               child: pw.Container(
                        //                 width: PdfPageFormat.a4.width - 40, // Adjusted for margins
                        //                 height: PdfPageFormat.a4.height-40,
                        //                 decoration: pw.BoxDecoration(
                        //                   border: pw.Border.all(width: 1),
                        //                 ),
                        //                 child: pw.Column(
                        //                     children: [
                        //                       pw.Container(
                        //                           width: PdfPageFormat.a4.width-40,
                        //                           height: 70,
                        //                           decoration: const pw.BoxDecoration(
                        //                               border: pw.Border(bottom: pw.BorderSide(
                        //                                   width: 1, color: PdfColors.black))
                        //                           ),
                        //                           child: pw.Column(
                        //
                        //                               children: [
                        //                                 pw.Text(globalCompanyName, style:  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        //                                 pw.Text("${globalAddress1}, ${globalAddress2}, ${globalAddress3} - ${globalPinCode}",
                        //                                     style:  pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        //                                 pw.Text("Phone : ${globalPhoneNumber}" + ", Cell : ${globalMobileNumber}"+ ", Email : ${globalEmailId}"
                        //                                     , style:  pw.TextStyle(fontWeight: pw.FontWeight.bold))
                        //                               ],
                        //                               mainAxisAlignment: pw.MainAxisAlignment.center,
                        //                               crossAxisAlignment: pw.CrossAxisAlignment.center)
                        //                       ),
                        //                       pw.Container(
                        //                           width: PdfPageFormat.a4.width-40,
                        //                           height: 20,
                        //                           decoration: const pw.BoxDecoration(
                        //                               border: pw.Border(bottom: pw.BorderSide(
                        //                                   width: 1, color: PdfColors.black))
                        //                           ),
                        //                           child:
                        //                           pw.Column(
                        //                             children:[
                        //                               pw.Text("Account Ledger Of ${party} ( From ${DateFormat('dd-MMM-yy').format(DateTime.parse(sDate.text))} To ${DateFormat('dd-MMM-yy').format(DateTime.parse(eDate.text))} )",
                        //                                   style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        //
                        //
                        //                             ], mainAxisAlignment: pw.MainAxisAlignment.center,)
                        //
                        //                       ),
                        //                       pw.Container(width: PdfPageFormat.a4.width-40,
                        //                           decoration: const pw.BoxDecoration(
                        //                               border: pw.Border(
                        //                                   bottom: pw.BorderSide(width: 1, color: PdfColors.black))),
                        //                           child:pw.Column(
                        //                               children: [
                        //                                 pw.Table(
                        //                                   border: const pw.TableBorder(
                        //                                       right: pw.BorderSide(width: 1, color: PdfColors.black),
                        //                                       left: pw.BorderSide(width: 1, color: PdfColors.black),
                        //                                       top: pw.BorderSide(width: 1, color: PdfColors.black),
                        //                                       verticalInside: pw.BorderSide(width: 1, color: PdfColors.black)
                        //                                   ),
                        //                                   columnWidths: {
                        //                                     0: const pw.FlexColumnWidth(0.15),
                        //                                     1: const pw.FlexColumnWidth(0.3),
                        //                                     2: const pw.FlexColumnWidth(0.15),
                        //                                     3: const pw.FlexColumnWidth(0.2),
                        //                                     4: const pw.FlexColumnWidth(0.2)
                        //                                   },
                        //                                   children: [
                        //                                     // Header Row
                        //                                     pw.TableRow(
                        //                                       decoration: const pw.BoxDecoration(
                        //                                           color: PdfColors.grey300,
                        //                                           border: pw.Border(bottom:pw.BorderSide(width: 1, color: PdfColors.black))
                        //                                       ),
                        //                                       children: [
                        //                                         pw.Padding(
                        //                                           padding: const pw.EdgeInsets.all(5),
                        //                                           child: pw.Text("Date", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                        //                                               textAlign: pw.TextAlign.center),
                        //                                         ),
                        //                                         pw.Padding(
                        //                                           padding: const pw.EdgeInsets.all(5),
                        //                                           child: pw.Text("Narration", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                        //                                               softWrap: false, textAlign: pw.TextAlign.center),
                        //                                         ),
                        //                                         pw.Padding(
                        //                                           padding: const pw.EdgeInsets.all(5),
                        //                                           child: pw.Text("V.No", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                        //                                               textAlign: pw.TextAlign.center),
                        //                                         ),
                        //                                         pw.Padding(
                        //                                           padding: const pw.EdgeInsets.all(5),
                        //                                           child: pw.Text("Debit",
                        //                                               style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                        //                                               softWrap: true, textAlign: pw.TextAlign.center),
                        //                                         ),
                        //                                         pw.Padding(
                        //                                           padding: const pw.EdgeInsets.all(5),
                        //                                           child: pw.Text("Credit", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                        //                                               textAlign: pw.TextAlign.center),
                        //                                         )
                        //                                       ],
                        //                                     ),
                        //                                     // Data Rows (Dynamically generated)
                        //                                     for (var item in secondPageTransferList)
                        //                                       pw.TableRow(
                        //                                         children: [
                        //                                           pw.Padding(
                        //                                             padding: const pw.EdgeInsets.fromLTRB(5, 1, 5, 1),
                        //                                             child: pw.Text(item['Cons_Date'].toString(), style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 10),
                        //                                                 softWrap: false, textAlign: pw.TextAlign.center),
                        //                                           ),
                        //                                           pw.Padding(
                        //                                             padding: const pw.EdgeInsets.fromLTRB(5, 1, 5, 1),
                        //                                             child: pw.Text(item['Narration'].toString(), style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 10), softWrap: false,
                        //                                                 textAlign: pw.TextAlign.center),
                        //                                           ),
                        //                                           pw.Padding(
                        //                                             padding: const pw.EdgeInsets.fromLTRB(5, 1, 5, 1),
                        //                                             child: pw.Expanded(child: pw.Text(item['Cons_No'].toString(),
                        //                                                 style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 10), softWrap: false, textAlign: pw.TextAlign.center) , ),
                        //                                           ),
                        //                                           pw.Padding(
                        //                                             padding: const pw.EdgeInsets.fromLTRB(5, 1, 5, 1),
                        //                                             child: pw.Text(item['DrAmt'].toString(),
                        //                                                 style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 10),softWrap: false,
                        //                                                 textAlign: pw.TextAlign.center) ,
                        //                                           ),
                        //                                           pw.Padding(
                        //                                             padding: const pw.EdgeInsets.fromLTRB(5, 1, 5, 1),
                        //                                             child: pw.Text(item['CrAmt'].toString(), style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 10),
                        //                                                 softWrap: false,
                        //                                                 textAlign: pw.TextAlign.center),
                        //                                           )
                        //                                         ],
                        //                                       ),
                        //                                   ],
                        //                                 )
                        //                               ]
                        //                           )
                        //                       )
                        //                     ]
                        //                 ),
                        //               ),
                        //             ),
                        //             // Subheader rectangle with text
                        //
                        //           ],
                        //         );
                        //       },
                        //     ),
                        //   );
                        // }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                WillPopScope(child:  Scaffold(
                                  appBar: AppBar(title: const Text(
                                      'Party Statement')),
                                  body: pdf != null ? PdfPreview(
                                    build: (format) => pdf.save(),
                                  ) : const Scaffold(body: Center(
                                    child: Text(
                                      "Pdf Fetching Error",
                                      style: TextStyle(
                                          fontSize: 16),),),),
                                ),  onWillPop: () async{
                                  billEntryList.clear();
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/Home',
                                        (Route<dynamic> route) => false, // This will remove all previous routes
                                  );
                                  return true;
                                })
                            ,
                          ),
                        );

                      }else{
                        showDialog(context: context, builder:(BuildContext context) {
                          return
                            AlertDialog(
                              title: const Text('REASON'),
                              content: const Text("No Data To Preview"), // Content of the dialog
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                ),
                              ],
                            );
                        } );
                      }
                    },
                      label: const Text("Preview",style: TextStyle(color: Colors.white), ),
                      icon: const Icon(Icons.preview, color: Colors.white,),
                      style: ElevatedButton.styleFrom(foregroundColor: Colors.black,
                        backgroundColor: const Color(0xFF004D40),),
                    )

                  ],)




              ],)
          )


      )
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


class BranchTransferReceiptPending {
  BranchTransferReceiptPending(
      this.sno,
      this.date,
      this.narration,
      this.vNo,
      this.debit,
      this.credit,
      );

  int sno;
  String date;
  String narration;
  String vNo;
  String debit;
  String credit;
}


class BranchTransefrReceiptSource extends DataGridSource {
  BranchTransefrReceiptSource({required List<BranchTransferReceiptPending> salesReportMain}) {
    _billEntry = salesReportMain.map<DataGridRow>((dataGridRow) => DataGridRow(
      cells: [
        DataGridCell<int>(columnName: 'sno', value: dataGridRow.sno),
        DataGridCell<String>(columnName: 'date', value: dataGridRow.date),
        DataGridCell<String>(columnName: 'narration', value: dataGridRow.narration),
        DataGridCell<String>(columnName: 'vNo', value: dataGridRow.vNo),
        DataGridCell<String>(columnName: 'debit', value: dataGridRow.debit),
        DataGridCell<String>(columnName: 'credit', value: dataGridRow.credit)
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
      _billEntry[dataRowIndex].getCells()[rowColumnIndex.columnIndex+2]=DataGridCell<int>(columnName: 'phone', value: value);

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
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
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
    // Check if the narration column contains 'TOTAL'
    final bool isTotalRow = row
        .getCells()
        .any((dataGridCell) => dataGridCell.columnName == 'narration' &&
        dataGridCell.value.toString().contains('TOTAL')||dataGridCell.value.toString().contains('CLOSING BALANCE'));

    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((dataGridCell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            dataGridCell.value.toString(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: isTotalRow ? FontWeight.bold : FontWeight.normal,
              color: isTotalRow ? Colors.black : Colors.grey[800], // Black for TOTAL rows, gray for others
            ),
          ),
        );
      }).toList(),
    );
  }

  RegExp _getRegExp(bool isNumericKeyBoard, String columnName) {
    return isNumericKeyBoard ? RegExp('[0-9]') : RegExp('[a-zA-Z ]');
  }
}