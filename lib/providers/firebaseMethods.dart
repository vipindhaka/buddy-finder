import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:studypartner/models/user.dart';

class FirebaseMethods with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  DocumentSnapshot currentUser;

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
        .add({
      'requestSender': requestsender['uid'],
      'requestReciever': requestReciever['uid'],
      'name': requestsender['name'],
      'profile_photo': requestsender['profile_photo'],
      'timestamp': DateTime.now(),
      'interests': requestsender['interests']
    });
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
    if (requestCheck.docs.isNotEmpty) check = 'Request Sent';
    print(requestCheck.docs.toString());
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
      friendCheck.docs.forEach((element) {
        if (element.id == buddyuid) {
          check = 'friend';
        }
      });

      print(friendCheck.docs.length.toString());
      //if (friendCheck == true) check = 'friends';
    }
    return check;
  }

  Future<QuerySnapshot> getConversations() {}
}
