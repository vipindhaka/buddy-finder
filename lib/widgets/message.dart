import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import 'package:studypartner/providers/firebaseMethods.dart';
import '../models/messagesingle.dart';

class MessageDisplay extends StatelessWidget {
  final DocumentSnapshot message;
  final String currentUserid;
  MessageDisplay(this.message, this.currentUserid);

  @override
  Widget build(BuildContext context) {
    final messageSingle = MessageSingle.fromMap(message.data());
    bool isMe = messageSingle.senderId == currentUserid;
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: size.width * .7),
          child: Container(
            // width: size.width * .45,
            margin: EdgeInsets.only(bottom: 10),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: !isMe ? Colors.white : Colors.green[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              messageSingle.message,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
