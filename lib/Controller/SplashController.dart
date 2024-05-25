import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:notes/Screen/Auth/AuthPage.dart';
import 'package:notes/Screen/NotesScreen/HomeScreen.dart';

class SpleshController extends GetxController {
  final auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    SplaceHandle();
  }

  void SplaceHandle() async {
    await Future.delayed(
      const Duration(seconds: 3),
    );
    if (auth.currentUser == null) {
      Get.to(AuthPage());
    } else {
      Get.to(HomeScreen());
      print(auth.currentUser!.email);
    }
  }
}
