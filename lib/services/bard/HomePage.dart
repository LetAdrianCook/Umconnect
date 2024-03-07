import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:um_connect/comp/bottomnav.dart';
import 'package:um_connect/services/bard/BardAIController.dart';
import 'package:um_connect/tabs/home.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    BardAIController controller = Get.put(BardAIController());
    TextEditingController textField = TextEditingController();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        centerTitle: true,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
            ),
          ],
        ),
        title: const Text(
          "BARD",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                controller.sendPrompt("Hello what can you do for me ");
              },
              icon: const Icon(Icons.security))
        ],
      ),
      bottomNavigationBar: BottomBar(
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index;
            });
          }),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
                child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Welcome to Bard API",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Obx(() => Column(
                      children: controller.historyList.map((e) {
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Text(e.system == "user" ? "👨‍💻" : "🤖"),
                              const SizedBox(width: 10),
                              Flexible(
                                  child: Text(
                                e.message ?? "",
                                style: const TextStyle(color: Colors.white),
                              )),
                            ],
                          ),
                        );
                      }).toList(),
                    ))
              ],
            )),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(10)),
              height: 60,
              child: Row(children: [
                Expanded(
                    child: TextFormField(
                        controller: textField,
                        decoration: const InputDecoration(
                            hintText: "Ask bard here",
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none)))),
                Obx(() => controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : IconButton(
                        onPressed: () {
                          if (textField.text != "") {
                            controller.sendPrompt(textField.text);
                            textField.clear();
                          }
                        },
                        icon: const Icon(Icons.send, color: Colors.white))),
                const SizedBox(width: 10)
              ]),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
