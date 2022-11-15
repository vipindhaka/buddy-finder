import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studypartner/pages/authPage.dart';
import 'package:studypartner/pages/homePage.dart';
import 'package:studypartner/providers/firebaseMethods.dart';

class GetStarted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    final data = Provider.of<FirebaseMethods>(context);
    return Scaffold(
      body: data.getCurrentUser() != null ? HomePage() : AuthPage(),
    );
  }
}
