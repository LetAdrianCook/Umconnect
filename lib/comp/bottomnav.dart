import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:um_connect/services/bard/HomePage.dart';
import 'package:um_connect/tabs/home.dart';
import 'package:um_connect/tabs/profilepage.dart';

class BottomBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const BottomBar(
      {Key? key, required this.selectedIndex, required this.onTabChange});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GNav(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        color: Colors.white,
        tabBackgroundColor: Color.fromARGB(255, 255, 107, 96),
        activeColor: Colors.black,
        padding: const EdgeInsets.all(20),
        selectedIndex: widget.selectedIndex,
        onTabChange: (selectedIndex) {
          if (selectedIndex == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          } else if (selectedIndex == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          }
        },
        gap: 7,
        tabs: [
          GButton(
            icon: Icons.message_rounded,
            text: "Messages",
          ),
          GButton(
            icon: Icons.star,
            text: "Bard AI",
          ),
          GButton(
            icon: Icons.people_alt_rounded,
            text: "Profile",
          ),
        ],
      ),
    );
  }
}
