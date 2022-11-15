import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:studypartner/models/customException.dart';
import 'package:studypartner/pages/homePage.dart';
import 'package:studypartner/providers/firebaseMethods.dart';
import 'package:studypartner/widgets/chooseimageDrawer.dart';
import 'package:studypartner/widgets/exceptiondisplay.dart';

class AddInterests extends StatefulWidget {
  static const routeName = 'add-interests';
  @override
  _AddInterestsState createState() => _AddInterestsState();
}

class _AddInterestsState extends State<AddInterests> {
  TextEditingController _interests = TextEditingController();
  bool _isLoading = false;
  File _pickedImageFile;

  void chooseImage(int no) async {
    Navigator.of(context).pop();
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.getImage(
          source: no == 1 ? ImageSource.camera : ImageSource.gallery,
          maxHeight: 600,
          maxWidth: 400,
          imageQuality: 80);
      setState(() {
        _pickedImageFile = File(pickedImage.path);
      });
    } catch (e) {
      showErrorException(context, CustomException('Failed to select image'));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _interests.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<FirebaseMethods>(context, listen: false);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Set up your profile',
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/books.jpg'),
          ),
        ),
        child: Center(
          child: Card(
            elevation: 20,
            //margin: EdgeInsets.all(10),
            child: Container(
              padding: EdgeInsets.all(10),
              height: 320,
              width: size.width * .8,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundImage: _pickedImageFile != null
                          ? FileImage(_pickedImageFile)
                          : null,
                      child: _pickedImageFile == null
                          ? Icon(
                              Icons.person,
                              size: 40,
                            )
                          : Container(),
                      radius: 40,
                    ),
                    TextButton(
                        onPressed: () {
                          selectOption(chooseImage, context);
                        },
                        child: Text('Add Image')),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Add Interests')),
                    TextField(
                      maxLength: 30,
                      controller: _interests,
                      decoration: InputDecoration(
                          hintStyle: TextStyle(),
                          hintText: 'Ex. c++ webdev dance poetry 12th flutter',
                          labelText: 'Enter space separated interests'),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _interests.text.length < 3 ||
                                    _pickedImageFile == null
                                ? null
                                : () async {
                                    List<String> inte = _interests.text
                                        .toLowerCase()
                                        .split(" ");
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    try {
                                      String token = await FirebaseMessaging
                                          .instance
                                          .getToken();
                                      await data.addDataToDb(
                                          data.getCurrentUser(),
                                          inte,
                                          _pickedImageFile,
                                          token);
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              HomePage.routeName);
                                    } catch (e) {
                                      showErrorException(context,
                                          CustomException('Please try again'));
                                    }
                                  },
                            child: Text('Submit'),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
