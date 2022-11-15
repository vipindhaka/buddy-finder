import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
//import 'package:provider/provider.dart';
//import 'package:studypartner/helper/adHelper.dart';
import 'package:studypartner/pages/ExamPage.dart';
import 'package:studypartner/pages/chatPage.dart';
import 'package:studypartner/pages/requests.dart';

import 'package:studypartner/pages/searchBuddyPage.dart';
//import 'package:studypartner/providers/firebaseMethods.dart';
import 'package:studypartner/widgets/appDrawer.dart';
import 'package:studypartner/widgets/bannerad.dart';
import 'package:studypartner/widgets/header.dart';

class PageViewpage extends StatefulWidget {
  final DocumentSnapshot user;
  PageViewpage(this.user);
  @override
  _PageViewpageState createState() => _PageViewpageState();
}

class _PageViewpageState extends State<PageViewpage> {
  PageController _pageController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _page = 0;
  // Future<void> handleNotification() async {
  //   RemoteMessage initialMessage =
  //       await FirebaseMessaging.instance.getInitialMessage();

  //   if (initialMessage?.data['type'] == 'chat') {
  //     setState(() {
  //       _page = 2;
  //     });
  //   }

  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     if (message.data['type'] == 'chat') {
  //       setState(() {
  //         _page = 2;
  //       });
  //     }
  //   });
  // }

  @override
  void initState() {
    super.initState();
    //handleNotification();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(_page, context, widget.user, _scaffoldKey),
      drawer: AppDrawer(widget.user),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              children: [
                ExamPage(widget.user),
                SearchBuddyPage(),
                ChatPage(),
                AllRequest(),
              ],
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _page = page;
                });
              },
              physics: NeverScrollableScrollPhysics(),
            ),
          ),
          ShowBannerAd(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Theme.of(context).accentColor,
        unselectedItemColor: Colors.grey,
        onTap: (value) {
          _pageController.animateToPage(value,
              duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        },
        currentIndex: _page,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Chats'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_add), label: 'Requests'),
        ],
      ),
    );
  }
}
