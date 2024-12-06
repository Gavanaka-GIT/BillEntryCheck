import 'package:billentry/billEntryMasScreen.dart';
import 'package:billentry/branchTransfer.dart';
import 'package:billentry/main.dart';
import 'package:billentry/purchaseEntryMasScreen.dart';
import 'package:billentry/stockReport.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var approvalCnt = 0;

class customDrawer extends StatelessWidget implements PreferredSizeWidget {
  final bool stkTransferCheck;
  final bool brhTransferCheck;

  const customDrawer({
    required this.stkTransferCheck,
    required this.brhTransferCheck,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF004D40),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(0)),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 10.0), // Adjust padding for better alignment
              child: Center(
                child: Image.asset('assets/icon/icon.png', height: 100), // Logo size adjustment
              ),
            ),
          ),


          _buildExpansionTile(
            context,
            Icons.account_box,
            'Master',
            [
              _buildListTile(context, Icons.person_add_alt_1, 'Ledger', '/Home/ledger'),
            ],
          ),

          // Entry Section (Sales and Purchase)
          _buildExpansionTile(
            context,
            Icons.input,
            'Entry',
            [
              _buildListTile(context, Icons.shopping_cart, 'Sales', '/Home/billEntry'),
              _buildListTile(context, Icons.shopping_bag, 'Purchase', '/Home/purchaseEntry'),
            ],
          ),

          // Report Section (Stock Report, Sales Report, Purchase Report)
          _buildExpansionTile(
            context,
            Icons.report,
            'Report',
            [
              _buildListTile(context, Icons.table_chart, 'Stock Report', '/Home/stock', condition: !stkTransferCheck),
              _buildListTile(context, Icons.table_chart, 'Sales Report', '/Home/sales'),
              _buildListTile(context, Icons.table_chart, 'Purchase Report', '/Home/purchase'),
            ],
          ),

          _buildExpansionTile(
          context,
          Icons.document_scanner,
          'Branch Report',
          [
          _buildListTile(context, Icons.swap_horizontal_circle, 'Branch Transfer', '/Home/branchTransfer', condition: !brhTransferCheck),
          _buildApprovalTile(context),
          ],),

          _buildLogoutTile(context),
        ],
      ),
    );
  }

  ListTile _buildListTile(BuildContext context, IconData icon, String title, String route, {bool condition = true}) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF004D40)),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: condition ? () => Navigator.pushNamed(context, route) : null,
      tileColor: Colors.transparent,
      hoverColor: Colors.deepPurple.withOpacity(0.1),
    );
  }


  ExpansionTile _buildExpansionTile(BuildContext context, IconData icon, String title, List<Widget> children) {
    return ExpansionTile(
      leading: Icon(icon, color: const Color(0xFF004D40)),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      children: children,
      tilePadding: EdgeInsets.symmetric(horizontal: 20),
      childrenPadding: EdgeInsets.only(left: 20),
      initiallyExpanded: false,
      trailing: Icon(Icons.arrow_drop_down, color: Color(0xFF004D40)),
    );
  }

  // Branch Approval Tile with Badge
  ListTile _buildApprovalTile(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.rotate_right_rounded, color: Color(0xFF004D40)),
      title: Row(
        children: [
          Text(
            "Branch Approval",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(width: 10),
          CircleAvatar(
            radius: 12,
            backgroundColor: approvalCnt == 0 ? Colors.green : Colors.red,
            child: Text(
              "$approvalCnt",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      onTap: () => Navigator.pushNamed(context, '/Home/branchApproval'),
    );
  }

  // Logout Tile
  ListTile _buildLogoutTile(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.logout_rounded, color: Color(0xFF004D40)),
      title: Text(
        "Logout",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      onTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Home()),
          ModalRoute.withName('/'),
        );
      },
      tileColor: Colors.transparent,
      hoverColor: Colors.deepPurple.withOpacity(0.1), // Subtle hover effect
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
