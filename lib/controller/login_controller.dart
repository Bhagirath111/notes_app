import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../screens/Notes_screen/notes.dart';

class FirebaseLoginController extends GetxController {
  final auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool passwordVisible = true;

  @override
  void onInit() {
    super.onInit();
  }

  visible(){
    passwordVisible = !passwordVisible;
    update();
  }

  login() async {
    try {
      await auth.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        ).then((value) {
        Get.to(const NotesScreen());
      });
    } on FirebaseAuthException catch (e) {
      if(e.code == 'user-not-found'){
        Get.snackbar('Error', 'No user found for that email');
      }
      else if(e.code == 'wrong-password'){
        Get.snackbar('Error', 'Password incorrect. Please try again');
      }
      print(e);
    }
    catch(error) {
      print(error);
    }
    emailController.clear();
    passwordController.clear();
  }
}
