import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../button/round.dart';
import 'verification_screen.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({Key? key}) : super(key: key);

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool loading = false;

  final phoneNumberController = TextEditingController();
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
                'Login With Mobile No...',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
              const SizedBox(height: 100),
              IntlPhoneField(
                controller: phoneNumberController,
                flagsButtonPadding: const EdgeInsets.all(6),
                dropdownIconPosition: IconPosition.trailing,
                decoration:
                    const InputDecoration(hintText: 'Enter Mobile Number'),
                initialCountryCode: 'IN',
              ),
              const SizedBox(height: 80),
              RoundButton(
                  title: 'Login',
                  loading: loading,
                  onTap: () {
                    setState(() {
                      loading = true;
                    });
                    auth.verifyPhoneNumber(
                        phoneNumber: "+91${phoneNumberController.text}",
                        verificationCompleted: (_) {
                          setState(() {
                            loading = false;
                          });
                        },
                        verificationFailed: (e) {
                          setState(() {
                            loading = false;
                          });
                          Get.snackbar("error 1", "something wrong");
                        },
                        codeSent: (String verificationId, int? token) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VerifyCodeScreen(
                                        verificationId: verificationId,
                                        phoneNumber: phoneNumberController.text,
                                      )));
                          setState(() {
                            loading = false;
                          });
                        },
                        codeAutoRetrievalTimeout: (e) {
                          Get.snackbar("Success", "Check Your Inbox!");
                          setState(() {
                            loading = false;
                          });
                        });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
