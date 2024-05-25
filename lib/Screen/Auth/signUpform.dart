import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/Controller/AuthController.dart';
import 'package:notes/Screen/Widget/AppColor.dart';
import 'package:notes/Screen/Widget/Mytext.dart';
import 'package:notes/Screen/Widget/PrimaryButoon.dart';
import 'package:notes/Screen/Widget/validation.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String errorUserName = '',
      errorEmail = '',
      errorPassword = '',
      errorUserNotFound = '';
  bool iscliked = true;
  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        TextField(
          controller: name,
          decoration: InputDecoration(
              hintText: "Full Name",
              prefixIcon: Icon(
                Icons.person_2_outlined,
              )),
          onChanged: (str) {
            setState(() {
              errorUserNotFound = '';
              errorUserName = validName(name.text);
            });
          },
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: myText(
            string: errorUserName,
            fontColor: errorColor,
          ),
        ),
        TextField(
          controller: email,
          decoration: const InputDecoration(
              hintText: "Email",
              prefixIcon: Icon(
                Icons.email_outlined,
              )),
          onChanged: (str) {
            setState(() {
              errorUserNotFound = '';
              errorEmail = validEmail(email.text);
            });
          },
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: myText(
            string: errorEmail,
            fontColor: errorColor,
          ),
        ),
        TextField(
          obscureText: iscliked,
          controller: password,
          onChanged: (str) {
            setState(() {
              errorUserNotFound = '';
              errorPassword = validPassword(password.text);
            });
          },
          decoration: InputDecoration(
            hintText: "Password",
            prefixIcon: Icon(
              Icons.lock_outline,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                iscliked ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  iscliked = !iscliked;
                });
              },
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child: myText(
            string: errorPassword,
            fontColor: errorColor,
          ),
        ),
        const SizedBox(height: 60),
        Obx(
          () => authController.isLoading.value
              ? const CircularProgressIndicator()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrimaryButton(
                        btnName: "SIGNUP",
                        icon: Icons.lock_open_outlined,
                        ontap: () {
                          authController.createUser(
                              email.text, password.text, name.text);
                        }),
                  ],
                ),
        ),
      ],
    );
  }
}
