import "package:flutter/material.dart";
import 'package:um_connect/services/auth/auth_service.dart';
import 'package:um_connect/comp/buttons.dart';
import 'package:um_connect/comp/textfields.dart';

class Register extends StatelessWidget {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController dnamecontroller = TextEditingController();
  final TextEditingController passcontroller = TextEditingController();
  final TextEditingController cpasscontroller = TextEditingController();
  final void Function()? onTap;
  Register({super.key, this.onTap});
  void register(BuildContext context) {
    final _auth = AuthService();

    if (passcontroller.text == cpasscontroller.text) {
      try {
        _auth.signUpWithEmailPassword(
          emailcontroller.text,
          passcontroller.text,
          dnamecontroller.text,
        );
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(e.toString()),
                ));
      }
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Tarunga pd kay dili mao ang pass"),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ang logo sa atong message app
          Container(
            margin: const EdgeInsets.only(top: 35),
            width: 200,
            height: 200,
            child: Image.asset(
              "images/logoapp.png",
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(
            height: 5,
          ),

          Text(
            "UM Connect",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 18,
            ),
          ),

          Text(
            "Register",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 25),

          Fields(
            hintText: "Email",
            hidePass: false,
            controller: emailcontroller,
          ),
          const SizedBox(height: 10),
          Fields(
            hintText: "Display Name",
            hidePass: false,
            controller: dnamecontroller,
          ),
          const SizedBox(height: 10),
          Fields(
            hintText: "Password",
            hidePass: true,
            controller: passcontroller,
          ),
          const SizedBox(height: 10),
          Fields(
            hintText: "Confirm Password",
            hidePass: true,
            controller: cpasscontroller,
          ),
          const SizedBox(height: 15),
          UmButton(
            buttonName: "Register",
            onTap: () => register(context),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already registered?",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              GestureDetector(
                onTap: onTap,
                child: Text(
                  " Login now",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
