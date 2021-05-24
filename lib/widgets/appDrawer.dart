import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studypartner/pages/settings.dart';
import 'package:studypartner/providers/firebaseMethods.dart';

class AppDrawer extends StatelessWidget {
  final DocumentSnapshot userData;
  AppDrawer(this.userData);
  // final url;
  // AppDrawer(this.url);
  @override
  Widget build(BuildContext context) {
    final fbMethods = Provider.of<FirebaseMethods>(context, listen: false);
    return Drawer(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              //padding: EdgeInsets.only(left: 10),
              margin: EdgeInsets.only(left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage:
                        CachedNetworkImageProvider(userData['profile_photo']),
                  ),
                  Text(
                    userData['name'],
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Divider(),
            TextButton.icon(
                style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(EdgeInsets.only(left: 10))),
                icon: Icon(Icons.settings),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(UserSettings.routeName, arguments: userData);
                },
                label: Text(
                  'Edit Profile',
                  style: TextStyle(fontSize: 20),
                )),
            Divider(),
            TextButton.icon(
              style: ButtonStyle(
                  padding:
                      MaterialStateProperty.all(EdgeInsets.only(left: 10))),
              icon: Icon(Icons.logout),
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return AlertDialog(
                        title: Text('Are you Sure'),
                        content: Text('Do you want to logout?'),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await fbMethods.signOut(context);
                              },
                              child: Text('Yes')),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('No'))
                        ],
                      );
                    });
              },
              label: Text(
                'Logout',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
