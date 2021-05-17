import 'package:flutter/material.dart';

selectOption(Function chooseImage, BuildContext context) {
  return showDialog(
    context: context,
    builder: (ctx) => SimpleDialog(
      title: Text('Choose option'),
      children: [
        SimpleDialogOption(
          onPressed: () {
            chooseImage(1);
          },
          child: Row(children: [
            Icon(Icons.camera),
            SizedBox(
              width: 10,
            ),
            Text('Open Camera'),
          ]),
        ),
        SimpleDialogOption(
          onPressed: () {
            chooseImage(2);
          },
          child: Row(
            children: [
              Icon(Icons.photo),
              SizedBox(
                width: 10,
              ),
              Text('Choose from gallery'),
            ],
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
        ),
      ],
    ),
  );
}
