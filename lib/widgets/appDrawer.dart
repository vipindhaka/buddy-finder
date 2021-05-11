import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studypartner/providers/firebaseMethods.dart';

class AppDrawer extends StatelessWidget {
  // final url;
  // AppDrawer(this.url);
  @override
  Widget build(BuildContext context) {
    final fbMethods = Provider.of<FirebaseMethods>(context, listen: false);
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              //padding: EdgeInsets.only(left: 10),
              margin: EdgeInsets.only(left: 10),
              child: CircleAvatar(
                radius: 40,
                backgroundImage: CachedNetworkImageProvider(
                    fbMethods.getCurrentUser().photoURL),
              ),
            ),
            Divider(),
            TextButton.icon(
                style: ButtonStyle(
                    padding:
                        MaterialStateProperty.all(EdgeInsets.only(left: 10))),
                icon: Icon(Icons.settings),
                onPressed: () {},
                label: Text(
                  'Settings',
                  style: TextStyle(fontSize: 20),
                )),
            TextButton.icon(
              style: ButtonStyle(
                  padding:
                      MaterialStateProperty.all(EdgeInsets.only(left: 10))),
              icon: Icon(Icons.logout),
              onPressed: () async {
                await fbMethods.signOut();
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
