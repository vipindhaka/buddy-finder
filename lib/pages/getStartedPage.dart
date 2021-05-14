import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studypartner/pages/authPage.dart';
import 'package:studypartner/pages/homePage.dart';
import 'package:studypartner/providers/firebaseMethods.dart';

class GetStarted extends StatelessWidget {
  // buildSplashScreen(Size size) {
  //   return Container(
  //     alignment: Alignment.center,
  //     //height: size.height * 45,
  //     decoration: BoxDecoration(
  //       image: DecorationImage(
  //         //alignment: Alignment.center,
  //         fit: BoxFit.cover,
  //         image: AssetImage(
  //           'assets/images/books.jpg',
  //         ),
  //       ),
  //     ),
  //     child: Stack(
  //       //mainAxisAlignment: MainAxisAlignment.end,
  //       children: [
  //         Positioned(
  //           top: size.height * .85,
  //           left: size.width * .1,
  //           //bottom: 25,
  //           child: Container(
  //             margin: EdgeInsets.only(bottom: size.height * .1),
  //             height: 40,
  //             width: size.width * .8,
  //             decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(10),
  //                 image: DecorationImage(
  //                     fit: BoxFit.cover,
  //                     image: AssetImage(
  //                         'assets/images/google_signin_button.png'))),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  //}

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    final data = Provider.of<FirebaseMethods>(context);
    return Scaffold(
      body: data.getCurrentUser() != null ? HomePage() : AuthPage(),
    );
  }
}
