import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studypartner/providers/firebaseMethods.dart';
import 'package:studypartner/widgets/nearbyBuddy.dart';

class FriendsPage extends StatefulWidget {
  static const routeName = '/friends';
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<FirebaseMethods>(context, listen: false);
    final User currentuser = data.getCurrentUser();
    return Scaffold(
      appBar: AppBar(title: Text('Friends')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('friends')
            .doc(currentuser.uid)
            .collection('myfriends')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Getting your friends..'),
                  SizedBox(
                    height: 10,
                  ),
                  CircularProgressIndicator()
                ],
              ),
            );
          }
          if (!snapshot.hasData) {
            return Text('oh boy you are lonely');
          }
          print(snapshot.data.docs.length);
          final data = snapshot.data.docs;
          //return Text('');
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return NearbyBuddy(
                data[index],
                null,
                'friends',
              );
            },
          );
        },
      ),
    );
  }
}
