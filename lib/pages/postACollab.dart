import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studypartner/models/collabPost.dart';
import 'package:studypartner/models/customException.dart';
import 'package:studypartner/providers/firebaseMethods.dart';
import 'package:studypartner/widgets/exceptiondisplay.dart';

class PostACollab extends StatefulWidget {
  static const routeName = '/upload-post';

  @override
  _PostACollabState createState() => _PostACollabState();
}

class _PostACollabState extends State<PostACollab> {
  //bool upload = false;
  TextEditingController description;
  DocumentSnapshot user;
  List<dynamic> interests;
  bool isInnit = true;
  String dropValue;

  @override
  void initState() {
    description = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInnit) {
      user = ModalRoute.of(context).settings.arguments as DocumentSnapshot;
      interests = user['interests'];
      dropValue = interests[0];
      isInnit = false;
    }

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    description.dispose();
    super.dispose();
  }

  Future<void> postCollab(CollabPost post) async {
    final fbMethods = Provider.of<FirebaseMethods>(context, listen: false);
    await fbMethods.postCollab(post);
    postPressed = false;
    Navigator.of(context).pop();
  }

  bool postPressed = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (postPressed == true) {
          showErrorException(
              context, CustomException('Please wait for upload!'));
          return;
        } else {
          Navigator.of(context).pop();
          return;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Upload Post'),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                  style: ButtonStyle(
                    backgroundColor: postPressed
                        ? MaterialStateProperty.all(Colors.white)
                        : MaterialStateProperty.all(
                            Theme.of(context).primaryColor),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  onPressed: postPressed
                      ? null
                      : () async {
                          if (description.text.trim().length < 10) {
                            showErrorException(
                                context,
                                CustomException(
                                    'Please provide a description'));
                          } else {
                            try {
                              setState(() {
                                postPressed = true;
                              });
                              final post = CollabPost(
                                  user['uid'],
                                  description.text.trim(),
                                  dropValue,
                                  user['name'],
                                  Timestamp.now());

                              await postCollab(post);
                            } catch (e) {
                              showErrorException(
                                  context, CustomException('Failed to post'));
                            }
                          }
                        },
                  child: Text(
                    'Post',
                    style: TextStyle(
                        fontSize: 20,
                        // backgroundColor: Colors.blueGrey,
                        color: postPressed ? Colors.grey : Colors.white),
                  )),
            ),
          ],
        ),
        body: ListView(
          children: [
            postPressed
                ? LinearProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation(Theme.of(context).primaryColor))
                : Container(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage:
                        CachedNetworkImageProvider(user['profile_photo']),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      controller: description,
                      maxLines: 2,
                      maxLength: 240,
                      decoration: InputDecoration(
                        hintText: 'Describe Collab Request',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Select Required Interest'),
                DropdownButton(
                    value: dropValue,
                    //underline: Container(),
                    elevation: 16,
                    onChanged: (value) {
                      setState(() {
                        dropValue = value;
                      });
                    },
                    items: interests
                        .map<DropdownMenuItem<String>>(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e.toString(),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        )
                        .toList()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
