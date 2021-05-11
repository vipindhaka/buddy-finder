import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:studypartner/widgets/appDrawer.dart';

header(String title, BuildContext context, {String url}) {
  return AppBar(
    toolbarHeight: kToolbarHeight,
    leading: url != null
        ? Container(
            margin: EdgeInsets.all(8),
            child: GestureDetector(
              child: CircleAvatar(
                //radius: 50,
                backgroundImage: CachedNetworkImageProvider(url),
              ),
              onTap: () => Scaffold.of(context).openDrawer(),
            ),
          )
        : Text(''),
    title: Text(
      title,
      style: TextStyle(fontSize: 30, letterSpacing: 2),
    ),
    centerTitle: true,
    elevation: 10,

    //bottom: TabBar(tabs: [TextField()]),
  );
}
