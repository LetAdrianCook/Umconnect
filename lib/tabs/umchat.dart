import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
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

  void sendPic() {}
  void sendFile() {}

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

    DateTime messageDateTime = DateTime.parse(data['dateTime']);

    return Container(
        alignment: messageAllign,
        child: Column(
          crossAxisAlignment:
              isCurUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            MessageDesign(message: data["message"], isCurUser: isCurUser),
            Text(getTimeAgo(
                messageDateTime)), // Display time ago instead of datetime
          ],
        ));
  }

  Widget MessageInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Row(
        children: [
          IconButton(
            onPressed: sendPic,
            icon: const Icon(Icons.perm_media_rounded),
          ),
          IconButton(
            onPressed: sendFile,
            icon: const Icon(Icons.attach_file_rounded),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 25),
              child: TextField(
                focusNode: umFocusNode,
                controller: messageController,
                decoration: const InputDecoration(hintText: "Enter a message."),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CircleAvatar(
              backgroundColor: Colors.lightBlueAccent,
              child: IconButton(
                onPressed: sendMessage,
                icon: const Icon(Icons.arrow_forward),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
