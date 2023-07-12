import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/button/round.dart';
import '../../controller/userprofile_controller.dart';
import 'notes.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserProfileController>(
      init: UserProfileController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            title: const Text('User Profile'),
          ),
          body: SingleChildScrollView(
            child: SizedBox(
              height: 700,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('userdata')
                    .where('userId', isEqualTo: controller.profileUser?.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView(
                    children: snapshot.data!.docs.map((document) {
                      //var docId = document.id;
                      var profileImage = document['profileImage'];
                      var docEmail = document['email'];
                      var docName = document['name'];
                      var docPhone = document['phoneNumber'];
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              const SizedBox(height: 30),
                              InkWell(
                                  onTap: () {
                                    controller.getImageGallery();
                                  },
                                  child: CircleAvatar(
                                      backgroundImage:
                                          (controller.image == null)
                                              ? NetworkImage(profileImage)
                                              : FileImage(controller.image!)
                                                  as ImageProvider,
                                      radius: 50,
                                      child: Visibility(
                                        visible: controller.image == null &&
                                            profileImage == '',
                                        child: const Icon(Icons.add_a_photo),
                                      ))),
                              const SizedBox(height: 50),
                              TextFormField(
                                controller: controller.updateNameController
                                  ..text = docName,
                                decoration: const InputDecoration(
                                    hintText: 'Enter Your name',
                                    hintStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black)),
                                validator: (name) {
                                  if (name!.isEmpty) {
                                    return 'Please Enter Valid Name';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: controller.updateEmailController
                                  ..text = docEmail,
                                validator: (email) {
                                  if (email!.isEmpty && !email.contains('@')) {
                                    return 'Please Enter Valid Email';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    hintText: 'Enter Your Email',
                                    hintStyle: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black)),
                              ),
                              const SizedBox(height: 15),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  docPhone,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 50),
                              RoundButton(
                                  title: 'Update',
                                  onTap: () async {
                                    if (controller.image != null) {
                                      firebase_storage.Reference ref =
                                          firebase_storage
                                              .FirebaseStorage.instance
                                              .ref(
                                                  '/ProfileImage/${DateTime.now().millisecondsSinceEpoch}');
                                      firebase_storage.UploadTask uploadTask =
                                          ref.putFile(
                                              controller.image!.absolute);

                                      await Future.value(uploadTask)
                                          .then((value) async {
                                        var newUrl = await ref.getDownloadURL();
                                        FirebaseFirestore.instance
                                            .collection('userdata')
                                            .doc(controller.profileUser!.uid)
                                            .set({
                                          "profileImage":
                                              newUrl.toString() != null
                                                  ? newUrl.toString()
                                                  : profileImage,
                                          'email': controller
                                                  .updateEmailController
                                                  .text
                                                  .isEmpty
                                              ? docEmail
                                              : controller
                                                  .updateEmailController.text,
                                          'name': controller
                                                  .updateNameController
                                                  .text
                                                  .isEmpty
                                              ? docName
                                              : controller
                                                  .updateNameController.text,
                                        }, SetOptions(merge: true));
                                      });
                                    } else {
                                      FirebaseFirestore.instance
                                          .collection('userdata')
                                          .doc(controller.profileUser!.uid)
                                          .set({
                                        'email': controller
                                                .updateEmailController
                                                .text
                                                .isEmpty
                                            ? docEmail
                                            : controller
                                                .updateEmailController.text,
                                        'name': controller.updateNameController
                                                .text.isEmpty
                                            ? docName
                                            : controller
                                                .updateNameController.text,
                                      }, SetOptions(merge: true));
                                    }
                                    Get.to(const NotesScreen());
                                  }),
                              const SizedBox(height: 45),
                              RoundButton(
                                  title: 'Sign out',
                                  onTap: () {
                                    controller.signOut(context);
                                  }),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
