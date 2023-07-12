import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../button/round.dart';
import '../Notes_screen/notes.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const VerifyCodeScreen(
      {Key? key, required this.verificationId, required this.phoneNumber})
      : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false;

  final verificationCodeController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 100),
              const Text(
                'Verify With OTP',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
              const SizedBox(height: 100),
              TextFormField(
                maxLength: 6,
                controller: verificationCodeController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(hintText: 'Enter 6 digit code'),
              ),
              const SizedBox(height: 80),
              RoundButton(
                  title: 'Verify',
                  loading: loading,
                  onTap: () async {
                    setState(() {
                      loading = true;
                    });
                    final credential = PhoneAuthProvider.credential(
                        verificationId: widget.verificationId,
                        smsCode: verificationCodeController.text.toString());
                    try {
                      await auth.signInWithCredential(credential);
                      User? user = FirebaseAuth.instance.currentUser;
                      await FirebaseFirestore.instance
                          .collection('userdata')
                          .doc(user!.uid)
                          .set({
                        'email': '',
                        'name': '',
                        'phoneNumber': widget.phoneNumber,
                        'profileImage': '',
                        'createdDate': DateTime.now(),
                        'userId': user.uid
                      });
                      Get.to(() => const NotesScreen());
                    } catch (e) {
                      setState(() {
                        loading = false;
                      });
                      Get.snackbar("error", "something wrong");
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
