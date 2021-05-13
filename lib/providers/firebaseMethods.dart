import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:studypartner/models/user.dart';
import 'package:studypartner/providers/locationMethods.dart';

class FirebaseMethods with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  DocumentSnapshot currentUser;
  bool updatingProfile = false;

  Future<User> signIn() async {
    GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication =
        await _signInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: _signInAuthentication.accessToken,
      idToken: _signInAuthentication.idToken,
    );
    UserCredential _user = await _auth.signInWithCredential(credential);
    notifyListeners();

    return _user.user;
  }

  Future<void> createUser() async {}

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    notifyListeners();
  }

  User getCurrentUser() {
    User currentUser;
    currentUser = _auth.currentUser;
    return currentUser;
  }

  Future<bool> authenticateUser(User user) async {
    QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user.email)
        .get();

    final List<DocumentSnapshot> docs = result.docs;

    return docs.length == 0 ? true : false;
  }

  Future<void> updateUserData(
    DocumentSnapshot userData,
    double prefradius,
    double newradius,
    String interests,
    String displayName,
    File image,
    LocationMethods locationMethods,
  ) async {
    String downloadUrl;
    updatingProfile = true;
    notifyListeners();
    if (image != null) {
      final uploadTask =
          FirebaseStorage.instance.ref().child('${userData['uid']}.jpg');
      await uploadTask.putFile(image);
      downloadUrl = await uploadTask.getDownloadURL();
    }
    Map<String, dynamic> updateData = {};
    List<MapEntry<String, dynamic>> entries = [];
    if (userData['name'] != displayName)
      entries.add(MapEntry('name', displayName));

    List<String> inte = interests.split(" ");

    if (userData['interests'] != inte) entries.add(MapEntry('interests', inte));

    if (downloadUrl != null)
      entries.add(MapEntry('profile_photo', downloadUrl));

    // if (userData['name'] != displayName)
    //   entries.add(MapEntry('name', displayName));

    updateData.addEntries(entries);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userData['uid'])
        .update(updateData);

    if (prefradius != newradius) locationMethods.setRadius(newradius);
    updatingProfile = false;
    notifyListeners();
  }

  Future<void> addDataToDb(User currentUser, List<String> interests) async {
    AppUser user = AppUser(
        uid: currentUser.uid,
        email: currentUser.email,
        profilePhoto: currentUser.photoURL,
        name: currentUser.displayName,
        //username: username,
        interests: interests,
        time: DateTime.now());

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .set(user.toMap(user));
    // await FirebaseFirestore.instance
    //     .collection('locations')
    //     .doc(currentUser.uid)
    //     .set({
    //   'userId': currentUser.uid,
    //   'interests': interests,
    //   'name': currentUser.displayName,
    //   'photo': currentUser.photoURL,
    //   'timestamp': DateTime.now()
    // });
  }

  Future<void> addlocation(User user, GeoFirePoint myLocation) async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      // 'userId': user.uid,
      'position': myLocation.data,
    });
  }

  Future<DocumentSnapshot> getUserData(String uid) async {
    final userdata =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    //final user = AppUser.fromMap(userdata.data());
    //print(user.name);
    //return user;
    return userdata;
  }

  Future<void> sendFriendRequest(
      DocumentSnapshot requestsender, DocumentSnapshot requestReciever) async {
    await FirebaseFirestore.instance
        .collection('requests')
        .doc(requestReciever['uid'])
        .collection('myreq')
        .doc(requestsender['uid'])
        .set({
      'requestSender': requestsender['uid'],
      'requestReciever': requestReciever['uid'],
      'name': requestsender['name'],
      'profile_photo': requestsender['profile_photo'],
      'timestamp': DateTime.now(),
      'interests': requestsender['interests']
    });
    notifyListeners();
  }

  Future<void> deleteRequest(DocumentSnapshot requestSender,
      DocumentSnapshot requestReciever, String check) async {
    print('deleting');
    await FirebaseFirestore.instance
        .collection('requests')
        .doc(requestReciever['uid'])
        .collection('myreq')
        .doc(requestSender[check == 'requests' ? 'requestSender' : 'uid'])
        .delete();
    notifyListeners();
  }

  Future<void> confirmRequest(DocumentSnapshot requestSender,
      DocumentSnapshot requestReciever, String check) async {
    await FirebaseFirestore.instance
        .collection('friends')
        .doc(requestReciever['uid'])
        .collection('myfriends')
        .add({
      'name': requestSender['name'],
      'profile_photo': requestSender['profile_photo'],
      'interests': requestSender['interests'],
      'timestamp': DateTime.now(),
      'friendUid': requestSender[check == 'requests' ? 'requestSender' : 'uid'],
      'myUid': requestReciever['uid'],
    });
    await FirebaseFirestore.instance
        .collection('friends')
        .doc(requestSender[check == 'requests' ? 'requestSender' : 'uid'])
        .collection('myfriends')
        .add({
      'name': requestReciever['name'],
      'profile_photo': requestReciever['profile_photo'],
      'interests': requestReciever['interests'],
      'timestamp': DateTime.now(),
      'friendUid': requestReciever['uid'],
      'myUid': requestSender[check == 'requests' ? 'requestSender' : 'uid'],
    });
    // await FirebaseFirestore.instance
    //     .collection('requests')
    //     .doc(requestReciever['uid'])
    //     .collection('myreq')
    //     .doc(requestSender[check == 'requests' ? 'requestSender' : 'uid'])
    //     .delete();
    await deleteRequest(requestSender, requestReciever, check);
    notifyListeners();
  }

  Future<QuerySnapshot> getLatestRequest(String uid) async {
    final latestRequest = await FirebaseFirestore.instance
        .collection('requests')
        .doc(uid)
        .collection('myreq')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();
    return latestRequest;
  }

  Future<QuerySnapshot> getrequests(String uid) async {
    final list = await FirebaseFirestore.instance
        .collection('requests')
        .doc(uid)
        .collection('myreq')
        .get();

    return list;
  }

  void removeBuddies(
      List<DocumentSnapshot> buddies, DocumentSnapshot currentuserdata) {
    final List<dynamic> currentUserinterests = currentuserdata['interests'];

    buddies.removeWhere((buddyelement) {
      final List<dynamic> buddyinterests = buddyelement['interests'];
      bool remove = true;

      currentUserinterests.forEach((element) {
        for (int i = 0; i < buddyinterests.length; i++) {
          if (element.toLowerCase() == buddyinterests[i].toLowerCase()) {
            remove = false;
            break;
            //return false;
          }
          break;
        }
      });
      return remove;
    });
  }

  Future<String> checkWhetherAlreadyFriendOrRequestSent(
      String buddyuid, String currentUseruid) async {
    String check = 'Send Request';
    QuerySnapshot recievedRequest;
    final QuerySnapshot requestCheck = await FirebaseFirestore.instance
        .collection('requests')
        .doc(buddyuid)
        .collection('myreq')
        .where('requestSender', isEqualTo: currentUseruid)
        .get();
    //print(requestCheck.docs.length.toString());
    if (requestCheck.docs.isNotEmpty) check = 'Request Sent';
    // print(requestCheck.docs.toString());
    if (requestCheck.docs.isEmpty) {
      recievedRequest = await FirebaseFirestore.instance
          .collection('requests')
          .doc(currentUseruid)
          .collection('myreq')
          .where(
            'requestSender',
            isEqualTo: buddyuid,
          )
          .get();
      if (recievedRequest.docs.isNotEmpty) check = 'Confirm Request';
    }
    if (requestCheck.docs.isEmpty && recievedRequest.docs.isEmpty) {
      final QuerySnapshot friendCheck = await FirebaseFirestore.instance
          .collection('friends')
          .doc(currentUseruid)
          .collection('myfriends')
          .get();
      print('here');
      friendCheck.docs.
          // firstWhere((element) {
          //   if (element.id == buddyuid) {
          //     check = 'friend';
          //   }
          //   return element.id == buddyuid;
          // });
          forEach((element) {
        if (element['friendUid'] == buddyuid) {
          check = 'Friends';
        }
      });

      print(friendCheck.docs.length.toString());
      //if (friendCheck == true) check = 'friends';
    }
    return check;
  }

  Future<QuerySnapshot> getConversations() {}
}
