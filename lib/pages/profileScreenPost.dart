import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studypartner/providers/firebaseMethods.dart';
import 'package:studypartner/widgets/requestdetails.dart';

class ProfileScreenPost extends StatefulWidget {
  static const routeName = '/profile-screen-post';
  @override
  _ProfileScreenPostState createState() => _ProfileScreenPostState();
}

class _ProfileScreenPostState extends State<ProfileScreenPost> {
  @override
  Widget build(BuildContext context) {
    final fbMethods = Provider.of<FirebaseMethods>(context, listen: false);
    final data =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    DocumentSnapshot currentuserData = data['currentUser'];
    String buddyuserId = data['buddyuserId'];
    String buddyName = data['buddyName'];
    String checkdata = data['check'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          buddyName,
        ),
      ),
      body: FutureBuilder(
        future: fbMethods.getUserData(buddyuserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            margin: const EdgeInsets.all(10),
            alignment: Alignment.center,
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: CachedNetworkImageProvider(
                        snapshot.data['profile_photo']),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    snapshot.data['name'],
                    style: TextStyle(
                        fontSize: 25, letterSpacing: 1, wordSpacing: 5),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    snapshot.data['interests'].join(" ") ?? '',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RequestChecker(
                      snapshot.data, currentuserData, checkdata, context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
