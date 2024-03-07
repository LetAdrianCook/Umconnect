import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:um_connect/Classes/photo.dart';
import 'package:um_connect/tabs/profilepage.dart';

class updatePhoto extends StatefulWidget {
  const updatePhoto({super.key});

  @override
  State<updatePhoto> createState() => _updatePhotoState();
}

class _updatePhotoState extends State<updatePhoto> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  String urlfile = "";

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  Widget imgExist() => Image.file(
        File(pickedFile!.path!),
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
      );

  Widget imgNotExist() => Image.asset(
        'images/no-image.png',
        fit: BoxFit.cover,
      );
  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  showLoaderDiaolog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
            margin: const EdgeInsets.only(left: 7),
            child: const Text('Uploading ...'),
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future uploadFile(context) async {
    showLoaderDiaolog(context);

    final path = 'images/${'${generateRandomString(5)}-{pickedFile!.name}'}';
    final file = File(pickedFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });
    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download Link: $urlDownload');

    updateDatabase(urlDownload, context);
  }

  final user = FirebaseAuth.instance.currentUser!;
  showAlertDialogUpload(BuildContext context) {
    Widget cancelButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text(
        'Cancel',
        style: TextStyle(color: Colors.red),
      ),
    );
    Widget continueButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
        uploadFile(context);
      },
      child: const Text(
        'Continue',
        style: TextStyle(color: Colors.green),
      ),
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Question"),
      content: const Text("Upload Image?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  showAlert(BuildContext context, String title, String msg) {
    Widget continueButton = TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          if (title == "Success") {
            if (urlfile == "") urlfile = "-";
            Navigator.of(context).pop(Photo(image: urlfile));
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          }
        },
        child: const Text('OK'));
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: [continueButton],
    );
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;
          return ProgressBar(progress);
        } else {
          return const SizedBox(height: 50);
        }
      });

  Widget ProgressBar(progress) => SizedBox(
        height: 50,
        child: Stack(
          fit: StackFit.expand,
          children: [
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey,
              color: Colors.green,
            ),
            Center(
              child: Text(
                '${(100 * progress).roundToDouble()}%',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      );

  Future updateDatabase(urlDownload, context) async {
    final docUser =
        FirebaseFirestore.instance.collection('Users').doc(user.uid);

    await docUser.update({
      'image': urlDownload,
    }).then((value) {
      showAlert(context, 'Success', 'Profile Picture Updated');
    });

    setState(() {
      pickedFile = null;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.grey,
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        centerTitle: true,
        title: const Text('Update Photo'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.grey),
            ),
            child: Center(
              child: pickedFile != null ? imgExist() : imgNotExist(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              selectFile();
            },
            icon: Icon(Icons.add_a_photo),
            label: Text('Select Photo'),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              if (pickedFile != null) {
                showAlertDialogUpload(context);
              } else {
                showAlert(context, "Error", "Please select a photo");
              }
            },
            icon: Icon(Icons.upload),
            label: Text('Upload Image'),
          ),
          const SizedBox(height: 10),
          buildProgress(),
        ],
      ),
    );
  }
}
