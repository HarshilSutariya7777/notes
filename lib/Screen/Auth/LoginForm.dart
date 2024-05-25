import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/Controller/AuthController.dart';
import 'package:notes/Screen/Widget/AppColor.dart';
import 'package:notes/Screen/Widget/Mytext.dart';
import 'package:notes/Screen/Widget/PrimaryButoon.dart';
import 'package:notes/Screen/Widget/validation.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool iscliked = true;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String errorUserName = '', errorPassword = '', errorUserNotFound = '';

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        TextField(
          controller: email,
          decoration: InputDecoration(
            hintText: "Email",
            prefixIcon: Icon(
              Icons.email_outlined,
            ),
          ),
          onChanged: (str) {
            setState(() {
              errorUserNotFound = '';
              errorUserName = validEmail(email.text);
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
                      btnName: "LOGIN",
                      icon: Icons.lock_open_outlined,
                      ontap: () async {
                        errorUserName = validEmail(email.text);
                        errorPassword = validPassword(password.text);
                        if (errorUserName == '' && password == '') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: Duration(seconds: 3),
                              content: Row(
                                children: [
                                  CircularProgressIndicator(
                                    backgroundColor: Colors.pink[300],
                                  ),
                                  SizedBox(width: 10),
                                  Text('Signing-In...')
                                ],
                              ),
                            ),
                          );
                        }
                        await authController.login(email.text, password.text);
                      },
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
