import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../screens/login_signup_screen/login.dart';

class UserProfileController extends GetxController {
  TextEditingController updateEmailController = TextEditingController();
  TextEditingController updateNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  User? profileUser = FirebaseAuth.instance.currentUser;

  File? image;
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future getImageGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      update();
    } else {
      print('No Image');
    }
  }

  signOut(context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const FirebaseLogin()),
        (Route<dynamic> route) => false);
  }
}
