import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final mobileKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: mobileKey,
      child: Scaffold(
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
                // IntlPhoneField(
                //   controller: phoneNumberController,
                //   flagsButtonPadding: const EdgeInsets.all(6),
                //   dropdownIconPosition: IconPosition.trailing,
                //   decoration:
                //       const InputDecoration(hintText: 'Enter Mobile Number'),
                //   initialCountryCode: 'IN',
                //   validator: (value){
                //     if(value!.number.isEmpty){
                //       return 'Please enter Mobile Number';
                //     }
                //     else if(value.number.length < 10) {
                //       return 'Please enter valid Number';
                //     }
                //     return null;
                //   },
                // ),
                TextFormField(
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration:
                      const InputDecoration(hintText: 'Enter Mobile Number'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Mobile No.';
                    } else if (value.length < 10) {
                      return 'Please Enter Valid Mobile No.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 80),
                RoundButton(
                    title: 'Login',
                    loading: loading,
                    onTap: () async {
                      if (mobileKey.currentState!.validate()) {
                        setState(() {
                          loading = true;
                        });
                        await auth.verifyPhoneNumber(
                            phoneNumber: phoneNumberController.text,
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
                                            phoneNumber:
                                                phoneNumberController.text,
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
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
