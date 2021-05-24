import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studypartner/pages/friendsPage.dart';
import 'package:studypartner/pages/requests.dart';
import 'package:studypartner/providers/firebaseMethods.dart';
import 'package:studypartner/widgets/nearbyBuddy.dart';

class ChatPage extends StatefulWidget {
  // final String uid;
  // ChatPage(this.uid);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>
    with AutomaticKeepAliveClientMixin {
  QuerySnapshot latestRequest;
  QuerySnapshot conversations;
  String url;
  Future<void> setData() async {
    final data = Provider.of<FirebaseMethods>(context, listen: false);
    latestRequest = await data.getLatestRequest(data.getCurrentUser());
    url = await data.getDownloadUrl(latestRequest.docs[0]['requestSender']);
    //conversations = await data.getConversations(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final data = Provider.of<FirebaseMethods>(context, listen: false);
    return Scaffold(
      
      body: FutureBuilder(
        future: setData(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
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
                        backgroundImage: CachedNetworkImageProvider(url),
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
                'Chats',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).primaryColor),
              ),
              Divider(),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(data.getCurrentUser().uid)
                    .collection('conversations')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: Text('Getting Chats'));
                  }
                  final chats = snapshot.data.docs;
                  print(chats.toString());
                  return Expanded(
                    child: ListView.builder(
                      itemCount: chats.length,
                      itemBuilder: (context, index) {
                        // if (chats[index].reference.collection('chats').get()) {
                        //   return Container();
                        // }
                        return NearbyBuddy(chats[index], null, 'chats');
                      },
                    ),
                  );
                },
              )
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        child: Icon(Icons.person_add_alt_1_outlined),
        onPressed: () {
          Navigator.of(context).pushNamed(FriendsPage.routeName);
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
