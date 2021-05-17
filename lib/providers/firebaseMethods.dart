import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:studypartner/models/customException.dart';

import 'package:studypartner/models/user.dart';
import 'package:studypartner/providers/locationMethods.dart';
import 'package:studypartner/widgets/exceptiondisplay.dart';

class FirebaseMethods with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  DocumentSnapshot currentUser;
  bool updatingProfile = false;
  //String downloadUrl;

  Future<User> signIn(BuildContext context) async {
    try {
      GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication _signInAuthentication =
          await _signInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: _signInAuthentication.accessToken,
        idToken: _signInAuthentication.idToken,
      );
      UserCredential _user = await _auth.signInWithCredential(credential);
      // await authenticateUser(_user.user, context);
      notifyListeners();
      return _user.user;
    } on PlatformException catch (e) {
      print(e.code);
      showErrorException(context, CustomException(e.code));
      throw e;
    } catch (e) {
      //print(e.toString());
      showErrorException(
          context, CustomException('Failed To sign In. Try again'));
      throw e;
    }
  }

  Future<void> createUser() async {}

  Future<void> signOut(BuildContext context) async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut().then((value) {
        notifyListeners();
      });
    } on PlatformException catch (e) {
      showErrorException(context, CustomException(e.code));
    } catch (e) {
      showErrorException(context, CustomException('Failed to sign out'));
    }
    //notifyListeners();
  }

  User getCurrentUser() {
    User currentUser;
    currentUser = _auth.currentUser;
    return currentUser;
  }

  Future<bool> authenticateUser(User user, BuildContext context) async {
    try {
      QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: user.email)
          .get();

      final List<DocumentSnapshot> docs = result.docs;

      return docs.length == 0 ? true : false;
    } on PlatformException catch (e) {
      showErrorException(context, CustomException(e.code));
      return null;
    } catch (e) {
      showErrorException(
          context, CustomException('Failed to authenticate user'));
      return null;
    }
  }

  Future<void> updateUserData(
      DocumentSnapshot userData,
      double prefradius,
      double newradius,
      String interests,
      String displayName,
      File image,
      LocationMethods locationMethods,
      BuildContext context) async {
    try {
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

      if (userData['interests'] != inte)
        entries.add(MapEntry('interests', inte));

      if (downloadUrl != null)
        entries.add(MapEntry('profile_photo', downloadUrl));

      updateData.addEntries(entries);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userData['uid'])
          .update(updateData);

      if (prefradius != newradius) locationMethods.setRadius(newradius);
      updatingProfile = false;
      notifyListeners();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      showErrorException(context, CustomException(e.code));
      updatingProfile = false;
      notifyListeners();
    } catch (e) {
      showErrorException(context, CustomException('Failed to update'));
      updatingProfile = false;
      notifyListeners();
    }
  }

  Future<void> addDataToDb(
      User currentUser, List<String> interests, File image) async {
    final uploadTask =
        FirebaseStorage.instance.ref().child('${currentUser.uid}.jpg');
    await uploadTask.putFile(image);
    String url = await uploadTask.getDownloadURL();

    AppUser user = AppUser(
        uid: currentUser.uid,
        email: currentUser.email,
        profilePhoto: url,
        name: currentUser.displayName,
        //username: username,
        interests: interests,
        time: DateTime.now());

    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .set(user.toMap(user));
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
      //'profile_photo': requestsender['profile_photo'],
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

    await deleteRequest(requestSender, requestReciever, check);
    notifyListeners();
  }

  Future<QuerySnapshot> getLatestRequest(User user) async {
    final latestRequest = await FirebaseFirestore.instance
        .collection('requests')
        .doc(user.uid)
        .collection('myreq')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    //print(downloadUrl);
    return latestRequest;
    // String url =

    //.child('${latestRequest.docs[0]['requestSender']}.jpg');
  }

  Future<QuerySnapshot> getrequests(String uid) async {
    try {
      final list = await FirebaseFirestore.instance
          .collection('requests')
          .doc(uid)
          .collection('myreq')
          .get();
      // print(list.docs[0].id);
      return list;
    } on PlatformException catch (e) {
      // showErrorException(context, CustomException(e.code));
      throw e;
    } catch (e) {
      // showErrorException(context, CustomException('Unable to fetch requests'));
      throw e;
    }
  }

  void removeBuddies(
      List<DocumentSnapshot> buddies, DocumentSnapshot currentuserdata) {
    bool check = false;
    Map<String, bool> interests = {};
    final List<dynamic> currentUserinterests = currentuserdata['interests'];
    for (var v = 0; v < currentUserinterests.length; v++) {
      //print('stuck here');
      if (interests[currentUserinterests[v]] == null) {
        var element = currentUserinterests[v];
        interests[element] = true;
      }
    }

    buddies.removeWhere((element) {
      bool common = false;
      final List<dynamic> buddyInterests = element['interests'];
      for (var v = 0; v < buddyInterests.length; v++) {
        if (interests[buddyInterests[v]] != null) {
          common = true;
        }
      }
      return !common;
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
      friendCheck.docs.forEach((element) {
        if (element['friendUid'] == buddyuid) {
          check = 'Friends';
        }
      });

      print(friendCheck.docs.length.toString());
    }
    return check;
  }

  Future<String> getDownloadUrl(String uid) async {
    final uploadTask = FirebaseStorage.instance.ref().child('$uid.jpg');
    String downloadUrl = await uploadTask.getDownloadURL();
    return downloadUrl;
  }
}
