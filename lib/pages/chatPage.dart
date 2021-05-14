import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studypartner/pages/requests.dart';
import 'package:studypartner/providers/firebaseMethods.dart';

class ChatPage extends StatefulWidget {
  final String uid;
  ChatPage(this.uid);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  QuerySnapshot latestRequest;
  QuerySnapshot conversations;
  Future<void> setData() async {
    final data = Provider.of<FirebaseMethods>(context, listen: false);
    latestRequest = await data.getLatestRequest(widget.uid);
    //conversations = await data.getConversations(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: AppDrawer(),
      //appBar: header('Chats', context),
      body: FutureBuilder(
        future: setData(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          // if (latestRequest.docs.isEmpty) {
          //   //return Text('');
          // }
          final latereq =
              latestRequest.docs.isNotEmpty ? latestRequest.docs[0] : null;

          return Column(
            children: [
              latereq != null
                  ? ListTile(
                      onTap: () {
                        Navigator.of(context).pushNamed(AllRequest.routeName);
                      },
                      leading: CircleAvatar(
                        backgroundImage: CachedNetworkImageProvider(
                            latereq['profile_photo']),
                      ),
                      title: Text(
                        'Friend Requests',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Approve or ignore requests'),
                    )
                  : Container(),
              SizedBox(
                height: 10,
              ),
              Text(
                'Conversations',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).primaryColor),
              ),
              Divider(),
              // StreamBuilder(),
            ],
          );
        },
      ),
    );
  }
}
