import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/button/round.dart';
import '../../controller/notes_controller.dart';
import 'userprofile.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotesController>(
      init: NotesController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: const Text('Add Your Notes'),
            leading: IconButton(
              onPressed: () {
                Get.to(() => const UserProfile());
              },
              icon: const Icon(Icons.person),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  TextFormField(
                    controller: controller.textController,
                    decoration: const InputDecoration(
                      hintText: 'Input Text',
                      hintStyle: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 30),
                  RoundButton(
                      title: 'Save',
                      onTap: () {
                        controller.saveNote();
                        FocusManager.instance.primaryFocus!.unfocus();
                      }),
                  const SizedBox(height: 50),
                  SizedBox(
                    height: 500,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('userdata')
                          .doc(controller.user!.uid)
                          .collection('notes')
                          .where('userId', isEqualTo: controller.user?.uid)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView(
                          children: snapshot.data!.docs.map((document) {
                            var docId = document.id;
                            return Center(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: Text(
                                        document['text'],
                                        style: const TextStyle(
                                            overflow: TextOverflow.visible),
                                      )),
                                      IconButton(
                                          onPressed: () {
                                            controller.deleteNote(docId);
                                          },
                                          icon: const Icon(Icons.delete,
                                              color: Colors.red)
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            controller.updateNote(
                                                context,
                                                docId,
                                                document['text'].toString());
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.black,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
