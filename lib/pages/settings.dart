import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:studypartner/models/customException.dart';
import 'package:studypartner/providers/firebaseMethods.dart';
import 'package:studypartner/providers/locationMethods.dart';
import 'package:studypartner/widgets/chooseimageDrawer.dart';
import 'package:studypartner/widgets/exceptiondisplay.dart';
import '../widgets/interstitialAd.dart';

import 'package:studypartner/widgets/radiusSelector.dart';

class UserSettings extends StatefulWidget {
  static const routeName = '/settings';
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  final displayName = TextEditingController();
  final interests = TextEditingController();
  bool firstTime = true;
  File _pickedImageFile;

  double radius;
  void getRadius(double radVal) {
    radius = radVal;
  }

  void setControllers() {
    final DocumentSnapshot userData = ModalRoute.of(context).settings.arguments;
    displayName.text = userData['name'];
    List<dynamic> interestData = userData['interests'];
    interests.text = interestData.join(" ");
  }

  buildDisplayNameField(
    String title,
    String value,
    String initialValue,
    TextEditingController controller,
  ) {
    final size = MediaQuery.of(context).size;
    //controller.text = initialValue;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      //mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 12,
          ),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.grey,
            ),
            //textAlign: TextAlign.left,
          ),
        ),
        SizedBox(
          width: size.width * .95,
          child: TextFormField(
            maxLength: title == 'Interests' ? 30 : 12,
            //initialValue: initialValue,
            controller: controller,
            decoration: InputDecoration(
              hintText: value,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    if (firstTime) {
      setControllers();
      firstTime = false;
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    interstialAd();
  }

  void chooseImage(int no) async {
    Navigator.of(context).pop();
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
        source: no == 1 ? ImageSource.camera : ImageSource.gallery,
        maxHeight: 600,
        maxWidth: 400,
        imageQuality: 80);
    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });
  }

  updateprofile(DocumentSnapshot userData, double prefradius) async {
    final fbMethods = Provider.of<FirebaseMethods>(context, listen: false);
    final locmethods = Provider.of<LocationMethods>(context, listen: false);
    if (userData['interests'].join(" ") == interests.text.trim() &&
        userData['name'] == displayName.text.trim() &&
        _pickedImageFile == null &&
        radius == prefradius) {
      print('dont apply changes');
      showErrorException(context, CustomException('Nothing to update'));
    } else if (displayName.text.trim().length < 4 ||
        interests.text.length < 4) {
      showErrorException(
          context, CustomException('Name or interests too small'));
    } else {
      print('apply changes');
      await fbMethods.updateUserData(
          userData,
          prefradius,
          radius,
          interests.text,
          displayName.text,
          _pickedImageFile,
          locmethods,
          context);
      // Navigator.of(context).pop();
      // setState(() {});
    }
  }

  bool isupdating = false;

  @override
  Widget build(BuildContext context) {
    // print('build again');

    final size = MediaQuery.of(context).size;
    final DocumentSnapshot userData = ModalRoute.of(context).settings.arguments;
    final radMethods = Provider.of<LocationMethods>(context, listen: false);
    double prefRadius = radMethods.getRadius();

    return WillPopScope(
      onWillPop: () {
        if (isupdating == true) {
          showErrorException(
              context, CustomException('Please wait for the upload'));
          return;
        } else {
          Navigator.of(context).pop();
          return;
        }
      },
      child: Scaffold(
          appBar: AppBar(
            //leading: ,
            title: Text('Settings'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Container(
              height: size.height - kToolbarHeight,
              child: Stack(
                children: [
                  Container(
                    //alignment: Alignment.center,
                    height: size.height * .25,
                    decoration: BoxDecoration(
                      // border: Bo,
                      //shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/books.jpg')),
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.elliptical(200, 50),
                        bottomRight: Radius.elliptical(200, 50),
                      ),
                    ),
                  ),
                  Positioned(
                    top: size.height * .18,
                    left: size.width * .35,
                    child: GestureDetector(
                      onTap: () {
                        selectOption(chooseImage, context);
                      },
                      child: CircleAvatar(
                        radius: size.width * .15,
                        backgroundImage: _pickedImageFile == null
                            ? CachedNetworkImageProvider(
                                userData['profile_photo'])
                            : FileImage(_pickedImageFile),
                      ),
                    ),
                  ),
                  Positioned(
                    top: size.height * .28,
                    left: size.width * .56,
                    child: Icon(
                      Icons.camera_alt,
                      size: 35,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                  Positioned(
                    top: size.height * .35,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          buildDisplayNameField(
                              'Display Name',
                              'Update Display Name',
                              userData['name'],
                              displayName),
                          buildDisplayNameField('Interests', 'Add Interests',
                              userData['interests'].toString(), interests),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: size.height * .72,
                    left: size.width * .34,
                    child: Consumer<FirebaseMethods>(
                      builder: (context, fbMethods, child) =>
                          fbMethods.updatingProfile
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(),
                                    Text('   Updating..')
                                  ],
                                )
                              : TextButton.icon(
                                  onPressed: () {
                                    try {
                                      isupdating = true;
                                      updateprofile(userData, prefRadius);
                                    } catch (e) {}
                                  },
                                  icon: Icon(Icons.upload_sharp),
                                  label: Text('Update Profile')),
                    ),
                  ),
                  Positioned(
                    top: size.height * .61,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RadiusSelector(
                        radMethods.getRadius(),
                        getRadius,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
