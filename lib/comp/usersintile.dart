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
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        padding: const EdgeInsets.all(30),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(profilePic),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dname,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(text),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
