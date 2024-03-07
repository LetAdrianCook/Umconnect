import "dart:io";

import "package:cloud_firestore/cloud_firestore.dart";
import "package:file_picker/file_picker.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:um_connect/comp/messagedesign.dart";
import "package:um_connect/services/auth/auth_service.dart";
import "package:um_connect/services/chat/chatservice.dart";
import "package:um_connect/services/chat/chattime.dart";

class UmChat extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  UmChat({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<UmChat> createState() => _UmChatState();
}

class _UmChatState extends State<UmChat> {
  final TextEditingController messageController = TextEditingController();

  final ChatService chatService = ChatService();
  final AuthService authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FocusNode umFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    umFocusNode.addListener(() {
      if (umFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 600), () => ScrollDown());
      }
    });

    Future.delayed(
      const Duration(milliseconds: 600),
      () => ScrollDown(),
    );
  }

  final ScrollController uSeeMeScrollin = ScrollController();
  void ScrollDown() {
    uSeeMeScrollin.animateTo(uSeeMeScrollin.position.maxScrollExtent,
        duration: const Duration(milliseconds: 600),
        curve: Curves.fastOutSlowIn);
  }

  void openMedia() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Center(child: const Text("Attach Image or Files")),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () async {
                    final ImagePicker _picker = ImagePicker();
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.camera);
                    if (image != null) {
                      Navigator.pop(context);

                      String imageUrl = await authService
                          .uploadImageToFirebase(File(image.path));

                      chatService.sendMessage(widget.receiverID, imageUrl);
                    }
                  },
                  child: const Icon(
                    Icons.camera_alt,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () async {
                    final ImagePicker _picker = ImagePicker();
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      Navigator.pop(context);

                      String imageUrl = await authService
                          .uploadImageToFirebase(File(image.path));

                      chatService.sendMessage(widget.receiverID, imageUrl);
                    }
                  },
                  child: const Icon(
                    Icons.image_outlined,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 20),
                InkWell(
                  onTap: () async {
                    final FilePicker _picker = FilePicker.platform;
                    final FilePickerResult? result = await _picker.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf', 'doc', 'docx', 'pptx']);

                    if (result != null) {
                      Navigator.pop(context);

                      String? filePath = result.files.single.path;

                      if (filePath != null) {
                        String documentUrl = await authService
                            .uploadDocumentToFirebase(File(filePath));
                        chatService.sendMessage(widget.receiverID, documentUrl);
                      } else {
                        print("empty");
                      }
                    }
                  },
                  child: const Icon(
                    Icons.attach_file,
                    size: 30,
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    umFocusNode.dispose();
    messageController.dispose();
  }

  //sending the message
  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await chatService.sendMessage(widget.receiverID, messageController.text);
      messageController.clear();
    }
    ScrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor:
            Theme.of(context).colorScheme.background, //color sa appbar
        foregroundColor: Colors.grey, // color sa texttt
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: messageList(),
          ),
          MessageInput(),
        ],
      ),
    );
  }

  Widget messageList() {
    String senderID = authService.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: chatService.getMessages(senderID, widget.receiverID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            controller: uSeeMeScrollin,
            children: snapshot.data!.docs
                .map((doc) => MessageItemBuilder(doc))
                .toList(),
          );
        });
  }

  Widget MessageItemBuilder(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurUser = data['senderID'] == authService.getCurrentUser()!.uid;

    var messageAllign =
        isCurUser ? Alignment.centerRight : Alignment.centerLeft;

    var timeAllign =
        isCurUser ? EdgeInsets.only(right: 20) : EdgeInsets.only(left: 20);

    DateTime messageDateTime = DateTime.parse(data['dateTime']);

    return Container(
        alignment: messageAllign,
        child: Column(
          crossAxisAlignment:
              isCurUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            MessageDesign(
              message: data["message"],
              isCurUser: isCurUser,
            ),
            Container(
              margin: timeAllign,
              child: Text(
                getTimeAgo(messageDateTime),
                style: TextStyle(fontSize: 13),
              ),
            ), // Display time ago instead of datetime
          ],
        ));
  }

  Widget MessageInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Row(
        children: [
          IconButton(
            onPressed: openMedia,
            icon: const Icon(Icons.add_rounded),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 25, right: 20),
              child: TextField(
                focusNode: umFocusNode,
                controller: messageController,
                decoration: const InputDecoration(hintText: "Enter a message."),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: CircleAvatar(
              backgroundColor: Color(0xFFFFC62828),
              child: IconButton(
                onPressed: sendMessage,
                icon: const Icon(Icons.send),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
