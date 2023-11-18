import 'package:chat_ju/const/approutes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../const/const.dart';
import '../../service/firebaseservice.dart';
import '../../const/globalcolor.dart';
import '../../helper/dialog.dart';
import '../../service/loadingprovider.dart';
import '../../widget/textformwidget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordRetypeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: blueLight, statusBarIconBrightness: Brightness.light));
    mq = MediaQuery.of(context).size;
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
                "Sign Up",
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
                        height: mq.height * .15,
                        width: mq.width * 0.8,
                        margin: EdgeInsets.only(
                            left: mq.width * 0.09, top: mq.height * .035),
                        child: Image.asset(
                          "asset/image/chatting.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      Text(
                        "Welcome to JU Chat Apps",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            color: textColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                      SizedBox(height: mq.height * .025),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTextFormField(
                              label: '"Name"',
                              controller: _nameController,
                              hintText: 'name',
                              validate: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: mq.height * .015,
                            ),
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
                                    return 'Please enter your email';
                                  }
                                  return null;
                                },
                                hintText: 'Password',
                                label: "Password"),
                            SizedBox(
                              height: mq.height * .015,
                            ),
                            _buildTextFormField(
                                controller: _passwordRetypeController,
                                validate: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your Retype Password';
                                  }
                                  return null;
                                },
                                hintText: 'Retype Password',
                                label: "Retype Password"),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: mq.height * .02,
                      ),
                      Consumer<LoadingProvider>(
                        builder: (context, loadingProivder, child) {
                          return _buildSignUp(loadingProivder, context);
                        },
                      ),
                      SizedBox(
                        height: mq.height * .023,
                      ),
                      _buildRichText(context),
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

  RichText _buildRichText(BuildContext context) {
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
            text: "Already have an account? ",
            style: GoogleFonts.poppins(color: textColor, fontSize: 14),
          ),
          TextSpan(
              text: "Sign in",
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pop(context);
                },
              style: GoogleFonts.poppins(
                  color: blueLight, fontWeight: FontWeight.bold, fontSize: 14))
        ]));
  }

  ElevatedButton _buildSignUp(
      LoadingProvider loadingProivder, BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: blueLight,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15)),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            if (_passwordController.text.trim() ==
                _passwordRetypeController.text.trim()) {
              loadingProivder.setLoadingValue(loadingValue: true);
              try {
                await FirebaseService.createUserWithEmailandPassword(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim())
                    .then((user) async {
                  await FirebaseService.createUserByEmailPassword(
                      name: _nameController.text.trim(), user: user);
                }).then((value) {
                  loadingProivder.setLoadingValue(loadingValue: false);
                });
                if (mounted) {
                  Dialogs.showSnackBar(context, "Sign up  Succesffuly");
                  Navigator.pushReplacementNamed(context, AppRoutes.signpage);
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == 'email-already-in-use') {
                  if (mounted) {
                    Dialogs.showDialogMethod(
                        context: context,
                        message:
                            "Email Already In User. Please Use Another Email",
                        title: 'Email Already in Use');
                  }
                  loadingProivder.setLoadingValue(loadingValue: false);
                } else if (e.code == 'invalid-email') {
                  if (mounted) {
                    Dialogs.showDialogMethod(
                        context: context,
                        message:
                            "Invalid Email address. Please put Valid Email Address",
                        title: 'Invalid Email Address');
                  }
                  loadingProivder.setLoadingValue(loadingValue: false);
                } else if (e.code == 'weak-password') {
                  if (mounted) {
                    Dialogs.showDialogMethod(
                        context: context,
                        message: "Invalid Password. Please Put Valied Password",
                        title: 'Password Invalied');
                  }
                  loadingProivder.setLoadingValue(loadingValue: false);
                } else if (e.code == 'too-many-requests') {
                  if (mounted) {
                    Dialogs.showDialogMethod(
                        context: context,
                        message: "To many requests",
                        title: 'To Many Request');
                  }
                  loadingProivder.setLoadingValue(loadingValue: false);
                } else if (e.code == 'operation-not-allowed') {
                  if (mounted) {
                    Dialogs.showDialogMethod(
                        context: context,
                        message: "Operation Not Allowed",
                        title: 'Operator Not Allowed');
                  }
                  loadingProivder.setLoadingValue(loadingValue: false);
                } else if (e.code == 'user-disabled') {
                  if (mounted) {
                    Dialogs.showDialogMethod(
                        context: context,
                        message: "User Disable",
                        title: 'User Disable');
                  }
                  loadingProivder.setLoadingValue(loadingValue: false);
                } else if (e.code == 'user-not-found') {
                  if (mounted) {
                    Dialogs.showDialogMethod(
                        context: context,
                        message: "User Not Found",
                        title: 'User ot Found');
                  }
                  loadingProivder.setLoadingValue(loadingValue: false);
                } else {
                  if (mounted) {
                    Dialogs.showDialogMethod(
                        context: context,
                        message: "Error Occured",
                        title: 'Please chack your internet or Othes');
                  }

                  loadingProivder.setLoadingValue(loadingValue: false);
                }
              } catch (e) {
                if (mounted) {
                  Dialogs.showDialogMethod(
                      context: context,
                      message: e.toString(),
                      title: 'Error Occured');
                }
                loadingProivder.setLoadingValue(loadingValue: false);
              }
            } else {
              Dialogs.flutterToast(
                  msg: "Password and Retype Password Doesn't Same");
              loadingProivder.setLoadingValue(loadingValue: false);
            }
          }
        },
        child: loadingProivder.isLoading
            ? CircularProgressIndicator(
                backgroundColor: white,
              )
            : Text("Sign Up",
                style: GoogleFonts.poppins(
                    color: white, fontWeight: FontWeight.w700, fontSize: 14)));
  }

  bool isValidEmail(String email) {
    // Regular expression for a more comprehensive email validation
    String emailRegex = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)*[a-zA-Z]{2,7}$';
    RegExp regex = RegExp(emailRegex);
    return regex.hasMatch(email);
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
}
