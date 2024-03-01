import "package:flutter/material.dart";
import "package:um_connect/tabs/login.dart";
import "package:um_connect/tabs/register.dart";

class LogReg extends StatefulWidget {
  const LogReg({super.key});

  @override
  State<LogReg> createState() => _LogRegState();
}

class _LogRegState extends State<LogReg> {
  bool showLoginTab = true;

  void switchTab() {
    setState(() {
      showLoginTab = !showLoginTab;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginTab) {
      return Login(onTap: switchTab);
    } else {
      return Register(onTap: switchTab);
    }
  }
}
