import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:um_connect/themes/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
        borderRadius: BorderRadius.circular(20),
        color: isCurUser
            ? (isDarkMode ? Color(0xFFFFC62828) : Color(0xFFFFC62828))
            : (isDarkMode ? Colors.grey.shade800 : Colors.grey),
      ),
      padding: const EdgeInsets.all(11),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Container(
        child: isUrl(message)
            ? GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.network(
                              message,
                              fit: BoxFit.fitWidth,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Aligns the IconButton to the right
                              children: [
                                IconButton(
                                  icon: Icon(Icons.download),
                                  onPressed: () {
                                    _launchURL(message);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Image.network(
                  message,
                  fit: BoxFit.cover,
                  width: 200,
                  height: 200,
                  errorBuilder: (context, error, stackTrace) {
                    return GestureDetector(
                      onTap: () {
                        _launchURL(message);
                      },
                      child: Text(
                        _getDocumentName(message),
                        style: TextStyle(
                          color: Color.fromARGB(255, 105, 238, 255),
                          fontSize: 17,
                        ),
                      ),
                    );
                  },
                ),
              )
            : Text(
                message,
                style: TextStyle(
                  color: isCurUser
                      ? Colors.white
                      : (isDarkMode ? Colors.white : Colors.black),
                  fontSize: 17,
                ),
              ),
      ),
    );
  }

  bool isUrl(String message) {
    Uri? uri = Uri.tryParse(message);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  String _getDocumentName(String url) {
    int startIndex = url.lastIndexOf('/') + 1;
    int endIndex = url.indexOf('?');
    String documentNameWithExtension = endIndex != -1
        ? url.substring(startIndex, endIndex)
        : url.substring(startIndex);

    return documentNameWithExtension;
  }

  void _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
}
