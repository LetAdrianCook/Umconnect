import "package:flutter/material.dart";

Color myCustomColor = Color(0xFF141414);

ThemeData darkMode = ThemeData(
    colorScheme: ColorScheme.dark(
  background: Color.fromARGB(255, 27, 27, 27),
  primary: Colors.grey.shade600,
  secondary: myCustomColor,
  tertiary: Colors.grey.shade800,
  inversePrimary: Colors.grey.shade300,
));
