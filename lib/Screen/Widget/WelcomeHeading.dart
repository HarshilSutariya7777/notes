import 'package:flutter/material.dart';

class WelcomeHeading extends StatelessWidget {
  const WelcomeHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/icons8-making-notes-80.png"),
          ],
        ),
        SizedBox(height: 20),
        Text(
          "Notes",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ],
    );
  }
}
