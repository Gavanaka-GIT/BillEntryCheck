import 'dart:convert';
import 'package:billentry/CustomWidgets/appBar.dart';
import 'package:billentry/CustomWidgets/customDrawer.dart';
import 'package:billentry/GlobalVariables.dart';
import 'package:billentry/LedgerReport.dart';
import 'package:billentry/main.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Ledger extends StatefulWidget {
  final dynamic approvedData;
  const Ledger({super.key, required this.approvedData});

  @override
  State<Ledger> createState() => _LedgerState();
}

class _LedgerState extends State<Ledger> {
  final _formKey = GlobalKey<FormState>(); // Global key for form validation

  // Controllers for TextFormFields
  final TextEditingController ledgerNameController = TextEditingController();
  final TextEditingController printNameController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController groupController = TextEditingController();
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController address3Controller = TextEditingController();
  final TextEditingController gstNumberController = TextEditingController();
  final TextEditingController stateNameController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController panCardController = TextEditingController();
  final TextEditingController msmeController = TextEditingController();
  final TextEditingController creditDaysController = TextEditingController();
  final TextEditingController creditAmountController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ccMailController = TextEditingController();
  final TextEditingController openingBalanceController =
      TextEditingController();

  List<String> groupList = [];
  List<String> groupIdList = [];
  List<dynamic> supplierList = [];
  List<String> cityList = [];
  List<String> cityIdList = [];
  List<String> openingBalanceSuffix = ["Dr", "Cr"];

  String groupName = "";
  String groupId = "";
  String cityName = "";
  String updPrintName = "";
  String cityId = "";
  String openingBalanceSuffixVar = "";
  String updSupplierId = "";

  bool checkBox = false;
  bool updChk = false;

  Future<void> fetchSavedData() async {
    try {
      String url = "${ipAddress}api/getLegderGroup";
      print(url);
      print(
          "---------------------------------------------------------------object");
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({"compId": globalCompId}));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print("check 1");
        print(data);
        print(data['valid']);
        if (data['valid']) {
          groupList.clear();
          groupIdList.clear();
          List<dynamic> getGroupData = data['groupNames'];
          for (int i = 0; i < getGroupData.length; i++) {
            groupList.add(getGroupData[i]['LedgerGroup']);
            groupIdList.add(getGroupData[i]['LedgerGroupId'].toString());
          }

          supplierList.clear();
          List<dynamic> getSupplierName = data['supplierNames'];
          for (int i = 0; i < getSupplierName.length; i++) {
            supplierList
                .add(getSupplierName[i]['Supplier'].toString().toLowerCase());
          }

          cityList.clear();
          cityIdList.clear();
          List<dynamic> getCityName = data['city'];
          for (int i = 0; i < getCityName.length; i++) {
            cityList.add(getCityName[i]['City'].toString());
            cityIdList.add(getCityName[i]['CityId'].toString());
          }

          if (!updChk) {
            setState(() {
              cityName = cityList[0];
              cityId = cityIdList[0];
              groupName = groupList[0];
              groupId = groupIdList[0];
            });
          }

          if (ledgerNameController.text != "") {
            if (updPrintName == ledgerNameController.text.toString()) {
              printNameController.text = ledgerNameController.text.toString();
            } else if (supplierList.isNotEmpty) {
              if (supplierList.contains(
                  ledgerNameController.text.toString().toLowerCase())) {
                int cnt = 0;
                for (int i = 0; i < supplierList.length; i++) {
                  if (supplierList[i] ==
                      (ledgerNameController.text.toString().toLowerCase())) {
                    cnt++;
                  }
                }
                setState(() {
                  printNameController.text =
                      ledgerNameController.text.toString() + cnt.toString();
                });
              } else {
                setState(() {
                  printNameController.text =
                      ledgerNameController.text.toString();
                });
              }
            }
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

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(
            color: Color(0xFF004D40),
          ),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: const Text("..Loading")),
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

  void _incrementCounter() {
    setState(() {});
  }

  Future<void> saveLedgerData(dynamic ledgerData) async {
    String cutTableApi = "${ipAddress}api/saveLedgerData";
    List<dynamic> jsonArray = [];
    jsonArray.add(ledgerData);
    showLoaderDialog(context);
    try {
      final response = await http.post(Uri.parse(cutTableApi),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode({"ledgerData": ledgerData}));
      if (response.statusCode == 200) {
        print("Check 1");
        final Map<String, dynamic> data = json.decode(response.body);
        print(data);
        print(data['savChk']);
        var saveChk = data['savChk'];

        if (saveChk) {
          ledgerNameController.clear();
          printNameController.clear();
          codeController.clear();
          groupController.clear();
          address1Controller.clear();
          address2Controller.clear();
          address3Controller.clear();
          gstNumberController.clear();
          stateNameController.clear();
          pinCodeController.clear();
          panCardController.clear();
          msmeController.clear();
          creditDaysController.clear();
          creditAmountController.clear();
          contactController.clear();
          mobileController.clear();
          phoneController.clear();
          emailController.clear();
          ccMailController.clear();
          openingBalanceController.clear();

          setState(() {
            groupList = [];
            groupIdList = [];
            supplierList = [];
            cityList = [];
            cityIdList = [];
            openingBalanceSuffix = ["Dr", "Cr"];

            groupName = "";
            groupId = "";
            cityName = "";
            cityId = "";
            openingBalanceSuffixVar = "";
            checkBox = false;
          });

          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('REASON'),
                content: updChk
                    ? const Text("Ledger updated Successfully")
                    : const Text("Ledger Inserted Successfully"),
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

          openingBalanceSuffixVar = openingBalanceSuffix[0];
          setState(() {
            updChk = false;
          });
          fetchSavedData();
        } else {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('REASON'),
                content: updChk
                    ? const Text("Ledger Updation Failed")
                    : const Text("Ledger Insertion Failed"),
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
      print(e);
      print("response.statusCode  chk2 ");
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

  @override
  void initState() {
    print("check" + widget.approvedData);
    var updVal = jsonDecode(widget.approvedData);
    print(updVal["approve"]);
    updChk = updVal["approve"];
    if (updVal["approve"]) {
      // updChk= true;
      print("Update function working");
      var selectedData = jsonDecode(updVal['selectedData']);
      setState(() {
        groupList = [];
        groupIdList = [];
        supplierList = [];
        cityList = [];
        cityIdList = [];
        openingBalanceSuffix = ["Dr", "Cr"];

        groupName = "";
        groupId = "";
        cityName = "";
        cityId = "";
        openingBalanceSuffixVar = "";
        checkBox = false;
      });

      print(selectedData);
      setState(() {
        ledgerNameController.text =
            selectedData['ledgerName'].toString() == "null"
                ? ""
                : selectedData['ledgerName'].toString();
        updSupplierId =
            selectedData['values']['SupplierId'].toString() == "null"
                ? ""
                : selectedData['values']['SupplierId'].toString();
        print("SupplierId$updSupplierId");
        updPrintName = selectedData['ledgerName'].toString() == "null"
            ? ""
            : selectedData['ledgerName'].toString();
        printNameController.text =
            selectedData['values']['PrintName'].toString() == "null"
                ? ""
                : selectedData['values']['PrintName'].toString();
        codeController.text =
            selectedData['values']['SupCode'].toString() == "null"
                ? ""
                : selectedData['values']['SupCode'].toString();
        groupName = selectedData['values']['ledgerGroup'].toString() == "null"
            ? ""
            : selectedData['values']['ledgerGroup'].toString();
        groupId = selectedData['values']['LedgerGroupId'].toString() == "null"
            ? ""
            : selectedData['values']['LedgerGroupId'].toString();
        address1Controller.text =
            selectedData['values']['Add1'].toString() == "null"
                ? ""
                : selectedData['values']['Add1'].toString();
        address2Controller.text =
            selectedData['values']['Add2'].toString() == "null"
                ? ""
                : selectedData['values']['Add2'].toString();
        address3Controller.text =
            selectedData['values']['Add3'].toString() == "null"
                ? ""
                : selectedData['values']['Add3'].toString();
        cityName = selectedData['values']['City'].toString() == "null"
            ? ""
            : selectedData['values']['City'][0].toString();
        cityId = selectedData['values']['City'].toString() == "null"
            ? ""
            : selectedData['values']['City'][1].toString();
        gstNumberController.text =
            selectedData['values']['gstNumber'].toString() == "null"
                ? ""
                : selectedData['values']['gstNumber'].toString();
        creditDaysController.text =
            selectedData['values']['CreditDays'].toString() == "null"
                ? ""
                : selectedData['values']['CreditDays'].toString();
        // creditAmountController.text = selectedData['values']['CreditDays'].toString()=="null"?"":selectedData['values']['CreditDays'].toString();
        contactController.text =
            selectedData['values']['Contact_person'].toString() == "null"
                ? ""
                : selectedData['values']['Contact_person'].toString();
        mobileController.text =
            selectedData['values']['Mobile_No'].toString() == "null"
                ? ""
                : selectedData['values']['Mobile_No'].toString();
        phoneController.text =
            selectedData['values']['phone'].toString() == "null"
                ? ""
                : selectedData['values']['phone'].toString();
        emailController.text =
            selectedData['values']['Mailid'].toString() == "null"
                ? ""
                : selectedData['values']['Mailid'].toString();
        openingBalanceController.text =
            selectedData['values']['OpBalAmt'].toString() == "null"
                ? ""
                : selectedData['values']['OpBalAmt'].toString();
        openingBalanceSuffixVar =
            selectedData['values']['OpType'].toString() == "Dr"
                ? openingBalanceSuffix[0]
                : openingBalanceSuffix[1];
        print("openingBalanceSuffixVar$openingBalanceSuffixVar");
        checkBox =
            selectedData['values']['active'].toString() == "Y" ? true : false;
      });

      fetchSavedData();
    } else {
      fetchSavedData();
      openingBalanceSuffixVar = openingBalanceSuffix[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          backgroundColor: Colors.pink[50],
          appBar: CustomAppBar(
            userName: globalUserName,
            emailId: globalEmailId,
            barTitle: "Ledger Master Creation",
            onMenuPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          drawer: const customDrawer(
              stkTransferCheck: false, brhTransferCheck: false),
          body: Container(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  // Handle tap action here, e.g., navigating to another screen or showing a message

                                  ledgerNameController.clear();
                                  printNameController.clear();
                                  codeController.clear();
                                  groupController.clear();
                                  address1Controller.clear();
                                  address2Controller.clear();
                                  address3Controller.clear();
                                  gstNumberController.clear();
                                  stateNameController.clear();
                                  pinCodeController.clear();
                                  panCardController.clear();
                                  msmeController.clear();
                                  creditDaysController.clear();
                                  creditAmountController.clear();
                                  contactController.clear();
                                  mobileController.clear();
                                  phoneController.clear();
                                  emailController.clear();
                                  ccMailController.clear();
                                  openingBalanceController.clear();

                                  setState(() {
                                    groupList = [];
                                    groupIdList = [];
                                    supplierList = [];
                                    cityList = [];
                                    cityIdList = [];
                                    openingBalanceSuffix = ["Dr", "Cr"];

                                    groupName = "";
                                    groupId = "";
                                    cityName = "";
                                    cityId = "";
                                    openingBalanceSuffixVar = "";
                                    checkBox = false;
                                    updChk = false;
                                  });

                                  openingBalanceSuffixVar =
                                      openingBalanceSuffix[0];
                                  fetchSavedData();
                                },
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: const Color(0xFF004D40),
                                  child: Container(
                                    width:
                                        90, // You can adjust the width as per your needs
                                    height:
                                        30, // You can adjust the height as per your needs
                                    alignment: Alignment
                                        .center, // Center the text within the container
                                    child: const Text(
                                      "New",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            16, // You can adjust the font size
                                        fontWeight: FontWeight
                                            .bold, // Optional: Add bold style for emphasis
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  // Handle tap action here, e.g., navigating to another screen or showing a message
                                  print('Card tapped!');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ledgerReportPage()));
                                },
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: const Color(0xFF004D40),
                                  child: Container(
                                    width:
                                        90, // You can adjust the width as per your needs
                                    height:
                                        30, // You can adjust the height as per your needs
                                    alignment: Alignment
                                        .center, // Center the text within the container
                                    child: const Text(
                                      "PartyList",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            16, // You can adjust the font size
                                        fontWeight: FontWeight
                                            .bold, // Optional: Add bold style for emphasis
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                          const SizedBox(
                              height: 5), // Provides spacing below the Card

                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextFormField(
                                      controller: ledgerNameController,
                                      onChanged: (String newValue) {
                                        print("newValue onChanged");
                                        print(newValue);
                                        if (updPrintName ==
                                            newValue.toString()) {
                                          printNameController.text =
                                              ledgerNameController.text
                                                  .toString();
                                        } else if (supplierList.isNotEmpty) {
                                          print(supplierList);
                                          print(supplierList
                                              .indexOf(newValue.toLowerCase()));
                                          if (supplierList.contains(
                                              newValue.toLowerCase().trim())) {
                                            int cnt = 0;
                                            for (int i = 0;
                                                i < supplierList.length;
                                                i++) {
                                              if (supplierList[i] ==
                                                  (newValue
                                                      .toLowerCase()
                                                      .trim())) {
                                                print(supplierList[i] +
                                                    " supplierList[i]");
                                                cnt++;
                                              }
                                            }
                                            setState(() {
                                              print("${cnt}cnt");
                                              printNameController.text =
                                                  ledgerNameController.text
                                                          .toString() +
                                                      cnt.toString();
                                            });
                                          } else {
                                            setState(() {
                                              printNameController.text =
                                                  ledgerNameController.text
                                                      .toString();
                                            });
                                          }
                                        } else {
                                          print(newValue);
                                          setState(() {
                                            printNameController.text =
                                                ledgerNameController.text
                                                    .toString();
                                          });
                                        }
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Ledger Name',
                                        labelStyle:
                                            const TextStyle(fontSize: 14),
                                        prefixIcon:
                                            const Icon(Icons.account_balance),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 3, horizontal: 10),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter a ledger name';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 0.0),
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: TextFormField(
                                      controller: printNameController,
                                      readOnly: false,
                                      showCursor: true,
                                      onChanged: (String newValue) {
                                        if (updPrintName ==
                                            ledgerNameController.text
                                                .toString()) {
                                          printNameController.text =
                                              ledgerNameController.text
                                                  .toString();
                                        } else if (supplierList.contains(
                                            newValue.toLowerCase().trim())) {
                                          int cnt = 0;
                                          for (int i = 0;
                                              i < supplierList.length;
                                              i++) {
                                            if (supplierList[i] ==
                                                (newValue
                                                    .toLowerCase()
                                                    .trim())) {
                                              print(supplierList[i] +
                                                  " supplierList[i]");
                                              cnt++;
                                            }
                                          }
                                          setState(() {
                                            print("${cnt}cnt");
                                            printNameController.text =
                                                newValue.toString() +
                                                    cnt.toString();
                                          });
                                        }
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Print Name',
                                        labelStyle:
                                            const TextStyle(fontSize: 14),
                                        prefixIcon: const Icon(Icons.person),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 10),
                                      ),
                                      validator: (value) {
                                        // if (value == null || value.isEmpty) {
                                        //   return 'Please enter the led';
                                        // }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),

                          // Code and Group in the same row with icons
                          Row(
                            children: [
                              // Flexible(
                              //   flex: 4, // Code field will take 20% of the space
                              //   child: Padding(
                              //       padding: const EdgeInsets.only(right: 16.0),
                              //       child: Card(elevation: 5,
                              //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              //         child: TextFormField(
                              //           controller: codeController,
                              //           decoration: InputDecoration(
                              //             labelText: 'Code',
                              //             labelStyle: TextStyle(fontSize: 14),
                              //             prefixIcon: Icon(Icons.code),
                              //             border: OutlineInputBorder(
                              //               borderRadius: BorderRadius.circular(10),
                              //             ),
                              //             contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                              //           ),
                              //           validator: (value) {
                              //             // if (value == null || value.isEmpty) {
                              //             //   return 'Please enter a code';
                              //             // }
                              //             return null;
                              //           },
                              //         ),)
                              //   ),
                              // ),
                              Flexible(
                                  flex:
                                      10, // Group field will take 80% of the space
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 1.0),
                                    child: Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: DropdownSearch(
                                        items: (filter, infiniteScrollProps) =>
                                            groupList,
                                        selectedItem: groupName,
                                        onChanged: (dynamic newValue) {
                                          groupName = newValue.toString();
                                          int idx =
                                              groupList.indexOf(groupName);
                                          if (idx != -1) {
                                            groupId = groupIdList[idx];
                                          }
                                        },
                                        validator: (value) {
                                          if (!groupList
                                              .contains(value.toString())) {
                                            return 'Please select the Group';
                                          }
                                          return null;
                                        },
                                        decoratorProps: DropDownDecoratorProps(
                                            expands: false,
                                            decoration: InputDecoration(
                                                prefixIcon:
                                                    const Icon(Icons.group),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                contentPadding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 0.0,
                                                        horizontal: 10))),
                                        popupProps:
                                            const PopupPropsMultiSelection.menu(
                                                showSearchBox: true),
                                        compareFn: (item1, item2) =>
                                            item1 == item2,
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                          const SizedBox(height: 5),

                          Padding(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextFormField(
                                  controller: address1Controller,
                                  maxLines:
                                      1, // Allows the address to have multiple lines
                                  keyboardType: TextInputType.streetAddress,
                                  decoration: InputDecoration(
                                    labelText: 'Address',
                                    labelStyle: const TextStyle(fontSize: 14),
                                    prefixIcon: const Icon(Icons.location_on),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter an address';
                                    }
                                    return null;
                                  },
                                ),
                              )),
                          const SizedBox(height: 5),

                          Padding(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextFormField(
                                  controller: address2Controller,
                                  maxLines:
                                      1, // Allows the address to have multiple lines
                                  decoration: InputDecoration(
                                    labelText: 'Address 2',
                                    labelStyle: const TextStyle(fontSize: 14),
                                    // prefixIcon: Icon(Icons.location_on),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                  ),
                                  validator: (value) {
                                    // if (value == null || value.isEmpty) {
                                    //   return 'Please enter an address';
                                    // }
                                    return null;
                                  },
                                ),
                              )),
                          const SizedBox(height: 5),

                          Padding(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextFormField(
                                  controller: address3Controller,
                                  maxLines:
                                      1, // Allows the address to have multiple lines
                                  decoration: InputDecoration(
                                    labelText: 'Address 3',
                                    labelStyle: const TextStyle(fontSize: 14),
                                    // prefixIcon: Icon(Icons.location_on),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                  ),
                                  validator: (value) {
                                    // if (value == null || value.isEmpty) {
                                    //   return 'Please enter an address';
                                    // }
                                    return null;
                                  },
                                ),
                              )),
                          const SizedBox(height: 5),

                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 0.0),
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: DropdownSearch(
                                      items: (filter, infiniteScrollProps) =>
                                          cityList,
                                      onChanged: (dynamic newValue) {
                                        cityName = newValue.toString();
                                        int idx = cityList.indexOf(newValue);
                                        if (idx != -1) {
                                          cityId = cityIdList[idx];
                                        }
                                      },
                                      selectedItem: cityName,
                                      validator: (value) {
                                        if (!cityList
                                            .contains(value.toString())) {
                                          return 'Please select the State';
                                        }
                                        return null;
                                      },
                                      decoratorProps: DropDownDecoratorProps(
                                          expands: false,
                                          decoration: InputDecoration(
                                              helperMaxLines: 1,
                                              hintMaxLines: 1,
                                              prefixIcon: const Icon(Icons.map),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              contentPadding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0))),
                                      popupProps:
                                          const PopupPropsMultiSelection.menu(
                                        showSearchBox: true,
                                        // constraints: BoxConstraints(minHeight: 100, maxHeight: 100)
                                      ),
                                      compareFn: (item1, item2) =>
                                          item1 == item2,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),

                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 1.0),
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: TextFormField(
                                      controller: pinCodeController,
                                      enabled: updChk ? false : true,
                                      decoration: InputDecoration(
                                        labelText: 'Pin Code',
                                        labelStyle:
                                            const TextStyle(fontSize: 14),
                                        prefixIcon: const Icon(Icons.pin),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 10),
                                      ),
                                      validator: (value) {
                                        // if (value == null || value.isEmpty) {
                                        //   return 'Please enter a pin name';
                                        // }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),

                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextFormField(
                                controller: gstNumberController,
                                // maxLines: 1, // Allows the address to have multiple lines
                                decoration: InputDecoration(
                                  labelText: 'Gst Number',
                                  labelStyle: const TextStyle(fontSize: 14),
                                  prefixIcon: const Icon(Icons.receipt),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                ),
                                validator: (value) {
                                  // if (value == null || value.isEmpty) {
                                  //   return 'Please enter an Gst Number';
                                  // }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),

                          // Padding(
                          //   padding: const EdgeInsets.only(top: 0.0),
                          //   child: Card(elevation: 5,
                          //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          //     child: TextFormField(
                          //       controller: panCardController,
                          //       enabled: false,
                          //       // maxLines: 1, // Allows the address to have multiple lines
                          //       decoration: InputDecoration(
                          //         labelText: 'Pan Card Number',
                          //         labelStyle: TextStyle(fontSize: 14),
                          //         prefixIcon: Icon(Icons.abc_outlined),
                          //         border: OutlineInputBorder(
                          //           borderRadius: BorderRadius.circular(10),
                          //         ),
                          //         contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          //       ),
                          //       validator: (value) {
                          //         // if (value == null || value.isEmpty) {
                          //         //   return 'Please enter an Msme Number';
                          //         // }
                          //         return null;
                          //       },
                          //     ),),
                          // ),
                          // SizedBox(height: 5),
                          //
                          // Padding(
                          //   padding: const EdgeInsets.only(top: 0.0),
                          //   child:Card(elevation: 5,
                          //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          //     child:
                          //     TextFormField(
                          //       controller: msmeController,
                          //       enabled: false,
                          //       // maxLines: 1, // Allows the address to have multiple lines
                          //       decoration: InputDecoration(
                          //         labelText: 'Msme Number',
                          //         labelStyle: TextStyle(fontSize: 14),
                          //         prefixIcon: Icon(Icons.abc_outlined),
                          //         border: OutlineInputBorder(
                          //           borderRadius: BorderRadius.circular(10),
                          //         ),
                          //         contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          //       ),
                          //       validator: (value) {
                          //         // if (value == null || value.isEmpty) {
                          //         //   return 'Please enter an Gst Number';
                          //         // }
                          //         return null;
                          //       },
                          //     ),
                          //   ),),
                          // SizedBox(height: 5),

                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: Padding(
                          //         padding: const EdgeInsets.only(right: 16.0),
                          //         child:Card(elevation: 5,
                          //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          //           child:  TextFormField(
                          //             controller: creditDaysController,
                          //             keyboardType: TextInputType.number,
                          //             decoration: InputDecoration(
                          //               labelText: 'Credit Days',
                          //               labelStyle: TextStyle(fontSize: 14),
                          //               prefixIcon: Icon(Icons.today_sharp),
                          //               border: OutlineInputBorder(
                          //                 borderRadius: BorderRadius.circular(10),
                          //               ),
                          //               contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          //             ),
                          //             validator: (value) {
                          //               if (value == null || value.isEmpty) {
                          //                 return 'Please enter a credit days';
                          //               }
                          //               return null;
                          //             },
                          //           ),),
                          //       ),
                          //     ),
                          //     Expanded(
                          //       child: Padding(
                          //         padding: const EdgeInsets.only(left: 1.0),
                          //         child:Card(elevation: 5,
                          //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          //           child:  TextFormField(
                          //             controller: creditAmountController,
                          //             enabled: false,
                          //             keyboardType: TextInputType.number,
                          //             decoration: InputDecoration(
                          //               labelText: 'Credit Amount',
                          //               labelStyle: TextStyle(fontSize: 14),
                          //               prefixIcon: Icon(Icons.credit_card),
                          //               border: OutlineInputBorder(
                          //                 borderRadius: BorderRadius.circular(10),
                          //               ),
                          //               contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          //             ),
                          //             // validator: (value) {
                          //             //   if (value == null || value.isEmpty) {
                          //             //     return 'Please enter a credit amount';
                          //             //   }
                          //             //   return null;
                          //             // },
                          //           ),),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(height: 5),

                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextFormField(
                                controller: contactController,
                                // maxLines: 1, // Allows the address to have multiple lines
                                decoration: InputDecoration(
                                  labelText: 'Contact',
                                  labelStyle: const TextStyle(fontSize: 14),
                                  prefixIcon: const Icon(Icons.abc_outlined),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter an Contact';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),

                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextFormField(
                                controller: mobileController,
                                // maxLines: 1, // Allows the address to have multiple lines
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  labelText: 'Mobile Number',
                                  labelStyle: const TextStyle(fontSize: 14),
                                  prefixIcon: const Icon(Icons.phone),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                ),
                                validator: (value) {
                                  // if (value == null || value.isEmpty) {
                                  //   return 'Please enter an Mobile Number';
                                  // }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),

                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextFormField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                // maxLines: 1, // Allows the address to have multiple lines
                                decoration: InputDecoration(
                                  labelText: 'Phone Number',
                                  labelStyle: const TextStyle(fontSize: 14),
                                  prefixIcon: const Icon(Icons.phone_android),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                ),
                                validator: (value) {
                                  // if (value == null || value.isEmpty) {
                                  //   return 'Please enter an Phone Number';
                                  // }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),

                          Padding(
                            padding: const EdgeInsets.only(top: 0.0),
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextFormField(
                                controller: emailController,
                                // maxLines: 1, // Allows the address to have multiple lines
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  labelStyle: const TextStyle(fontSize: 14),
                                  prefixIcon: const Icon(Icons.mail),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 10),
                                ),
                                validator: (value) {
                                  // if (value == null || value.isEmpty) {
                                  //   return 'Please enter an Email';
                                  // }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),

                          // Padding(
                          //   padding: const EdgeInsets.only(top: 0.0),
                          //   child:Card(elevation: 5,
                          //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          //     child:
                          //     TextFormField(
                          //       controller: ccMailController,
                          //       // maxLines: 1, // Allows the address to have multiple lines
                          //       decoration: InputDecoration(
                          //         labelText: 'Cc Mail',
                          //         labelStyle: TextStyle(fontSize: 14),
                          //         prefixIcon: Icon(Icons.contact_mail_rounded),
                          //         border: OutlineInputBorder(
                          //           borderRadius: BorderRadius.circular(10),
                          //         ),
                          //         contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          //       ),
                          //       validator: (value) {
                          //         // if (value == null || value.isEmpty) {
                          //         //   return 'Please enter an Cc Mail';
                          //         // }
                          //         return null;
                          //       },
                          //     ),
                          //   ),),
                          // SizedBox(height: 5),

                          Row(
                            children: [
                              Flexible(
                                flex: 8,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Card(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: TextFormField(
                                      controller: openingBalanceController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: 'Opening Balance',
                                        labelStyle:
                                            const TextStyle(fontSize: 14),
                                        prefixIcon: const Icon(Icons.money),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 10),
                                      ),
                                      validator: (value) {
                                        // if (value == null || value.isEmpty) {
                                        //   return 'Please enter a Opening Balance';
                                        // }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 1.0),
                                  child: Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Container(
                                        // Add padding for the dropdown
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Colors
                                                  .grey), // Border style for the dropdown
                                        ),
                                        child: DropdownButton(
                                            value: openingBalanceSuffixVar,
                                            items: openingBalanceSuffix
                                                .map((String value) {
                                              return DropdownMenuItem(
                                                  value: value,
                                                  child: Text(value));
                                            }).toList(),
                                            onChanged: (String? newValue) {
                                              setState(() {
                                                openingBalanceSuffixVar =
                                                    newValue.toString();
                                              });
                                            }),
                                      )),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),

                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Checkbox(
                                    value: checkBox,
                                    onChanged: (bool? newValue) {
                                      setState(() {
                                        checkBox = newValue ?? false;
                                      });
                                    }),
                                const Text("IsActive")
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            print(
                                                'Form is valid, performing save action');
                                            var supplierCustomer =
                                                int.parse(groupId) == 1
                                                    ? "C"
                                                    : "S";
                                            var pinAddressMerger = updChk
                                                ? ""
                                                : ",${pinCodeController.text}";
                                            dynamic value = {
                                              "Supplier":
                                                  ledgerNameController.text,
                                              "Add1": address1Controller.text,
                                              "Add2": address2Controller.text,
                                              "City": cityId,
                                              "Phone": phoneController.text,
                                              "TNGST_No":
                                                  gstNumberController.text,
                                              "TIN_No":
                                                  msmeController.text, //check
                                              "MaildId": emailController.text,
                                              "Contact_Person":
                                                  contactController.text,
                                              "Mobile_No":
                                                  mobileController.text,
                                              "Supplier_Customer":
                                                  supplierCustomer, //check,
                                              "IsActive": checkBox ? "Y" : "N",
                                              "Add3": address3Controller.text
                                                      .toString() +
                                                  pinAddressMerger.toString(),
                                              "CompId": globalCompId,
                                              "LedgerGroupId": groupId,
                                              "PrintName":
                                                  printNameController.text,
                                              "SupCode": codeController.text,
                                              "CreditDays":
                                                  creditDaysController.text,
                                              "OpBalAmt":
                                                  openingBalanceController.text,
                                              "OpType": openingBalanceSuffixVar,
                                              "Update": updChk,
                                              "UpdId": updSupplierId
                                            };
                                            saveLedgerData(value);
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('Alert'),
                                                  content: const Text(
                                                      "Please Enter the Required Fields"), // Content of the dialog
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
                                        },
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 40),
                                          foregroundColor: Colors.white,
                                          backgroundColor:
                                              const Color(0xFF004D40),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          updChk ? 'Update' : 'Save',
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ))),
                              const SizedBox(width: 5),
                              Expanded(
                                  child: Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          // Reset the form
                                          _formKey.currentState!.reset();
                                          print('Cancel button pressed');
                                          updChk = false;
                                        },
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor:
                                              const Color(0xFF004D40),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 15, horizontal: 40),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ))),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: () async {
          Navigator.pushNamedAndRemoveUntil(
              context, '/Home', (Route<dynamic> route) => false);
          return true;
        });
  }
}
