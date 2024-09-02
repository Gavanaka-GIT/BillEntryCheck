// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:syncfusion_flutter_datagrid/datagrid.dart';
// import 'package:syncfusion_flutter_core/theme.dart';
// import 'package:collection/collection.dart';
//
//
// List<BillEntry> billEntryList=[];
// class EmployeeDataGrid extends StatefulWidget {
//   @override
//   _EmployeeDataGridState createState() => _EmployeeDataGridState();
// }
//
// class BillEntry {
//   BillEntry(
//       this.id,
//       this.name,
//       this.designation,
//       this.uom,
//       this.hsnCode,
//       this.stock,
//       this.quantity,
//       this.rate,
//       this.amount,
//       this.disc,
//       this.discAmt,
//       this.GSTAmt,
//       this.TotAmt,
//       );
//
//   final int id;
//   final String name;
//   final String designation;
//   final String uom;
//   final String hsnCode;
//   final double stock;
//   late final double quantity;
//   final double rate;
//   final double amount;
//   final double disc;
//   final double discAmt;
//   final double GSTAmt;
//   final double TotAmt;
// }
//
// class _EmployeeDataGridState extends State<EmployeeDataGrid> {
//   late EmployeeDataSource _employeeDataSource;
//
//   @override
//   void initState() {
//     super.initState();
//     _employeeDataSource = EmployeeDataSource(billEntry: []);
//     getGridData();
//   }
//
//   Future<void> getGridData() async {
//     billEntryList = [
//       BillEntry(1, '222', 'ALMOND', 'PCS', '1234', 557.00, 10, 500.00, 5000.00, 5.00, 250.00, 450.00, 5700.00),
//       BillEntry(2, '888', 'NUTS', 'PCS', '4678', 557.00, 10, 500.00, 5000.00, 5.00, 250.00, 450.00, 5700.00),
//     ];
//
//     setState(() {
//       _employeeDataSource = EmployeeDataSource(billEntry: billEntryList);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//
//     return Scaffold(
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Padding(padding: EdgeInsets.fromLTRB(0, 100, 0, 0)),
//           Expanded(
//             child: SfDataGridTheme(
//               data: SfDataGridThemeData(
//                 currentCellStyle: DataGridCurrentCellStyle(
//                   borderWidth: 2,
//                   borderColor: Colors.pinkAccent,
//                 ),
//                 selectionColor: Colors.lightGreen[50],
//                 headerColor: Colors.pink[100],
//               ),
//               child: Container(
//                 margin: EdgeInsets.fromLTRB(width > 1400 ? 75 : 0, 0, 0, 0),
//                 child: SfDataGrid(
//                   allowEditing: true,
//                   selectionMode: SelectionMode.single,
//                   headerGridLinesVisibility: GridLinesVisibility.both,
//                   navigationMode: GridNavigationMode.cell,
//                   source: _employeeDataSource,
//                   editingGestureType: EditingGestureType.tap,
//                   columnWidthCalculationRange: ColumnWidthCalculationRange.visibleRows,
//                   gridLinesVisibility: GridLinesVisibility.both,
//                   columns: [
//                     GridColumn(
//                       columnName: 'id',
//                       width: 65,
//                       allowEditing: false,
//                       label: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 16.0),
//                         alignment: Alignment.centerLeft,
//                         child: Text('SNO', overflow: TextOverflow.ellipsis),
//                       ),
//                     ),
//                     GridColumn(
//                       columnName: 'name',
//                       width: 75,
//                       label: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 16.0),
//                         alignment: Alignment.center,
//                         child: Text('Code', overflow: TextOverflow.ellipsis),
//                       ),
//                     ),
//                     GridColumn(
//                       columnName: 'designation',
//                       width: 250,
//                       label: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 16.0),
//                         alignment: Alignment.center,
//                         child: Text('Particular', overflow: TextOverflow.ellipsis),
//                       ),
//                     ),
//                     GridColumn(
//                       columnName: 'uom',
//                       width: 75,
//                       label: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 16.0),
//                         alignment: Alignment.center,
//                         child: Text('Uom', overflow: TextOverflow.ellipsis),
//                       ),
//                     ),
//                     GridColumn(
//                       columnName: 'hsnCode',
//                       width: 100,
//                       label: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 16.0),
//                         alignment: Alignment.center,
//                         child: Text('HsnCode', overflow: TextOverflow.ellipsis),
//                       ),
//                     ),
//                     GridColumn(
//                       columnName: 'stock',
//                       width: 100,
//                       label: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 16.0),
//                         alignment: Alignment.center,
//                         child: Text('Stock', overflow: TextOverflow.ellipsis),
//                       ),
//                     ),
//                     GridColumn(
//                       columnName: 'quantity',
//                       width: 100,
//                       allowEditing: true,
//                       label: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 16.0),
//                         alignment: Alignment.center,
//                         child: Text('Quantity', overflow: TextOverflow.ellipsis),
//                       ),
//                     ),
//                     GridColumn(
//                       columnName: 'rate',
//                       width: 100,
//                       label: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 16.0),
//                         alignment: Alignment.center,
//                         child: Text('Rate', overflow: TextOverflow.ellipsis),
//                       ),
//                     ),
//                     GridColumn(
//                       columnName: 'amount',
//                       width: 100,
//                       label: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 16.0),
//                         alignment: Alignment.center,
//                         child: Text('Amount', overflow: TextOverflow.ellipsis),
//                       ),
//                     ),
//                     GridColumn(
//                       columnName: 'disc',
//                       width: 100,
//                       label: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 16.0),
//                         alignment: Alignment.center,
//                         child: Text('Disc', overflow: TextOverflow.ellipsis),
//                       ),
//                     ),
//                     GridColumn(
//                       columnName: 'discAmt',
//                       width: 100,
//                       label: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 16.0),
//                         alignment: Alignment.center,
//                         child: Text('DiscAmt', overflow: TextOverflow.ellipsis),
//                       ),
//                     ),
//                     GridColumn(
//                       columnName: 'GSTAmt',
//                       width: 100,
//                       label: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 16.0),
//                         alignment: Alignment.center,
//                         child: Text('GSTAmt', overflow: TextOverflow.ellipsis),
//                       ),
//                     ),
//                     GridColumn(
//                       columnName: 'TotAmt',
//                       width: 100,
//                       label: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 16.0),
//                         alignment: Alignment.center,
//                         child: Text('TotAmt', overflow: TextOverflow.ellipsis),
//                       ),
//                     ),
//                   ],
//                   columnWidthMode: ColumnWidthMode.fill,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class EmployeeDataSource extends DataGridSource {
//   EmployeeDataSource({required List<BillEntry> billEntry}) {
//     _billEntry = billEntry.map<DataGridRow>((dataGridRow) => DataGridRow(
//       cells: [
//         DataGridCell<int>(columnName: 'id', value: dataGridRow.id),
//         DataGridCell<String>(columnName: 'name', value: dataGridRow.name),
//         DataGridCell<String>(columnName: 'designation', value: dataGridRow.designation),
//         DataGridCell<String>(columnName: 'uom', value: dataGridRow.uom),
//         DataGridCell<String>(columnName: 'hsnCode', value: dataGridRow.hsnCode),
//         DataGridCell<double>(columnName: 'stock', value: dataGridRow.stock),
//         DataGridCell<double>(columnName: 'quantity', value: dataGridRow.quantity),
//         DataGridCell<double>(columnName: 'rate', value: dataGridRow.rate),
//         DataGridCell<double>(columnName: 'amount', value: dataGridRow.amount),
//         DataGridCell<double>(columnName: 'disc', value: dataGridRow.disc),
//         DataGridCell<double>(columnName: 'discAmt', value: dataGridRow.discAmt),
//         DataGridCell<double>(columnName: 'GSTAmt', value: dataGridRow.GSTAmt),
//         DataGridCell<double>(columnName: 'TotAmt', value: dataGridRow.TotAmt),
//       ],
//     )).toList();
//   }
//
//   late List<DataGridRow> _billEntry;
//
//   @override
//   List<DataGridRow> get rows => _billEntry;
//
//   // List<Employee> _employees = [];
//
//   // List<DataGridRow> dataGridRows = [];
//
//   /// Helps to hold the new value of all editable widget.
//   /// Based on the new value we will commit the new value into the corresponding
//   /// [DataGridCell] on [onSubmitCell] method.
//   dynamic newCellValue;
//
//   /// Help to control the editable text in [TextField] widget.
//   TextEditingController editingController = TextEditingController();
//
//   // @override
//   // List<DataGridRow> get rows => dataGridRows;
//
//   @override
//   DataGridRowAdapter? buildRow(DataGridRow row) {
//     return DataGridRowAdapter(
//         cells: row.getCells().map<Widget>((dataGridCell) {
//           return Container(
//               alignment: (dataGridCell.columnName == 'id' ||
//                   dataGridCell.columnName == 'salary')
//                   ? Alignment.center
//                   : Alignment.center,
//               padding: EdgeInsets.symmetric(horizontal: 16.0),
//               child: Text(
//                 dataGridCell.value.toString(),
//                 overflow: TextOverflow.ellipsis,
//               ));
//         }).toList());
//   }
//
//   @override
//   Future<void> onCellSubmit(DataGridRow dataGridRow,
//       RowColumnIndex rowColumnIndex, GridColumn column) async {
//     final dynamic oldValue = dataGridRow
//         .getCells()
//         .firstWhereOrNull((DataGridCell dataGridCell) =>
//     dataGridCell.columnName == column.columnName)
//         ?.value ??
//         '';
//     print("onCellSubmit working");
//     final int dataRowIndex = _billEntry.indexOf(dataGridRow);
//     if (newCellValue == null || oldValue == newCellValue) {
//       return;
//     }
//     if (column.columnName == 'quantity') {
//       print("Check Point 1");
//       print(_billEntry[dataRowIndex].getCells()[rowColumnIndex.columnIndex].value);
//       _billEntry[dataRowIndex].getCells()[rowColumnIndex.columnIndex]=DataGridCell<int>(columnName: 'quantity', value: newCellValue);
//       //_billEntry[dataRowIndex].quantity = newCellValue as int;
//       billEntryList[dataRowIndex].quantity=double.parse(newCellValue.toString());
//     }
//
//     /*if (column.columnName == 'id') {
//       dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
//           DataGridCell<int>(columnName: 'id', value: newCellValue);
//       _employees[dataRowIndex].id = newCellValue as int;
//     } else if (column.columnName == 'name') {
//       dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
//           DataGridCell<String>(columnName: 'name', value: newCellValue);
//       _employees[dataRowIndex].name = newCellValue.toString();
//     } else if (column.columnName == 'designation') {
//       dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
//           DataGridCell<String>(columnName: 'designation', value: newCellValue);
//       _employees[dataRowIndex].designation = newCellValue.toString();
//     } else {
//       dataGridRows[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
//           DataGridCell<dynamic>(columnName: column.columnName, value: newCellValue);
//     }*/
//     // Add any additional logic to handle the cell submission
//   }
//
//   @override
//   Future<bool> canSubmitCell(DataGridRow dataGridRow,
//       RowColumnIndex rowColumnIndex, GridColumn column) async {
//     print("canSubmitCell");
//     if (column.columnName == 'quantity' && newCellValue == null) {
//       // Return false, to retain in edit mode.
//       // To avoid null value for cell
//       return Future.value(false);
//     } else {
//       return Future.value(true);
//     }
//   }
//
//   @override
//   Widget? buildEditWidget(DataGridRow dataGridRow,
//       RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
//     // Text going to display on editable widget
//     final String displayText = dataGridRow
//         .getCells()
//         .firstWhereOrNull((DataGridCell dataGridCell) =>
//     dataGridCell.columnName == column.columnName)
//         ?.value
//         ?.toString() ??
//         '';
//
//     // The new cell value must be reset.
//     // To avoid committing the [DataGridCell] value that was previously edited
//     // into the current non-modified [DataGridCell].
//     newCellValue = null;
//
//     final bool isNumericType =
//         column.columnName == 'quantity' || column.columnName == 'salary';
//
//     // Holds regular expression pattern based on the column type.
//     final RegExp regExp = _getRegExp(isNumericType, column.columnName);
//
//     return Container(
//       padding: const EdgeInsets.all(8.0),
//       alignment: isNumericType ? Alignment.centerRight : Alignment.centerLeft,
//       child: TextField(
//         autofocus: true,
//         controller: editingController..text = displayText,
//         textAlign: isNumericType ? TextAlign.right : TextAlign.left,
//         autocorrect: false,
//         decoration: InputDecoration(
//           contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
//         ),
//         inputFormatters: <TextInputFormatter>[
//           FilteringTextInputFormatter.allow(regExp)
//         ],
//         keyboardType: isNumericType ? TextInputType.number : TextInputType.text,
//         onChanged: (String value) {
//           if (value.isNotEmpty) {
//             if (isNumericType) {
//               newCellValue = int.parse(value);
//             } else {
//               newCellValue = value;
//             }
//           } else {
//             newCellValue = null;
//           }
//         },
//         onSubmitted: (String value) {
//           print("widget working");
//           /// Call [CellSubmit] callback to fire the canSubmitCell and
//           /// onCellSubmit to commit the new value in single place.
//           submitCell();
//         },
//       ),
//     );
//   }
//
//   RegExp _getRegExp(bool isNumericKeyBoard, String columnName) {
//     return isNumericKeyBoard ? RegExp('[0-9]') : RegExp('[a-zA-Z ]');
//   }
// }
