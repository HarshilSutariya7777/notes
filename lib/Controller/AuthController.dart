import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:notes/Screen/Auth/AuthPage.dart';
import 'package:notes/Screen/NotesScreen/HomeScreen.dart';

class AuthController extends GetxController {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;

  //login code
  Future<void> login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.to(HomeScreen());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    isLoading.value = false;
  }

  //sign in code
  Future<void> createUser(String email, String password, String name) async {
    isLoading.value = true;
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await initUser(email, name);
      Get.to(HomeScreen());
      print("Account created....");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    isLoading.value = false;
  }

  //log-out
  Future<void> logoutUser() async {
    await auth.signOut();
    Get.to(AuthPage());
  }

  //
  Future<void> initUser(String email, String name) async {
    try {
      await db.collection("users").doc(auth.currentUser!.uid).set({
        "email": email,
        "name": name,
        "id": auth.currentUser!.uid,
      });
    } catch (e) {
      print(e);
    }
  }
}
