import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../screens/Notes_screen/notes.dart';

class FirebaseLoginController extends GetxController {
  final auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool passwordVisible = true;
  bool loading = false;

  @override
  void onInit() {
    super.onInit();
  }

  visible() {
    passwordVisible = !passwordVisible;
    update();
  }

  googleLogin() async {
    print('google login method called');
    GoogleSignIn googleSignIn = GoogleSignIn();
    try{
      var result = await googleSignIn.signIn();
      if(result == null) {
        return;
      }
      final userData = await result.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: userData.accessToken,
        idToken: userData.idToken,
      );
      var finalResult = await FirebaseAuth.instance.signInWithCredential(credential).then((value) async {
        User? user = FirebaseAuth.instance.currentUser;
        await FirebaseFirestore.instance
            .collection('userdata')
            .doc(user!.uid)
            .set({
          'createdDate': DateTime.now(),
          'email': user.email,
          'name': user.displayName,
          'phoneNumber': '',
          'profileImage': user.photoURL,
          'userId': user.uid
            });
        Get.to(const NotesScreen());
      });
      print("Result ${result}");
      print(result.displayName);
      print(result.email);
      print(result.photoUrl);
      print(finalResult);
    }
    catch(error){
      print(error);
    }
  }

  emailSignIn() async {
    try {
      await auth
          .signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      )
          .then((value) {
        Get.to(const NotesScreen());
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar('Error', 'No user found for that email');
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Error', 'Password incorrect. Please try again');
      }
      print(e);
    } catch (error) {
      print(error);
    }
    emailController.clear();
    passwordController.clear();
  }


}
