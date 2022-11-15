import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:studypartner/models/profile.dart';

import 'package:studypartner/providers/firebaseMethods.dart';
import 'package:studypartner/widgets/interstitialAd.dart';
import 'package:studypartner/widgets/requestdetails.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = 'profile-page';
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();

    interstialAd();
  }

  @override
  Widget build(BuildContext context) {
    final ProfilePerson data = ModalRoute.of(context).settings.arguments;
    DocumentSnapshot currentuserData = data.userData;
    DocumentSnapshot buddyuserData = data.buddyData;
    String checkdata = data.check;
    final fbMethods = Provider.of<FirebaseMethods>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          buddyuserData['name'],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              checkdata == 'requests'
                  ? FutureBuilder(
                      future: fbMethods
                          .getDownloadUrl(buddyuserData['requestSender']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircleAvatar(
                            radius: 50,
                          );
                        }
                        return CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              CachedNetworkImageProvider(snapshot.data),
                        );
                      },
                    )
                  : CircleAvatar(
                      radius: 50,
                      backgroundImage: CachedNetworkImageProvider(
                          buddyuserData['profile_photo']),
                    ),
              SizedBox(
                height: 10,
              ),
              Text(
                buddyuserData['name'],
                style:
                    TextStyle(fontSize: 25, letterSpacing: 1, wordSpacing: 5),
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                buddyuserData['interests'].join(" ") ?? '',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 15,
              ),
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: 20,
              ),
              RequestChecker(
                  buddyuserData, currentuserData, checkdata, context),
            ],
          ),
        ),
      ),
    );
  }
}
