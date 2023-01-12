import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return Scaffold(
    appBar : AppBar(
      title: Image.asset(
        "assets/images/logo.png",
        height: 40,
      ),
      elevation: 0.0,
      centerTitle: false,
    ),
  );
}

InputDecoration textFieldInputDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.black54),
    border: InputBorder.none,
    focusColor: CupertinoColors.link,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
    ),

  );
}

TextStyle simpleTextStyle() {
  return const TextStyle(color: Colors.black54, fontSize: 16);
}

TextStyle biggerTextStyle() {
  return const TextStyle(color: Colors.white, fontSize: 17);
}