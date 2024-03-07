import "package:flutter/material.dart";
import 'package:um_connect/comp/textfields.dart';
import 'package:um_connect/services/auth/auth_service.dart';

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
                title: Text("Password does not match!"),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ang logo sa atong message app
              Container(
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
                "REGISTER",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
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
              ElevatedButton(
                style: buttonStyle(),
                onPressed: () {
                  register(context);
                },
                child: const Text(
                  'REGISTER',
                  style: TextStyle(
                      fontSize: 15, color: Color.fromRGBO(250, 249, 249, 1)),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already registered?",
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
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
        ),
      ),
    );
  }
}

buttonStyle() => ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 209, 9, 9),
    fixedSize: const Size(332, 50),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5), // Adjust the border radius here
    ));
