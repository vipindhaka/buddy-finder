import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
//import 'package:studypartner/helper/adHelper.dart';

import 'package:studypartner/providers/firebaseMethods.dart';
import 'package:studypartner/providers/locationMethods.dart';
import 'package:studypartner/widgets/bannerad.dart';

import 'package:studypartner/widgets/nearbyBuddy.dart';

class SearchBuddyPage extends StatefulWidget {
  @override
  _SearchBuddyPageState createState() => _SearchBuddyPageState();
}

class _SearchBuddyPageState extends State<SearchBuddyPage> {
  bool _isLoading = false;
  int buddyType = 0;
  static final _kAdIndex = 1;

  int _getSearchItemIndex(int rawIndex) {
    if (rawIndex >= _kAdIndex) {
      return rawIndex - 1;
    }
    return rawIndex;
  }

  buildNearBuddy(FirebaseMethods fbdata) {
    //final size = MediaQuery.of(context).size;
    try {
      return Consumer<LocationMethods>(
        builder: (context, locMethods, child) {
          return FutureBuilder(
              future: locMethods.getNearbyBuddy(context),
              builder: (ctx, streamSnapshot) {
                if (streamSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                // print('rebuilt');
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
                        itemCount: buddies.length + 1,
                        itemBuilder: (ctx, index) {
                          if (index == _kAdIndex) {
                            //_kAdIndex = 2;
                            return ShowBannerAd();
                          } else {
                            return NearbyBuddy(
                                buddies[_getSearchItemIndex(index)],
                                currentuserdata,
                                'search');
                          }
                        });
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
      height: 50,
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
            top: size.height * .5,
            left: size.width * .2,
            child: Column(
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
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //super.build(context);
    final size = MediaQuery.of(context).size;
    final locData = Provider.of<LocationMethods>(context);
    final fbData = Provider.of<FirebaseMethods>(context, listen: false);

    return Scaffold(
        body: !_isLoading
            ? buildSearchScreen(size, locData)
            : buildNearBuddy(fbData));
  }

  // @override
  //
  // bool get wantKeepAlive => true;
}
