import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:studypartner/providers/firebaseMethods.dart';

import 'package:studypartner/widgets/nearbyBuddy.dart';

class AllRequest extends StatefulWidget {
  static const routeName = 'all-requests';
  @override
  _AllRequestState createState() => _AllRequestState();
}

class _AllRequestState extends State<AllRequest> {
  DocumentSnapshot userdata;
  //List<DocumentSnapshot> requests = [];

  Future<QuerySnapshot> setUpData() async {
    final data = Provider.of<FirebaseMethods>(context, listen: false);
    final user = data.getCurrentUser();
    userdata = await data.getUserData(user.uid);
    return await data.getrequests(user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: setUpData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          final List<DocumentSnapshot> datalist = snapshot.data.docs;
          if (datalist.length == 0) {
            return Center(
              child: Text('oh boy! No Requests'),
            );
          }
          return ListView.builder(
            itemCount: datalist.length,
            itemBuilder: (context, index) {
              return NearbyBuddy(datalist[index], userdata, 'requests');
            },
          );
        },
      ),
    );
  }
}
