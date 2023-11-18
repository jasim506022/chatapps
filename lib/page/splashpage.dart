import 'package:chat_ju/const/approutes.dart';
import 'package:flutter/material.dart';

import '../service/firebaseservice.dart';
import '../const/const.dart';
import '../const/globalcolor.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), () {
      bool isUserLoggedIn = FirebaseService.auth.currentUser != null;
      String routeName =
          isUserLoggedIn ? AppRoutes.homePage : AppRoutes.signpage;
      Navigator.pushReplacementNamed(context, routeName);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                "asset/image/chatting.png",
                height: mq.shortestSide * 0.2, // Adjust the image height
                width: mq.shortestSide * 0.2, // Adjust the image width
              ),
            ),
            Text(
              "Chat Apps",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2),
            )
          ]),
    );
  }
}
