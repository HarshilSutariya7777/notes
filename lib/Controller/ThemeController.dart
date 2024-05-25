import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final GetStorage box = GetStorage();
  final String _key = 'isDarkMode';

  var isDarkMode = false.obs;

  //
  ThemeController() {
    isDarkMode.value = loadThemeFromBox();
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  bool loadThemeFromBox() => box.read(_key) ?? false;
  ThemeMode get theme => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    box.write(_key, isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
