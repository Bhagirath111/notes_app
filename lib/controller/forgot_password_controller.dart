import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/login_signup_screen/login.dart';

class ForgotPasswordController extends GetxController{
  TextEditingController emailController = TextEditingController();

  @override
  void dispose(){
    super.dispose();
    emailController.dispose();
  }

  verifyEmail(){
    FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim()).then((value) {
      Get.snackbar('Success', 'Password reset email Sent');
      Get.to(const FirebaseLogin());
      emailController.clear();
    }).onError((error, stackTrace) {
      Get.snackbar('Failed', 'This email is not registered');
    });
  }

}