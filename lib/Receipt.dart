import 'dart:convert';

import 'package:billentry/CustomWidgets/appBar.dart';
import 'package:billentry/CustomWidgets/customDrawer.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:collection/collection.dart';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'GlobalVariables.dart';
import 'main.dart';

class Receipt extends StatelessWidget {
  const Receipt({super.key});

  @override
  Widget build(BuildContext context) {
    return const ReceiptPage();
  }
}

class ReceiptPage extends StatefulWidget {
  const ReceiptPage({super.key});

  @override
  State<ReceiptPage> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptPage> {
  String billType = "";
  String groupName = "";
  bool approvalValue = false;
  String item = "";
  String invoiceNum = "";
  double qty = 0.0;
  double discount = 0.0;
  double itemRate = 0.0;
  late DateTime now;
  var edate;
  var sdate;
  var globalUserName = "";
  var globalEmailId = "";
  var selected = false;
  var index = -1;
  var groupId = "";
  String customer = "";
  var customerId = "";

  _ReceiptScreenState() {
    now = DateTime.now();
    edate = DateFormat('dd/MM/yyyy').format(now);
    sdate = DateFormat('dd/MM/yyyy').format(now);
  }
  DateTime currentDate = DateTime.now();

  List<String> payType = ['cash on hand', 'debit card', "credit card"];
  List<Map<String, dynamic>> receiptdata = [
    // Example data, replace with your actual data
    {
      'sno': 1,
      'customer': 'John Doe',
      'BalAmt': 1000,
      'Amount': 500,
      'AdxAmount': 200,
      'List': 'A'
    },
    {
      'sno': 2,
      'customer': 'Jane Smith',
      'BalAmt': 1500,
      'Amount': 700,
      'AdxAmount': 300,
      'List': 'B'
    },
  ];
  TextEditingController date = TextEditingController();
  TextEditingController paymode = TextEditingController();
  TextEditingController qtyTextController = TextEditingController();
  TextEditingController itemTextController = TextEditingController();
  TextEditingController discTextController = TextEditingController();
  TextEditingController rateTextController = TextEditingController();
  TextEditingController gstTextController = TextEditingController();
  List<String> groupList = [];
  List<String> groupIdList = [];
  List<String> customerDataList = [];
  List<String> customerIdDataList = [];

  Future<void> fetchReceiptData() async {
    try {
      String url = "${ipAddress}api/getReceipt/receiptData/$globalCompId";
      print(url);
      print("---------------------------ip--------------------------------");
      final response = await http.get(
        Uri.parse(url),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print(
            "--------------------------------------------------------check 1-----------------------------------------------------");
        print(data);
        print(
            "--------------------------------------------------------check 77-----------------------------------------------------");
        print(data['valid']);
        if (data['valid']) {
          groupList.clear();
          groupIdList.clear();

          List<dynamic> getGroupData = data['bankdetiles'];
          for (int i = 0; i < getGroupData.length; i++) {
            groupIdList.add(getGroupData[i]['LedgerId'].toString());
            groupList.add(getGroupData[i]['Ledger'].toString());
          }

          customerDataList.clear();
          print(data['customerdata']);
          print(
              "--------------------------------------------------------check 888-----------------------------------------------------");
          customerDataList.clear();
          customerIdDataList.clear();

          List<dynamic> getCustomerName = data['customerdata'];
          for (int i = 0; i < getCustomerName.length; i++) {
            print(
                "--------------------------------------------------------check 007-----------------------------------------------------");
            print(getCustomerName[i]['Supplier'].toString());
            customerIdDataList.add(getCustomerName[i]['SupplierId'].toString());
            customerDataList.add(getCustomerName[i]['Supplier'].toString());
          }
        }
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Conn Err'),
              content: const Text(
                  "Please ReOpen this Page"), // Content of the dialog
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
    } catch (e) {
      print("Error");
      print(e);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Conn Err'),
            content:
                const Text("Please ReOpen this Page"), // Content of the dialog
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
    now = DateTime.now();
    fetchReceiptData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true, // Added missing callback
      child: Scaffold(
        backgroundColor: Colors.pink[50],
        appBar: CustomAppBar(
          userName: globalUserName,
          emailId: globalEmailId,
          onMenuPressed: () {
            Scaffold.of(context).openDrawer();
          },
          barTitle: "RECEIPT",
        ),
        drawer: const customDrawer(
          stkTransferCheck: false,
          brhTransferCheck: false,
        ),
        body: Container(
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //
                      const Padding(padding: EdgeInsets.all(5)),
                      BootstrapContainer(fluid: true, children: [
                        BootstrapRow(
                          children: <BootstrapCol>[
                            BootstrapCol(
                                sizes: 'col-md-12',
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextFormField(
                                    readOnly: true,
                                    textAlign: TextAlign.center,
                                    controller: TextEditingController()
                                      ..text = invoiceNum.toString(),
                                    decoration: const InputDecoration(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(15, 0, 0, 0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      labelText: 'Pay No',
                                      prefixIcon:
                                          const Icon(Icons.payment_outlined),
                                      fillColor: Colors.white,
                                      // contentPadding: EdgeInsets.symmetric(vertical: height*0.01),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ]),

//<------------------------------------------------date------------------------------------------------------>

                      const Padding(padding: EdgeInsets.all(5)),
                      BootstrapContainer(fluid: true, children: [
                        BootstrapRow(
                          children: <BootstrapCol>[
                            BootstrapCol(
                              sizes: 'col-md-12',
                              child: TextField(
                                controller: date,
                                readOnly: true,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                  labelText: 'To Date',
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors
                                            .red), // Change the border color here
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.calendar_month),
                                    onPressed: !approvalValue
                                        ? () async {
                                            DateTime? pickedDate =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2101),
                                            );
                                            if (pickedDate != null) {
                                              setState(() {
                                                date.text = pickedDate
                                                    .toString()
                                                    .split(' ')[0];
                                                edate = pickedDate
                                                    .toString()
                                                    .split(' ')[0];
                                              });
                                            }
                                          }
                                        : null,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]),

//<-----------------------------------------------------bank/cash------------------------------------------->

                      const SizedBox(height: 5),

                      // Code and Group in the same row with icons
                      Row(
                        children: [
                          Flexible(
                            flex: 10, // Group field will take 80% of the space
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: DropdownSearch(
                                  items: (filter, infiniteScrollProps) =>
                                      groupList,
                                  selectedItem: groupName,
                                  onChanged: (dynamic newValue) {
                                    groupName = newValue.toString();
                                    int idx = groupList.indexOf(groupName);
                                    if (idx != -1) {
                                      groupId = groupIdList[idx];
                                    }
                                  },
                                  validator: (value) {
                                    if (!groupList.contains(value.toString())) {
                                      return 'Please select the Bank';
                                    }
                                    return null;
                                  },
                                  decoratorProps: DropDownDecoratorProps(
                                    expands: false,
                                    decoration: InputDecoration(
                                      prefixIcon:
                                          const Icon(Icons.account_balance),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        vertical: 0.0,
                                        horizontal: 10,
                                      ),
                                      hintText:
                                          'Enter the Bank', // Placeholder text
                                    ),
                                  ),
                                  popupProps:
                                      const PopupPropsMultiSelection.menu(
                                    showSearchBox: true,
                                  ),
                                  compareFn: (item1, item2) => item1 == item2,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

//<-------------------------------------------PayMode------------------------------------------------->

                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 15, 25, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DropdownButtonFormField<String>(
                                isExpanded: true,
                                value: billType.isEmpty ? null : billType,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  labelText: "Pay Mode",
                                  prefixIcon:
                                      const Icon(Icons.payments_outlined),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 15),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                hint: const Text(
                                  'Select your Pay Mode',
                                  style: TextStyle(fontSize: 14),
                                ),
                                items: payType
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
                                    return 'Please select a Pay Mode.';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    item = value!;
                                  });
                                }
                                // !approvalValue
                                //     ? (value) {
                                //         if (billType != value) {
                                //           setState(() {
                                //             billType = value!;
                                //           });
                                //
                                //           if (value == "Non-GST Bill") {
                                //             // Additional logic here if needed
                                //           }
                                //         }
                                //       }
                                //     : null,

                                ),
                          ],
                        ),
                      ),

                      //<-------------------------------------------Customer------------------------------------------------->
                      Row(
                        children: [
                          Flexible(
                              flex:
                                  10, // Group field will take 80% of the space
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: DropdownSearch(
                                    items: (filter, infiniteScrollProps) =>
                                        customerDataList,
                                    selectedItem: customer,
                                    onChanged: (dynamic newValue) {
                                      customer = newValue.toString();
                                      int idx =
                                          customerDataList.indexOf(customer);
                                      if (idx != -1) {
                                        customerId = customerIdDataList[idx];
                                      }
                                    },
                                    validator: (value) {
                                      if (!customerDataList
                                          .contains(value.toString())) {
                                        return 'Please select the customer';
                                      }
                                      return null;
                                    },
                                    decoratorProps: DropDownDecoratorProps(
                                        expands: false,
                                        decoration: InputDecoration(
                                            prefixIcon: const Icon(Icons.group),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 0.0,
                                                    horizontal: 10))),
                                    popupProps:
                                        const PopupPropsMultiSelection.menu(
                                            showSearchBox: true),
                                    compareFn: (item1, item2) => item1 == item2,
                                  ),
                                ),
                              )),
                        ],
                      ),

                      const Padding(padding: EdgeInsets.all(10)),
                      Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: const Color(0xFF004D40),
                                textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            child: const Text(
                              'Add',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          !approvalValue
                              ? const SizedBox(width: 10)
                              : const SizedBox(
                                  height: 0.01,
                                ),
                          !approvalValue
                              ? ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.black,
                                      backgroundColor: const Color(0xFF004D40),
                                      textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold)),
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : const SizedBox(
                                  height: 0.01,
                                ),
                          const SizedBox(width: 10),
                          approvalValue
                              ? IconButton(
                                  onPressed: () async {},
                                  icon: const Icon(Icons.picture_as_pdf))
                              : const SizedBox(
                                  height: 0.01,
                                ),
                        ],
                      )),

                      //---------------------------------------data grid------------------------------------------------------->
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 200,
                        child: SfDataGridTheme(
                          data: SfDataGridThemeData(
                            currentCellStyle: const DataGridCurrentCellStyle(
                              borderWidth: 2,
                              borderColor: Colors.pinkAccent,
                            ),
                            selectionColor: Colors.lightGreen[50],
                            headerColor: const Color(0xFF004D40),
                          ),
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(
                                //width > 1400 ? 75
                                100,
                                0,
                                0,
                                0),

                            // Set a fixed height for the DataGrid
                            child: SfDataGrid(
                              allowEditing: true,
                              selectionMode: SelectionMode.single,
                              headerGridLinesVisibility:
                                  GridLinesVisibility.both,
                              // navigationMode: GridNavigationMode.cell,
                              source: ReceiptDataSource(receiptdata),
                              editingGestureType: EditingGestureType.tap,
                              columnWidthCalculationRange:
                                  ColumnWidthCalculationRange.visibleRows,
                              gridLinesVisibility: GridLinesVisibility.both,
                              columns: [
                                GridColumn(
                                  columnName: 'sno',
                                  width: 65,
                                  allowEditing: false,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    alignment: Alignment.centerLeft,
                                    child: const Text('SNO',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'customer',
                                  width: 200,
                                  allowEditing: false,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    alignment: Alignment.center,
                                    child: const Text('Customer',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'BalAmt',
                                  width: 200,
                                  allowEditing: false,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    alignment: Alignment.center,
                                    child: const Text('BalAmt',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'Amount',
                                  width: 200,
                                  allowEditing: false,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    alignment: Alignment.center,
                                    child: const Text('Amount',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'AdxAmount',
                                  width: 200,
                                  allowEditing: false,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    alignment: Alignment.center,
                                    child: const Text('AdxAmount',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                                GridColumn(
                                  columnName: 'List',
                                  width: 200,
                                  allowEditing: false,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    alignment: Alignment.center,
                                    child: const Text('List',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Padding(padding: EdgeInsets.all(10)),
                      Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: const Color(0xFF004D40),
                                textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            child: const Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Receiptclass {
  Receiptclass(this.sno, this.customer, this.balAmt, this.amount,
      this.adxAmount, this.list);

  final int sno;
  final String customer;
  final double balAmt;
  final double amount;
  final double adxAmount;
  final double list;
}

class ReceiptDataSource extends DataGridSource {
  ReceiptDataSource(List<Map<String, dynamic>> receiptdata) {
    _receiptdata = receiptdata
        .map<DataGridRow>((e) => DataGridRow(cells: [
              DataGridCell<int>(columnName: 'sno', value: e['sno']),
              DataGridCell<String>(
                  columnName: 'customer', value: e['customer']),
              DataGridCell<double>(columnName: 'BalAmt', value: e['BalAmt']),
              DataGridCell<double>(columnName: 'Amount', value: e['Amount']),
              DataGridCell<double>(
                  columnName: 'AdxAmount', value: e['AdxAmount']),
              DataGridCell<String>(columnName: 'List', value: e['List']),
            ]))
        .toList();
  }

  List<DataGridRow> _receiptdata = [];

  @override
  List<DataGridRow> get rows => _receiptdata;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}
