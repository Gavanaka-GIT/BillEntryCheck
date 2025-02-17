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

late List<DataGridRow> _ReceiptData = [];

class ReceiptPage extends StatefulWidget {
  const ReceiptPage({super.key});

  @override
  State<ReceiptPage> createState() => _ReceiptScreenState();
}

late ReceiptDataSource _ReceiptDataSource;
late ListDataSource _listDataSource;

class _ReceiptScreenState extends State<ReceiptPage> {
  TextEditingController AMOUNT = TextEditingController();
  final DataGridController dataGridController = DataGridController();
  final DataGridController ListGridController = DataGridController();

  String billType = "";
  String groupName = "";
  bool approvalValue = false;
  String item = "";
  double qty = 0.0;
  double discount = 0.0;
  double itemRate = 0.0;
  late DateTime now;
  var edate;
  var sdate;

  var selected = false;
  var index = -1;
  var groupId = "";
  String customer = "";
  var customerId = "";
  String balamount = "";
  String amount = "";
  int idx = -1;
  var payno = "";

  _ReceiptScreenState() {
    now = DateTime.now();
    edate = DateFormat('dd/MM/yyyy').format(now);
    sdate = DateFormat('dd/MM/yyyy').format(now);
  }
  DateTime currentDate = DateTime.now();

  List<String> payType = ['IMPS', 'NEFT', "CHEQUE", "CASH", "QR"];
  List<Receiptclass> receiptdata = [];
  List<ListReceiptclass> listreceiptdata = [];

  TextEditingController date = TextEditingController();
  TextEditingController paymode = TextEditingController();
  TextEditingController qtyTextController = TextEditingController();
  TextEditingController itemTextController = TextEditingController();
  TextEditingController discTextController = TextEditingController();
  TextEditingController rateTextController = TextEditingController();
  TextEditingController gstTextController = TextEditingController();
  TextEditingController payNoController = new TextEditingController();
  List<String> groupList = [];
  List<String> groupIdList = [];
  List<String> customerDataList = [];
  List<String> customerIdDataList = [];
  List<String> balanceDataList = [];
  List<String> suplierListData = [];
  List<String> transNo = [];
  List<String> transDate = [];
  List<String> supplier = [];
  List<String> amountList = [];
  List<String> supplierId = [];

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(
            color: Color(0xFF004D40),
          ),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text("..In Progress")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(child: alert, onWillPop: () => Future.value(false));
      },
    );
  }

  Future<void> saveData(List textData, List receiptData2, List listData) async {
    String cutTableApi = "${ipAddress}api/saveReceiptEntry";
    print(cutTableApi);
    showLoaderDialog(context);
    try {
      print(
          "----------------------------------------------------------cutTableApi");
      final response = await http.post(Uri.parse(cutTableApi),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({
            "TEXTDAT": textData,
            "RECEIPTDAT": receiptData2,
            "LISTDAT": listData,
          }));
      print(jsonEncode);
      print(
          "------------------------------------------------------------------------");
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
              return AlertDialog(
                title: const Text('REASON'),
                content: const Text("Receipt Saved Successfully"),
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

          receiptdata = [];
          listreceiptdata = [];

          setState(() {
            date.clear();
            _ReceiptDataSource = ReceiptDataSource(receiptdata: []);
            _listDataSource = ListDataSource(Listdata: []);
          });
        } else {
          // Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('REASON'),
                content: const Text("Receipt Insertion Failed"),
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
      } else {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
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
    } catch (e) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
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
          customerIdDataList.clear();
          balanceDataList.clear();
          print(data['customerdata']);
          List<dynamic> getCustomerName = data['customerdata'];
          for (int i = 0; i < getCustomerName.length; i++) {
            customerIdDataList.add(getCustomerName[i]['SupplierId'].toString());
            customerDataList.add(getCustomerName[i]['Supplier'].toString());
            balanceDataList.add(getCustomerName[i]['BalAmt'].toString());
          }
          try {
            DateTime now = DateTime.now();
            var startYear;
            if (now.month >= 4) {
              startYear = now.year % 100; // Extract last two digits of the year
            } else {
              startYear = (now.year - 1) %
                  100; // Extract last two digits of the previous year
            }
            var payNo = globalPrefix +
                "/" +
                "PRC" +
                "/" +
                startYear.toString() +
                "/" +
                data['payNo'].toString();
            payNoController.text = payNo;
          } catch (e) {
            print(e);
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
  //----------------------------------------------------------------------------------------------------------------------------------

  Future<void> fetchListData(var supplierId) async {
    try {
      String url =
          "${ipAddress}api/getReceipt/receiptDataList/$globalCompId/$supplierId";
      print(url);
      print("---------------------------ip1--------------------------------");
      final response = await http.get(
        Uri.parse(url),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print(
            "--------------------------------------------------------check00-----------------------------------------------------");
        print(data);
        print(
            "--------------------------------------------------------check 00-----------------------------------------------------");
        print(data['valid']);
        if (data['valid']) {
          List<dynamic> invdata = data["listdetiles"];
          for (int i = 0; i < invdata.length; i++) {
            listreceiptdata.add(ListReceiptclass(
                invdata[i]["TransNo"].toString(),
                invdata[i]["Supplier"].toString(),
                double.parse(invdata[i]["Amount"].toString()),
                double.parse(invdata[i]["Amount"].toString()),
                invdata[i]["TransDate"].toString(),
                invdata[i]["SupplierId"].toString()));
          }
          setState(() {
            _listDataSource = ListDataSource(Listdata: listreceiptdata);
          });
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
    date.text = DateTime.now().toString().split(' ')[0];
    edate = DateTime.now().toString().split(' ')[0];

    _ReceiptDataSource = ReceiptDataSource(receiptdata: receiptdata);
    _listDataSource = ListDataSource(Listdata: listreceiptdata); // });

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
            barTitle: "RECEIPT"),
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
                                    textAlign: TextAlign.start,
                                    controller: payNoController,
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
                      BootstrapContainer(
                        fluid: true,
                        children: [
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
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
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
                        ],
                      ),

//<-----------------------------------------------------bank/cash------------------------------------------->

                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Flexible(
                            flex: 10, // Group field will take 80% of the space
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 2, 20, 0),
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
                                      label: Text("Bank"),

                                      prefixIcon:
                                          const Icon(Icons.account_balance),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        vertical: 0.0,
                                        horizontal: 15,
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
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Flexible(
                            flex: 10, // Group field will take 80% of the space
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 1, 20, 1),
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 0),
                                  child: DropdownButtonFormField<String>(
                                    value: billType.isEmpty ? null : billType,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      labelText: "Pay Mode",
                                      prefixIcon:
                                          const Icon(Icons.payments_outlined),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 15),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    hint: const Text(
                                      'Select The Pay Mode',
                                    ),
                                    items: payType
                                        .map((item) => DropdownMenuItem<String>(
                                              value: item,
                                              child: Text(
                                                item,
                                                style: const TextStyle(
                                                    fontSize: 14),
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
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      //<-------------------------------------------Customer------------------------------------------------->
                      Row(
                        children: [
                          Flexible(
                              flex:
                                  10, // Group field will take 80% of the space
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 1, 20, 0),
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: DropdownSearch(
                                    items: (filter, infiniteScrollProps) =>
                                        customerDataList,
                                    selectedItem: customer,
                                    onChanged: (dynamic newValue) {
                                      setState(() {
                                        customer = newValue.toString();
                                        int idx =
                                            customerDataList.indexOf(customer);
                                        if (idx != -1) {
                                          customerId = customerIdDataList[idx];
                                          balamount = balanceDataList[idx];
                                        }
                                      });
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
                                            label: Text("Customer"),
                                            prefixIcon: const Icon(Icons.group),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 0.0,
                                                    horizontal: 15))),
                                    popupProps:
                                        const PopupPropsMultiSelection.menu(
                                            showSearchBox: true),
                                    compareFn: (item1, item2) => item1 == item2,
                                  ),
                                ),
                              )),
                        ],
                      ),

                      //---------------------------------------Balance amount---------------------------------------->

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
                                    controller: TextEditingController()
                                      ..text = balamount,
                                    decoration: const InputDecoration(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(15, 0, 0, 0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      labelText: 'Balance Amount',
                                      prefixIcon:
                                          Icon(Icons.currency_rupee_rounded),
                                      fillColor: Colors.white,
                                      // contentPadding: EdgeInsets.symmetric(vertical: height*0.01),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ]),
                      //-----------------------------amount--------------------------------------------------
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
                                    keyboardType: TextInputType.number,
                                    controller: AMOUNT,
                                    decoration: const InputDecoration(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(15, 0, 0, 0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      labelText: 'Amount',

                                      prefixIcon:
                                          Icon(Icons.currency_rupee_rounded),
                                      filled: true,

                                      fillColor: Colors.white,
                                      // contentPadding: EdgeInsets.symmetric(vertical: height*0.01),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        amount = value;
                                      });
                                    },
                                  ),
                                )),
                          ],
                        ),
                      ]),

                      //--------------------------------add,delete------------------------------>
                      const Padding(padding: EdgeInsets.all(10)),
                      Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              print("CHECK1");
                              if (double.parse(amount) > 0.0) {
                                var exist = false;
                                for (int i = 0; i < receiptdata.length; i++) {
                                  if (receiptdata[i].customer == customer) {
                                    exist = true;
                                    print("exist:$exist");
                                    break;
                                  }
                                  print(exist);
                                }
                                if (!exist) {
                                  print("CHECK2");
                                  receiptdata.add(Receiptclass(
                                      receiptdata.length + 1,
                                      customer,
                                      double.parse(balamount),
                                      double.parse(AMOUNT.text.toString()),
                                      double.parse(AMOUNT.text.toString()) -
                                          double.parse(balamount),
                                      customerId));
                                  print("CHECK3");

                                  setState(() {
                                    _ReceiptDataSource = ReceiptDataSource(
                                        receiptdata: receiptdata);
                                    _listDataSource = ListDataSource(
                                        Listdata: listreceiptdata);
                                  });

                                  int customerIdx =
                                      customerDataList.indexOf(customer);
                                  var supplierId =
                                      customerIdDataList[customerIdx];
                                  fetchListData(supplierId);
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Check'),
                                        content: const Text(
                                            "Customer Name was Already Exist"), // Content of the dialog
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('OK'),
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
                                  onPressed: () {
                                    if (idx != -1) {
                                      var deletedCustomerName =
                                          receiptdata[idx - 1].customer;
                                      receiptdata.removeAt(idx - 1);
                                      for (int i = 0;
                                          i < receiptdata.length;
                                          i++) {
                                        receiptdata[i].sno = i + 1;
                                      }

                                      List<int> deleteArray = [];
                                      listreceiptdata.removeWhere((value) =>
                                          value.customer ==
                                          deletedCustomerName);
                                      print(deleteArray);

                                      setState(() {
                                        _ReceiptDataSource = ReceiptDataSource(
                                            receiptdata: receiptdata);
                                        _listDataSource = ListDataSource(
                                            Listdata: listreceiptdata);
                                      });
                                    }
                                  },
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
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Container(
                                        height: 300,
                                        width: 700,
                                        child: SingleChildScrollView(
                                          child: SfDataGridTheme(
                                            data: SfDataGridThemeData(
                                              currentCellStyle:
                                                  const DataGridCurrentCellStyle(
                                                borderWidth: 2,
                                                borderColor: Colors.pinkAccent,
                                              ),
                                              selectionColor:
                                                  Colors.lightGreen[50],
                                              headerColor:
                                                  const Color(0xFF004D40),
                                            ),
                                            child: Container(
                                              margin: const EdgeInsets.fromLTRB(
                                                  //width > 1400 ? 75
                                                  0,
                                                  0,
                                                  0,
                                                  0),

                                              // Set a fixed height for the DataGrid
                                              child: SfDataGrid(
                                                allowEditing: true,
                                                controller: ListGridController,
                                                selectionMode:
                                                    SelectionMode.single,
                                                headerGridLinesVisibility:
                                                    GridLinesVisibility.both,
                                                // navigationMode: GridNavigationMode.cell,
                                                source: _listDataSource,
                                                editingGestureType:
                                                    EditingGestureType.tap,
                                                columnWidthCalculationRange:
                                                    ColumnWidthCalculationRange
                                                        .visibleRows,
                                                gridLinesVisibility:
                                                    GridLinesVisibility.both,
                                                columns: [
                                                  GridColumn(
                                                    columnName: 'tranSno',
                                                    width: 200,
                                                    allowEditing: false,
                                                    label: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16.0),
                                                      alignment:
                                                          Alignment.center,
                                                      child: const Text(
                                                          'TransNo',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                  ),
                                                  GridColumn(
                                                    columnName: 'transDate',
                                                    width: 200,
                                                    allowEditing: false,
                                                    label: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16),
                                                      alignment:
                                                          Alignment.center,
                                                      child: const Text(
                                                          'Trans Date',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                  ),
                                                  GridColumn(
                                                    columnName: 'customer',
                                                    width: 200,
                                                    allowEditing: false,
                                                    label: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16),
                                                      alignment:
                                                          Alignment.center,
                                                      child: const Text(
                                                          'Customer',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                  ),
                                                  GridColumn(
                                                    columnName: 'BalAmt',
                                                    width: 200,
                                                    allowEditing: false,
                                                    label: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16),
                                                      alignment:
                                                          Alignment.center,
                                                      child: const Text(
                                                          'Balance Amt',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                  ),
                                                  GridColumn(
                                                    columnName: 'recAmount',
                                                    width: 200,
                                                    allowEditing: false,
                                                    label: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16),
                                                      alignment:
                                                          Alignment.center,
                                                      child: const Text(
                                                          'Received Amt',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)),
                                                    ),
                                                  ),
                                                ],
                                                onSelectionChanged:
                                                    (addedRows, removedRows) {
                                                  // print(addedRows.toString() + "addedRows");
                                                  // idx = dataGridController.currentCell.rowIndex;
                                                  // print(index.toString() + "index");

                                                  print(ListGridController
                                                      .selectedRow
                                                      ?.getCells()[0]
                                                      .value);
                                                  idx = ListGridController
                                                      .selectedRow
                                                      ?.getCells()[0]
                                                      .value;
                                                  print(
                                                      idx.toString() + "index");
                                                },
                                              ),
                                            ),
                                          ),
                                        )),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("OK"))
                                    ],
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: const Color(0xFF004D40),
                                textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            child: const Text(
                              'List',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
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
                                0,
                                0,
                                0,
                                0),

                            // Set a fixed height for the DataGrid
                            child: SfDataGrid(
                              allowEditing: true,
                              controller: dataGridController,
                              selectionMode: SelectionMode.single,
                              headerGridLinesVisibility:
                                  GridLinesVisibility.both,
                              // navigationMode: GridNavigationMode.cell,
                              source: _ReceiptDataSource,
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
                                  columnName: 'AdvAmount',
                                  width: 200,
                                  allowEditing: false,
                                  label: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    alignment: Alignment.center,
                                    child: const Text('AdvAmount',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ],
                              onSelectionChanged: (addedRows, removedRows) {
                                // print(addedRows.toString() + "addedRows");
                                // idx = dataGridController.currentCell.rowIndex;
                                // print(index.toString() + "index");

                                print(dataGridController.selectedRow
                                    ?.getCells()[0]
                                    .value);
                                idx = dataGridController.selectedRow
                                    ?.getCells()[0]
                                    .value;
                                print(idx.toString() + "index");
                              },
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
                            onPressed: () {
                              if (groupName == "") {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Alert"),
                                        content: Text("Please Select the Bank"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("OK"))
                                        ],
                                      );
                                    });
                                return;
                              }
                              //add paymode validation
                              if (item == "") {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Alert"),
                                        content:
                                            Text("Please Select the Pay mode"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("OK"))
                                        ],
                                      );
                                    });
                                return;
                              }
                              if (customer == "") {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Alert"),
                                        content:
                                            Text("Please Select the Customer"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("OK"))
                                        ],
                                      );
                                    });
                                return;
                              }

                              if (receiptdata.length == 0) {
                                return;
                              }
                              List<dynamic> textData = [];

                              textData.add({
                                "PAYNO": payNoController.text.toString(),
                                "EDATE": date.text.toString(),
                                "BANK": groupName,
                                "BANKID": groupId,
                                "PAYTYPE": item,
                                "CompId": globalCompId
                              });

                              List<dynamic> reciptDataList = [];
                              for (int i = 0; i < receiptdata.length; i++) {
                                reciptDataList.add({
                                  "CUSTOMER": receiptdata[i].customer,
                                  "CUSTOMERID": receiptdata[i].customerId,
                                  "BALAMT": receiptdata[i].balAmt,
                                  "AMOUNT": receiptdata[i].amount,
                                  "ADVAMOUNT": receiptdata[i].advAmount,
                                });
                              } //Store the receipt data

                              List<dynamic> listReceiptDataList = [];
                              for (int i = 0; i < listreceiptdata.length; i++) {
                                listReceiptDataList.add({
                                  "TRANSNO": listreceiptdata[i].tranSno,
                                  "TRANSDATE": listreceiptdata[i].transDate,
                                  "CUSTOMER": listreceiptdata[i].customer,
                                  "CUSTOMERID": listreceiptdata[i].customerId,
                                  "BALAMT": listreceiptdata[i].balAmt,
                                  "RECAMOUNT": listreceiptdata[i].recAmount,
                                });
                              } //Store the receipt data

                              saveData(textData, reciptDataList,
                                  listReceiptDataList);
                            },
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
      this.advAmount, this.customerId);

  int sno;
  String customer;
  double balAmt;
  double amount;
  double advAmount;
  String customerId;
}

class ReceiptDataSource extends DataGridSource {
  ReceiptDataSource({required List<Receiptclass> receiptdata}) {
    print(receiptdata.toString() + "receiptdata");
    _ReceiptData = receiptdata
        .map<DataGridRow>((dataGridRow) => DataGridRow(
              cells: [
                DataGridCell<int>(columnName: 'sno', value: dataGridRow.sno),
                DataGridCell<String>(
                    columnName: 'customer', value: dataGridRow.customer),
                DataGridCell<double>(
                    columnName: 'BalAmt', value: dataGridRow.balAmt),
                DataGridCell<double>(
                    columnName: 'Amount', value: dataGridRow.amount),
                DataGridCell<double>(
                    columnName: 'AdvAmount', value: dataGridRow.advAmount),
              ],
            ))
        .toList();
  }

  List<DataGridRow> _ReceiptData = [];

  @override
  List<DataGridRow> get rows => _ReceiptData;

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

class ListReceiptclass {
  ListReceiptclass(this.tranSno, this.customer, this.balAmt, this.recAmount,
      this.transDate, this.customerId);

  String tranSno;
  String transDate;
  String customer;
  double balAmt;
  double recAmount;
  String customerId;
}

class ListDataSource extends DataGridSource {
  ListDataSource({required List<ListReceiptclass> Listdata}) {
    print(Listdata.toString() + "Listdata");
    _ListData = Listdata.map<DataGridRow>((dataGridRow) => DataGridRow(
          cells: [
            DataGridCell<String>(
                columnName: 'tranSno', value: dataGridRow.tranSno),
            DataGridCell<String>(
                columnName: 'transDate', value: dataGridRow.transDate),
            DataGridCell<String>(
                columnName: 'customer', value: dataGridRow.customer),
            DataGridCell<double>(
                columnName: 'BalAmt', value: dataGridRow.balAmt),
            DataGridCell<double>(
                columnName: 'recAmount', value: dataGridRow.recAmount),
          ],
        )).toList();
  }

  List<DataGridRow> _ListData = [];

  @override
  List<DataGridRow> get rows => _ListData;

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
