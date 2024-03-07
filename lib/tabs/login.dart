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

  buttonStyle() => ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 209, 9, 9),
      fixedSize: const Size(332, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5), // Adjust the border radius here
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                "UM CONNECT",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 30),
              ElevatedButton(
                style: buttonStyle(),
                onPressed: () {
                  login(context);
                },
                child: const Text(
                  'LOGIN',
                  style: TextStyle(
                      fontSize: 15, color: Color.fromRGBO(250, 249, 249, 1)),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not registered yet?",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w400),
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
        ),
      ),
    );
  }
}
