import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:um_connect/Classes/message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();

        return user;
      }).toList();
    });
  }

  //send
  Future<void> sendMessage(String receiverID, message) async {
    //get current user info
    final String currentUserId = _auth.currentUser!.uid;
    final String currentEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
    final DateTime dateTime = DateTime.now();

    //create new message

    Message newMessage = Message(
        senderID: currentUserId,
        senderEmail: currentEmail,
        receiverID: receiverID,
        message: message,
        dateTime: dateTime.toString(),
        timestamp: timestamp.toString());
    //construct chatroom id
    List<String> ids = [currentUserId, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');
    //add message to db
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  //get message
  Stream<QuerySnapshot> getMessages(String userID, receiverID) {
    List<String> ids = [userID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
