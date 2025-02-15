import 'package:billentry/CustomWidgets/appBar.dart';
import 'package:billentry/CustomWidgets/customDrawer.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'main.dart';

class Payments extends StatelessWidget {
  const Payments({super.key});

  @override
  Widget build(BuildContext context) {
    return const PaymentPage();
  }
}

late List<DataGridRow> _paymentData = [];

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _ReceiptScreenState();
}

late PaymentSource _receiptDataSource;
late ListDataSource _listDataSource;

class _ReceiptScreenState extends State<PaymentPage> {
  TextEditingController AMOUNT = TextEditingController();
  final DataGridController dataGridController = DataGridController();
  final DataGridController listGridController = DataGridController();

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
  String balAmount = "";
  String amount = "";
  int idx = -1;
  var payNo = "";

  _ReceiptScreenState() {
    now = DateTime.now();
    edate = DateFormat('dd/MM/yyyy').format(now);
    sdate = DateFormat('dd/MM/yyyy').format(now);
  }
  DateTime currentDate = DateTime.now();

  List<String> payType = ['IMPS', 'NEFT', "CHEQUE", "CASH", "QR"];
  List<PaymentClass> paymentData = [];
  List<ListPaymentClass> listReceiptData = [];

  TextEditingController date = TextEditingController();
  TextEditingController payMode = TextEditingController();
  TextEditingController qtyTextController = TextEditingController();
  TextEditingController itemTextController = TextEditingController();
  TextEditingController discTextController = TextEditingController();
  TextEditingController rateTextController = TextEditingController();
  TextEditingController gstTextController = TextEditingController();
  TextEditingController payNoController = TextEditingController();
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

  // Future<void> saveData(List textData, List receiptData2, List listData) async {
  //   String cutTableApi = "${ipAddress}api/saveReceiptEntry";
  //   print(cutTableApi);
  //   showLoaderDialog(context);
  //   try {
  //     print(
  //         "----------------------------------------------------------cutTableApi");
  //     final response = await http.post(Uri.parse(cutTableApi),
  //         headers: <String, String>{
  //           'Content-Type': 'application/json; charset=UTF-8',
  //         },
  //         body: jsonEncode({
  //           "TEXTDAT": textData,
  //           "RECEIPTDAT": receiptData2,
  //           "LISTDAT": listData,
  //         }));
  //     print(jsonEncode);
  //     print(
  //         "------------------------------------------------------------------------");
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> data = json.decode(response.body);
  //       print(data);
  //       print(data['savChk']);
  //       var saveChk = data['savChk'];
  //
  //       if (saveChk) {
  //         Navigator.pop(context);
  //         showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: const Text('REASON'),
  //               content: const Text("Receipt Saved Successfully"),
  //               // Content of the dialog
  //               actions: <Widget>[
  //                 TextButton(
  //                   child: const Text('OK'),
  //                   onPressed: () {
  //                     Navigator.of(context).pop(); // Close the dialog
  //                   },
  //                 ),
  //               ],
  //             );
  //           },
  //         );
  //
  //         receiptdata = [];
  //         listreceiptdata = [];
  //
  //         setState(() {
  //           date.clear();
  //           _ReceiptDataSource = ReceiptDataSource(receiptdata: []);
  //           _listDataSource = ListDataSource(Listdata: []);
  //         });
  //       } else {
  //         // Navigator.pop(context);
  //         showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: const Text('REASON'),
  //               content: const Text("Receipt Insertion Failed"),
  //               // Content of the dialog
  //               actions: <Widget>[
  //                 TextButton(
  //                   child: const Text('OK'),
  //                   onPressed: () {
  //                     Navigator.of(context).pop(); // Close the dialog
  //                   },
  //                 ),
  //               ],
  //             );
  //           },
  //         );
  //       }
  //     } else {
  //       Navigator.pop(context);
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: const Text('REASON'),
  //             content: const Text("Conn Err"), // Content of the dialog
  //             actions: <Widget>[
  //               TextButton(
  //                 child: const Text('OK'),
  //                 onPressed: () {
  //                   Navigator.of(context).pop(); // Close the dialog
  //                 },
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     }
  //   } catch (e) {
  //     Navigator.pop(context);
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: const Text('REASON'),
  //           content: const Text("Conn Err"), // Content of the dialog
  //           actions: <Widget>[
  //             TextButton(
  //               child: const Text('OK'),
  //               onPressed: () {
  //                 Navigator.of(context).pop(); // Close the dialog
  //               },
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }

  // Future<void> fetchReceiptData() async {
  //   try {
  //     String url = "${ipAddress}api/getReceipt/receiptData/$globalCompId";
  //     print(url);
  //     print("---------------------------ip--------------------------------");
  //     final response = await http.get(
  //       Uri.parse(url),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> data = json.decode(response.body);
  //       print(
  //           "--------------------------------------------------------check 1-----------------------------------------------------");
  //       print(data);
  //       print(
  //           "--------------------------------------------------------check 77-----------------------------------------------------");
  //       print(data['valid']);
  //       if (data['valid']) {
  //         groupList.clear();
  //         groupIdList.clear();
  //
  //         List<dynamic> getGroupData = data['bankdetiles'];
  //         for (int i = 0; i < getGroupData.length; i++) {
  //           groupIdList.add(getGroupData[i]['LedgerId'].toString());
  //           groupList.add(getGroupData[i]['Ledger'].toString());
  //         }
  //
  //         customerDataList.clear();
  //         customerIdDataList.clear();
  //         balanceDataList.clear();
  //         print(data['customerdata']);
  //         List<dynamic> getCustomerName = data['customerdata'];
  //         for (int i = 0; i < getCustomerName.length; i++) {
  //           customerIdDataList.add(getCustomerName[i]['SupplierId'].toString());
  //           customerDataList.add(getCustomerName[i]['Supplier'].toString());
  //           balanceDataList.add(getCustomerName[i]['BalAmt'].toString());
  //         }
  //         payNoController.text = data['payNo'];
  //       }
  //     } else {
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: const Text('Conn Err'),
  //             content: const Text(
  //                 "Please ReOpen this Page"), // Content of the dialog
  //             actions: <Widget>[
  //               TextButton(
  //                 child: const Text('OK'),
  //                 onPressed: () {
  //                   Navigator.of(context).pop(); // Close the dialog
  //                 },
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     }
  //   } catch (e) {
  //     print("Error");
  //     print(e);
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: const Text('Conn Err'),
  //           content:
  //               const Text("Please ReOpen this Page"), // Content of the dialog
  //           actions: <Widget>[
  //             TextButton(
  //               child: const Text('OK'),
  //               onPressed: () {
  //                 Navigator.of(context).pop(); // Close the dialog
  //               },
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }
  //----------------------------------------------------------------------------------------------------------------------------------

  // Future<void> fetchListData(var supplierId) async {
  //   try {
  //     String url =
  //         "${ipAddress}api/getReceipt/receiptDataList/$globalCompId/$supplierId";
  //     print(url);
  //     print("---------------------------ip1--------------------------------");
  //     final response = await http.get(
  //       Uri.parse(url),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> data = json.decode(response.body);
  //       print(
  //           "--------------------------------------------------------check00-----------------------------------------------------");
  //       print(data);
  //       print(
  //           "--------------------------------------------------------check 00-----------------------------------------------------");
  //       print(data['valid']);
  //       if (data['valid']) {
  //         List<dynamic> invdata = data["listdetiles"];
  //         for (int i = 0; i < invdata.length; i++) {
  //           listreceiptdata.add(ListReceiptclass(
  //               invdata[i]["TransNo"].toString(),
  //               invdata[i]["Supplier"].toString(),
  //               double.parse(invdata[i]["Amount"].toString()),
  //               double.parse(invdata[i]["Amount"].toString()),
  //               invdata[i]["TransDate"].toString(),
  //               invdata[i]["SupplierId"].toString()));
  //         }
  //         setState(() {
  //           _listDataSource = ListDataSource(Listdata: listreceiptdata);
  //         });
  //       }
  //     } else {
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: const Text('Conn Err'),
  //             content: const Text(
  //                 "Please ReOpen this Page"), // Content of the dialog
  //             actions: <Widget>[
  //               TextButton(
  //                 child: const Text('OK'),
  //                 onPressed: () {
  //                   Navigator.of(context).pop(); // Close the dialog
  //                 },
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     }
  //   } catch (e) {
  //
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: const Text('Conn Err'),
  //           content:
  //               const Text("Please ReOpen this Page"), // Content of the dialog
  //           actions: <Widget>[
  //             TextButton(
  //               child: const Text('OK'),
  //               onPressed: () {
  //                 Navigator.of(context).pop(); // Close the dialog
  //               },
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   }
  // }

  @override
  void initState() {
    super.initState();
    date.text = DateTime.now().toString().split(' ')[0];
    edate = DateTime.now().toString().split(' ')[0];

    _receiptDataSource = PaymentSource(paymentData: paymentData);
    _listDataSource = ListDataSource(listData: listReceiptData); // });

    // fetchReceiptData();
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
            barTitle: "PAYMENT"),
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
                                      prefixIcon: Icon(Icons.payment_outlined),
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
                                      return 'Please select the Bank/Cash';
                                    }
                                    return null;
                                  },
                                  decoratorProps: DropDownDecoratorProps(
                                    expands: false,
                                    decoration: InputDecoration(
                                      label: const Text("Bank/Cash"),

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
                                          'Enter the Bank/Cash', // Placeholder text
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
                                          balAmount = balanceDataList[idx];
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
                                            label: const Text("Customer"),
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
                                      ..text = balAmount,
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
                              if (double.parse(amount) > 0.0) {
                                var exist = false;
                                for (int i = 0; i < paymentData.length; i++) {
                                  if (paymentData[i].customer == customer) {
                                    exist = true;
                                    break;
                                  }
                                }
                                if (!exist) {
                                  paymentData.add(PaymentClass(
                                      paymentData.length + 1,
                                      customer,
                                      double.parse(balAmount),
                                      double.parse(AMOUNT.text.toString()),
                                      double.parse(AMOUNT.text.toString()) -
                                          double.parse(balAmount),
                                      customerId));

                                  setState(() {
                                    _receiptDataSource =
                                        PaymentSource(paymentData: paymentData);
                                    _listDataSource = ListDataSource(
                                        listData: listReceiptData);
                                  });

                                  int customerIdx =
                                      customerDataList.indexOf(customer);
                                  var supplierId =
                                      customerIdDataList[customerIdx];
                                  // fetchListData(supplierId);
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
                                          paymentData[idx - 1].customer;
                                      paymentData.removeAt(idx - 1);
                                      for (int i = 0;
                                          i < paymentData.length;
                                          i++) {
                                        paymentData[i].sno = i + 1;
                                      }

                                      List<int> deleteArray = [];
                                      listReceiptData.removeWhere((value) =>
                                          value.customer ==
                                          deletedCustomerName);

                                      setState(() {
                                        _receiptDataSource = PaymentSource(
                                            paymentData: paymentData);
                                        _listDataSource = ListDataSource(
                                            listData: listReceiptData);
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
                                    content: SizedBox(
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
                                                controller: listGridController,
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
                                                  idx = listGridController
                                                      .selectedRow
                                                      ?.getCells()[0]
                                                      .value;
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
                                          child: const Text("OK"))
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
                              source: _receiptDataSource,
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
                                idx = dataGridController.selectedRow
                                    ?.getCells()[0]
                                    .value;
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
                                        title: const Text("Alert"),
                                        content: const Text(
                                            "Please Select the Bank"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("OK"))
                                        ],
                                      );
                                    });
                                return;
                              }
                              //add PayMode validation
                              if (item == "") {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Alert"),
                                        content: const Text(
                                            "Please Select the Pay mode"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("OK"))
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
                                        title: const Text("Alert"),
                                        content: const Text(
                                            "Please Select the Customer"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("OK"))
                                        ],
                                      );
                                    });
                                return;
                              }

                              if (paymentData.length == 0) {
                                return;
                              }
                              List<dynamic> textData = [];

                              textData.add({
                                "PAYNO": payNoController.text.toString(),
                                "EDATE": date.text.toString(),
                                "BANK": groupName,
                                "BANKID": groupId,
                                "PAYTYPE": item
                              });

                              List<dynamic> reciptDataList = [];
                              for (int i = 0; i < paymentData.length; i++) {
                                reciptDataList.add({
                                  "CUSTOMER": paymentData[i].customer,
                                  "CUSTOMERID": paymentData[i].customerId,
                                  "BALAMT": paymentData[i].balAmt,
                                  "AMOUNT": paymentData[i].amount,
                                  "ADVAMOUNT": paymentData[i].advAmount,
                                });
                              } //Store the receipt data

                              List<dynamic> listReceiptDataList = [];
                              for (int i = 0; i < listReceiptData.length; i++) {
                                listReceiptDataList.add({
                                  "TRANSNO": listReceiptData[i].tranSno,
                                  "TRANSDATE": listReceiptData[i].transDate,
                                  "CUSTOMER": listReceiptData[i].customer,
                                  "CUSTOMERID": listReceiptData[i].customerId,
                                  "BALAMT": listReceiptData[i].balAmt,
                                  "RECAMOUNT": listReceiptData[i].recAmount,
                                });
                              } //Store the receipt data
                              //
                              // saveData(textData, reciptDataList,
                              //     listReceiptDataList);
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

class PaymentClass {
  PaymentClass(this.sno, this.customer, this.balAmt, this.amount,
      this.advAmount, this.customerId);

  int sno;
  String customer;
  double balAmt;
  double amount;
  double advAmount;
  String customerId;
}

class PaymentSource extends DataGridSource {
  PaymentSource({required List<PaymentClass> paymentData}) {
    _paymentData = paymentData
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

  List<DataGridRow> _PaymentData = [];

  @override
  List<DataGridRow> get rows => _PaymentData;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}

class ListPaymentClass {
  ListPaymentClass(this.tranSno, this.customer, this.balAmt, this.recAmount,
      this.transDate, this.customerId);

  String tranSno;
  String transDate;
  String customer;
  double balAmt;
  double recAmount;
  String customerId;
}

class ListDataSource extends DataGridSource {
  ListDataSource({required List<ListPaymentClass> listData}) {
    _ListData = listData
        .map<DataGridRow>((dataGridRow) => DataGridRow(
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
            ))
        .toList();
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
        padding: const EdgeInsets.all(8.0),
        child: Text(e.value.toString()),
      );
    }).toList());
  }
}
