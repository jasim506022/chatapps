import 'dart:io';

import 'package:chat_ju/const/approutes.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../const/globalcolor.dart';
import '../../const/const.dart';
import '../../helper/dialog.dart';
import '../../service/loadingprovider.dart';
import '../../widget/textformwidget.dart';
import '../../service/firebaseservice.dart';

class SignPage extends StatefulWidget {
  const SignPage({Key? key}) : super(key: key);

  @override
  State<SignPage> createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _keyForm = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: blueLight, statusBarIconBrightness: Brightness.light));
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
            child: Stack(
          children: [
            Container(
              height: mq.height,
              width: mq.width,
              color: blueLight,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18, top: 15),
              child: Text(
                "Log In",
                style: GoogleFonts.poppins(
                    color: white, fontWeight: FontWeight.bold, fontSize: 28),
              ),
            ),
            Positioned(
              top: mq.height * 0.08,
              child: Container(
                height: mq.height * 0.9,
                width: mq.width,
                decoration: BoxDecoration(
                    color: whiteshade,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView(
                    children: [
                      Container(
                        height: mq.height * .35,
                        width: mq.width * 0.8,
                        margin: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.09,
                            top: 30),
                        child: Image.asset("asset/image/loginpage.png"),
                      ),
                      SizedBox(
                        height: mq.height * .02,
                      ),
                      Form(
                        key: _keyForm,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTextFormField(
                                controller: _emailController,
                                hintText: 'Email',
                                label: "Email",
                                validate: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  } else if (!isValidEmail(value)) {
                                    return 'Please enter a valid email address';
                                  }
                                  return null;
                                }),
                            SizedBox(
                              height: mq.height * .015,
                            ),
                            _buildTextFormField(
                                controller: _passwordController,
                                validate: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your Password';
                                  }
                                  return null;
                                },
                                hintText: 'Password',
                                label: "Password"),
                          ],
                        ),
                      ),
                      SizedBox(height: mq.height * .01),
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 24),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.forgetpasswordpage);
                            },
                            child: Text("Forgot Password?",
                                style: GoogleFonts.poppins(
                                    color: blueLight,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14)),
                          ),
                        ),
                      ),
                      Consumer<LoadingProvider>(
                        builder: (context, loadingProivder, child) {
                          return _singinButton(loadingProivder);
                        },
                      ),
                      SizedBox(height: mq.height * .02),
                      Row(
                        children: [
                          Expanded(
                              child: Divider(
                            color: grey,
                            indent: 2,
                          )),
                          SizedBox(
                            width: mq.width * .02,
                          ),
                          Text("Or",
                              style: GoogleFonts.poppins(
                                  color: textColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14)),
                          SizedBox(
                            width: mq.width * .02,
                          ),
                          Expanded(
                              child: Divider(
                            color: grey,
                            indent: 2,
                          ))
                        ],
                      ),
                      SizedBox(height: mq.height * .02),
                      _buildGoogleSignInButton(),
                      SizedBox(height: mq.height * .03),
                      _buildRichText(),
                      SizedBox(
                        height: mq.height * .3,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }

  RichText _buildRichText() {
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
            text: "Don't already Have an account? ",
            style: GoogleFonts.poppins(color: textColor, fontSize: 14),
          ),
          TextSpan(
              text: "Sign Up",
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushNamed(context, AppRoutes.signUpPage);
                },
              style: GoogleFonts.poppins(
                  color: blueLight, fontWeight: FontWeight.bold, fontSize: 14))
        ]));
  }

  InkWell _buildGoogleSignInButton() {
    return InkWell(
      onTap: () {
        Dialogs.showProgressBar(context);
        FirebaseService.signInWithGoogle(context: context).then((user) async {
          Navigator.pop(context);
          if (user != null) {
            if (await FirebaseService.userExists()) {
              Navigator.pushReplacementNamed(context, AppRoutes.homePage);
            } else {
              await FirebaseService.createUserbyGmail().then((value) {
                Navigator.pushReplacementNamed(context, AppRoutes.homePage);
              });
            }
          }
        });
      },
      child: Container(
        height: mq.height * .07,
        width: mq.width,
        decoration: BoxDecoration(
            color: blueLight, borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            Container(
                height: mq.height * .07,
                width: mq.height * .1,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15))),
                child: Image.asset("asset/image/google.png")),
            SizedBox(
              width: mq.width * 0.04,
            ),
            Text("Sign up with Google",
                style: GoogleFonts.poppins(
                    color: white, fontWeight: FontWeight.w700, fontSize: 18))
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField(
      {required String label,
      required TextEditingController controller,
      required String hintText,
      required String? Function(String?) validate}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        SizedBox(height: mq.height * .01),
        TextFormFieldWidget(
            emailController: controller,
            hintText: hintText,
            validate: validate),
      ],
    );
  }

  Widget _singinButton(LoadingProvider loadingProvider) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: blueLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      ),
      onPressed: () async {
        if (_keyForm.currentState!.validate()) {
          try {
            final result = await InternetAddress.lookup('google.com');
            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
              loadingProvider.setLoadingValue(loadingValue: true);
              await FirebaseService.singEmailandPasswordSnapshot(
                email: _emailController.text,
                password: _passwordController.text,
              ).then((value) {
                loadingProvider.setLoadingValue(loadingValue: false);
              });

              if (mounted) {
                Dialogs.showSnackBar(
                  context,
                  "Login Successfully",
                );
                Navigator.pushReplacementNamed(context, AppRoutes.homePage);
              }
            } else {
              Dialogs.flutterToast(msg: "No Internet Connection");
            }
          } on SocketException {
            if (mounted) {
              Dialogs.showDialogMethod(
                context: context,
                message:
                    "No Internect Connection. Please your Interenet Connection",
                title: 'No Internet Connection',
              );
            }
          } on FirebaseAuthException catch (e) {
            if (e.code == 'user-not-found') {
              if (mounted) {
                Dialogs.showDialogMethod(
                  context: context,
                  message:
                      "This User Not found. Please Check Your Email And Password",
                  title: 'User Not Found',
                );
              }

              loadingProvider.setLoadingValue(loadingValue: false);
            } else if (e.code == 'wrong-password') {
              if (mounted) {
                Dialogs.showDialogMethod(
                  context: context,
                  message: "Password Incorrect. Please Check your Password",
                  title: 'Incorrect password.',
                );
              }
              loadingProvider.setLoadingValue(loadingValue: false);
            } else {
              if (mounted) {
                Dialogs.showDialogMethod(
                  context: context,
                  message: "Error Occurred",
                  title: 'Error Occurred',
                );
              }
              loadingProvider.setLoadingValue(loadingValue: false);
            }
          } catch (e) {
            if (mounted) {
              Dialogs.showDialogMethod(
                context: context,
                message: e.toString(),
                title: 'Error Occurred',
              );
            }
            loadingProvider.setLoadingValue(loadingValue: false);
          }
        }
      },
      child: loadingProvider.isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: white,
              ),
            )
          : Text(
              "Sign In",
              style: GoogleFonts.poppins(
                color: white,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
    );
  }

  bool isValidEmail(String email) {
    String emailRegex = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)*[a-zA-Z]{2,7}$';
    RegExp regex = RegExp(emailRegex);
    return regex.hasMatch(email);
  }
}
