import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:studypartner/providers/firebaseMethods.dart';

class ExamPage extends StatefulWidget {
  @override
  _ExamPageState createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    final data = Provider.of<FirebaseMethods>(context, listen: false);
    return Scaffold(
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
