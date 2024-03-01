import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:um_connect/themes/theme_provider.dart";

class MessageDesign extends StatelessWidget {
  final String message;
  final bool isCurUser;

  const MessageDesign({
    super.key,
    required this.message,
    required this.isCurUser,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: isCurUser
            ? (isDarkMode
                ? Colors.green
                    .shade600 //if dark mode kani mugawas (sa user na chat bubble)
                : Colors.green.shade500) //if light mode kani mugawas
            : (isDarkMode
                ? Colors.grey
                    .shade800 //if dark mode kani mugawas (sa uban na chat bubble)
                : Colors.grey.shade200), //if light mode kani mugawas
      ),
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        message,
        style: TextStyle(
          color: isCurUser
              ? Colors.white //sa user
              : (isDarkMode
                  ? Colors.white //dark mode //sa receiver
                  : Colors.black), //light mode
        ),
      ),
    );
  }
}
