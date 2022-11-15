import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:studypartner/models/profile.dart';
import 'package:studypartner/pages/individualchatPage.dart';
import 'package:studypartner/pages/profilePage.dart';
import 'package:studypartner/providers/firebaseMethods.dart';

class NearbyBuddy extends StatefulWidget {
  final DocumentSnapshot buddy;

  final DocumentSnapshot currentuserdata;
  final String check;
  NearbyBuddy(
    this.buddy,
    this.currentuserdata,
    this.check,
  );

  @override
  _NearbyBuddyState createState() => _NearbyBuddyState();
}

class _NearbyBuddyState extends State<NearbyBuddy> {
  double km;

  @override
  Widget build(BuildContext context) {
    final fbdata = Provider.of<FirebaseMethods>(context, listen: false);
    final currentuseruid = fbdata.getCurrentUser().uid;
    if (widget.check == 'search') {
      final startuser = widget.currentuserdata['position']['geopoint'];
      final endUser = widget.buddy['position']['geopoint'] ?? 0;
      double distanceInMeters = Geolocator.distanceBetween(startuser.latitude,
          startuser.longitude, endUser.latitude, endUser.longitude);
      km = distanceInMeters / 1000;
    }
    if (widget.check == 'chats') {}

    return Container(
      child: ListTile(
        onTap: () {
          widget.check == 'friends'
              ? Navigator.of(context).pushReplacementNamed(
                  IndividualChatScreen.routeName,
                  arguments: widget.buddy)
              : widget.check != 'chats'
                  ? Navigator.of(context).pushNamed(ProfilePage.routeName,
                      arguments: ProfilePerson(
                          widget.buddy, widget.currentuserdata, widget.check))
                  : Navigator.of(context).pushNamed(
                      IndividualChatScreen.routeName,
                      arguments: widget.buddy);
        },
        leading: widget.check == 'search'
            ? CircleAvatar(
                //radius: 50,
                backgroundImage:
                    CachedNetworkImageProvider(widget.buddy['profile_photo']),
              )
            : FutureBuilder(
                future: fbdata.getDownloadUrl(widget.check == 'requests'
                    ? widget.buddy['requestSender']
                    : widget.check != 'chats'
                        ? widget.buddy['friendUid']
                        : widget.buddy.id),
                builder: (ctx, urlSnapshot) {
                  if (urlSnapshot.connectionState == ConnectionState.waiting) {
                    return CircleAvatar();
                  }
                  return CircleAvatar(
                    backgroundImage:
                        CachedNetworkImageProvider(urlSnapshot.data),
                  );
                },
              ),
        title: Text(widget.buddy['name']),
        subtitle: widget.check != 'chats'
            ? Text(widget.buddy['interests'].join(" "),
                overflow: TextOverflow.clip)
            : Text(
                widget.buddy['lastMessage'].toString(),
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: TextStyle(
                    fontWeight: widget.buddy['senderId'] == currentuseruid
                        ? FontWeight.normal
                        : FontWeight.bold),
              ),
        trailing: widget.check == 'search'
            ? Text(km.toStringAsFixed(2).toString() + ' km away')
            : widget.check != 'chats'
                ? Text('')
                : Text(
                    timeago.format(
                      widget.buddy['timestamp'].toDate(),
                    ),
                  ),
      ),
    );
  }
}
