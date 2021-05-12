import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studypartner/models/profile.dart';

import 'package:studypartner/models/user.dart';

import 'package:studypartner/providers/firebaseMethods.dart';
import 'package:studypartner/widgets/header.dart';

class ProfilePage extends StatefulWidget {
  static const routeName = 'profile-page';
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<String> checkUser(String buddyuid, String currentUseruid) async {
    final data = Provider.of<FirebaseMethods>(context, listen: false);
    final check = await data.checkWhetherAlreadyFriendOrRequestSent(
        buddyuid, currentUseruid);
    return check;
  }

  //Future<void>

  @override
  Widget build(BuildContext context) {
    final ProfilePerson data = ModalRoute.of(context).settings.arguments;
    DocumentSnapshot currentuserData = data.userData;
    DocumentSnapshot buddyuserData = data.buddyData;
    String checkdata = data.check;
    print(currentuserData.data().toString());
    // final fbMethods = Provider.of<FirebaseMethods>(context, listen: false);
    //final size = MediaQuery.of(context).size;

    return Scaffold(
      //appBar: header('Profile', context),
      body: Container(
        margin: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage:
                    CachedNetworkImageProvider(buddyuserData['profile_photo']),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                buddyuserData['name'],
                style:
                    TextStyle(fontSize: 25, letterSpacing: 1, wordSpacing: 5),
              ),
              //Divider(),
              SizedBox(
                height: 15,
              ),
              Text(
                buddyuserData['interests'].toString() ?? '',
                style: TextStyle(fontSize: 20),
              ),
              // Text(
              //   user.bio == null ? 'Add interests for better results' : '',
              //   style: TextStyle(fontSize: 12, color: Colors.grey),
              // ),
              SizedBox(
                height: 15,
              ),
              Divider(
                thickness: 2,
              ),
              SizedBox(
                height: 20,
              ),

              Consumer<FirebaseMethods>(
                builder: (context, fbMethods, child) {
                  return FutureBuilder(
                    future: checkUser(
                      buddyuserData[
                          checkdata == 'requests' ? 'requestSender' : 'uid'],
                      currentuserData['uid'],
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }
                      print(snapshot.data);
                      String check = snapshot.data;
                      return Row(
                        //mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton.icon(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).primaryColor),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                              icon: Icon(
                                check == 'Send Request'
                                    ? Icons.person_add
                                    : check == 'Request Sent'
                                        ? Icons.person
                                        : Icons.check,
                                color: Colors.white,
                              ),
                              label: Text(
                                check,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15, color: Colors.white),
                              ),
                              onPressed: check == 'Send Request'
                                  ? () async {
                                      // setState(() {});
                                      await fbMethods.sendFriendRequest(
                                          currentuserData, buddyuserData);
                                    }
                                  : check == 'Request Sent'
                                      ? () async {
                                          //setState(() {});
                                          await fbMethods.deleteRequest(
                                              buddyuserData,
                                              currentuserData,
                                              checkdata);
                                        }
                                      : () async {
                                          //setState(() {});
                                          await fbMethods.confirmRequest(
                                              buddyuserData,
                                              currentuserData,
                                              checkdata);
                                        }),
                          if (check == 'Friends')
                            TextButton.icon(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).primaryColor),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                onPressed: () {},
                                icon: Icon(Icons.message, color: Colors.white),
                                label: Text(
                                  'Message',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ))
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
