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
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            border: Border.all(color: Colors.red, width: 1),
            borderRadius: BorderRadius.circular(20)),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.red,
                  width: 1,
                ),
              ),
              child: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(profilePic),
              ),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dname,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 22),
                ),
                Text(text),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LimitedTextDisplayWidget extends StatelessWidget {
  final String text;
  final int maxDisplayLength;

  const LimitedTextDisplayWidget({
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
