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
  bool newUser = true;

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<FirebaseMethods>(context, listen: false);
    return FutureBuilder(
      future: data.authenticateUser(
        data.getCurrentUser(),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());

        final displaywidget = snapshot.data ? AddInterests() : PageViewpage();
        return displaywidget;
      },

      //findUser ? AddInterests() : oldUser(data),
    );
  }
}
