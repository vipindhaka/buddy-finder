import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:studypartner/models/profile.dart';
import 'package:studypartner/pages/profilePage.dart';
import 'package:studypartner/providers/firebaseMethods.dart';

class NearbyBuddy extends StatefulWidget {
  final List<DocumentSnapshot> buddies;
  final int index;
  final DocumentSnapshot currentuserdata;
  final String check;
  NearbyBuddy(this.buddies, this.index, this.currentuserdata, this.check);

  @override
  _NearbyBuddyState createState() => _NearbyBuddyState();
}

class _NearbyBuddyState extends State<NearbyBuddy> {
  //String _isLoading = 'add';
  double km;
  @override
  Widget build(BuildContext context) {
    //final fbdata = Provider.of<FirebaseMethods>(context, listen: false);
    if (widget.check == 'search') {
      final startuser = widget.currentuserdata['position']['geopoint'];
      final endUser = widget.buddies[widget.index]['position']['geopoint'] ?? 0;
      double distanceInMeters = Geolocator.distanceBetween(startuser.latitude,
          startuser.longitude, endUser.latitude, endUser.longitude);
      km = distanceInMeters / 1000;
    }

    return Container(
      child: ListTile(
          onTap: () {
            Navigator.of(context).pushNamed(ProfilePage.routeName,
                arguments: ProfilePerson(
                  widget.buddies[widget.index],
                  widget.currentuserdata,
                  widget.check,
                ));
          },
          leading: CircleAvatar(
            //radius: 50,
            backgroundImage: CachedNetworkImageProvider(
                widget.buddies[widget.index]['profile_photo']),
          ),
          title: Text(widget.buddies[widget.index]['name']),
          subtitle: Text(widget.buddies[widget.index]['interests']
              .toString()), //Text(km.toStringAsFixed(2).toString() + ' km away'),
          trailing: widget.check == 'search'
              ? Text(km.toStringAsFixed(2).toString() + ' km away')
              : Text('')),
    );
  }
}
