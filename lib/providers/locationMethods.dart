import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studypartner/providers/firebaseMethods.dart';

class LocationMethods with ChangeNotifier {
  final geo = Geoflutterfire();
  FirebaseMethods fbMethods = FirebaseMethods();
  SharedPreferences _sharedPreferences;
  LocationMethods(this._sharedPreferences);

  Future<Stream<List<DocumentSnapshot>>> getNearbyBuddy() async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final user = fbMethods.getCurrentUser();

    final position = await getCurrentLocation();
    GeoFirePoint myLocation = geo.point(
      latitude: position.latitude,
      longitude: position.longitude,
    );
    var collection = FirebaseFirestore.instance.collection('users');
    GeoFirePoint center =
        geo.point(latitude: position.latitude, longitude: position.longitude);
    await fbMethods.addlocation(user, myLocation);
    Stream<List<DocumentSnapshot>> stream =
        geo.collection(collectionRef: collection).within(
              center: center,
              radius: _sharedPreferences.getDouble('radius'),
              field: 'position',
            );

    return stream;
  }

  Future<Position> getCurrentLocation() async {
    final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    return position;
  }

  Future<void> setRadius(double radius) async {
    await _sharedPreferences.setDouble('radius', radius);
  }

  double getRadius() {
    return _sharedPreferences.getDouble('radius');
  }
}
