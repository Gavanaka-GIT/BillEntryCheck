import 'package:billentry/billEntryMasScreen.dart';
import 'package:billentry/branchTransfer.dart';
import 'package:billentry/main.dart';
import 'package:billentry/purchaseEntryMasScreen.dart';
import 'package:billentry/stockReport.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var approvalCnt=0;
class customDrawer extends StatelessWidget implements PreferredSizeWidget{
  final bool stkTransferCheck;
  final bool brhTransferCheck;
  const customDrawer({
    required this.stkTransferCheck,
    required this.brhTransferCheck
  });

  @override
  Widget build (BuildContext context){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, // Remove any extra padding around ListView
        children: [
          // Drawer Header with subtle design improvements
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF004D40), // Premium color for header
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)], // Light shadow
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 10.0), // Adjust padding for better alignment
              child: Center(
                child: Image.asset('assets/icon/icon.png', height: 50), // Logo size adjustment
              ),
            ),
          ),

          // ListTiles with some small improvements
          _buildListTile(context, Icons.home, 'Home', '/Home'),
          _buildListTile(context, Icons.shopping_cart, 'Sales', '/Home/billEntry'),
          _buildListTile(context, Icons.shopping_bag, 'Purchase', '/Home/purchaseEntry'),
          _buildListTile(context, Icons.table_chart, 'Stock Report', '/Home/stock', condition: !stkTransferCheck),
          _buildListTile(context, Icons.table_chart, 'Sales Report', '/Home/sales'),
          _buildListTile(context, Icons.table_chart, 'Purchase Report', '/Home/purchase'),
          _buildListTile(context, Icons.swap_horizontal_circle, 'Branch Transfer', '/Home/branchTransfer', condition: !brhTransferCheck),
          _buildApprovalTile(context),
          _buildLogoutTile(context),
        ],
      ),
    );
  }

  // Reusable ListTile builder with premium style
  ListTile _buildListTile(BuildContext context, IconData icon, String title, String route, {bool condition = true}) {
    return ListTile(
      leading: Icon(icon, color: Color(0xFF004D40)), // Subtle accent color for icons
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500), // Slightly larger text and bold
      ),
      onTap: condition ? () => Navigator.pushNamed(context, route) : null,
      tileColor: Colors.transparent, // Transparent background for a cleaner look
      hoverColor: Colors.deepPurple.withOpacity(0.1), // Hover effect
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
