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
import '../../const/method.dart';
import '../../service/provider/loadingprovider.dart';
import '../../widget/textformwidget.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final _emailController = TextEditingController();

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
              padding: EdgeInsets.only(
                  left: mq.width * 0.04, top: mq.height * 0.018),
              child: Text(
                "Forget Password",
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
                  padding:  EdgeInsets.symmetric(horizontal: mq.width * 0.036,),
                  child: ListView(
                    children: [
                      Container(
                        height: mq.height * .35,
                        width: mq.width * 0.8,
                        margin: EdgeInsets.only(
                            left: mq.width * 0.09,
                            top: mq.height * 0.035),
                        child: Image.asset("asset/image/loginpage.png"),
                      ),
                      SizedBox(
                        height: mq.height * .02,
                      ),
                      Column(
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
                        ],
                      ),
                      SizedBox(height: mq.height * .02),
                      Consumer<LoadingProvider>(
                        builder: (context, loadingProivder, child) {
                          return _buildResectPassword(loadingProivder);
                        },
                      ),
                      SizedBox(height: mq.height * .02),
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
            text: "Are you want to Login?",
            style: GoogleFonts.poppins(color: textColor, fontSize: 14),
          ),
          TextSpan(
              text: "Sign In",
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushNamed(context, AppRoutes.signpage);
                },
              style: GoogleFonts.poppins(
                  color: blueLight, fontWeight: FontWeight.bold, fontSize: 14))
        ]));
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
            obscureText: false,
            emailController: controller,
            hintText: hintText,
            validate: validate),
      ],
    );
  }

  Widget _buildResectPassword(LoadingProvider loadingProvider) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: blueLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        padding:  EdgeInsets.symmetric(horizontal: mq.width * 0.022, vertical: mq.height * 0.018),
      ),
      onPressed: () async {
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            await FirebaseAuth.instance.sendPasswordResetEmail(
              email: _emailController.text.trim(),
            );
            Navigator.pushReplacementNamed(context, AppRoutes.signpage);
            Methods.flutterToast(
                msg: "Password reset. Please Check Your Email");
          }
        } on SocketException {
          if (mounted) {
            Methods.showDialogMethod(
              context: context,
              message:
                  "No Internect Connection. Please your Interenet Connection",
              title: 'No Internet Connection',
            );
          }
        } catch (e) {
          if (mounted) {
            Methods.showDialogMethod(
              context: context,
              message: e.toString(),
              title: 'Error Occurred',
            );
          }
          loadingProvider.setLoadingValue(loadingValue: false);
        }
      },
      child: loadingProvider.isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: white,
              ),
            )
          : Text(
              "Resect Password",
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
