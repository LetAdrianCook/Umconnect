import 'package:flutter/material.dart';
import 'package:um_connect/comp/drawer.dart';

class UmProfile extends StatefulWidget {
  const UmProfile({super.key});

  @override
  State<UmProfile> createState() => _UmProfileState();
}

class _UmProfileState extends State<UmProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Page"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      ),
      drawer: UmDrawer(),
    );
  }
}
