import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studypartner/providers/firebaseMethods.dart';
import '../models/messagesingle.dart';

class SendMessage extends StatefulWidget {
  final String conversationId;
  SendMessage(this.conversationId);
  @override
  _SendMessageState createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    messageController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  sendingMessage() async {
    final data = Provider.of<FirebaseMethods>(context, listen: false);
    final senderId = data.getCurrentUser().uid;
    final message =
        MessageSingle(messageController.text.trim(), senderId, Timestamp.now());

    setState(() {
      messageController.clear();
    });
    await data.sendingMessage(widget.conversationId, message);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                  // icon: Icon(Icons.ac_unit),
                  hintText: 'Type a message',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          if (messageController.text.trim().isNotEmpty)
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.green[900],
              child: IconButton(
                padding: EdgeInsets.only(left: 4),
                icon: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
                onPressed: sendingMessage,
              ),
            )
        ],
      ),
    );
  }
}
