import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:studypartner/pages/addInterests.dart';

import 'package:studypartner/pages/pageviewpage.dart';

import 'package:studypartner/providers/firebaseMethods.dart';

class HomePage extends StatefulWidget {
  static const routeName = 'home-page';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //bool newUser = true;
  DocumentSnapshot userData;
  Future<bool> setupData() async {
    final fbMethods = Provider.of<FirebaseMethods>(context, listen: false);
    final newUser = await fbMethods.authenticateUser(
      fbMethods.getCurrentUser(),
    );
    if (!newUser) {
      userData = await fbMethods.getUserData(fbMethods.getCurrentUser().uid);
    }
    return newUser;
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<FirebaseMethods>(context, listen: false);
    return FutureBuilder(
      future: setupData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        final displaywidget =
            snapshot.data ? AddInterests() : PageViewpage(userData);
        return displaywidget;
      },

      //findUser ? AddInterests() : oldUser(data),
    );
  }
}
