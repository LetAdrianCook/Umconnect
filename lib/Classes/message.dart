import "package:cloud_firestore/cloud_firestore.dart";

class Message {
  final String senderID;
  final String senderEmail;
  final String receiverID;
  final String message;
  final String dateTime;
  final String timestamp;

  Message({
    required this.senderID,
    required this.senderEmail,
    required this.receiverID,
    required this.message,
    required this.dateTime,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': senderEmail,
      'receiverID': receiverID,
      'message': message,
      'dateTime': dateTime,
      'timestamp': timestamp,
    };
  }
}
