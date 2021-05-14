import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studypartner/pages/addInterests.dart';

import 'package:studypartner/pages/getStartedPage.dart';
import 'package:studypartner/pages/homePage.dart';
import 'package:studypartner/pages/profilePage.dart';
import 'package:studypartner/pages/requests.dart';
import 'package:studypartner/pages/settings.dart';
import 'package:studypartner/providers/firebaseMethods.dart';
import 'package:studypartner/providers/locationMethods.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.getDouble('radius') ??
      await sharedPreferences.setDouble('radius', 10.0);
  runApp(MyApp(sharedPreferences));
}

class MyApp extends StatelessWidget {
  final sharedPreferences;
  MyApp(this.sharedPreferences);
  // This widget is the root of your application.
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
          // textTheme: TextTheme()
          //     .copyWith(headline6: TextStyle(fontFamily: 'Signatra')),
          primarySwatch: Colors.blueGrey,
          accentColor: Colors.brown,
        ),
        home: GetStarted(),
        routes: {
          //EditProfile.routeName: (ctx) => EditProfile(),
          AllRequest.routeName: (ctx) => AllRequest(),
          AddInterests.routeName: (ctx) => AddInterests(),
          HomePage.routeName: (ctx) => HomePage(),
          ProfilePage.routeName: (ctx) => ProfilePage(),
          UserSettings.routeName: (ctx) => UserSettings(),
        },
      ),
    );
  }
}
