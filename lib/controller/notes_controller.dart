import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/button/round.dart';
import 'package:notes_app/screens/Notes_screen/notification_services.dart';

class NotesController extends GetxController {
  NotificationServices notificationServices = NotificationServices();

  TextEditingController textController = TextEditingController();
  TextEditingController updateTextController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void onInit() {
    super.onInit();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit();
    notificationServices.setupInteractMessage();
    //notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      print('Device token');
      print(value);
    });
  }

  saveNote() {
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('userdata')
          .doc(user!.uid)
          .collection('notes')
          .add({'userId': user!.uid, 'text': textController.text.toString()});
      textController.clear();
    } else {
      Get.snackbar('Error', 'Please Enter Text');
    }
  }

  deleteNote(String id) {
    FirebaseFirestore.instance
        .collection('userdata')
        .doc(user!.uid)
        .collection('notes')
        .doc(id)
        .delete();
    Get.snackbar('Success', 'Delete Item Successfully');
  }

  updateNote(BuildContext context, String id, String text) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextFormField(
                    controller: updateTextController..text = text,
                  ),
                  const SizedBox(height: 30),
                  RoundButton(
                    title: 'Update',
                    onTap: () {
                      FirebaseFirestore.instance
                          .collection('userdata')
                          .doc(user!.uid)
                          .collection('notes')
                          .doc(id)
                          .update({'text': updateTextController.text});
                      Get.back();
                      updateTextController.clear();
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
