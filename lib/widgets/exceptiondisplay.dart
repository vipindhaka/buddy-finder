import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studypartner/models/customException.dart';

showErrorException(BuildContext context, CustomException exception) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(milliseconds: 400),
      content: Text(exception.message),
    ),
  );
}
