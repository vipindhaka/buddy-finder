import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studypartner/pages/addInterests.dart';
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
                Theme.of(context).accentColor
              ]),
        ),
        child: Stack(
          children: [
            Positioned(
                //height: 100,
                top: size.height * .8,
                left: _isLoading == false ? 10 : size.width * .5,
                // bottom: 25,
                child: _isLoading == false
                    ? GestureDetector(
                        onTap: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          await data.signIn();

                          _isLoading = false;
                        },
                        child: Container(
                          height: 100,
                          width: size.width * .9,
                          margin: EdgeInsets.all(10),
                          //width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(
                                  'assets/images/google_signin_button.png'),
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
