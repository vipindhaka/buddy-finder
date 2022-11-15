class AppUser {
  String uid;
  String name;
  String email;
  //String username;
  // String status;
  // int state;
  String profilePhoto;
  List<dynamic> interests;
  DateTime time;
  Map position;
  String token;

  AppUser({
    this.uid,
    this.name,
    this.email,
    //this.username,
    // this.status,
    // this.state,
    this.profilePhoto,
    this.interests,
    this.time,
    this.position,
    this.token,
  });

  Map toMap(AppUser user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['name'] = user.name;
    data['email'] = user.email;
    //data['username'] = user.username;
    // data['status'] = user.status;
    // data['state'] = user.state;
    data['profile_photo'] = user.profilePhoto;
    data['interests'] = user.interests;
    data['timestamp'] = user.time;
    data['position'] = {};
    data['token'] = user.token;
    return data;
  }

  AppUser.fromMap(Map<dynamic, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.name = mapData['name'];
    this.email = mapData['email'];
    //his.username = mapData['username'];
    //this.status = mapData['status'];
    // this.state = mapData['state'];
    this.profilePhoto = mapData['profile_photo'];
    this.interests = mapData['interests'];
    this.time = mapData['timestamp'].toDate();
    this.position = mapData['position'];
    this.token = mapData['token'];
  }
}
