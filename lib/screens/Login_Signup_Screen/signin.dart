import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/button/round.dart';
import '../../controller/signin_controller.dart';
import '../mobile_number_screens/mobile_no.dart';
import 'forgot_password.dart';
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
                        'Sign In',
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
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        maxLength: 6,
                        controller: controller.passwordController,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty || value.length < 6) {
                            return 'Please Enter Valid Password';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.password),
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
                      const SizedBox(height: 40),
                      RoundButton(
                        // color: Colors.black12,
                        title: 'Sign in',
                        loading: controller.loading,
                        onTap: () {
                          controller.loading = true;
                          if (formLoginKey.currentState!.validate()) {
                            controller.emailSignIn();
                            controller.loading = false;
                          } else {
                            Get.snackbar(
                                'Error',
                                'Please Enter Valid Email and Password'
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      const Row(
                        children: [
                          Expanded(
                              child: Divider(
                                color: Colors.black,
                              )
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Text('OR'),
                          ),
                          Expanded(
                              child: Divider(
                                color: Colors.black,
                              )
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
                              color: Colors.lightBlue
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Do\'nt Have Account?',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.black
                            ),
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
                          Get.to(const LoginWithPhoneNumber());
                        },
                        child: Container(
                          height: 50,
                          width: Get.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black12
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(Icons.call),
                              ),
                              Text(
                                'Login Using Mobile No...',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      InkWell(
                        onTap: () {
                          controller.googleLogin();
                        },
                        child: Container(
                          height: 50,
                          width: Get.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black12
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset('assets/google.png'),
                              ),
                              const Text(
                                  'Sign In With Google',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

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
