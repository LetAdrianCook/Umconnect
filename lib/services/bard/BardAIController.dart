import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:um_connect/services/bard/BardModel.dart';
import 'package:um_connect/services/bard/data.dart';

class BardAIController extends GetxController {
  RxList<BardModel> historyList = RxList<BardModel>([
    BardModel(system: "user", message: "What can you do for me"),
    BardModel(system: "bard", message: "What can you do for me"),
  ]);

  RxBool isLoading = false.obs;

  void sendPrompt(String prompt) async {
    isLoading.value = true;
    var newHistory = BardModel(system: "user", message: prompt);
    historyList.add(newHistory);
    final body = {
      'prompt': {
        'text': prompt,
      },
    };

    final request = await http.post(
      Uri.parse(
          'https://generativelanguage.googleapis.com/v1beta2/models/text-bison-001:generateText?key=$APIKEY'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    final response = jsonDecode(request.body);

    if (response["candidates"] != null && response["candidates"].isNotEmpty) {
      final bardReplay = response["candidates"][0]["output"];
      if (bardReplay != null) {
        var newHistory2 = BardModel(system: "bard", message: bardReplay);
        historyList.add(newHistory2);
        print(bardReplay.toString());
      } else {
        // Check if Get.context is not null before using it
        if (Get.context != null) {
          BuildContext storedContext = Get.context!;

          // Show dialog when bardReplay is null using stored context
          showDialog(
            context: storedContext,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Bard Cannot Answer'),
                content: Text('The response is null, Bard cannot answer.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          print('Get.context is null');
        }
      }
    } else {
      // Handle case where candidates array is empty or null
      print('No candidates found in the response');
    }

    isLoading.value = false;
  }
}
