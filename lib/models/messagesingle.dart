import 'package:cloud_firestore/cloud_firestore.dart';

class MessageSingle {
  String message;
  String senderId;
  //String recieverid;
  Timestamp timestamp;

  MessageSingle(
    this.message,
    this.senderId,
    //this.recieverid,
    this.timestamp,
  );

  Map toMap(MessageSingle message) {
    var messageMap = Map<String, dynamic>();
    messageMap['message'] = message.message;
    messageMap['senderId'] = message.senderId;
    //messageMap['recieverId'] = message.recieverid;
    messageMap['timestamp'] = message.timestamp;
    return messageMap;
  }

  MessageSingle.fromMap(Map<String, dynamic> messageData) {
    this.message = messageData['message'];
    this.senderId = messageData['senderId'];
    //this.recieverid = messageData['recieverId'];
    this.timestamp = messageData['timestamp'];
  }
}
