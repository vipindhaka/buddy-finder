import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePerson {
  final DocumentSnapshot buddyData;
  final DocumentSnapshot userData;
  final String check;
  // final String buddyname;
  //final String downloadUrl;

  ProfilePerson(
    this.buddyData,
    this.userData,
    this.check,
    // this.buddyname,
    //this.downloadUrl,
  );
}
