import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../button/round.dart';
import '../../controller/signup_controller.dart';

class FirebaseSignup extends StatelessWidget {
  const FirebaseSignup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formSignupKey = GlobalKey<FormState>();
    return GetBuilder<FirebaseSignupController>(
      init: FirebaseSignupController(),
      builder: (controller) {
        return Form(
          key: formSignupKey,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 100),
                      const Text(
                        'Sign Up',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        controller: controller.nameController,
                        validator: (name) {
                          if (name!.isEmpty) {
                            return 'Please Enter Name';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Enter Your Name',
                          hintStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        controller: controller.emailController,
                        validator: (email) {
                          if (email!.isEmpty && !email.contains('@')) {
                            return 'Please Enter Valid Email';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Enter Your Email',
                          hintStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        maxLength: 6,
                        controller: controller.passwordController,
                        validator: (password) {
                          if (password!.isEmpty && password.length < 6) {
                            return 'Please Enter Valid Password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            hintText: 'Enter Your Password',
                            suffixIcon: IconButton(
                              onPressed: () {
                                controller.visible();
                              },
                              icon: Icon(
                                controller.passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                            ),
                            hintStyle: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black)),
                        obscureText: controller.passwordVisible,
                      ),
                      const SizedBox(height: 90),
                      RoundButton(
                        title: 'Sign up',
                        onTap: () {
                          if (formSignupKey.currentState!.validate()) {
                            controller.signUp();
                          }
                        },
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
