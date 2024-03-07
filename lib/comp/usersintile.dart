import 'package:flutter/material.dart';

class UserInTiles extends StatelessWidget {
  final String text;
  final String dname;
  final String profilePic;
  final void Function()? onTap;

  const UserInTiles({
    Key? key,
    required this.text,
    required this.profilePic,
    this.onTap,
    required this.dname,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(31),
                border: Border.all(
                  color: Colors.red,
                  width: 1,
                ),
              ),
              child: CircleAvatar(
                radius: 31,
                backgroundImage: NetworkImage(profilePic),
              ),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LimitedTextDisplayWidget2(
                  text: dname,
                  maxDisplayLength: 20,
                ),
                LimitedTextDisplayWidget1(
                  text: text,
                  maxDisplayLength: 30,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LimitedTextDisplayWidget1 extends StatelessWidget {
  final String text;
  final int maxDisplayLength;

  const LimitedTextDisplayWidget1({
    Key? key,
    required this.text,
    required this.maxDisplayLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final truncatedText = text.length > maxDisplayLength
        ? '${text.substring(0, maxDisplayLength)}...'
        : text;

    return Text(
      truncatedText,
    );
  }
}

class LimitedTextDisplayWidget2 extends StatelessWidget {
  final String text;
  final int maxDisplayLength;

  const LimitedTextDisplayWidget2({
    Key? key,
    required this.text,
    required this.maxDisplayLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final truncatedText = text.length > maxDisplayLength
        ? '${text.substring(0, maxDisplayLength)}...'
        : text;

    return Text(
      truncatedText,
      style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
    );
  }
}
