import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:studypartner/providers/firebaseMethods.dart';

class ExamPage extends StatefulWidget {
  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
  // Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // double _radius;
  //final tabController=TabController(length: length, vsync: vsync)
  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    final data = Provider.of<FirebaseMethods>(context, listen: false);
    return Scaffold(
        //drawer: AppDrawer(),
        // appBar: header(
        //   'Collab Dev',
        //   context,
        //   url: data.getCurrentUser().photoURL,
        // ),
        body: FutureBuilder(
      future: data.getUserData(data.getCurrentUser().uid),
      builder: (ctx, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        print(userSnapshot.data.toString());
        return Text('');
      },
    ));
  }
}
