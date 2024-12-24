import 'dart:convert';
import 'package:billentry/CustomWidgets/appBar.dart';
import 'package:billentry/CustomWidgets/customDrawer.dart';
import 'package:billentry/GlobalVariables.dart';
import 'package:billentry/main.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:flutter_bootstrap/flutter_bootstrap.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:collection/collection.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:printing/printing.dart';
import 'package:num_to_words/num_to_words.dart';


import 'package:dropdown_button2/dropdown_button2.dart';


List<BillEntry> billEntryList=[];
List<dynamic> prevBillEntryList=[];
class BillEntryMasScreen extends StatefulWidget {
  const BillEntryMasScreen({super.key} );


  @override
  State<BillEntryMasScreen> createState() => _billEntryMasState();
}

class _billEntryMasState extends State<BillEntryMasScreen> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: billEntryFirstScreen(),
    );
  }
}

class billEntryFirstScreen extends StatefulWidget {
  final dynamic data;
  const billEntryFirstScreen({super.key, this.data});

  @override
  _billEntryFirstState createState() => _billEntryFirstState();
}


class _billEntryFirstState extends State<billEntryFirstScreen> {
  final GlobalKey<SfDataGridState> pdfKey = GlobalKey<SfDataGridState>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;

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
  String customerName="";
  double grandTotalAmount=0.0;
  List<String> SalesType=["Sales", "Sales B"];
  int salesTypeidx=0;
  late DateTime now;
  var edate;
  _billEntryFirstState(){
    now = DateTime.now();
    edate =  DateFormat('dd/MM/yyyy').format(now);
  }

  String savedShipToName="";
  double savedTotalAmount=0.0;

  var selected = false;
  var index  =-1;
  bool approvalValue=false;

  TextEditingController date = TextEditingController();
  TextEditingController _itemController = TextEditingController();
  TextEditingController _shipToController = TextEditingController();
  TextEditingController _customerController = TextEditingController();
  TextEditingController qtyTextController = TextEditingController();
  TextEditingController itemTextController = TextEditingController();
  TextEditingController discTextController = TextEditingController();
  TextEditingController rateTextController = TextEditingController();
  TextEditingController gstTextController = TextEditingController();
  final DataGridController _dataGridController = DataGridController();
  TextEditingController toDateController = TextEditingController();
  final TextEditingController _controller= TextEditingController();

  List<Item> items = [
    Item(
      serialNumber: "1",
      itemName: "",
      hsnCode: "",
      uom: "",
      quantity: "",
      rate: "",
      cgstPercent: "",
      sgstPercent: "",
      amount: ""
    ),
    Item(
      serialNumber: "2",
      itemName: "",
      hsnCode: "",
      uom: "",
      quantity: "",
      rate: "",
      cgstPercent: "",
      sgstPercent: "",
      amount: ""
    ),Item(
        serialNumber: "3",
        itemName: "",
        hsnCode: "",
        uom: "",
        quantity: "",
        rate: "",
        cgstPercent: "",
        sgstPercent: "",
        amount: ""
    ),
    Item(
        serialNumber: "4",
        itemName: "",
        hsnCode: "",
        uom: "",
        quantity: "",
        rate: "",
        cgstPercent: "",
        sgstPercent: "",
        amount: ""
    ),
    Item(
        serialNumber: "5",
        itemName: "",
        hsnCode: "",
        uom: "",
        quantity: "",
        rate: "",
        cgstPercent: "",
        sgstPercent: "",
        amount: ""
    ),
    Item(
        serialNumber: "6",
        itemName: "",
        hsnCode: "",
        uom: "",
        quantity: "",
        rate: "",
        cgstPercent: "",
        sgstPercent: "",
        amount: ""
    ),
    Item(
        serialNumber: "7",
        itemName: "",
        hsnCode: "",
        uom: "",
        quantity: "",
        rate: "",
        cgstPercent: "",
        sgstPercent: "",
        amount: ""
    ),
    Item(
        serialNumber: "8",
        itemName: "",
        hsnCode: "",
        uom: "",
        quantity: "",
        rate: "",
        cgstPercent: "",
        sgstPercent: "",
        amount: ""
    ),
    Item(
        serialNumber: "9",
        itemName: "",
        hsnCode: "",
        uom: "",
        quantity: "",
        rate: "",
        cgstPercent: "",
        sgstPercent: "",
        amount: ""
    ),
    Item(
        serialNumber: "10",
        itemName: "",
        hsnCode: "",
        uom: "",
        quantity: "",
        rate: "",
        cgstPercent: "",
        sgstPercent: "",
        amount: ""
    ),
    Item(
        serialNumber: "11",
        itemName: "",
        hsnCode: "",
        uom: "",
        quantity: "",
        rate: "",
        cgstPercent: "",
        sgstPercent: "",
        amount: ""
    ),Item(
        serialNumber: "12",
        itemName: "",
        hsnCode: "",
        uom: "",
        quantity: "",
        rate: "",
        cgstPercent: "",
        sgstPercent: "",
        amount: ""
    ),
    Item(
        serialNumber: "13",
        itemName: "",
        hsnCode: "",
        uom: "",
        quantity: "",
        rate: "",
        cgstPercent: "",
        sgstPercent: "",
        amount: ""
    ),

  ];

  List<Item> items2 = List.generate(25, (index) {
    int serialNumber = index + 14;
    return Item(
        serialNumber: serialNumber.toString(),
        itemName: "",
        hsnCode: "",
        uom: "",
        quantity: "",
        rate: "",
        cgstPercent: "",
        sgstPercent: "",
        amount: ""
    );
  });



  DateTime currentDate = DateTime.now();

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(color: Color(0xFF004D40),),
          Container(margin: const EdgeInsets.only(left: 7),child:const Text("..In Progress" )),
        ],),
    );
    showDialog(
      barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return WillPopScope(child: alert, onWillPop: ()=> Future.value(false));
      },
    );
  }

  showBillNoLoaderDialog(BuildContext context){
    AlertDialog alert=const AlertDialog(
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

  bool pdfChk=true;
  Future<pw.Document?> fetchPdfDocument( String InvNo) async{

    try{
      String url="${ipAddress}api/getPdfData";
      print(url);
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          }, body: jsonEncode({
            "compId":globalCompId,
            "InvNo":InvNo
          }));
      if(response.statusCode == 200){
        final Map<String,dynamic> companyData = jsonDecode(response.body);
        List<Item> tempTableData=[];
        tempTableData=items;
        int length = companyData['getInvData'].length<=13 ?companyData['getInvData'].length:13;
        print(length);
         for(int i=0;i<length;i++){
          tempTableData[i].itemName=companyData['getInvData'][i]['Item'].toString() != "null"?companyData['getInvData'][i]['Item'].toString():"";
          tempTableData[i].hsnCode= companyData['getInvData'][i]['HsnCode'].toString() != "null"?companyData['getInvData'][i]['HsnCode'].toString():"";
          tempTableData[i].uom= companyData['getInvData'][i]['Uom'].toString() != "null"?companyData['getInvData'][i]['Uom'].toString().substring(0,3):"";
          tempTableData[i].quantity= companyData['getInvData'][i]['Quantity'].toString() != "null"?companyData['getInvData'][i]['Quantity'].toString():"";
          tempTableData[i].rate= companyData['getInvData'][i]['Rate'].toString() != "null"?companyData['getInvData'][i]['Rate'].toString():"";
          tempTableData[i].cgstPercent= companyData['getInvData'][i]['CGSTP'].toString() != "null"?companyData['getInvData'][i]['CGSTP'].toString():"";
          tempTableData[i].sgstPercent= companyData['getInvData'][i]['SGSTP'].toString() != "null"?companyData['getInvData'][i]['SGSTP'].toString():"";
          tempTableData[i].amount= companyData['getInvData'][i]['Amount'].toString() != "null"?companyData['getInvData'][i]['Amount'].toString():"";
        }
        List<Item> tempTableData2=[];
         if(companyData['getInvData'].length>13){

           tempTableData2=items2;
           for(int i=13;i<companyData['getInvData'].length;i++){
             print(i);
             print(companyData['getInvData'][i]['Item'].toString());
             tempTableData2[i-13].itemName=companyData['getInvData'][i]['Item'].toString() != "null"?companyData['getInvData'][i]['Item'].toString():"";
             tempTableData2[i-13].hsnCode= companyData['getInvData'][i]['HsnCode'].toString() != "null"?companyData['getInvData'][i]['HsnCode'].toString():"";
             tempTableData2[i-13].uom= companyData['getInvData'][i]['Uom'].toString() != "null"?companyData['getInvData'][i]['Uom'].toString().substring(0,3):"";
             tempTableData2[i-13].quantity= companyData['getInvData'][i]['Quantity'].toString() != "null"?companyData['getInvData'][i]['Quantity'].toString():"";
             tempTableData2[i-13].rate= companyData['getInvData'][i]['Rate'].toString() != "null"?companyData['getInvData'][i]['Rate'].toString():"";
             tempTableData2[i-13].cgstPercent= companyData['getInvData'][i]['CGSTP'].toString() != "null"?companyData['getInvData'][i]['CGSTP'].toString():"";
             tempTableData2[i-13].sgstPercent= companyData['getInvData'][i]['SGSTP'].toString() != "null"?companyData['getInvData'][i]['SGSTP'].toString():"";
             tempTableData2[i-13].amount= companyData['getInvData'][i]['Amount'].toString() != "null"?companyData['getInvData'][i]['Amount'].toString():"";
           }
         }
        print(tempTableData[0].itemName);

        print(companyData['getInvData'][0]['NetAmount'].toString());
        double value = double.parse(companyData['getInvData'][0]['NetAmount'].toString());
        int integerPart = value.toInt();
        print(integerPart.toWords());

        print(tempTableData);
        final ByteData data = await rootBundle.load('assets/icon/logo.png');
        final Uint8List imageBytes = data.buffer.asUint8List();
        final image = pw.MemoryImage(imageBytes);

        final pdf = pw.Document();
        double pdfWidth =PdfPageFormat.a4.width-40;
        print(pdfWidth);
        print("width");
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: pw.EdgeInsets.zero,
            build: (pw.Context context) {
              return pw.Stack(
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
                      height: PdfPageFormat.a4.height-40,
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(width: 1),
                      ),
                      child: pw.Column(
                          children: [
                            pw.Container(
                              width: PdfPageFormat.a4.width - 40,
                              height: 80,
                              decoration: const pw.BoxDecoration(border: pw.Border(bottom: pw.BorderSide(
                                color:PdfColors.black,
                                width: 1,
                              ))),
                              child:pw.Row(children: [
                                pw.Container(
                                  width: pdfWidth*0.20,
                                  decoration: const pw.BoxDecoration(
                                      border: pw.Border(right: pw.BorderSide(
                                        color:PdfColors.black,
                                        width: 1,
                                      ))),
                                  child:pw.Image(image,height: 80),
                                ),
                                pw.Container(child: pw.Container(width: pdfWidth*0.80,child:pw.Column(
                                    mainAxisAlignment: pw.MainAxisAlignment.center,
                                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                                    children: [
                                      pw.Text(companyData['compDetails'][0]['CompanyName'].toString() != "null"? companyData['compDetails'][0]['CompanyName'].toString(): "", textAlign: pw.TextAlign.center,
                                          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                                      pw.Text("${companyData['compDetails'][0]['CompanyAddress1'].toString() != "null"? "${companyData['compDetails'][0]['CompanyAddress1'].toString()}, ":""} ${companyData['compDetails'][0]['CompanyAddress2'].toString() != "null"?"${companyData['compDetails'][0]['CompanyAddress2']}, ":""} ${companyData['compDetails'][0]['CompanyAddress3'].toString()!="null"? companyData['compDetails'][0]['CompanyAddress3'].toString():""} - ${companyData['compDetails'][0]['CompanyPinCode'].toString() != "null"?companyData['compDetails'][0]['CompanyPinCode'].toString(): "" }",
                                          style: const pw.TextStyle(fontSize: 10) ,
                                          textAlign: pw.TextAlign.center),
                                      pw.Text("Phone : ${companyData['compDetails'][0]['Phone'].toString() != "null"? companyData['compDetails'][0]['Phone'].toString():""}, Cell : ${companyData['compDetails'][0]['Mobile'].toString() != "null"?companyData['compDetails'][0]['Mobile'].toString():""}, Email : ${companyData['compDetails'][0]['Email'].toString() != "null"?companyData['compDetails'][0]['Email'].toString():""}\n"
                                          , style: const pw.TextStyle(fontSize: 10)
                                          ,textAlign:pw.TextAlign.center),
                                      pw.Text("GSTIN No : ${companyData['compDetails'][0]['GstNo'].toString() != "null"?companyData['compDetails'][0]['GstNo'].toString():"" }", textAlign: pw.TextAlign.center,
                                          style: const pw.TextStyle(fontSize: 10))
                                    ]
                                )))
                                ]),
                            ),
                            pw.Container(
                                width: PdfPageFormat.a4.width-40,
                                height: 20,
                                decoration: const pw.BoxDecoration(
                                    border: pw.Border(bottom: pw.BorderSide(
                                        width: 1, color: PdfColors.black))
                                ),
                                child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center,
                                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                                    children: [pw.Text("TAX INVOICE",
                                        style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold))]
                                )
                            ),
                            pw.Container(
                                width: PdfPageFormat.a4.width-40,
                                height: 40,
                                decoration: const pw.BoxDecoration(
                                    border: pw.Border(bottom: pw.BorderSide(width: 1, color: PdfColors.black))
                                ),
                                child: pw.Row(
                                    children: [
                                      pw.Container(
                                          width: pdfWidth*0.15,
                                          height: 40,
                                          decoration: const pw.BoxDecoration(
                                              border: pw.Border(
                                                  right: pw.BorderSide(width: 1, color: PdfColors.black))
                                          ),
                                          child: pw.Column(
                                              children: [
                                                pw.SizedBox(height: 5),
                                                pw.Text("Invoice No",
                                                    style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                                                pw.SizedBox(height: 7),
                                                pw.Text("Invoice Date",
                                                    style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold))
                                              ]
                                          )
                                      ),
                                      pw.Container(
                                          width: pdfWidth*0.35,
                                          height: 40,
                                          decoration: const pw.BoxDecoration(border:
                                          pw.Border(right: pw.BorderSide(width: 1, color: PdfColors.black))),
                                          child: pw.Column(children: [
                                            pw.SizedBox(height: 5),
                                            pw.Text(companyData['getInvData'][0]['InvNo'].toString() != "null" || companyData['getInvData'][0]['InvNo'].toString() !=""? companyData['getInvData'][0]['InvNo'].toString(): "",
                                                style: const pw.TextStyle(fontSize: 10)),
                                            pw.SizedBox(height: 7),
                                            pw.Text(companyData['getInvData'][0]['InvDate'].toString() != "null"? companyData['getInvData'][0]['InvDate'].toString(): "",
                                                style: const pw.TextStyle(fontSize: 10)),
                                          ])
                                      ),
                                      pw.Container(
                                          width: pdfWidth*0.2,
                                          height: 40,
                                          decoration: const pw.BoxDecoration(
                                              border: pw.Border(
                                                  right: pw.BorderSide(width: 1, color: PdfColors.black))
                                          ),
                                          child: pw.Column(
                                              children: [
                                                pw.SizedBox(height: 5),
                                                pw.Text("Transport",
                                                    style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                                                pw.SizedBox(height: 7),
                                                pw.Text("Place of Supply",
                                                    style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold))
                                              ]
                                          )
                                      ),
                                      pw.Container(
                                          width: pdfWidth*0.3,
                                          height: 40,
                                          decoration: const pw.BoxDecoration(border:
                                          pw.Border(right: pw.BorderSide(width: 1, color: PdfColors.black))),
                                          child: pw.Column(children: [
                                            pw.SizedBox(height: 5),
                                            pw.Text(companyData['getInvData'][0]['Transport'].toString() != "null" && companyData['getInvData'][0]['Transport'].toString() != "" ? companyData['getInvData'][0]['Transport'].toString(): "-",
                                                style: const pw.TextStyle(fontSize: 10)),
                                            pw.SizedBox(height: 7),
                                            pw.Text(companyData['getInvData'][0]['ShipStateName'].toString() != "null" && companyData['getInvData'][0]['ShipStateName'].toString() != ""? companyData['getInvData'][0]['ShipStateName'].toString(): "-",
                                                style: const pw.TextStyle(fontSize: 10)),
                                          ])
                                      )
                                    ]
                                )
                            ),
                            pw.Container(width: PdfPageFormat.a4.width-40,
                                height: 20,
                                decoration: const pw.BoxDecoration(
                                    border: pw.Border(
                                        bottom: pw.BorderSide(width: 1, color: PdfColors.black))),
                                child: pw.Row(
                                    children: [
                                      pw.Container(
                                          width: pdfWidth*0.5,
                                          height: 20,
                                          decoration: const pw.BoxDecoration(
                                              border: pw.Border(
                                                  right: pw.BorderSide(width: 1, color: PdfColors.black)
                                              )
                                          ),
                                          child: pw.Column(
                                              children: [
                                                pw.SizedBox(height: 3.5),
                                                pw.Text("Bill To",
                                                    style: const pw.TextStyle(fontSize: 12))
                                              ]
                                          )
                                      ),
                                      pw.Container(
                                          width: pdfWidth*0.5,
                                          height: 20,
                                          decoration: const pw.BoxDecoration(
                                              border: pw.Border(
                                                  right: pw.BorderSide(width: 1, color: PdfColors.black)
                                              )
                                          ),
                                          child: pw.Column(
                                              children: [
                                                pw.SizedBox(height: 3.5),
                                                pw.Text("Ship To",
                                                    style: const pw.TextStyle(fontSize: 12))
                                              ]
                                          )
                                      )
                                    ]
                                )),
                            pw.Container(width: PdfPageFormat.a4.width-40,
                                height: 100,
                                decoration: const pw.BoxDecoration(
                                    border: pw.Border(
                                        bottom: pw.BorderSide(width: 1, color: PdfColors.black))),
                                child: pw.Row(
                                    children: [
                                      pw.Container(
                                          width: pdfWidth*0.5,
                                          height: 100,
                                          decoration: const pw.BoxDecoration(
                                              border: pw.Border(
                                                  right: pw.BorderSide(width: 1, color: PdfColors.black)
                                              )
                                          ),
                                          child: pw.Column(
                                            children: [
                                              pw.Container(height: 66.5, child: pw.Column(children: [pw.SizedBox(height: 5.5),
                                                pw.Text(companyData['getInvData'][0]['BillSupName'].toString() != "null"?companyData['getInvData'][0]['BillSupName'].toString():"",
                                                    textAlign: pw.TextAlign.center,
                                                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                                                pw.Text(companyData['getInvData'][0]['BillSupAdd1'].toString() != "null"?companyData['getInvData'][0]['BillSupAdd1'].toString():""
                                                    ,textAlign:pw.TextAlign.center, style: const pw.TextStyle( fontSize: 10)),
                                                pw.Text(companyData['getInvData'][0]['BillSupAdd2'].toString() != "null"?companyData['getInvData'][0]['BillSupAdd2'].toString():"", textAlign: pw.TextAlign.center,
                                                    style: const pw.TextStyle( fontSize: 10)),
                                                pw.Text(companyData['getInvData'][0]['BillSupAdd3'].toString() != "null"?companyData['getInvData'][0]['BillSupAdd3'].toString():"", textAlign: pw.TextAlign.center,
                                                    style: const pw.TextStyle( fontSize: 10))])),
                                              pw.Text("GSTIN : ${companyData['getInvData'][0]['BillGstNo'].toString() != "null"?companyData['getInvData'][0]['BillGstNo'].toString():""}",style: const pw.TextStyle( fontSize: 10)),
                                              pw.Text(companyData['getInvData'][0]['BillStateName'].toString() != "null"?companyData['getInvData'][0]['BillStateName'].toString() :"", style: const pw.TextStyle( fontSize: 10))
                                            ],
                                          )
                                      ),
                                      pw.Container(
                                          width: pdfWidth*0.5,
                                          height: 100,
                                          decoration: const pw.BoxDecoration(
                                              border: pw.Border(
                                                  right: pw.BorderSide(width: 1, color: PdfColors.black)
                                              )
                                          ),
                                          child: pw.Column(
                                            children: [
                                              pw.Container(height: 66.5, child: pw.Column(children: [
                                                pw.SizedBox(height: 5.5),
                                                pw.Text(companyData['getInvData'][0]['ShipSupName'].toString()  != "null"?companyData['getInvData'][0]['ShipSupName'].toString():"" ,
                                                    textAlign: pw.TextAlign.center,
                                                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                                                pw.Text(companyData['getInvData'][0]['ShipSupAdd1'].toString()  != "null"?companyData['getInvData'][0]['ShipSupAdd1'].toString():""
                                                    ,textAlign:pw.TextAlign.center,style: const pw.TextStyle( fontSize: 10)),
                                                pw.Text(companyData['getInvData'][0]['ShipSupAdd2'].toString()  != "null"?companyData['getInvData'][0]['ShipSupAdd2'].toString():"", textAlign: pw.TextAlign.center,style: const pw.TextStyle( fontSize: 10)),
                                                pw.Text(companyData['getInvData'][0]['ShipSupAdd3'].toString()  != "null"?companyData['getInvData'][0]['ShipSupAdd3'].toString():"", textAlign: pw.TextAlign.center,style: const pw.TextStyle( fontSize: 10))])),
                                              pw.Text("GSTIN : ${companyData['getInvData'][0]['ShipGstNo'].toString()  != "null"?companyData['getInvData'][0]['ShipGstNo'].toString() :""}",style: const pw.TextStyle( fontSize: 10)),
                                              pw.Text(companyData['getInvData'][0]['ShipStateName'].toString() ,style: const pw.TextStyle( fontSize: 10))
                                            ],
                                          )
                                      )
                                    ]
                                )),
                            pw.Container(width: PdfPageFormat.a4.width-40,
                                height: 304,
                                decoration: const pw.BoxDecoration(
                                    border: pw.Border(
                                        bottom: pw.BorderSide(width: 1, color: PdfColors.black))),
                                child:pw.Column(
                                    children: [
                                      pw.Table(
                                        border: const pw.TableBorder(
                                            right: pw.BorderSide(width: 1, color: PdfColors.black),
                                            left: pw.BorderSide(width: 1, color: PdfColors.black),
                                            top: pw.BorderSide(width: 1, color: PdfColors.black),
                                            verticalInside: pw.BorderSide(width: 1, color: PdfColors.black)
                                        ),
                                        columnWidths: {
                                          0: const pw.FlexColumnWidth(0.075),
                                          1: const pw.FlexColumnWidth(0.225),
                                          2: const pw.FlexColumnWidth(0.125),
                                          3: const pw.FlexColumnWidth(0.075),
                                          4: const pw.FlexColumnWidth(0.106),
                                          5: const pw.FlexColumnWidth(0.1),
                                          6: const pw.FlexColumnWidth(0.0976),
                                          7: const pw.FlexColumnWidth(0.0964),
                                          8: const pw.FlexColumnWidth(0.1),
                                        },
                                        children: [
                                          // Header Row
                                          pw.TableRow(
                                            decoration: const pw.BoxDecoration(
                                                color: PdfColors.grey300,
                                                border: pw.Border(bottom:pw.BorderSide(width: 1, color: PdfColors.black))
                                            ),
                                            children: [
                                              pw.Padding(
                                                padding: const pw.EdgeInsets.all(5),
                                                child: pw.Text("S.No", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                                              ),
                                              pw.Padding(
                                                padding: const pw.EdgeInsets.all(5),
                                                child: pw.Text("Item", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10), softWrap: false),
                                              ),
                                              pw.Padding(
                                                padding: const pw.EdgeInsets.all(5),
                                                child: pw.Text("HSN Code", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                                              ),
                                              pw.Padding(
                                                padding: const pw.EdgeInsets.all(5),
                                                child: pw.Text("Uom",
                                                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                                                softWrap: true),
                                              ),
                                              pw.Padding(
                                                padding: const pw.EdgeInsets.all(5),
                                                child: pw.Text("Quantity", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                                              ),
                                              pw.Padding(
                                                padding: const pw.EdgeInsets.all(5),
                                                child: pw.Text("Rate", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                                              ),
                                              pw.Padding(
                                                padding: const pw.EdgeInsets.all(5),
                                                child: pw.Text("CGST%", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                                              ),
                                              pw.Padding(
                                                padding: const pw.EdgeInsets.all(5),
                                                child: pw.Text("SGST%", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                                              ),
                                              pw.Padding(
                                                padding: const pw.EdgeInsets.all(5),
                                                child: pw.Text("Amount", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                                              ),
                                            ],
                                          ),
                                          // Data Rows (Dynamically generated)
                                          for (var item in tempTableData) pw.TableRow(
                                            children: [
                                              pw.Padding(
                                                padding: const pw.EdgeInsets.all(5),
                                                child: pw.Text(item.serialNumber.toString(), style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 10), softWrap: false),
                                              ),
                                              pw.Padding(
                                                padding: const pw.EdgeInsets.all(5),
                                                child: pw.Text(item.itemName, style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 10), softWrap: false),
                                              ),
                                              pw.Padding(
                                                padding: const pw.EdgeInsets.all(5),
                                                child: pw.Expanded(child: pw.Text(item.hsnCode, style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 10), softWrap: false) ),
                                              ),
                                              pw.Padding(
                                                padding: const pw.EdgeInsets.all(5),
                                                child: pw.Text(item.uom,
                                                    style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 10),softWrap: false,
                                                textAlign: pw.TextAlign.center) ,
                                              ),
                                              pw.Padding(
                                                padding: const pw.EdgeInsets.all(5),
                                                child: pw.Text(item.quantity.toString(), style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 10),
                                                    softWrap: false,
                                                textAlign: pw.TextAlign.right),
                                              ),
                                              pw.Padding(
                                                padding: const pw.EdgeInsets.all(5),
                                                child: pw.Text(item.rate.toString(),
                                                    style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 10),
                                                    softWrap: false,
                                                textAlign: pw.TextAlign.right),
                                              ),
                                              pw.Padding(
                                                padding: const pw.EdgeInsets.all(5),
                                                child: pw.Text(item.cgstPercent.toString(), style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 10),
                                                    softWrap: false,
                                                    textAlign: pw.TextAlign.right),
                                              ),
                                              pw.Padding(
                                                padding: const pw.EdgeInsets.all(5),
                                                child: pw.Text(item.sgstPercent.toString(), style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 10),
                                                    softWrap: false,
                                                    textAlign: pw.TextAlign.right),
                                              ),
                                              pw.Padding(
                                                padding: const pw.EdgeInsets.all(5),
                                                child: pw.Text(item.amount.toString(), style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 10),
                                                    softWrap: false,
                                                textAlign: pw.TextAlign.right),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ]
                                )
                            ),
                            pw.Container(width: PdfPageFormat.a4.width-40,
                                height: 20,
                                decoration: const pw.BoxDecoration(
                                    border: pw.Border(
                                        bottom: pw.BorderSide(width: 1, color: PdfColors.black))),
                                child: pw.Row(
                                    children: [
                                      pw.Container(
                                          width: pdfWidth * 0.300,
                                          height: 20,
                                          decoration: const pw.BoxDecoration(border: pw.Border(right: pw.BorderSide(width: 1, color: PdfColors.black))),
                                          child: pw.Row(
                                              children: [
                                                pw.Text("Bundles :", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                                                pw.Text("0", style: const pw.TextStyle( fontSize: 10)),
                                                pw.Text("Vehicle :", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                                                pw.Text(companyData['getInvData'][0]['Vehicle'].toString()  != "null"?companyData['getInvData'][0]['Vehicle'].toString():"", style: const pw.TextStyle( fontSize: 10)),
                                              ], mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly)  ),
                                      pw.Container(
                                          width: pdfWidth * 0.200,
                                          height: 20,
                                          decoration: const pw.BoxDecoration(border: pw.Border(right: pw.BorderSide(width: 1, color: PdfColors.black))),
                                          child: pw.Row(
                                              children: [
                                                pw.Text("Total Quantity : ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                                              ], mainAxisAlignment: pw.MainAxisAlignment.center)  ),
                                      pw.Container(
                                          width: pdfWidth * 0.106,
                                          height: 20,
                                          decoration: const pw.BoxDecoration(border: pw.Border(right: pw.BorderSide(width: 1, color: PdfColors.black))),
                                          child: pw.Row(
                                              children: [
                                                pw.Text(companyData['getInvData'][0]['TotQty'].toString()  != "null"?companyData['getInvData'][0]['TotQty'].toString():"", style: const pw.TextStyle( fontSize: 10)),
                                              ], mainAxisAlignment: pw.MainAxisAlignment.center)  ),
                                      pw.Container(
                                          width: pdfWidth * 0.1976,
                                          height: 20,
                                          decoration: const pw.BoxDecoration(border: pw.Border(right: pw.BorderSide(width: 1, color: PdfColors.black))),
                                          child: pw.Row(
                                              children: [
                                                pw.Text("Total", style: pw.TextStyle( fontWeight: pw.FontWeight.bold,fontSize: 10)
                                                ),
                                              ], mainAxisAlignment: pw.MainAxisAlignment.center)
                                      ),
                                      pw.Container(
                                          width: pdfWidth * 0.1964,
                                          height: 20,
                                          decoration: const pw.BoxDecoration(border: pw.Border(right: pw.BorderSide(width: 1, color: PdfColors.black))),
                                          child: pw.Row(
                                              children: [
                                                pw.Text(companyData['getInvData'][0]['TotAmount'].toString()  != "null"?companyData['getInvData'][0]['TotAmount'].toString():"", style: pw.TextStyle( fontWeight: pw.FontWeight.bold,fontSize: 12)
                                                ),
                                              ], mainAxisAlignment: pw.MainAxisAlignment.center)
                                      )
                                    ]
                                )
                            ),
                            pw.Container(width: PdfPageFormat.a4.width-40,
                                height: 110,
                                decoration: const pw.BoxDecoration(
                                    border: pw.Border(
                                        bottom: pw.BorderSide(width: 1, color: PdfColors.black))),
                                child: pw.Row(children: [
                                  pw.Container(width: pdfWidth*0.606,
                                      height: 110,
                                      decoration: const pw.BoxDecoration(border: pw.Border(right: pw.BorderSide(width: 1,
                                          color: PdfColors.black))),
                                      child: pw.Column(children: [
                                        pw.Container(
                                            width: pdfWidth*0.606,
                                            height: 40,
                                            child: pw.Row(
                                                children: [
                                                  pw.Expanded(child: pw.Text("Amount In Words: ",
                                                      style: const pw.TextStyle(fontSize: 10)))
                                                  ,
                                                  pw.Expanded(child: pw.Text("RUPEES ${integerPart.toWords().toUpperCase()} ONLY",
                                                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10),
                                                      overflow: pw.TextOverflow.span)),

                                                ], mainAxisAlignment: pw.MainAxisAlignment.center,
                                                crossAxisAlignment: pw.CrossAxisAlignment.center
                                            )
                                        ),
                                        pw.Container(
                                            width: pdfWidth*0.606,
                                            height: 70,
                                            child: pw.Row(
                                                children: [
                                                  pw.Expanded(child: pw.Text("Terms and Conditions: ",
                                                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10)))
                                                  ,
                                                  pw.Expanded(child: pw.Text("We are small industry as per MSME act "
                                                      "Our Udyam registrtion no is TN28-0137367 "
                                                      "The provisions  of section 43B(h) of income tax act is applicable on our supplies."
                                                      "Subject to Palladam Jurisdiction.",
                                                      style: const pw.TextStyle( fontSize: 10),
                                                      overflow: pw.TextOverflow.span)),

                                                ], mainAxisAlignment: pw.MainAxisAlignment.center,
                                                crossAxisAlignment: pw.CrossAxisAlignment.center
                                            )
                                        )
                                      ])),
                                  pw.Container(width: pdfWidth* 0.1976,
                                      height: 110,
                                      decoration: const pw.BoxDecoration(border: pw.Border(right: pw.BorderSide(width: 1,
                                          color: PdfColors.black))),
                                      child: pw.Column(children: [
                                        pw.SizedBox(height: 5),
                                        pw.Text("Discount", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10)),
                                        pw.SizedBox(height: 5),
                                        pw.Text("CGST", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10)),
                                        pw.SizedBox(height: 5),
                                        pw.Text("SGST", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10)),
                                        pw.SizedBox(height: 5),
                                        pw.Text("Roundoff", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))
                                      ])
                                  ),
                                  pw.Container(width: pdfWidth* 0.1964,
                                      height: 110,
                                      decoration: const pw.BoxDecoration(border: pw.Border(right: pw.BorderSide(width: 1,
                                          color: PdfColors.black))),
                                      child: pw.Column(children: [
                                        pw.SizedBox(height: 5),
                                        pw.Text(companyData['getInvData'][0]['DiscAmt'].toString()  != "null"?companyData['getInvData'][0]['DiscAmt'].toString():"", style: const pw.TextStyle(fontSize: 10)),
                                        pw.SizedBox(height: 5),
                                        pw.Text(companyData['getInvData'][0]['CGST'].toString()  != "null"?companyData['getInvData'][0]['CGST'].toString():"", style: const pw.TextStyle(fontSize: 10)),
                                        pw.SizedBox(height: 5),
                                        pw.Text(companyData['getInvData'][0]['SGST'].toString()  != "null"?companyData['getInvData'][0]['SGST'].toString():"", style: const pw.TextStyle(fontSize: 10)),
                                        pw.SizedBox(height: 5),
                                        pw.Text(companyData['getInvData'][0]['RoundAmt'].toString()  != "null"?companyData['getInvData'][0]['RoundAmt'].toString():"", style: const pw.TextStyle(fontSize: 10))
                                      ]))
                                ])),
                            pw.Container(width: PdfPageFormat.a4.width-40,
                                height: 20,
                                decoration: const pw.BoxDecoration(
                                    border: pw.Border(
                                        bottom: pw.BorderSide(width: 1, color: PdfColors.black))),
                                child: pw.Row(children: [
                                  pw.Container(width: pdfWidth*0.606,
                                      height: 20,
                                      decoration: const pw.BoxDecoration(
                                          border: pw.Border(
                                              right: pw.BorderSide(width: 1, color: PdfColors.black))),
                                      child: pw.Column(children:[
                                        pw.SizedBox(height: 3.5),
                                        pw.Text("Bank Details", style:pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,fontSize: 10
                                        ), textAlign: pw.TextAlign.center)]) ),
                                  pw.Container(width: pdfWidth*0.394,
                                      height: 20,
                                      decoration: const pw.BoxDecoration(
                                          border: pw.Border(
                                              right: pw.BorderSide(width: 1, color: PdfColors.black))),
                                      child: pw.Row(children:[
                                        pw.SizedBox(width: 7.5),
                                        pw.Text("Net Amount",style:pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,fontSize: 10
                                        )),
                                        pw.SizedBox(width: 73.5),
                                        pw.Text(companyData['getInvData'][0]['NetAmount'].toString()  != "null"?companyData['getInvData'][0]['NetAmount'].toString():"", style:pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,fontSize: 10
                                        ),textAlign: pw.TextAlign.end ),
                                        pw.SizedBox(width: 23.5),], mainAxisAlignment: pw.MainAxisAlignment.center,
                                          crossAxisAlignment: pw.CrossAxisAlignment.center) )
                                ], )
                            ),

                            pw.Container(width: PdfPageFormat.a4.width-40,
                                height: 87.8,
                                decoration: const pw.BoxDecoration(
                                    border: pw.Border(
                                        bottom: pw.BorderSide(width: 1, color: PdfColors.black))),
                                child:  pw.Row(children: [
                                  pw.Container(width: pdfWidth*0.606,
                                      height: 88,
                                      decoration: const pw.BoxDecoration(
                                          border: pw.Border(
                                              right: pw.BorderSide(width: 1, color: PdfColors.black))),
                                      child: pw.Column(
                                          children: [
                                            pw.SizedBox(height: 5.5),
                                            pw.Row(children: [
                                              pw.Text("Account Name : ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10)),
                                              pw.Text(companyData['compDetails'][0]['CompanyName'].toString() != "null" && companyData['compDetails'][0]['CompanyName'].toString() != ""?companyData['compDetails'][0]['CompanyName'].toString() : "-", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))
                                            ], mainAxisAlignment: pw.MainAxisAlignment.center, crossAxisAlignment: pw.CrossAxisAlignment.center),
                                            pw.Row(children: [
                                              pw.Text("Account No : ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10)),
                                              pw.Text(companyData['compDetails'][0]['AccNo'].toString() != "null" && companyData['compDetails'][0]['AccNo'].toString() != "" ?companyData['compDetails'][0]['AccNo'].toString(): "-", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))
                                            ], mainAxisAlignment: pw.MainAxisAlignment.center, crossAxisAlignment: pw.CrossAxisAlignment.center),
                                            pw.Row(children: [
                                              pw.Text("IFSC Code : ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10)),
                                              pw.Text(companyData['compDetails'][0]['Ifsc'].toString() != "null" && companyData['compDetails'][0]['Ifsc'].toString() != ""?companyData['compDetails'][0]['Ifsc'].toString(): "-", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))
                                            ], mainAxisAlignment: pw.MainAxisAlignment.center, crossAxisAlignment: pw.CrossAxisAlignment.center),
                                            pw.Row(children: [
                                              pw.Text("Bank Name : ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10)),
                                              pw.Text(companyData['compDetails'][0]['Bank'].toString() != "null" && companyData['compDetails'][0]['Bank'].toString() != ""?companyData['compDetails'][0]['Bank'].toString(): "-", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))
                                            ], mainAxisAlignment: pw.MainAxisAlignment.center, crossAxisAlignment: pw.CrossAxisAlignment.center),
                                            pw.Row(children: [
                                              pw.Text("Branch : ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10)),
                                              pw.Text(companyData['compDetails'][0]['Branch'].toString() != "null" && companyData['compDetails'][0]['Branch'].toString() != ""?companyData['compDetails'][0]['Branch'].toString(): "-", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))
                                            ], mainAxisAlignment: pw.MainAxisAlignment.center, crossAxisAlignment: pw.CrossAxisAlignment.center),

                                          ],
                                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                                          mainAxisAlignment: pw.MainAxisAlignment.center
                                      )
                                  ),
                                  pw.Container(width: pdfWidth*0.394,
                                      height: 88,
                                      decoration: const pw.BoxDecoration(
                                          border: pw.Border(
                                              right: pw.BorderSide(width: 1, color: PdfColors.black))),
                                      child: pw.Column(children: [
                                        pw.SizedBox(height: 5.5),
                                        pw.Row(children: [
                                          pw.Text("For ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                                          pw.Text(companyData['compDetails'][0]['CompanyName'].toString() != "null"?companyData['compDetails'][0]['CompanyName'].toString() : "", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))
                                        ], mainAxisAlignment: pw.MainAxisAlignment.center, crossAxisAlignment: pw.CrossAxisAlignment.center),
                                        pw.SizedBox(height: 45),
                                        pw.Text("Authorised Signature", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10)),
                                      ])
                                  )
                                ])
                            ),

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

        if(companyData['getInvData'].length>13){
          pdf.addPage(
            pw.Page(
              pageFormat: PdfPageFormat.a4,
              margin: pw.EdgeInsets.zero,
              build: (pw.Context context) {
                return pw.Stack(
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
                        height: PdfPageFormat.a4.height-40,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(width: 1),
                        ),
                        child: pw.Column(
                            children: [
                              pw.Container(width: PdfPageFormat.a4.width-40,
                                  height: 564,
                                  decoration: const pw.BoxDecoration(
                                      border: pw.Border(
                                          bottom: pw.BorderSide(width: 1, color: PdfColors.black))),
                                  child:pw.Column(
                                      children: [
                                        pw.Table(
                                          border: const pw.TableBorder(
                                              right: pw.BorderSide(width: 1, color: PdfColors.black),
                                              left: pw.BorderSide(width: 1, color: PdfColors.black),
                                              top: pw.BorderSide(width: 1, color: PdfColors.black),
                                              verticalInside: pw.BorderSide(width: 1, color: PdfColors.black)
                                          ),
                                          columnWidths: {
                                            0: const pw.FlexColumnWidth(0.075),
                                            1: const pw.FlexColumnWidth(0.225),
                                            2: const pw.FlexColumnWidth(0.125),
                                            3: const pw.FlexColumnWidth(0.075),
                                            4: const pw.FlexColumnWidth(0.106),
                                            5: const pw.FlexColumnWidth(0.1),
                                            6: const pw.FlexColumnWidth(0.0976),
                                            7: const pw.FlexColumnWidth(0.0964),
                                            8: const pw.FlexColumnWidth(0.1),
                                          },
                                          children: [
                                            // Header Row
                                            pw.TableRow(
                                              decoration: const pw.BoxDecoration(
                                                  color: PdfColors.grey300,
                                                  border: pw.Border(bottom:pw.BorderSide(width: 1, color: PdfColors.black))
                                              ),
                                              children: [
                                                pw.Padding(
                                                  padding: const pw.EdgeInsets.all(5),
                                                  child: pw.Text("S.No", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                                                ),
                                                pw.Padding(
                                                  padding: const pw.EdgeInsets.all(5),
                                                  child: pw.Text("Item", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                                                ),
                                                pw.Padding(
                                                  padding: const pw.EdgeInsets.all(5),
                                                  child: pw.Text("HSN Code", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                                                ),
                                                pw.Padding(
                                                  padding: const pw.EdgeInsets.all(5),
                                                  child: pw.Text("Uom",
                                                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                                                      softWrap: true),
                                                ),
                                                pw.Padding(
                                                  padding: const pw.EdgeInsets.all(5),
                                                  child: pw.Text("Quantity", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                                                ),
                                                pw.Padding(
                                                  padding: const pw.EdgeInsets.all(5),
                                                  child: pw.Text("Rate", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                                                ),
                                                pw.Padding(
                                                  padding: const pw.EdgeInsets.all(5),
                                                  child: pw.Text("CGST%", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                                                ),
                                                pw.Padding(
                                                  padding: const pw.EdgeInsets.all(5),
                                                  child: pw.Text("SGST%", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                                                ),
                                                pw.Padding(
                                                  padding: const pw.EdgeInsets.all(5),
                                                  child: pw.Text("Amount", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                                                ),
                                              ],
                                            ),
                                            // Data Rows (Dynamically generated)
                                            for (var item in tempTableData2) pw.TableRow(
                                              children: [
                                                pw.Padding(
                                                  padding: const pw.EdgeInsets.all(5),
                                                  child: pw.Text(item.serialNumber.toString(), style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 10)),
                                                ),
                                                pw.Padding(
                                                  padding: const pw.EdgeInsets.all(5),
                                                  child: pw.Text(item.itemName, style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 10)),
                                                ),
                                                pw.Padding(
                                                  padding: const pw.EdgeInsets.all(5),
                                                  child: pw.Expanded(child: pw.Text(item.hsnCode, style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 10)) ),
                                                ),
                                                pw.Padding(
                                                  padding: const pw.EdgeInsets.all(5),
                                                  child: pw.Expanded(child: pw.Text(item.uom,
                                                      style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 10),
                                                      textAlign: pw.TextAlign.center) ),
                                                ),
                                                pw.Padding(
                                                  padding: const pw.EdgeInsets.all(5),
                                                  child: pw.Text(item.quantity.toString(), style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 10),
                                                      textAlign: pw.TextAlign.right),
                                                ),
                                                pw.Padding(
                                                  padding: const pw.EdgeInsets.all(5),
                                                  child: pw.Text(item.rate.toString(),
                                                      style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 10),
                                                      textAlign: pw.TextAlign.right),
                                                ),
                                                pw.Padding(
                                                  padding: const pw.EdgeInsets.all(5),
                                                  child: pw.Text(item.cgstPercent.toString(), style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 10),
                                                      textAlign: pw.TextAlign.right),
                                                ),
                                                pw.Padding(
                                                  padding: const pw.EdgeInsets.all(5),
                                                  child: pw.Text(item.sgstPercent.toString(), style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 10),
                                                      textAlign: pw.TextAlign.right),
                                                ),
                                                pw.Padding(
                                                  padding: const pw.EdgeInsets.all(5),
                                                  child: pw.Text(item.amount.toString(), style: pw.TextStyle(fontWeight: pw.FontWeight.normal, fontSize: 10),
                                                      textAlign: pw.TextAlign.right),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      ]
                                  )
                              ),
                              pw.Container(width: PdfPageFormat.a4.width-40,
                                  height: 20,
                                  decoration: const pw.BoxDecoration(
                                      border: pw.Border(
                                          bottom: pw.BorderSide(width: 1, color: PdfColors.black))),
                                  child: pw.Row(
                                      children: [
                                        pw.Container(
                                            width: pdfWidth * 0.300,
                                            height: 20,
                                            decoration: const pw.BoxDecoration(border: pw.Border(right: pw.BorderSide(width: 1, color: PdfColors.black))),
                                            child: pw.Row(
                                                children: [
                                                  pw.Text("Bundles :", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                                                  pw.Text("0", style: const pw.TextStyle( fontSize: 10)),
                                                  pw.Text("Vehicle :", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                                                  pw.Text(companyData['getInvData'][0]['Vehicle'].toString()  != "null"?companyData['getInvData'][0]['Vehicle'].toString():"", style: const pw.TextStyle( fontSize: 10)),
                                                ], mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly)  ),
                                        pw.Container(
                                            width: pdfWidth * 0.200,
                                            height: 20,
                                            decoration: const pw.BoxDecoration(border: pw.Border(right: pw.BorderSide(width: 1, color: PdfColors.black))),
                                            child: pw.Row(
                                                children: [
                                                  pw.Text("Total Quantity : ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                                                ], mainAxisAlignment: pw.MainAxisAlignment.center)  ),
                                        pw.Container(
                                            width: pdfWidth * 0.106,
                                            height: 20,
                                            decoration: const pw.BoxDecoration(border: pw.Border(right: pw.BorderSide(width: 1, color: PdfColors.black))),
                                            child: pw.Row(
                                                children: [
                                                  pw.Text(companyData['getInvData'][0]['TotQty'].toString()  != "null"?companyData['getInvData'][0]['TotQty'].toString():"", style: const pw.TextStyle( fontSize: 10)),
                                                ], mainAxisAlignment: pw.MainAxisAlignment.center)  ),
                                        pw.Container(
                                            width: pdfWidth * 0.1976,
                                            height: 20,
                                            decoration: const pw.BoxDecoration(border: pw.Border(right: pw.BorderSide(width: 1, color: PdfColors.black))),
                                            child: pw.Row(
                                                children: [
                                                  pw.Text("Total", style: pw.TextStyle( fontWeight: pw.FontWeight.bold,fontSize: 10)
                                                  ),
                                                ], mainAxisAlignment: pw.MainAxisAlignment.center)
                                        ),
                                        pw.Container(
                                            width: pdfWidth * 0.1964,
                                            height: 20,
                                            decoration: const pw.BoxDecoration(border: pw.Border(right: pw.BorderSide(width: 1, color: PdfColors.black))),
                                            child: pw.Row(
                                                children: [
                                                  pw.Text(companyData['getInvData'][0]['TotAmount'].toString()  != "null"?companyData['getInvData'][0]['TotAmount'].toString():"", style: pw.TextStyle( fontWeight: pw.FontWeight.bold,fontSize: 12)
                                                  ),
                                                ], mainAxisAlignment: pw.MainAxisAlignment.center)
                                        )
                                      ]
                                  )
                              ),
                              pw.Container(width: PdfPageFormat.a4.width-40,
                                  height: 110,
                                  decoration: const pw.BoxDecoration(
                                      border: pw.Border(
                                          bottom: pw.BorderSide(width: 1, color: PdfColors.black))),
                                  child: pw.Row(children: [
                                    pw.Container(width: pdfWidth*0.606,
                                        height: 110,
                                        decoration: const pw.BoxDecoration(border: pw.Border(right: pw.BorderSide(width: 1,
                                            color: PdfColors.black))),
                                        child: pw.Column(children: [
                                          pw.Container(
                                              width: pdfWidth*0.606,
                                              height: 40,
                                              child: pw.Row(
                                                  children: [
                                                    pw.Expanded(child: pw.Text("Amount In Words: ",
                                                        style: const pw.TextStyle(fontSize: 10)))
                                                    ,
                                                    pw.Expanded(child: pw.Text("RUPEES ${integerPart.toWords().toUpperCase()} ONLY",
                                                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10),
                                                        overflow: pw.TextOverflow.span)),

                                                  ], mainAxisAlignment: pw.MainAxisAlignment.center,
                                                  crossAxisAlignment: pw.CrossAxisAlignment.center
                                              )
                                          ),
                                          pw.Container(
                                              width: pdfWidth*0.606,
                                              height: 70,
                                              child: pw.Row(
                                                  children: [
                                                    pw.Expanded(child: pw.Text("Terms and Conditions: ",
                                                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10)))
                                                    ,
                                                    pw.Expanded(child: pw.Text("We are small industry as per MSME act "
                                                        "Our Udyam registrtion no is TN28-0137367 "
                                                        "The provisions  of section 43B(h) of income tax act is applicable on our supplies."
                                                        "Subject to Palladam Jurisdiction.",
                                                        style: const pw.TextStyle( fontSize: 10),
                                                        overflow: pw.TextOverflow.span)),

                                                  ], mainAxisAlignment: pw.MainAxisAlignment.center,
                                                  crossAxisAlignment: pw.CrossAxisAlignment.center
                                              )
                                          )
                                        ])),
                                    pw.Container(width: pdfWidth* 0.1976,
                                        height: 110,
                                        decoration: const pw.BoxDecoration(border: pw.Border(right: pw.BorderSide(width: 1,
                                            color: PdfColors.black))),
                                        child: pw.Column(children: [
                                          pw.SizedBox(height: 5),
                                          pw.Text("Discount", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10)),
                                          pw.SizedBox(height: 5),
                                          pw.Text("CGST", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10)),
                                          pw.SizedBox(height: 5),
                                          pw.Text("SGST", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10)),
                                          pw.SizedBox(height: 5),
                                          pw.Text("Roundoff", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))
                                        ])
                                    ),
                                    pw.Container(width: pdfWidth* 0.1964,
                                        height: 110,
                                        decoration: const pw.BoxDecoration(border: pw.Border(right: pw.BorderSide(width: 1,
                                            color: PdfColors.black))),
                                        child: pw.Column(children: [
                                          pw.SizedBox(height: 5),
                                          pw.Text(companyData['getInvData'][0]['DiscAmt'].toString()  != "null"?companyData['getInvData'][0]['DiscAmt'].toString():"", style: const pw.TextStyle(fontSize: 10)),
                                          pw.SizedBox(height: 5),
                                          pw.Text(companyData['getInvData'][0]['CGST'].toString()  != "null"?companyData['getInvData'][0]['CGST'].toString():"", style: const pw.TextStyle(fontSize: 10)),
                                          pw.SizedBox(height: 5),
                                          pw.Text(companyData['getInvData'][0]['SGST'].toString()  != "null"?companyData['getInvData'][0]['SGST'].toString():"", style: const pw.TextStyle(fontSize: 10)),
                                          pw.SizedBox(height: 5),
                                          pw.Text(companyData['getInvData'][0]['RoundAmt'].toString()  != "null"?companyData['getInvData'][0]['RoundAmt'].toString():"", style: const pw.TextStyle(fontSize: 10))
                                        ]))
                                  ])),
                              pw.Container(width: PdfPageFormat.a4.width-40,
                                  height: 20,
                                  decoration: const pw.BoxDecoration(
                                      border: pw.Border(
                                          bottom: pw.BorderSide(width: 1, color: PdfColors.black))),
                                  child: pw.Row(children: [
                                    pw.Container(width: pdfWidth*0.606,
                                        height: 20,
                                        decoration: const pw.BoxDecoration(
                                            border: pw.Border(
                                                right: pw.BorderSide(width: 1, color: PdfColors.black))),
                                        child: pw.Column(children:[
                                          pw.SizedBox(height: 3.5),
                                          pw.Text("Bank Details", style:pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold,fontSize: 10
                                          ), textAlign: pw.TextAlign.center)]) ),
                                    pw.Container(width: pdfWidth*0.394,
                                        height: 20,
                                        decoration: const pw.BoxDecoration(
                                            border: pw.Border(
                                                right: pw.BorderSide(width: 1, color: PdfColors.black))),
                                        child: pw.Row(children:[
                                          pw.SizedBox(width: 7.5),
                                          pw.Text("Net Amount",style:pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold,fontSize: 10
                                          )),
                                          pw.SizedBox(width: 73.5),
                                          pw.Text(companyData['getInvData'][0]['NetAmount'].toString()  != "null"?companyData['getInvData'][0]['NetAmount'].toString():"", style:pw.TextStyle(
                                              fontWeight: pw.FontWeight.bold,fontSize: 10
                                          ),textAlign: pw.TextAlign.end ),
                                          pw.SizedBox(width: 23.5),], mainAxisAlignment: pw.MainAxisAlignment.center,
                                            crossAxisAlignment: pw.CrossAxisAlignment.center) )
                                  ], )
                              ),

                              pw.Container(width: PdfPageFormat.a4.width-40,
                                  height: 87.8,
                                  decoration: const pw.BoxDecoration(
                                      border: pw.Border(
                                          bottom: pw.BorderSide(width: 1, color: PdfColors.black))),
                                  child:  pw.Row(children: [
                                    pw.Container(width: pdfWidth*0.606,
                                        height: 88,
                                        decoration: const pw.BoxDecoration(
                                            border: pw.Border(
                                                right: pw.BorderSide(width: 1, color: PdfColors.black))),
                                        child: pw.Column(
                                            children: [
                                              pw.SizedBox(height: 5.5),
                                              pw.Row(children: [
                                                pw.Text("Account Name : ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10)),
                                                pw.Text(companyData['compDetails'][0]['CompanyName'].toString() != "null" && companyData['compDetails'][0]['CompanyName'].toString() != ""?companyData['compDetails'][0]['CompanyName'].toString() : "-", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))
                                              ], mainAxisAlignment: pw.MainAxisAlignment.center, crossAxisAlignment: pw.CrossAxisAlignment.center),
                                              pw.Row(children: [
                                                pw.Text("Account No : ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10)),
                                                pw.Text(companyData['compDetails'][0]['AccNo'].toString() != "null" && companyData['compDetails'][0]['AccNo'].toString() != "" ?companyData['compDetails'][0]['AccNo'].toString(): "-", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))
                                              ], mainAxisAlignment: pw.MainAxisAlignment.center, crossAxisAlignment: pw.CrossAxisAlignment.center),
                                              pw.Row(children: [
                                                pw.Text("IFSC Code : ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10)),
                                                pw.Text(companyData['compDetails'][0]['Ifsc'].toString() != "null" && companyData['compDetails'][0]['Ifsc'].toString() != ""?companyData['compDetails'][0]['Ifsc'].toString(): "-", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))
                                              ], mainAxisAlignment: pw.MainAxisAlignment.center, crossAxisAlignment: pw.CrossAxisAlignment.center),
                                              pw.Row(children: [
                                                pw.Text("Bank Name : ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10)),
                                                pw.Text(companyData['compDetails'][0]['Bank'].toString() != "null" && companyData['compDetails'][0]['Bank'].toString() != ""?companyData['compDetails'][0]['Bank'].toString(): "-", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))
                                              ], mainAxisAlignment: pw.MainAxisAlignment.center, crossAxisAlignment: pw.CrossAxisAlignment.center),
                                              pw.Row(children: [
                                                pw.Text("Branch : ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10)),
                                                pw.Text(companyData['compDetails'][0]['Branch'].toString() != "null" && companyData['compDetails'][0]['Branch'].toString() != ""?companyData['compDetails'][0]['Branch'].toString(): "-", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))
                                              ], mainAxisAlignment: pw.MainAxisAlignment.center, crossAxisAlignment: pw.CrossAxisAlignment.center),

                                            ],
                                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                                            mainAxisAlignment: pw.MainAxisAlignment.center
                                        )
                                    ),
                                    pw.Container(width: pdfWidth*0.394,
                                        height: 88,
                                        decoration: const pw.BoxDecoration(
                                            border: pw.Border(
                                                right: pw.BorderSide(width: 1, color: PdfColors.black))),
                                        child: pw.Column(children: [
                                          pw.SizedBox(height: 5.5),
                                          pw.Row(children: [
                                            pw.Text("For ", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                                            pw.Text(companyData['compDetails'][0]['CompanyName'].toString() != "null"?companyData['compDetails'][0]['CompanyName'].toString() : "", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10))
                                          ], mainAxisAlignment: pw.MainAxisAlignment.center, crossAxisAlignment: pw.CrossAxisAlignment.center),
                                          pw.SizedBox(height: 45),
                                          pw.Text("Authorised Signature", style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 10)),
                                        ])
                                    )
                                  ])
                              ),

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

        return pdf;
      }else{
        return null;
      }
    }catch(e){
      print(e);
      return null;
    }

  }


  Future<void> fetchSupplierData() async {
    try {
      // String tempResult=docId;
      // docId = docId.replaceAll("/","%2F");
      //String getLayPrep = "http://${ipAddress}:5025/api/getLayprep/" + docId ;
      String url="${ipAddress}api/getSupplierData/$globalCompId";
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
        //shipTo=CustomerIdList[0];


        _incrementCounter();
      }
    } catch (e) {
      print("chkErr");
      print(e);
    }
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
      String url="${ipAddress}api/getBillEntryData";
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
        savedShipToName= result[0]['Supplier'].toString();
        customerName=result[0]['Person'].toString();
        try {
          billEntryList.clear();
          prevBillEntryList.clear();
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
            prevBillEntryList.add(jsonEncode({
              "ITEMID": result[i]['ItemId'].toString(),
              "QUANTITY": result[i]['Quantity'].toString() != "null" ? double.parse(
                  result[i]['Quantity'].toString()) : 0.0
            }));
            savedTotalAmount = savedTotalAmount +double.parse(
                result[i]['TotAmt'].toString());
          }
          _employeeDataSource = EmployeeDataSource(billEntry: billEntryList);
        }catch(e){
          print("GridErr :- $e");
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
                title: const Text('Conn Err'),
                content: const Text("Please ReOpen this Page"), // Content of the dialog
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
      print("chkErr");
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return
            AlertDialog(
              title: const Text('Conn Err'),
              content: const Text("Please ReOpen this Page"), // Content of the dialog
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


  Future<void> fetchItemData() async {
    try {
      // String tempResult=docId;
      // docId = docId.replaceAll("/","%2F");
      //String getLayPrep = "http://${ipAddress}:5025/api/getLayprep/" + docId ;
      String getApi="${ipAddress}api/getItemData/$globalCompId";
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

  Future<void> updateBillEntryData(List masData,List detData)async {
    String cutTableApi ="${ipAddress}api/updateBillEntryData";
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
                      child: const Text('OK'),
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
                  title: const Text('REASON'),
                  content: const Text("Update Failed, Please Try Again"),
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

  Future<void> saveBillEntryData(List masData, List detData)async {
    String cutTableApi ="${ipAddress}api/saveBillEntry";
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
          String invNum= invoiceNum;
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
          _controller.clear();
          edate = DateFormat('dd/MM/yyyy').format(now);
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
          grandTotalAmount = 0.0;
          SalesType = ["Sales", "Sales B"];
          salesTypeidx = 0;

          selected = false;
          index = -1;

          date.clear();
          _itemController.clear();
          qtyTextController.clear();
          itemTextController.clear();
          discTextController.clear();
          rateTextController.clear();
          gstTextController.clear();
          _customerController.clear();
          _shipToController.clear();


          currentDate = DateTime.now();

          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return
                AlertDialog(
                  title: const Text('REASON'),
                  content: const Text("Bill Generated Successfully"),
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

          BillTypeList.add("Non-GST Bill");
          BillTypeList.add("GST Bill");
          PayTypeList.add("Credit");
          PayTypeList.add("Cash");
          billType = BillTypeList[0];
          getInvoiceNumber("NGST",true);
          payType = PayTypeList[0];
          print("currentDate");
          print(currentDate);
          date.text = currentDate.toString().split(' ')[0];
          fetchSupplierData();
          fetchItemData();
          billEntryList = [];
          _employeeDataSource = EmployeeDataSource(billEntry: []);

          try {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return
                  AlertDialog(
                    content: const Text("Do you want the print of Invoice ?"),
                    // Content of the dialog
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Yes'),
                        onPressed: () async {
                          showLoaderDialog(context);
                          final pdf = await fetchPdfDocument(
                              invNum);
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                 WillPopScope(child:  Scaffold(
                                   appBar: AppBar(title: const Text(
                                       'Invoice Preview')),
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
                          ); // Close the dialog
                        },
                      ),
                      TextButton(
                        child: const Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                    ],
                  );
              },
            );
          }catch(e){
            print("Error :- $e");
          }


        } else {
          // Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return
                AlertDialog(
                  title: const Text('REASON'),
                  content: const Text("Bill Entry Generation Failed"),
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

  Future<void> getInvoiceNumber(String payType, bool chk) async{
    String cutTableApi ="${ipAddress}api/getInvoiceNumber";
    print(cutTableApi);
    // Use addPostFrameCallback to show the dialog
    if(!chk) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          showBillNoLoaderDialog(context);
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
        print(data);
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
                  title: const Text('Connection Error'),
                  content: const Text("Please Reselect the Bill Type to Update Invoice"), // Content of the dialog
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
        if(!chk) {
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return
                AlertDialog(
                  title: const Text('Connection Error'),
                  content: const Text("Please Reselect the Bill Type to Update Invoice"), // Content of the dialog
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
        }else{
          Navigator.pop(context);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return
                AlertDialog(
                  title: const Text('Connection Error'),
                  content: const Text("Please Reselect the Bill Type to Update Invoice"), // Content of the dialog
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
    }catch(e){
     if(!chk) {
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return
              AlertDialog(
                title: const Text('Connection Error'),
                content: const Text("Please Reselect the Bill Type to Update Invoice"), // Content of the dialog
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
     }else{
       Navigator.pop(context);
       showDialog(
         context: context,
         builder: (BuildContext context) {
           return
             AlertDialog(
               title: const Text('Connection Error'),
               content: const Text("Please Reselect the Bill Type to Update Invoice"), // Content of the dialog
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
  }

  late EmployeeDataSource _employeeDataSource;
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight]);
    try {
      print(widget.data['valid']);
      approvalValue=widget.data['valid'];
    }catch(e){
      approvalValue=false;
    }
    print("valid");
    if(!approvalValue) {
      BillTypeList.add("Non-GST Bill");
      BillTypeList.add("GST Bill");
      PayTypeList.add("Credit");
      PayTypeList.add("Cash");
      billType = BillTypeList[0];
      getInvoiceNumber("NGST", false);
      payType = PayTypeList[0];
      date.text = currentDate.toString().split(' ')[0];
      fetchSupplierData();
      fetchItemData();
      billEntryList=[];
      _employeeDataSource = EmployeeDataSource(billEntry: []);
    }else{
      BillTypeList.add("Non-GST Bill");
      BillTypeList.add("GST Bill");
      PayTypeList.add("Credit");
      PayTypeList.add("Cash");
      billType = BillTypeList[0];
      // getInvoiceNumber("NGST", false);
      payType = PayTypeList[0];
      invoiceNum="";
      fetchSavedData(widget.data['transno']);
      // date.text = currentDate.toString().split(' ')[0];
      // fetchSupplierData();
      // fetchItemData();
      _employeeDataSource = EmployeeDataSource(billEntry: []);
    }
    // getGridData();
  }

  Future<void> getGridData(bool delChk, bool apprChk) async {
    // billEntryList = [
    //   BillEntry(1, '222', 'ALMOND', 'PCS', '1234', 557.00, 10, 500.00, 5000.00, 5.00, 250.00, 450.00, 5700.00),
    //   BillEntry(2, '888', 'NUTS', 'PCS', '4678', 557.00, 10, 500.00, 5000.00, 5.00, 250.00, 450.00, 5700.00),
    // ];
    // if(item !="") {
    print("save Operation Working");
    bool dupChk=false;
    if(selected && !delChk){
     item = _itemController.text.toString();
    }else{
      if(billEntryList.isNotEmpty) {
        for (int i = 0; i < billEntryList.length; i++) {
          if (billEntryList[i].item == item) {
            dupChk=true;
            break;
          }
        }
      }
    }
    if(!dupChk) {

      int idx = !approvalValue ? ItemList.indexOf(item):0;
      print("idx :- $idx");
      double rate =  itemRate ;
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
      print("stateCodeId");
      print(stateCodeId);
      if (billType == "Non-GST Bill") {
        gstAmount = 0.0;
      } else {
        if(!delChk){
        if (stateCodeId == 68 ) { //checking TN Gst
          print("State Code $stateCodeId");
          cgstp = !approvalValue ?CGstList[idx]: billEntryList[index].CgstP;
          sgstp = !approvalValue ?SGstList[idx]: billEntryList[index].SgstP;
          print("State Code $stateCodeId");
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
            "0"
        ));
      }
      else if (delChk) {
        billEntryList.removeAt(index);
        if (billEntryList.isNotEmpty) {
          for (int i = 0; i < billEntryList.length; i++) {
            billEntryList[i].sno = i + 1;
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
            billEntryList[i].item = item;
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
      if (billEntryList.isNotEmpty) {
        for (int i = 0; i < billEntryList.length; i++) {
          grandTotalAmount = billEntryList[i].TotAmt + grandTotalAmount;
          savedTotalAmount = billEntryList[i].TotAmt + savedTotalAmount;
              print("${billEntryList[i].name} ,${billEntryList[i].item} ,${billEntryList[i].uom} ,${billEntryList[i].hsnCode} ,${billEntryList[i].stock} ,${billEntryList[i].quantity} ,${billEntryList[i].rate} ,${billEntryList[i].disc} ,${billEntryList[i].amount} ,${billEntryList[i].discAmt} ,${billEntryList[i].GSTAmt} ,${billEntryList[i].TotAmt} ,${billEntryList[i].AmtWOGst} ,${billEntryList[i].AmtWDisc} ,${billEntryList[i].CgstP} ,${billEntryList[i].CgstA} ,${billEntryList[i].SgstP} ,${billEntryList[i].SgstA} ,${billEntryList[i].IgstP} ,${billEntryList[i].IgstA} ,${billEntryList[i].discP} ,");
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
      String valueStr="The following item($item) Already exists";
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return
            AlertDialog(
              title: const Text('Duplicate Error'),
              content: Text(valueStr), // Content of the dialog
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print("${height}height");
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
      double length= billEntryList.isEmpty?initialHeightPercent:gridHeightPercent;
      gridHeight= height*length;
    }

    return WillPopScope(child:
    Scaffold(
      backgroundColor: Colors.pink[50],
        appBar:
        CustomAppBar(userName: globalUserName, emailId: globalEmailId,
            onMenuPressed: (){
              Scaffold.of(context).openDrawer();
            }, barTitle: "SALES ENTRY"),
        drawer:
        const customDrawer(stkTransferCheck: false,
            brhTransferCheck: false),
        body:Container(
          // color: Colors.pink[50],
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
                            padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
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
                                      contentPadding: const EdgeInsets.symmetric(vertical: 0,horizontal: 15),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      // Add more decoration..
                                      // contentPadding: EdgeInsets.symmetric(vertical:height*0.009 )
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
                                    onChanged: !approvalValue?
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
                                    }:null,
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
                                    dropdownStyleData: const DropdownStyleData(
                                      decoration: BoxDecoration(
                                        // borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    menuItemStyleData: const MenuItemStyleData(
                                      //  padding: EdgeInsets.symmetric(horizontal: 16),
                                    ),
                                    isDense: true,

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
                                        // textAlign: TextAlign.center,
                                        controller: TextEditingController()..text= invoiceNum.toString(),
                                        decoration: const InputDecoration(
                                          contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                          border: OutlineInputBorder(),labelText: 'Invoice No',
                                            fillColor: Colors.white, filled: true,
                                            // contentPadding: EdgeInsets.symmetric(vertical: height*0.01),
                                          ),
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
                                          fillColor: Colors.white,
                                          suffixIcon: IconButton(
                                            icon: const Icon(Icons.calendar_today),
                                            onPressed: !approvalValue ?
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
                                                });
                                              }
                                            }:null,
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
                                  if(salesTypeidx == 0){
                                    salesTypeidx=1;
                                  }else{
                                    salesTypeidx=0;
                                  }
                                });
                              },
                                child: Text(SalesType[salesTypeidx] ),
                              ),
                            ],
                          ),
                          //const Padding(padding:EdgeInsets.all(5)),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children:[
                                !approvalValue?
                                 Padding(padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                                child:Autocomplete<String>(
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
                                          if(!CustomerList.contains(value)){
                                            controller.text="";
                                          }else{
                                            setState(() {
                                              customer = value;
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
                                            border: const OutlineInputBorder(),
                                            // contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
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
                                                customer = option;
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
                                ) ,)
                                :
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
                                              decoration: const InputDecoration(border: OutlineInputBorder(),labelText: 'Customer',
                                                fillColor: Colors.white, filled: true,
                                                contentPadding: EdgeInsets.fromLTRB(15,0,0,0),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ]
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
                          //         // DropdownButtonFormField2<String>(
                          //         //   isExpanded: true,
                          //         //   value: payType,
                          //         //   decoration: InputDecoration(
                          //         //     //alignLabelWithHint: true,
                          //         //     fillColor: Colors.white,
                          //         //     filled: true,
                          //         //     labelText: "Pay Type",
                          //         //     border: OutlineInputBorder(
                          //         //     ),
                          //         //     // Add more decoration..
                          //         //   ),
                          //         //   hint: const Text(
                          //         //     'Select your pay type',
                          //         //     style: TextStyle(fontSize: 14),
                          //         //   ),
                          //         //   items: PayTypeList
                          //         //       .map((item) => DropdownMenuItem<String>(
                          //         //     value: item,
                          //         //     child: Text(
                          //         //       item,
                          //         //       style: const TextStyle(
                          //         //         fontSize: 14,
                          //         //       ),
                          //         //     ),
                          //         //   ))
                          //         //       .toList(),
                          //         //   validator: (value) {
                          //         //     //print("Check Point Working 2");
                          //         //     if (value == null) {
                          //         //       return 'Please pay type.';
                          //         //     }
                          //         //     return null;
                          //         //   },
                          //         //   onChanged: !approvalValue ?
                          //         //       (String? value) {
                          //         //     setState(() {
                          //         //       payType = value!;
                          //         //     });
                          //         //   }:null,
                          //         //   onSaved: (String? value) {
                          //         //     payType = value!;
                          //         //
                          //         //   },
                          //         //   buttonStyleData: const ButtonStyleData(
                          //         //     padding: EdgeInsets.only(right: 0),
                          //         //   ),
                          //         //   iconStyleData: const IconStyleData(
                          //         //     icon: Icon(
                          //         //       Icons.arrow_drop_down,
                          //         //       color: Colors.black45,
                          //         //     ),
                          //         //     iconSize: 24,
                          //         //   ),
                          //         //   dropdownStyleData: DropdownStyleData(
                          //         //     decoration: BoxDecoration(
                          //         //       // borderRadius: BorderRadius.circular(15),
                          //         //     ),
                          //         //   ),
                          //         //   menuItemStyleData: const MenuItemStyleData(
                          //         //     //padding: EdgeInsets.symmetric(horizontal: 16),
                          //         //   ),
                          //         // ),
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
                                              decoration: const InputDecoration(
                                                //alignLabelWithHint: true,
                                                fillColor: Colors.white,
                                                filled: true,
                                                labelText: "Pay Type",
                                                border: OutlineInputBorder(
                                                ),
                                                contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0)
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
                                              dropdownStyleData: const DropdownStyleData(
                                                decoration: BoxDecoration(
                                                  // borderRadius: BorderRadius.circular(15),
                                                ),
                                              ),
                                              menuItemStyleData: const MenuItemStyleData(
                                                //padding: EdgeInsets.symmetric(horizontal: 16),
                                              ),
                                            ) ),
                                            const SizedBox(width: 20,),
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
                                                    if(!CustomerList.contains(value)){
                                                      controller.text="";
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
                                                    border: const OutlineInputBorder(),
                                                    contentPadding: const EdgeInsets.fromLTRB(15, 0, 0, 0)
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
                                            ))],)
                                      ,
                                      // TextFormField(
                                      //   showCursor: false,
                                      //   readOnly: true,
                                      //   controller: TextEditingController()..text= shipTo,
                                      //   decoration: InputDecoration(border: OutlineInputBorder(),labelText: 'Ship To',
                                      //       fillColor: Colors.white, filled: true),
                                      // ),
                                    ) :
                                    BootstrapCol(
                                      sizes: 'col-md-12',
                                      child:
                                          Row(children: [
                                            Expanded(child:DropdownButtonFormField2<String>(
                                              isExpanded: true,
                                              value: payType,
                                              decoration: const InputDecoration(
                                                //alignLabelWithHint: true,
                                                fillColor: Colors.white,
                                                filled: true,
                                                labelText: "Pay Type",
                                                border: OutlineInputBorder(
                                                ),
                                                contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0)
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
                                              dropdownStyleData: const DropdownStyleData(
                                                decoration: BoxDecoration(
                                                  // borderRadius: BorderRadius.circular(15),
                                                ),
                                              ),
                                              menuItemStyleData: const MenuItemStyleData(
                                                //padding: EdgeInsets.symmetric(horizontal: 16),
                                              ),
                                            ) ),
                                            const SizedBox(width: 20,),
                                            Expanded(child: TextFormField(
                                              showCursor: false,
                                              readOnly: true,
                                              // textAlign: TextAlign.center,
                                              controller: TextEditingController()..text= savedShipToName.toString(),
                                              decoration: const InputDecoration(border: OutlineInputBorder(),labelText: 'Ship To',
                                                fillColor: Colors.white, filled: true,
                                                  contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0)
                                                // contentPadding: EdgeInsets.symmetric(vertical: height*0.01),
                                              ),
                                            ),)
                                          ],)
                                      
                                    ),
                                  ],
                                ),
                              ]
                          ),


                          Column(children: [
                            Padding(
                            padding:  EdgeInsets.fromLTRB( !approvalValue ?25:0, 30,
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
                                 !approvalValue?
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
                                            item = value;
                                          });
                                        },
                                        onSubmitted: (value) {
                                          // if(ItemList.indexOf(value)==-1){
                                          //   controller..text="";
                                          // }else{
                                          setState(() {
                                            item = value;
                                          });
                                          // }
                                        },
                                        decoration: const InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
                                          labelText: "Item",
                                          hintText: 'Search for a item',
                                          border: OutlineInputBorder(),
                                          contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0)
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
                                                  print("Selection : $option");
                                                  item = option;
                                                  print(ItemList.indexOf(item));
                                                  if(ItemList.contains(item)){
                                                    setState(() {
                                                      itemRate= RateList[ItemList.indexOf(item)];
                                                      print("Rate : $itemRate");
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
                                  ) :
                                 BootstrapContainer(
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
                                                   contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
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
                                                decoration: const InputDecoration(border: OutlineInputBorder(),
                                                    labelText: 'Quantity',
                                                    contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                                    fillColor: Colors.white, filled: true),
                                              ))
                                              ,const SizedBox(width: 20,),
                                              Expanded(child: TextFormField(
                                                keyboardType: TextInputType.text,
                                                showCursor: false,
                                                readOnly: true,
                                                // onChanged: (String newValue){
                                                //   itemRate = double.parse(newValue);
                                                // },
                                                controller: gstTextController,
                                                decoration: const InputDecoration(border: OutlineInputBorder(),labelText: 'Gst',
                                                    fillColor: Colors.white, filled: true,
                                                    contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0)),
                                              )),],)
                                        ,
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
                                          decoration: const InputDecoration(border: OutlineInputBorder(),labelText: 'Disc',
                                              fillColor: Colors.white, filled: true,
                                              contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0)),
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
                                        TextFormField(
                                          keyboardType: TextInputType.number,
                                          // showCursor: false,
                                          // readOnly: true,
                                          onChanged: (String newValue){
                                            itemRate = double.parse(newValue);
                                          },
                                          controller: rateTextController,
                                          decoration: const InputDecoration(border: OutlineInputBorder(),labelText: 'Rate',
                                              fillColor: Colors.white, filled: true,
                                              contentPadding: EdgeInsets.fromLTRB(15, 0, 0, 0)),
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
                                      if (qty != 0.0) {
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
                                      }
                                      else {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return
                                              AlertDialog(
                                                title: const Text('REASON'),
                                                content: const Text(
                                                    "Please Enter The Qty"),
                                                // Content of the dialog
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
                                        foregroundColor: Colors.black,
                                        backgroundColor: const Color(0xFF004D40),
                                        textStyle: const TextStyle(color: Colors.black,
                                            fontWeight: FontWeight.bold)
                                    ),
                                    child: const Text('Save', style: TextStyle(
                                        color: Colors.white
                                    ),),
                                  ),
                                  !approvalValue ?const SizedBox(width: 10): const SizedBox(height: 0.01,),
                                  !approvalValue ?ElevatedButton(
                                    onPressed: () {
                                      getGridData(true,false);
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
                                        backgroundColor: const Color(0xFF004D40),
                                        textStyle: const TextStyle(color: Colors.black,
                                            fontWeight: FontWeight.bold)
                                    ),
                                    child: const Text('Delete', style: TextStyle(
                                        color: Colors.white
                                    ),),
                                  ): const SizedBox(height: 0.01,),
                                  const SizedBox(width: 10),
                                  approvalValue ?IconButton(onPressed: () async{

                                    if(pdfChk) {
                                      pdfChk=false;
                                      print("button working started");
                                      // if (pdfKey.currentState != null) {

                                      showLoaderDialog(context);
                                      final pdf = await fetchPdfDocument(
                                          invoiceNum);
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Scaffold(
                                                appBar: AppBar(title: const Text(
                                                    'Invoice Preview')),
                                                body: pdf != null ? PdfPreview(
                                                  build: (format) => pdf.save(),
                                                ) : const Scaffold(body: Center(
                                                  child: Text(
                                                    "Pdf Fetching Error",
                                                    style: TextStyle(
                                                        fontSize: 16),),),),
                                              ),
                                        ),
                                      );
                                      print("Export finished");


                                      print("button working ended");
                                      pdfChk=true;
                                    }
                                  }, icon: const Icon(Icons.picture_as_pdf)):const SizedBox(height: 0.01,),
                                ],)
                            ),
                          ],),



                          const Padding(padding: EdgeInsets.fromLTRB(0, 30, 0, 0)),
                          Column(children: [
                            SizedBox(
                            height: gridHeight,
                            child:
                            SfDataGridTheme(
                              data: SfDataGridThemeData(
                                currentCellStyle: const DataGridCurrentCellStyle(
                                  borderWidth: 2,
                                  borderColor: Colors.pinkAccent,
                                ),
                                selectionColor: Colors.lightGreen[50],
                                headerColor: const Color(0xFF004D40),
                              ),
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(//width > 1400 ? 75
                                    0, 0, 0, 0),
                                child:
                                SfDataGrid(
                                  key: pdfKey,
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
                                      columnName: 'sno',
                                      width: 65,
                                      allowEditing: false,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        alignment: Alignment.centerLeft,
                                        child: const Text('SNO', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'name',
                                      width: 75,
                                      visible: false,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text('Code', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'item',
                                      width: 250,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text('Particular', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'uom',
                                      width: 75,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text('Uom', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'hsnCode',
                                      width: 100,
                                      visible: false,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text('HsnCode', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'stock',
                                      width: 100,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text('Stock', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'quantity',
                                      width: 100,
                                      allowEditing: true,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text('Quantity', overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'rate',
                                      width: 100,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text('Rate', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'amount',
                                      width: 100,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text('Amount', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'disc',
                                      visible: false,
                                      width: 100,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text('Disc', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'discAmt',
                                      width: 100,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text('DiscAmt', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'GSTAmt',
                                      width: 100,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text('GSTAmt', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                    GridColumn(
                                      columnName: 'TotAmt',
                                      width: 100,
                                      label: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                        alignment: Alignment.center,
                                        child: const Text('TotAmt', overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white)),
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
                                      _itemController.text=data.getCells()[2].value;
                                      discTextController.text=data.getCells()[9].value.toString();
                                      rateTextController.text=data.getCells()[7].value.toString();
                                      if(billType=="GST Bill") {
                                        int gstIdx= billEntryList.indexWhere((entry){
                                          return entry.item==data.getCells()[2].value.toString();
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
                                      discount=data.getCells()[9].value;
                                      itemRate = data.getCells()[7].value;
                                    });
                                  },
                                  columnWidthMode: ColumnWidthMode.fill,
                                ),
                              ),
                            ),),],),


                          const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),
                          Center(child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 20,),Text("Total Amount : - ${!approvalValue?grandTotalAmount:savedTotalAmount}"),
                              const SizedBox(width: 20,),
                              ElevatedButton(
                                onPressed: () {
                                  if(!approvalValue) {
                                    if (billEntryList.isNotEmpty &&
                                        shipTo != 0) {
                                      List<dynamic> detList = [];
                                      double totalAmount = 0.0;
                                      double totalQty = 0.0;
                                      double totalAmountWOGst = 0.0;
                                      double vatAmt = 0.0;
                                      double discAmt = 0.0;
                                      double cGst = 0.0;
                                      double sGst = 0.0;
                                      double iGst = 0.0;
                                      double Gst = 0.0;
                                      for (int i = 0; i <
                                          billEntryList.length; i++) {
                                        detList.add({
                                          "id": billEntryList[i].sno,
                                          "itemId": billEntryList[i].name,
                                          "item": billEntryList[i].item,
                                          "uom": billEntryList[i].uom,
                                          "hsnCode": billEntryList[i].hsnCode,
                                          "stock": billEntryList[i].stock,
                                          "quantity": billEntryList[i].quantity,
                                          "rate": billEntryList[i].rate,
                                          "amount": billEntryList[i].amount,
                                          "disc": billEntryList[i].disc,
                                          "discAmt": billEntryList[i].discAmt,
                                          "GSTAmt": billEntryList[i].GSTAmt,
                                          "TotAmt": billEntryList[i].TotAmt,
                                          "AmtWOGst": billEntryList[i].AmtWOGst,
                                          "AmtWDisc": billEntryList[i].AmtWDisc,
                                          "CgstP": billEntryList[i].CgstP,
                                          "CgstA": billEntryList[i].CgstA,
                                          "SgstP": billEntryList[i].SgstP,
                                          "SgstA": billEntryList[i].SgstA,
                                          "IgstP": billEntryList[i].IgstP,
                                          "IgstA": billEntryList[i].IgstA,
                                          "discP": billEntryList[i].discP,
                                        });
                                        totalAmount = totalAmount +
                                            billEntryList[i].TotAmt;
                                        totalQty = totalQty +
                                            billEntryList[i].quantity;
                                        totalAmountWOGst = totalAmountWOGst +
                                            billEntryList[i].AmtWOGst;
                                        vatAmt =
                                            vatAmt + billEntryList[i].GSTAmt;
                                        discAmt =
                                            discAmt + billEntryList[i].discAmt;
                                        cGst = cGst + billEntryList[i].CgstA;
                                        sGst = sGst + billEntryList[i].SgstA;
                                        iGst = iGst + billEntryList[i].IgstA;
                                      }
                                      double roundAmt = vatAmt.toInt() - vatAmt;
                                      roundAmt = double.parse(
                                          roundAmt.toStringAsFixed(2));
                                      Gst = cGst + sGst + iGst;
                                      List<dynamic> masList = [];
                                      masList.add({
                                        "InvoiceNo": invoiceNum,
                                        "SupplierId": customerId,
                                        "Person": customer,
                                        "NetAmount": totalAmount,
                                        "TotQty": totalQty,
                                        "TotAmountWOGst": totalAmountWOGst,
                                        "PayType": payType == "Cash"
                                            ? "C"
                                            : "D",
                                        "CompId": globalCompId,
                                        "VatAmt": vatAmt,
                                        "RoundAmt": roundAmt < 0.50 &&
                                            roundAmt != 0.0
                                            ? -(roundAmt)
                                            : roundAmt,
                                        "discAmt": discAmt,
                                        "isVat": vatAmt == 0.0 ? "N" : "Y",
                                        "Cgst": cGst,
                                        "Sgst": sGst,
                                        "Igst": iGst,
                                        "Gst": Gst,
                                        "ShipTo": shipTo,
                                        "BillType": salesTypeidx == 0
                                            ? "A"
                                            : "B",
                                        "dat": edate
                                      });
                                      print("jsonObject");
                                      print(masList.length);
                                      print(masList);

                                      saveBillEntryData(masList, detList);
                                    }
                                    else {
                                      print(shipTo);
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return
                                            AlertDialog(
                                              title: const Text('ALERT'),
                                              content: shipTo == 0
                                                  ? const Text(
                                                  "Please select/Reselect the shipTo")
                                                  : const Text(
                                                  "Please Save The Item, Before Generating The Bill"),
                                              // Content of the dialog
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
                                  }else{
                                    if (billEntryList.isNotEmpty ) {
                                      List<dynamic> detList = [];
                                      double totalAmount = 0.0;
                                      double totalQty = 0.0;
                                      double totalAmountWOGst = 0.0;
                                      double vatAmt = 0.0;
                                      double discAmt = 0.0;
                                      double cGst = 0.0;
                                      double sGst = 0.0;
                                      double iGst = 0.0;
                                      double Gst = 0.0;

                                      // var prevQty= jsonDecode(prevBillEntryList[idx1]);
                                      // prevQty['QUANTITY'];
                                      // print(prevQty);
                                      for (int i = 0; i <
                                          billEntryList.length; i++) {
                                        int pqIdx= prevBillEntryList.indexWhere((entry){
                                          var decodedValue = jsonDecode(entry);
                                          print(decodedValue["ITEMID"].toString()==billEntryList[i].name);
                                          return decodedValue["ITEMID"].toString()==billEntryList[i].name;
                                        });
                                        var prevQty= jsonDecode(prevBillEntryList[pqIdx]);
                                        detList.add({
                                          "id": billEntryList[i].sno,
                                          "itemId": billEntryList[i].name,
                                          "item": billEntryList[i].item,
                                          "uom": billEntryList[i].uom,
                                          "hsnCode": billEntryList[i].hsnCode,
                                          "stock": billEntryList[i].stock,
                                          "quantity": billEntryList[i].quantity,
                                          "rate": billEntryList[i].rate,
                                          "amount": billEntryList[i].amount,
                                          "disc": billEntryList[i].disc,
                                          "discAmt": billEntryList[i].discAmt,
                                          "GSTAmt": billEntryList[i].GSTAmt,
                                          "TotAmt": billEntryList[i].TotAmt,
                                          "AmtWOGst": billEntryList[i].AmtWOGst,
                                          "AmtWDisc": billEntryList[i].AmtWDisc,
                                          "CgstP": billEntryList[i].CgstP,
                                          "CgstA": billEntryList[i].CgstA,
                                          "SgstP": billEntryList[i].SgstP,
                                          "SgstA": billEntryList[i].SgstA,
                                          "IgstP": billEntryList[i].IgstP,
                                          "IgstA": billEntryList[i].IgstA,
                                          "discP": billEntryList[i].discP,
                                          "InvoiceNum": invoiceNum,
                                          "ChangedQty": double.parse(prevQty['QUANTITY'].toString())-double.parse(billEntryList[i].quantity.toString()),
                                          "ChangeChk": double.parse(prevQty['QUANTITY'].toString())-double.parse(billEntryList[i].quantity.toString()) == 0.0 ?
                                                       false:true
                                        });
                                        totalAmount = totalAmount +
                                            billEntryList[i].TotAmt;
                                        totalQty = totalQty +
                                            billEntryList[i].quantity;
                                        totalAmountWOGst = totalAmountWOGst +
                                            billEntryList[i].AmtWOGst;
                                        vatAmt =
                                            vatAmt + billEntryList[i].GSTAmt;
                                        discAmt =
                                            discAmt + billEntryList[i].discAmt;
                                        cGst = cGst + billEntryList[i].CgstA;
                                        sGst = sGst + billEntryList[i].SgstA;
                                        iGst = iGst + billEntryList[i].IgstA;
                                      }
                                      double roundAmt = vatAmt.toInt() - vatAmt;
                                      roundAmt = double.parse(
                                          roundAmt.toStringAsFixed(2));
                                      Gst = cGst + sGst + iGst;
                                      print("jsonObject");
                                      print(detList.length);
                                      print(detList);

                                      List<dynamic> masList = [];
                                      masList.add({
                                        "InvoiceNo": invoiceNum,
                                        "NetAmount": totalAmount,
                                        "TotQty": totalQty,
                                        "TotAmountWOGst": totalAmountWOGst,
                                        "CompId": globalCompId,
                                        "RoundAmt": roundAmt < 0.50 &&
                                            roundAmt != 0.0
                                            ? -(roundAmt)
                                            : roundAmt,
                                        "VatAmt": vatAmt,
                                        "discAmt": discAmt,
                                        "Cgst": cGst,
                                        "Sgst": sGst,
                                        "Igst": iGst,
                                        "Gst": Gst,
                                      });
                                      print("jsonObject");
                                      print(masList.length);
                                      print(masList);


                                      updateBillEntryData(masList,detList);
                                    }
                                    else {
                                      print(shipTo);
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return
                                            AlertDialog(
                                              title: const Text('ALERT'),
                                              content: const Text(
                                                  "No valid to Item to Update"),
                                              // Content of the dialog
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
                                    textStyle: const TextStyle(color: Colors.black,
                                        fontWeight: FontWeight.bold)
                                ),
                                child: Text( !approvalValue?'Save': 'Update', style: const TextStyle(
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
    ), onWillPop: () async{
      billEntryList.clear();
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/Home',
            (Route<dynamic> route) => false, // This will remove all previous routes
      );
      return true;
    });
    dispose();
  }
}

class BillEntry {
  BillEntry(
      this.sno,
      this.name,
      this.item,
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

   int sno;
   String name;
   String item;
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
        DataGridCell<int>(columnName: 'sno', value: dataGridRow.sno),
        DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
        DataGridCell<String>(columnName: 'item', value: dataGridRow.item),
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


class Item {
  String serialNumber;
  String itemName;
  String hsnCode;
  String uom;
  String quantity;
  String rate;
  String cgstPercent;
  String sgstPercent;
  String amount;

  Item({
    required this.serialNumber,
    required this.itemName,
    required this.hsnCode,
    required this.uom,
    required this.quantity,
    required this.rate,
    required this.cgstPercent,
    required this.sgstPercent,
    required this.amount
  });
}


