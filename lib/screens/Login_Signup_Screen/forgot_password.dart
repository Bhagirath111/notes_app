import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/button/round.dart';
import '../../controller/forgot_password_controller.dart';


class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final passwordKey = GlobalKey<FormState>();
    return GetBuilder<ForgotPasswordController>(
      init: ForgotPasswordController(),
      builder: (controller) {
        return Form(
          key: passwordKey,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 90),
                      const Text(
                        'Forgot Password',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                            color: Colors.black
                        ),
                      ),
                      const SizedBox(height: 50),
                      const Text(
                        'Receive an email to reset your Password',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54
                        ),
                      ),
                      const SizedBox(height: 50),
                      TextFormField(
                        controller: controller.emailController,
                        validator: (email) {
                          if(email!.isEmpty && !email.contains('@')){
                            return 'Please Enter Valid Email';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            hintText: 'Enter Your Email',
                            hintStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black
                            )
                        ),
                      ),
                      const SizedBox(height: 50),
                      RoundButton(
                           title: 'Send',
                          onTap: () {
                            if(passwordKey.currentState!.validate()){
                              controller.verifyEmail();
                            }
                           }
                           )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
