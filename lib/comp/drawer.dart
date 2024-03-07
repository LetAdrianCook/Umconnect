import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter/widgets.dart";
import 'package:um_connect/services/auth/auth_service.dart';
import "package:um_connect/services/bard/HomePage.dart";
import "package:um_connect/tabs/home.dart";
import "package:um_connect/tabs/profilepage.dart";
import "package:um_connect/tabs/settings.dart";

class UmDrawer extends StatelessWidget {
  const UmDrawer({super.key});
  void logout(BuildContext context) {
    final auth = AuthService();
    auth.signOut(context);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      shadowColor: Colors.red,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFFFFC62828)),
            child: Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Image.asset("images/logoapp.png"),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: ListTile(
              title: const Text(
                "Home",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              leading: const Icon(
                Icons.home,
                color: Color(0xFFFFC62828),
                size: 30,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: ListTile(
              title: const Text(
                "Settings",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              leading: const Icon(
                Icons.settings,
                color: Color(0xFFFFC62828),
                size: 30,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UmSettings()),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: ListTile(
              title: const Text(
                "Logout",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              ),
              leading: const Icon(
                Icons.logout,
                color: Color(0xFFFFC62828),
                size: 30,
              ),
              onTap: () => logout(context),
            ),
          ),
        ],
      ),
    );
  }
}
