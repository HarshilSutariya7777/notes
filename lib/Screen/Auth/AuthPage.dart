import 'package:flutter/material.dart';
import 'package:notes/Screen/Auth/AuthpageBody.dart';
import 'package:notes/Screen/Widget/WelcomeHeading.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(children: [
              WelcomeHeading(),
              SizedBox(height: 40),
              AuthPageBody(),
            ]),
          ),
        ),
      ),
    );
  }
}
