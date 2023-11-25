import 'package:chat_ju/model/userpersonmodel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'approutes.dart';
import 'callcontroller.dart';
import 'const.dart';
import 'globalcolor.dart';
import '../service/firebaseservice.dart';

class Methods {
  //for getting formatted time from miliSecondSinceEpochs String
  static String getTimeFormatted(BuildContext context, String time) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(context);
  }

// Message Time
  static String getmessageTime(BuildContext context, String time) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();

    final formattedTime = TimeOfDay.fromDateTime(sent).format(context);
    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return formattedTime;
    }

    return now.year == sent.year
        ? '$formattedTime - ${sent.day} ${_getMonth(sent)}'
        : '$formattedTime - ${sent.day} ${_getMonth(sent)} ${sent.year}';
  }

// Get Month
  static String _getMonth(DateTime date) {
    switch (date.month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return 'NA';
  }

// Display show to showSnachBar
  static void showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 1),
      content: Text(
        msg,
        style:
            TextStyle(color: white, fontWeight: FontWeight.bold, fontSize: 14),
      ),
      backgroundColor: textColor,
    ));
  }

// Display show Progress Bar
  static void showProgressBar(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Center(
          child: CircularProgressIndicator(
        color: blueLight,
        backgroundColor: white,
      )),
    );
  }

// Get Last Active Time
  static String getLastActiveTime(BuildContext context, String lastActive) {
    final int i = int.tryParse(lastActive) ?? -1;

    if (i == -1) return 'Last seen not available';

    DateTime time = DateTime.fromMillisecondsSinceEpoch(i);
    DateTime now = DateTime.now();

    String formattedTime = TimeOfDay.fromDateTime(time).format(context);
    if (time.day == now.day &&
        time.month == now.month &&
        time.year == time.year) {
      return 'Last seen today at $formattedTime';
    }

    if ((now.difference(time).inHours / 24).round() == 1) {
      return 'Last seen yesterday at $formattedTime';
    }

    String month = _getMonth(time);

    return 'Last seen on ${time.day} $month on $formattedTime';
  }

// Flutter Toast
  static flutterToast({required String msg}) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: textColor,
        textColor: white,
        fontSize: 16.0);
  }

//Show Dialog
  static showDialogMethod(
      {required BuildContext context,
      required String title,
      required String message}) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              Flexible(
                child: Text(
                  "$title Error",
                  style: GoogleFonts.poppins(
                      color: textColor,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              const Icon(
                Icons.error_sharp,
                color: Colors.red,
              )
            ],
          ),
          content: Text(
            message,
            style: GoogleFonts.poppins(
                color: textColor, fontWeight: FontWeight.w500, fontSize: 14),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Okay",
                  style: GoogleFonts.poppins(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ))
          ],
        );
      },
    );
  }

// Cala
  static call(
      {required BuildContext context,
      required UserPersonModel user,
      required bool isAudio}) {
    CallController.callId = "1020";
    CallController.userId = FirebaseService.user.uid;
    isAudio ? CallController.audio = true : CallController.audio = false;
    CallController.username = prefs!.getString("name") ?? "Jasim";
    Navigator.of(context).pushNamed(AppRoutes.callViewPage);
    FirebaseService.sendCallNotification(
        isAudio ? "Audio Call" : "Video Call", user);
  }
}
