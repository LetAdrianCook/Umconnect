import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import 'package:um_connect/services/auth/auth_service.dart';
import "package:um_connect/tabs/home.dart";
import "package:um_connect/tabs/profilepage.dart";
import "package:um_connect/tabs/settings.dart";

class UmDrawer extends StatelessWidget {
  const UmDrawer({super.key});
  void logout() {
    final auth = AuthService();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          DrawerHeader(
            child: Center(
              child: Container(
                margin: const EdgeInsets.only(top: 35),
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(width: 0, color: Colors.transparent),
                ),
                child: Image.asset("images/logoapp.png"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: ListTile(
              title: const Text("Home"),
              leading: const Icon(Icons.home),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: ListTile(
              title: const Text("Profile"),
              leading: const Icon(Icons.people_alt_rounded),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: ListTile(
              title: const Text("Settings"),
              leading: const Icon(Icons.settings),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UmSettings()),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: ListTile(
              title: const Text("Logout"),
              leading: const Icon(Icons.logout),
              onTap: logout,
            ),
          ),
        ],
      ),
    );
  }
}
