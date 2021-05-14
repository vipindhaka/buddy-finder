import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studypartner/models/customException.dart';
import 'package:studypartner/providers/firebaseMethods.dart';
import 'package:studypartner/widgets/exceptiondisplay.dart';

class LocationMethods with ChangeNotifier {
  final geo = Geoflutterfire();
  FirebaseMethods fbMethods = FirebaseMethods();
  SharedPreferences _sharedPreferences;
  LocationMethods(this._sharedPreferences);

  Future<Stream<List<DocumentSnapshot>>> getNearbyBuddy(
      BuildContext context) async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final user = fbMethods.getCurrentUser();

      final position = await getCurrentLocation(context);
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
    } on PlatformException catch (e) {
      print('not searching p');
      throw e;
      //showErrorException(context, CustomException(e.code));
    } catch (e) {
      print('not searching');
      throw e;
      //showErrorException(context, CustomException(e.code));
    }
  }

  Future<Position> getCurrentLocation(BuildContext context) async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      return position;
    } catch (e) {
      print('here');
      bool status = await Permission.location.isPermanentlyDenied ||
          await Permission.location.isDenied;
      if (status) {
        showErrorException(context,
            CustomException('Please provide location access for this feature'));
      }
      throw e;
    }
  }

  Future<void> setRadius(double radius) async {
    await _sharedPreferences.setDouble('radius', radius);
  }

  double getRadius() {
    return _sharedPreferences.getDouble('radius');
  }
}
