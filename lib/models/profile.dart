import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePerson {
  final DocumentSnapshot buddyData;
  final DocumentSnapshot userData;
  final String check;

  ProfilePerson(this.buddyData, this.userData, this.check);
}
