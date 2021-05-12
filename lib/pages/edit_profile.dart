// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:studypartner/models/user.dart';
// import 'package:studypartner/providers/firebaseMethods.dart';

// class EditProfile extends StatefulWidget {
//   static const routeName = 'edit-profile';
//   @override
//   _EditProfileState createState() => _EditProfileState();
// }

// class _EditProfileState extends State<EditProfile> {
// final displayName = TextEditingController();
// final interests = TextEditingController();

// buildDisplayNameField(
//   String title,
//   String value,
// ) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Padding(
//         padding: EdgeInsets.only(
//           top: 12,
//         ),
//         child: Text(
//           title,
//           style: TextStyle(
//             color: Colors.grey,
//           ),
//         ),
//       ),
//       TextField(
//         controller: title == 'interests' ? interests : displayName,
//         decoration: InputDecoration(hintText: value),
//       ),
//     ],
//   );
// }

//   @override
//   Widget build(BuildContext context) {
//     final profileId = ModalRoute.of(context).settings.arguments as String;
//     final fbdata = Provider.of<FirebaseMethods>(context, listen: false);

//     //print(profileId);
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         title: Text(
//           'Edit Profile',
//           style: TextStyle(
//             color: Colors.black,
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(
//               Icons.done,
//               size: 30,
//               color: Colors.green,
//             ),
//             onPressed: () => Navigator.of(context).pop(),
//           )
//         ],
//       ),
//       body: FutureBuilder(
//         future: fbdata.getUserData(profileId),
//         builder: (context, userSnapshot) {
//           if (userSnapshot.connectionState == ConnectionState.waiting) {
//             return CircularProgressIndicator();
//           }
//           //print(userSnapshot.data.data());
//           final user = AppUser.fromMap(userSnapshot.data.data());
//           displayName.text = user.name;
//           bio.text = user.bio;

//           return ListView(
//             children: [
//               Container(
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(top: 16, bottom: 8),
//                       child: CircleAvatar(
//                         radius: 50,
//                         backgroundImage: CachedNetworkImageProvider(
//                           user.profilePhoto,
//                         ),
//                       ),
//                     ),
// Padding(
//   padding: EdgeInsets.all(16),
//   child: Column(
//     children: [
//       buildDisplayNameField(
//           'Display Name', 'Update Display Name'),
//       buildDisplayNameField('interests', 'Add Interests'),
//     ],
//   ),
//                     ),
//                     Consumer<FirebaseMethods>(
//                       builder: (context, fbMeth, child) {
//                         return fbMeth.updateProfile == false
//                             ? ElevatedButton(
//                                 onPressed: () async {
//                                   await fbMeth.updateData(
//                                     profileId,
//                                     displayName.text,
//                                     bio.text,
//                                   );
//                                 },
//                                 child: Text(
//                                   'Update Profile',
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               )
//                             : CircularProgressIndicator();
//                       },
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(16),
//                       child: TextButton.icon(
//                         onPressed: () async {
//                           await fbdata.signOut();
//                         },
//                         icon: Icon(
//                           Icons.cancel,
//                           color: Colors.red,
//                         ),
//                         label: Text(
//                           'Logout',
//                           style: TextStyle(
//                             color: Colors.red,
//                             fontSize: 20,
//                           ),
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
