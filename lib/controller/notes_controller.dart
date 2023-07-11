import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotesController extends GetxController {
  TextEditingController textController = TextEditingController();
  TextEditingController updateTextController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void onInit() {
    super.onInit();
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
                  FloatingActionButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('userdata')
                          .doc(user!.uid)
                          .collection('notes')
                          .doc(id)
                          .update({'text': updateTextController.text});
                      Get.back();
                      updateTextController.clear();
                    },
                    child: const Text('Update'),
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
