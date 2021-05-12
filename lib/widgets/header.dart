import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:studypartner/widgets/appDrawer.dart';

header(int page, BuildContext context, DocumentSnapshot user,
    GlobalKey<ScaffoldState> scaffoldkey) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    //automaticallyImplyLeading: false,
    //toolbarHeight: kToolbarHeight,
    title: Text(
      page == 0
          ? 'Collab Dev'
          : page == 1
              ? 'Search buddy'
              : 'Activity',
      style: TextStyle(color: Theme.of(context).primaryColor),
    ),
    centerTitle: true,
    leading: InkWell(
      onTap: () => scaffoldkey.currentState.openDrawer(),
      child: Container(
        margin: EdgeInsets.only(left: 10),
        child: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(user['profile_photo']),
        ),
      ),
    ),
  );
}
