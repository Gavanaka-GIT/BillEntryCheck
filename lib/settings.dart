import 'package:billentry/GlobalVariables.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() {
    return _SettingsPage();
  }
}

class _SettingsPage extends State<SettingsPage> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final TextEditingController ipAddressController = TextEditingController();
  TextEditingController portController = TextEditingController();
  bool logchk=false;

  @override
  void initState() {
    super.initState();
    ipAddressController.text = ip;
    portController.text = port;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child:
         !logchk?
         SizedBox(
            height: 330,
            child: AlertDialog(

              title: const Center(child:Text("Settings Login", style:  TextStyle(fontWeight: FontWeight.bold),) ,),
              shadowColor: Colors.black,
              content: Column(
                children: [
                  Card(
                    elevation: 5,
                  shadowColor: Colors.black,
                    child:
                  TextFormField(
                    controller: userNameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: const TextStyle(fontSize: 14),
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    ),
                  ),
                  ),
                  const SizedBox(height: 10,),
                  Card(elevation: 5,
                  shadowColor: Colors.black, child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(fontSize: 14),
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    ),
                  ),),

                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          if (userNameController.text == "bill" && passwordController.text == "bill123") {
                            setState(() {
                              logchk=true;
                            });
                          }
                        },
                        child: const Text("Login"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ):
         SizedBox(
            height: 320,
            child:
            AlertDialog(
              title: const Center(child:Text("Settings", style: TextStyle(fontWeight: FontWeight.bold),) ,),
              content: Column(
                children: [
                  TextFormField(
                    controller: ipAddressController,
                    decoration: InputDecoration(
                      labelText: 'IP Address',
                      labelStyle: const TextStyle(fontSize: 14),
                      prefixIcon: const Icon(Icons.network_ping),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  TextFormField(
                    controller: portController,
                    decoration: InputDecoration(
                      labelText: 'Port',
                      labelStyle: const TextStyle(fontSize: 14),
                      prefixIcon: const Icon(Icons.computer),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        ip = ipAddressController.text.toString();
                        port= portController.text.toString();
                        ipAddress="http://$ip:$port/" ;
                        logchk=false;
                      });

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                            (Route<dynamic> route) => false, // This will remove all previous routes
                      );

                    },
                    child: const Text("Save"),
                  )
                ],
              ),
            )
        ),
        ),
      ),
      onWillPop: () async {
        logchk=false;
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/',
              (Route<dynamic> route) => false, // This will remove all previous routes
        );
        return true;
      },
    );
  }
}
