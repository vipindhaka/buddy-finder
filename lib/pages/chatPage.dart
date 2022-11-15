//import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studypartner/pages/friendsPage.dart';
//import 'package:studypartner/pages/requests.dart';
import 'package:studypartner/providers/firebaseMethods.dart';
import 'package:studypartner/widgets/nearbyBuddy.dart';

class ChatPage extends StatefulWidget {
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
// with AutomaticKeepAliveClientMixin
{
  //List<DocumentSnapshot> storechats = [];
  @override
  Widget build(BuildContext context) {
    //super.build(context);
    final data = Provider.of<FirebaseMethods>(context, listen: false);
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(data.getCurrentUser().uid)
            .collection('conversations')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text('Getting Chats'));
          }
          final chats = snapshot.data.docs;
          // storechats = chats;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              return NearbyBuddy(chats[index], null, 'chats');
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'friends',
        elevation: 10,
        child: Icon(Icons.person_add_alt_1_outlined),
        onPressed: () {
          Navigator.of(context).pushNamed(FriendsPage.routeName);
        },
      ),
    );
  }

  // @override

  // bool get wantKeepAlive => true;
}
