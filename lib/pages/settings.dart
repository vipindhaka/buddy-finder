import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studypartner/providers/locationMethods.dart';
import 'package:studypartner/widgets/header.dart';
import 'package:studypartner/widgets/radiusSelector.dart';

class UserSettings extends StatefulWidget {
  static const routeName = '/settings';
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  final displayName = TextEditingController();
  final interests = TextEditingController();
  bool firstTime = true;

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
            maxLength: title == 'Interests' ? 30 : 20,
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
    // TODO: implement didChangeDependencies
    if (firstTime) {
      setControllers();
      firstTime = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('build again');
    final size = MediaQuery.of(context).size;
    final DocumentSnapshot userData = ModalRoute.of(context).settings.arguments;
    final radMethods = Provider.of<LocationMethods>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
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
                  child: CircleAvatar(
                    radius: size.width * .15,
                    backgroundImage:
                        CachedNetworkImageProvider(userData['profile_photo']),
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
                  child: TextButton.icon(
                      onPressed: (userData['name'] == displayName.text &&
                              userData['interests'].join(" ") == interests.text)
                          ? null
                          : () {},
                      icon: Icon(Icons.upload_sharp),
                      label: Text('Update Profile')),
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
        )

        // Positioned(
        //   top: size.height * .35,
        //   left: size.width * .45,
        //   child: CircleAvatar(
        //     child: Text('here'),
        //     backgroundImage:
        //         CachedNetworkImageProvider(userData['profile_photo']),
        //   ),
        // ),
        );
  }
}
