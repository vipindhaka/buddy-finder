import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studypartner/models/customException.dart';
import 'package:studypartner/pages/individualchatPage.dart';
import 'package:studypartner/providers/firebaseMethods.dart';
import 'package:studypartner/widgets/exceptiondisplay.dart';

class RequestChecker extends StatefulWidget {
  final DocumentSnapshot buddyuserData;
  final DocumentSnapshot currentuserData;
  final String checkdata;
  final BuildContext context;
  RequestChecker(
      this.buddyuserData, this.currentuserData, this.checkdata, this.context);
  @override
  _RequestCheckerState createState() => _RequestCheckerState();
}

class _RequestCheckerState extends State<RequestChecker> {
  Future<String> checkUser(
      String buddyuid, String currentUseruid, BuildContext context) async {
    final data = Provider.of<FirebaseMethods>(context, listen: false);
    final check = await data.checkWhetherAlreadyFriendOrRequestSent(
        buddyuid, currentUseruid);
    return check;
  }

  @override
  Widget build(BuildContext context) {
    final fbMethods = Provider.of<FirebaseMethods>(context, listen: false);
    return FutureBuilder(
      future: checkUser(
          widget.buddyuserData[
              widget.checkdata == 'requests' ? 'requestSender' : 'uid'],
          widget.currentuserData['uid'],
          context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        String check = snapshot.data;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton.icon(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
                icon: Icon(
                  check == 'Send Request'
                      ? Icons.person_add
                      : check == 'Request Sent'
                          ? Icons.person
                          : Icons.check,
                  color: Colors.white,
                ),
                label: Text(
                  check,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
                onPressed: check == 'Send Request'
                    ? () async {
                        try {
                          await fbMethods.sendFriendRequest(
                              widget.currentuserData, widget.buddyuserData);
                          setState(() {});
                        } catch (e) {
                          showErrorException(context,
                              CustomException('Failed to send Request'));
                        }
                      }
                    : check == 'Request Sent'
                        ? () async {
                            //setState(() {});
                            try {
                              await fbMethods.deleteRequest(
                                  widget.buddyuserData,
                                  widget.currentuserData,
                                  widget.checkdata);
                              setState(() {});
                            } catch (e) {
                              showErrorException(context,
                                  CustomException('Failed to delete request'));
                            }
                          }
                        : check == 'Confirm Request'
                            ? () async {
                                try {
                                  await fbMethods.confirmRequest(
                                      widget.buddyuserData,
                                      widget.currentuserData,
                                      widget.checkdata);
                                  setState(() {});
                                } catch (e) {
                                  showErrorException(
                                      context,
                                      CustomException(
                                          'Failed to confirm request'));
                                }
                              }
                            : null),
            if (check == 'Friends' && widget.checkdata != 'requests')
              TextButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(
                        IndividualChatScreen.routeName,
                        arguments: widget.buddyuserData);
                  },
                  icon: Icon(Icons.message, color: Colors.white),
                  label: Text(
                    'Message',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.white),
                  ))
          ],
        );
      },
    );
  }
}
