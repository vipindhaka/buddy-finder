import 'package:cloud_firestore/cloud_firestore.dart';

class CollabPost {
  String userId;
  String description;
  String interestRequirement;
  String userName;
  Timestamp time;

  CollabPost(
    this.userId,
    this.description,
    this.interestRequirement,
    this.userName,
    this.time,
  );

  Map toMap(CollabPost collabPost) {
    var data = Map<String, dynamic>();
    data['userId'] = collabPost.userId;
    data['description'] = collabPost.description;
    data['interestRequirement'] = collabPost.interestRequirement;
    data['userName'] = collabPost.userName;
    data['timestamp'] = collabPost.time;
    return data;
  }

  CollabPost.fromMap(Map<String, dynamic> post) {
    this.userId = post['userId'];
    this.description = post['description'];
    this.interestRequirement = post['interestRequirement'];
    this.userName = post['userName'];
    this.time = post['timestamp'];
  }
}
