import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:studypartner/providers/firebaseMethods.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final data = Provider.of<FirebaseMethods>(context);
    return Container(
        alignment: Alignment.center,
        //height: size.height * 45,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor,
                Colors.white,
              ]),
        ),
        child: Stack(
          children: [
            Positioned(
              top: size.height * .7,
              left: size.width * .34,
              child: Row(
                children: [
                  Divider(),
                  Text('Sign in using',
                      style: TextStyle(fontSize: 22, color: Colors.blueAccent)),
                ],
              ),
            ),
            Positioned(
                //height: 100,
                top: size.height * .8,
                left: _isLoading == false ? size.width * .26 : size.width * .45,
                // bottom: 25,
                child: _isLoading == false
                    ? GestureDetector(
                        onTap: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          try {
                            await data.signIn(context);
                          } catch (e) {
                            print('an error occured');
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                        child: Container(
                          height: 40,
                          width: size.width * .8,
                          //margin: EdgeInsets.all(10),
                          //padding: EdgeInsets.all(20),
                          //width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              alignment: Alignment.center,
                              fit: BoxFit.cover,
                              image: AssetImage('assets/images/signin.png'),
                            ),
                          ),
                          //child: Text('welcome'),
                        ),
                      )
                    : Center(child: CircularProgressIndicator())),
            Positioned(
              //height: 100,
              top: size.height * .1,
              left: size.width * .1,
              // bottom: 25,
              child: Container(
                height: 200,
                width: size.width * .8,
                //margin: EdgeInsets.all(10),
                //width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/company.png'),
                    ),
                    // color: Colors.grey,
                    borderRadius: BorderRadius.circular(10)),
                //child: Text('welcome'),
              ),
            )
          ],
        ));
  }
}
