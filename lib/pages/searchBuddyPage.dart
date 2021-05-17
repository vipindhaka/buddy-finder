import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:studypartner/providers/firebaseMethods.dart';
import 'package:studypartner/providers/locationMethods.dart';

import 'package:studypartner/widgets/nearbyBuddy.dart';

class SearchBuddyPage extends StatefulWidget {
  @override
  _SearchBuddyPageState createState() => _SearchBuddyPageState();
}

class _SearchBuddyPageState extends State<SearchBuddyPage> {
  bool _isLoading = false;
  int buddyType = 0;
  // List<DocumentSnapshot> allBuddies = [];
  buildNearBuddy(FirebaseMethods fbdata) {
    try {
      return Consumer<LocationMethods>(
        builder: (context, locMethods, child) {
          return FutureBuilder(
              future: locMethods.getNearbyBuddy(context),
              builder: (ctx, streamSnapshot) {
                if (streamSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (streamSnapshot.error != null) {
                  print(streamSnapshot.error.toString());
                  PermissionStatus check;
                  return AlertDialog(
                    title: Text('Permission Denied'),
                    content: Text('Please allow location to use this feature'),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          check = await Permission.location.request();

                          if (check.isPermanentlyDenied) {
                            openAppSettings();
                          }

                          bool status = await Permission.location.isGranted;

                          if (status) {
                            setState(() {});
                          }
                        },
                        child: Text(
                          check.isGranted ? 'Open app Settings' : 'Allow',
                        ),
                      )
                    ],
                  );
                }

                return StreamBuilder(
                  stream: streamSnapshot.data,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    List<DocumentSnapshot> buddies = snapshot.data;
                    //print(buddies.length.toString());
                    print('kind of here');
                    if (buddies.length - 1 == 0) {
                      return Center(
                        child: Text('No buddy Found..'),
                      );
                    }

                    //List<double> distance=[];
                    DocumentSnapshot currentuserdata =
                        buddies.firstWhere((element) {
                      return element.id == fbdata.getCurrentUser().uid;
                    });

                    buddies.removeWhere((docelement) {
                      return docelement.id == fbdata.getCurrentUser().uid;
                    });

                    if (buddyType == 2) {
                      fbdata.removeBuddies(buddies, currentuserdata);
                    }

                    if (buddies.length == 0) {
                      return Center(
                        child: Text('No buddy Found..'),
                      );
                    }
                    return ListView.builder(
                      itemCount: buddies.length,
                      itemBuilder: (ctx, index) {
                        return NearbyBuddy(
                            buddies, index, currentuserdata, 'search');
                      },
                    );
                  },
                );
              });
        },
      );
    } catch (e) {
      print('definitely here');
    }
  }

  Widget buildSearchButton(Size size, String title, int type) {
    return Container(
      //color: Colors.white,
      height: 50,
      //width: size.width * .4,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all()),
      child: Center(
          child: TextButton.icon(
              onPressed: () {
                buddyType = type;
                setState(() {
                  _isLoading = true;
                });
              },
              icon: Icon(
                Icons.location_searching,
                color: Colors.blue,
                size: 30,
              ),
              label: Text(
                title,
                style: TextStyle(
                    fontSize: 15, color: Theme.of(context).accentColor),
              ))),
    );
  }

  Container buildSearchScreen(Size size, LocationMethods locData) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('assets/images/search.jpg'),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: size.height * .6,
            left: size.width * .2,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildSearchButton(size, 'Search Nearby', 1),
                SizedBox(
                  height: 10,
                ),
                buildSearchButton(size, 'Search With Similar Interests', 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final locData = Provider.of<LocationMethods>(context);
    final fbData = Provider.of<FirebaseMethods>(context, listen: false);
    //final currentUser = fbData.getCurrentUser();
    return Scaffold(
        //drawer: AppDrawer(),
        //appBar: header('Search Buddy', context),
        body: !_isLoading
            ? buildSearchScreen(size, locData)
            : buildNearBuddy(fbData)
        // body: TextButton(
        //   child: Text('Signout'),
        //   onPressed: fbData.signOut,
        // ),
        );
  }
}
