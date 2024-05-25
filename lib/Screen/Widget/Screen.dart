import 'package:flutter/cupertino.dart';

class Screen {
  static var deviceHeight, deviceWidth;
  static setScreen(context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
  }
}
