import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studypartner/providers/firebaseMethods.dart';
import '../widgets/message.dart';
import '../widgets/sendMessage.dart';

class IndividualChatScreen extends StatefulWidget {
  static const routeName = '/indivdual-chat-screen';
  @override
  _IndividualChatScreenState createState() => _IndividualChatScreenState();
}

class _IndividualChatScreenState extends State<IndividualChatScreen> {
  String conversation;

  displayMessagesList(dynamic messages, String currentUser) {
    // final data = Provider.of<FirebaseMethods>(context, listen: false);
    // final currentUser = data.getCurrentUser().uid;
    return Expanded(
      child: ListView.builder(
        reverse: true,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return MessageDisplay(messages[index], currentUser);
        },
      ),
    );
  }

  messagesListener(String conversationId, String userId) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('allConversations')
                .doc(conversationId)
                .collection('chats')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final messages = snapshot.data.docs;
              return displayMessagesList(messages, userId);
            },
          ),
          SendMessage(conversationId),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DocumentSnapshot buddyData =
        ModalRoute.of(context).settings.arguments;
    final fbMethods = Provider.of<FirebaseMethods>(context, listen: false);

    final currentUser = fbMethods.getCurrentUser().uid;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor.withOpacity(1.0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(buddyData['name']),
        actions: [
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: buddyData.data().containsKey('conversationID')
          ? messagesListener(buddyData['conversationID'], currentUser)
          : FutureBuilder(
              future: fbMethods.getOrCreateConversation(
                  buddyData['myUid'], buddyData['friendUid'],
                  (String conversationId) {
                conversation = conversationId;
              }),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                return messagesListener(conversation, currentUser);
              },
            ),
    );
  }
}
