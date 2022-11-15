import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studypartner/pages/addInterests.dart';
import 'package:studypartner/pages/friendsPage.dart';

import 'package:studypartner/pages/getStartedPage.dart';
import 'package:studypartner/pages/homePage.dart';
import 'package:studypartner/pages/individualchatPage.dart';
import 'package:studypartner/pages/postACollab.dart';
import 'package:studypartner/pages/profilePage.dart';
import 'package:studypartner/pages/profileScreenPost.dart';
import 'package:studypartner/pages/requests.dart';
import 'package:studypartner/pages/settings.dart';
import 'package:studypartner/providers/firebaseMethods.dart';
import 'package:studypartner/providers/locationMethods.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  //FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.getDouble('radius') ??
      await sharedPreferences.setDouble('radius', 10.0);
  runApp(MyApp(sharedPreferences));
}

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // If you're going to use other Firebase services in the background, such as Firestore,
//   // make sure you call `initializeApp` before using other Firebase services.
//   await Firebase.initializeApp();
//   print("Handling a background message: ${message.messageId}");
// }

class MyApp extends StatelessWidget {
  final sharedPreferences;
  MyApp(this.sharedPreferences);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => FirebaseMethods(),
        ),
        ChangeNotifierProvider(
            create: (ctx) => LocationMethods(sharedPreferences))
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CollabDev',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          accentColor: Colors.blueGrey,
          appBarTheme: AppBarTheme(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              textTheme: TextTheme().copyWith(
                headline6: TextStyle(
                    fontSize: 20,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w500),
              ),
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.blueGrey)),
        ),
        home: GetStarted(),
        routes: {
          //EditProfile.routeName: (ctx) => EditProfile(),
          AllRequest.routeName: (ctx) => AllRequest(),
          AddInterests.routeName: (ctx) => AddInterests(),
          HomePage.routeName: (ctx) => HomePage(),
          ProfilePage.routeName: (ctx) => ProfilePage(),
          UserSettings.routeName: (ctx) => UserSettings(),
          FriendsPage.routeName: (ctx) => FriendsPage(),
          IndividualChatScreen.routeName: (ctx) => IndividualChatScreen(),
          PostACollab.routeName: (ctx) => PostACollab(),
          ProfileScreenPost.routeName: (ctx) => ProfileScreenPost(),
        },
      ),
    );
  }
}
