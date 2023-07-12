import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class FirebaseSignupController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool passwordVisible = true;

  @override
  void onInit() {
    super.onInit();
  }

  visible() {
    passwordVisible = !passwordVisible;
    update();
  }

  signUp() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      )
          .then((value) async {
        User? user = FirebaseAuth.instance.currentUser;
        await FirebaseFirestore.instance
            .collection('userdata')
            .doc(user!.uid)
            .set({
          'email': emailController.text,
          'name': nameController.text,
          'profileImage': '',
          'phoneNumber': '',
          'createdDate': DateTime.now(),
          'userId': user.uid,
        });
        Get.back();
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('an account already exists for this email');
        Get.snackbar('Error', 'an account already exists for this email');
      } else if (e.code == 'Weak Password') {
        print('The Password Provided is Too Weak');
        Get.snackbar('Error', 'The Password Provided is Too Weak');
      }
    } catch (e) {
      print(e);
    }
    nameController.clear();
    emailController.clear();
    passwordController.clear();
  }
}
