import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:um_connect/firebase_options.dart';
import 'package:um_connect/splashscreen/splashscreenlogin.dart';
import 'package:um_connect/themes/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Um Connect',
      debugShowCheckedModeBanner: false,
      home: splashScreen(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
