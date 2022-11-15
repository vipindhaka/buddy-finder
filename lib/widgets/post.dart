import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studypartner/models/collabPost.dart';
import 'package:studypartner/pages/profileScreenPost.dart';
//import 'package:intl/intl.dart';
import 'package:studypartner/providers/firebaseMethods.dart';
import 'package:timeago/timeago.dart' as timeago;

class SinglePost extends StatelessWidget {
  final CollabPost post;
  final DocumentSnapshot currentuser;
  SinglePost(this.post, this.currentuser);
  @override
  Widget build(BuildContext context) {
    final fbMethods = Provider.of<FirebaseMethods>(context, listen: false);
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                FutureBuilder(
                  future: fbMethods.getDownloadUrl(post.userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      print('getting photo');
                      return CircleAvatar();
                    }

                    return CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider(snapshot.data),
                    );
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(post.userName,
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                        SizedBox(width: 5),
                        Text(timeago.format(post.time.toDate()))
                      ],
                    ),
                    Text(
                      'Interest Required: ' + post.interestRequirement,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text(post.description),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(ProfileScreenPost.routeName, arguments: {
                    'buddyuserId': post.userId,
                    'currentUser': currentuser,
                    'check': 'posts',
                    'buddyName': post.userName,
                  });
                },
                child: Text('Connect'))
          ],
        ),
      ),
    );
  }
}
