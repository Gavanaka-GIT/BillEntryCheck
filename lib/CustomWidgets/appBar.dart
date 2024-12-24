import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String emailId;
  final Function onMenuPressed;
  final String barTitle;

  const CustomAppBar({super.key, 
    required this.userName,
    required this.emailId,
    required this.onMenuPressed,
    required this.barTitle
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF004D40),
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(
              Icons.menu_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              // This now has the correct context
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
      title: Text(
        barTitle,
        style: const TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      actions: [
        Center(
          child: PopupMenuButton(
            icon: const Icon(
              Icons.person,
              color: Colors.white,
            ),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  child: Row(
                    children: [
                      const Icon(Icons.person),
                      const SizedBox(width: 10),
                      Text(
                        userName,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      const Icon(Icons.mail),
                      const SizedBox(width: 10),
                      Text(
                        emailId,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ];
            },
          ),
        ),
      ],
    );
  }

}
