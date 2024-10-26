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
    return Drawer(child:
    ListView( children: [
      ListTile( leading : Icon(Icons.home),title: Text("Home"),
        onTap: (){
          // Navigator.pushNamed(context, '/Home/billEntry');
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/Home',
                (Route<dynamic> route) => false, // This will remove all previous routes
          );
        },),
      ListTile( leading : Icon(Icons.shopping_cart),title: Text("Sales"),
        onTap: (){
          Navigator.pushNamed(context, '/Home/billEntry');
          // Navigator.pushNamedAndRemoveUntil(
          //   context,
          //   '/Home/billEntry',
          //       (Route<dynamic> route) => false, // This will remove all previous routes
          // );
        },),
      ListTile(leading: Icon(Icons.shopping_bag),title: Text("Puchase"),
        onTap: (){
          Navigator.pushNamed(context, '/Home/purchaseEntry');
          // Navigator.pushNamedAndRemoveUntil(
          //   context,
          //   '/Home/purchaseEntry',
          //       (Route<dynamic> route) => false, // This will remove all previous routes
          // );
        },),
      ListTile(leading: Icon(Icons.table_chart),
        title: Text("Stock Report"),
        onTap: (){
        if(!stkTransferCheck) {
          Navigator.pushNamed(
            context,
            '/Home/stock'// Remove all routes until the first
          );
          // Navigator.pushNamedAndRemoveUntil(
          //   context,
          //   '/Home/stock',
          //       (Route<dynamic> route) => false, // This will remove all previous routes
          // );
        }
        }),
      ListTile(leading: Icon(Icons.table_chart),
          title: Text("Sales Report"),
          onTap: (){

              Navigator.pushNamed(
                  context,
                  '/Home/sales'// Remove all routes until the first
              );
              // Navigator.pushNamedAndRemoveUntil(
              //   context,
              //   '/Home/stock',
              //       (Route<dynamic> route) => false, // This will remove all previous routes
              // );
          }),
      ListTile(leading: Icon(Icons.table_chart),
          title: Text("Purchase Report"),
          onTap: (){
            Navigator.pushNamed(
                context,
                '/Home/purchase'// Remove all routes until the first
            );
            // Navigator.pushNamedAndRemoveUntil(
            //   context,
            //   '/Home/stock',
            //       (Route<dynamic> route) => false, // This will remove all previous routes
            // );
          }),
      ListTile(leading: Icon(Icons.swap_horizontal_circle),
        title:Text("Branch Transfer"),
        onTap:(){
        if(!brhTransferCheck) {
          Navigator.pushNamed(
              context,
              '/Home/branchTransfer'// Remove all routes until the first
          );
          // Navigator.pushNamedAndRemoveUntil(
          //   context,
          //   '/Home/branchTransfer',
          //       (Route<dynamic> route) => false, // This will remove all previous routes
          // );
        }
        }),
      ListTile(leading: Icon(Icons.rotate_right_rounded),
          title:Row(children: [Text("Branch Approval"),
            SizedBox(width: 15,),
            CircleAvatar(radius: 12,child: Text("${approvalCnt}"),
            backgroundColor: approvalCnt ==0? Colors.green:Colors.red,)],),
          onTap:(){
              Navigator.pushNamed(
                  context,
                  '/Home/branchApproval'// Remove all routes until the first
              );
              // Navigator.pushNamedAndRemoveUntil(
              //   context,
              //   '/Home/branchApproval',
              //       (Route<dynamic> route) => false, // This will remove all previous routes
              // );
          }),
      ListTile( leading : Icon(Icons.logout_rounded),
        title: Text("Logout"),
        onTap: (){
          // Navigator.of(context).push(
          //   MaterialPageRoute(builder: (context)=> Home())
          // );
          Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=>Home())
              ,
              ModalRoute.withName('/'));
          // Navigator.pop(context);
        },),

    ],),);

  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
