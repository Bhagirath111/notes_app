import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/button/round.dart';
import '../../controller/login_controller.dart';
import 'forgot_password.dart';
import '../mobile_number_screens/mobile_no.dart';
import 'signup.dart';

class FirebaseLogin extends StatelessWidget {
  const FirebaseLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formLoginKey = GlobalKey<FormState>();
    return GetBuilder<FirebaseLoginController>(
      init: FirebaseLoginController(),
      builder: (controller) {
        return Form(
          key: formLoginKey,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      const Text(
                        'Log In',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 40),
                      TextFormField(
                        controller: controller.emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Please Enter Valid Email';
                          } else {
                            return null;
                          }
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
                        validator: (value) {
                          if (value!.isEmpty || value.length < 6) {
                            return 'Please Enter Valid Password';
                          } else {
                            return null;
                          }
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
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          Get.to(const LoginWithPhoneNumber());
                        },
                        child: const Text(
                          'Login Using Mobile No...',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.lightBlue
                        ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Do Not Have Account?',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(const FirebaseSignup());
                            },
                            child: const Text(
                              'Sign Up...',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          Get.to(const ForgotPasswordScreen());
                        },
                        child: const Text(
                          'Forgot Password',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.lightBlue),
                        ),
                      ),
                      const SizedBox(height: 40),
                      RoundButton(
                          title: 'Log in',
                          onTap: () {
                            if (formLoginKey.currentState!.validate()) {
                              controller.login();
                            } else {
                              Get.snackbar('Error', 'Please Enter Valid Email and Password');
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
