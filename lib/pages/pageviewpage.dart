import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studypartner/pages/ExamPage.dart';
import 'package:studypartner/pages/chatPage.dart';
import 'package:studypartner/pages/profilePage.dart';
import 'package:studypartner/pages/searchBuddyPage.dart';
import 'package:studypartner/providers/firebaseMethods.dart';
import 'package:studypartner/widgets/appDrawer.dart';

class PageViewpage extends StatefulWidget {
  @override
  _PageViewpageState createState() => _PageViewpageState();
}

class _PageViewpageState extends State<PageViewpage> {
  PageController _pageController;
  int _page = 0;
  DocumentSnapshot user;

  @override
  void initState() {
    // TODO: implement initState
    //
    super.initState();
    _pageController = PageController();
    //checkUser();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<FirebaseMethods>(context, listen: false);
    final userId = data.getCurrentUser().uid;
    return Scaffold(
      drawer: AppDrawer(),
      body: PageView(
        //pageSnapping: false,
        children: [
          ExamPage(),
          //AddInterests(),
          SearchBuddyPage(),
          ChatPage(userId),
          //ProfilePage(userId),
        ],
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            _page = page;
          });
        },
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Theme.of(context).accentColor,
        unselectedItemColor: Colors.grey,
        //iconSize: ,
        //border: Border.all(),
        // activeColor: Theme.of(context).accentColor,
        onTap: (value) {
          _pageController.animateToPage(value,
              duration: Duration(milliseconds: 300), curve: Curves.bounceIn);
        },
        currentIndex: _page,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Chats'),
          //BottomNavigationBarItem(icon: Icon(Icons.contacts), label: 'Profile'),
        ],
      ),
    );
  }
}
