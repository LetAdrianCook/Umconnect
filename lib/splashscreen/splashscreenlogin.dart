import 'package:flutter/material.dart';
import 'package:um_connect/services/auth/session.dart';

class splashScreen extends StatefulWidget {
  @override
  _splashScreenState createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController cont;
  late Animation<double> zooming;

  @override
  void initState() {
    super.initState();
    cont = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    zooming = Tween<double>(begin: 200.0, end: 300.0).animate(cont)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Session()),
          );
        }
      });
    cont.forward();
  }

  @override
  void dispose() {
    cont.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Container(
          width: zooming.value,
          height: zooming.value,
          child: Image.asset('images/logoapp.png'),
        ),
      ),
    );
  }
}
