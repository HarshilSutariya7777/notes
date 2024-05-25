import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/Controller/SplashController.dart';

class SpleshScreenPage extends StatelessWidget {
  const SpleshScreenPage({super.key});

  @override
  Widget build(BuildContext context) {
    SpleshController spleshController = Get.put(SpleshController());
    return Scaffold(
      body: Center(
          child: Image.asset("assets/images/icons8-making-notes-80.png")),
    );
  }
}
