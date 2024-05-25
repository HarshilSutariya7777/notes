import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget myText({
  required String string,
  Color? fontColor,
  double? fontSize,
  FontWeight? fontWeight,
  FontStyle? fontStyle,
  double? wordSpacing,
  TextAlign? textAlign,
  double? letterSpacing,
  Color? bgcolor,
  TextDecoration? textDecoration,
  String? fontFamily,
}) {
  return Text(
    string,
    style: TextStyle(
        color: fontColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        wordSpacing: wordSpacing,
        letterSpacing: letterSpacing,
        backgroundColor: bgcolor,
        decoration: textDecoration,
        fontFamily: fontFamily),
    textAlign: textAlign,
  );
}
