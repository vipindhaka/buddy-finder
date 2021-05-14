import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studypartner/pages/homePage.dart';
import 'package:studypartner/providers/firebaseMethods.dart';

class AddInterests extends StatefulWidget {
  static const routeName = 'add-interests';
  @override
  _AddInterestsState createState() => _AddInterestsState();
}

class _AddInterestsState extends State<AddInterests> {
  TextEditingController _interests = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _interests.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<FirebaseMethods>(context, listen: false);
    return Center(
      child: Container(
        margin: EdgeInsets.all(10),
        height: 180,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Add Interests',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                TextField(
                  controller: _interests,
                  decoration: InputDecoration(
                      hintText: 'Ex. c++ web dev 12th class flutter',
                      labelText: 'Please enter your interests'),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _interests.text.isEmpty
                            ? null
                            : () async {
                                List<String> inte = _interests.text.split(" ");
                                setState(() {
                                  _isLoading = true;
                                });
                                await data.addDataToDb(
                                    data.getCurrentUser(), inte);
                                Navigator.of(context)
                                    .pushReplacementNamed(HomePage.routeName);
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
    );
  }
}
