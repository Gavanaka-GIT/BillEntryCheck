import 'dart:convert';

import 'package:billentry/CustomWidgets/appBar.dart';
import 'package:billentry/CustomWidgets/customDrawer.dart';
import 'package:billentry/GlobalVariables.dart';
import 'package:billentry/billEntryMasScreen.dart';
import 'package:billentry/ledger.dart';
import 'package:billentry/main.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import 'package:http/http.dart' as http;

import 'Item.dart';





class itemReportPage extends StatefulWidget{
  const itemReportPage({super.key});

  @override
  _itemReport createState()=> _itemReport();
}

List<BranchTransferReceiptPending> BranchTransferReceiptList=[];
class _itemReport extends State<itemReportPage>{

  late BranchTransefrReceiptSource _BranchTransefrReceiptSource;
  String secondGridName="";
  bool mainChk=true;
  dynamic ledgerData;
  List<dynamic> transferList=[];
  final DataGridController _dataGridController = DataGridController();
  void _incrementCounter() {
    setState(() {
    });
  }

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

  Future<void> FetchMasData()async {
    String cutTableApi ="${ipAddress}api/getItemReportDatas";
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
          transferList= data['result'];
          approvalCnt =transferList.length;
          int cnt=1;
          try {
            for (int i = 0; i < transferList.length; i++) {
              BranchTransferReceiptList.add(BranchTransferReceiptPending(
                  cnt, transferList[i]['item'],
                  transferList[i]['Item_Group'].toString(),
                  transferList[i]['ItemCode'].toString(),
                  transferList[i]['Uom'].toString(),
                  transferList[i]['Hsn'].toString(),
                  transferList[i]['IsActive'].toString(),
                  transferList[i]['SalesRate'].toString(),
                  transferList[i]['ItemId'].toString()
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
      mainChk?
      Scaffold(
          appBar: CustomAppBar(userName: globalUserName,
              emailId: globalEmailId,
              onMenuPressed: (){
                Scaffold.of(context).openDrawer();
              }, barTitle: "ITEM REPORT"),
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
                    Expanded(child: Padding(padding: const EdgeInsets.all(15), child:
                    SizedBox(
                      width: width >500?width*0.5: width,
                      child: TextField(
                        decoration: InputDecoration(border:
                        OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
                            contentPadding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                            prefixIcon: const Icon(Icons.search),
                            hintText: "Search Item Name here",
                            labelText: "Search Item Name"
                        ),
                        onChanged: (String newValue){
                          if(newValue == "") {
                            if(mainChk) {
                              updateTable(BranchTransferReceiptList);
                            }else{
                              // updateDetTable(tempStockReportDet);
                            }
                          }else{
                            if(BranchTransferReceiptList.isNotEmpty ) {
                              if(mainChk) {
                                List<BranchTransferReceiptPending> tempSalesList = [];
                                for (int i = 0; i < BranchTransferReceiptList.length; i++) {
                                  if (BranchTransferReceiptList[i].itemName.toLowerCase().contains(
                                      newValue.toString().toLowerCase())) {
                                    print("Check Point Working");
                                    tempSalesList.add(BranchTransferReceiptList[i]);
                                  }
                                }
                                updateTable(tempSalesList);
                              }else{
                                // List<StockReportDet> tempSearchDet = [];
                                //
                                // for (int i = 0; i < tempStockReportDet.length; i++) {
                                //   if (tempStockReportDet[i].itemname.toLowerCase().contains(
                                //       newValue.toString().toLowerCase())) {
                                //     print("Check Point Working");
                                //     tempSearchDet.add(tempStockReportDet[i]);
                                //   }
                                // }
                                // updateDetTable(tempSearchDet);
                              }
                            }else{
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return
                                    AlertDialog(
                                      title: const Text('REASON'),
                                      content: const Text("No Data"), // Content of the dialog
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
                        },
                      ),
                    ),
                    )) ],),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:
                  [
                    Row( mainAxisAlignment:MainAxisAlignment.center,children: [
                      SizedBox(
                        width: width>500? width:width,
                        height: height * 0.65,
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
                                columnName: 'itemName',
                                width: width<500?166:width*0.4,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: const Text('ITEMNAME', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'itemGroup',
                                width: width<500?163:width*0.25,
                                allowFiltering: false,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: const Text('ITEMGRP', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'code',
                                width: width<500?130:width*0.25,
                                allowFiltering: false,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: const Text('CODE', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'uom',
                                width: width<500?115:width*0.25,
                                allowFiltering: false,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: const Text('UOM', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'hsncode',
                                width: width<500?115:width*0.25,
                                allowFiltering: false,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: const Text('HSNCODE', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'active',
                                width: width<500?124:width*0.25,
                                allowFiltering: true,
                                visible: true,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: const Text('ACTIVE', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'rate',
                                width: width<500?115:width*0.25,
                                allowFiltering: false,
                                visible: true,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: const Text('RATE', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              GridColumn(
                                columnName: 'itemId',
                                width: width<500?115:width*0.25,
                                allowFiltering: false,
                                visible: true,
                                label: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  alignment: Alignment.center,
                                  child: const Text('ITEMID', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
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
                      // setState(() {
                      //   mainChk=false;
                      //   // _stockReportDetSource = StockReportDetSource(stockReportDet: tempStockReportDet);
                      // });
                      print("Check Working");
                      if(_dataGridController.selectedRow?.getCells()[1].value!= null) {
                        print(_dataGridController.selectedRow?.getCells()[1].value);
                        String value=_dataGridController.selectedRow?.getCells()[1].value;
                        String masId =_dataGridController.selectedRow?.getCells()[8].value;
                        print(masId);
                        dynamic selectedVal;
                        // for(int i=0;i<transferList.length;i++) {
                        //   if(masId == transferList[i]['itemId'].toString()){
                        //     selectedVal= transferList[i];
                        //     break;
                        //   }
                        // }
                        print(selectedVal);
                        ledgerData= jsonEncode({"ledgerName":value, "selectedValue":masId});
                        setState(() {
                          mainChk=false;
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
                              title: const Text('REASON'),
                              content: const Text("Please Select The Row"), // Content of the dialog
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
                      label: const Text("Fetch Selected Item",style: TextStyle(color: Colors.white), ),
                      icon: const Icon(Icons.arrow_forward, color: Colors.pink,),
                      style: ElevatedButton.styleFrom(foregroundColor: Colors.black,
                        backgroundColor: const Color(0xFF004D40),),
                    )

                  ],)




              ],)
          )


      ):
      ItemLedger( approvedData: jsonEncode({"approve":true, "selectedData":ledgerData}),)
          //     Ledger()
          , onWillPop: () async{
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/Home/Item',
                  (Route<dynamic> route) => false, // This will remove all previous routes
            );
            return true;
          });

  }

}


class BranchTransferReceiptPending {
  BranchTransferReceiptPending(
      this.sno,
      this.itemName,
      this.itemGroup,
      this.code,
      this.uom,
      this.hsnCode,
      this.active,
      this.rate,
      this.itemId);

  int sno;
  String itemName;
  String itemGroup;
  String code;
  String uom;
  String hsnCode;
  var active;
  String rate;
  String itemId;
}


class BranchTransefrReceiptSource extends DataGridSource {
  BranchTransefrReceiptSource({required List<BranchTransferReceiptPending> salesReportMain}) {
    _billEntry = salesReportMain.map<DataGridRow>((dataGridRow) => DataGridRow(
      cells: [
        DataGridCell<int>(columnName: 'sno', value: dataGridRow.sno),
        DataGridCell<String>(columnName: 'itemName', value: dataGridRow.itemName),
        DataGridCell<String>(columnName: 'itemGroup', value: dataGridRow.itemGroup),
        DataGridCell<String>(columnName: 'code', value: dataGridRow.code),
        DataGridCell<String>(columnName: 'uom', value: dataGridRow.uom),
        DataGridCell<String>(columnName: 'hsnCode', value: dataGridRow.hsnCode),
        DataGridCell<String>(columnName: 'active', value: dataGridRow.active),
        DataGridCell(columnName: 'rate', value: dataGridRow.rate),
        DataGridCell<String>(columnName: 'itemId', value: dataGridRow.itemId)
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
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
          return Container(
              alignment: (dataGridCell.columnName == 'id' ||
                  dataGridCell.columnName == 'salary')
                  ? Alignment.center
                  : Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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