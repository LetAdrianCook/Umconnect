import 'package:flutter/material.dart';
import 'package:um_connect/services/auth/auth_service.dart';
import 'package:um_connect/comp/buttons.dart';
import 'package:um_connect/comp/textfields.dart';

class Login extends StatelessWidget {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passcontroller = TextEditingController();
  final void Function()? onTap;
  Login({super.key, this.onTap});

  void login(BuildContext context) async {
    final signService = AuthService();
    try {
      await signService.signInWithEmailPassword(
          emailcontroller.text, passcontroller.text);
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Invalid Email or Password"),
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
            "Login",
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
            hintText: "Password",
            hidePass: true,
            controller: passcontroller,
          ),
          const SizedBox(height: 15),
          UmButton(buttonName: "Login", onTap: () => login(context)),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Not registered yet?",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              GestureDetector(
                onTap: onTap,
                child: Text(
                  " Register now",
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
