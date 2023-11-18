import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_ju/const/approutes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../const/callcontroller.dart';
import '../../const/globalcolor.dart';
import '../../const/const.dart';
import '../../model/userpersonmodel.dart';
import '../../service/firebaseservice.dart';

class UserCardDialogWidget extends StatelessWidget {
  const UserCardDialogWidget({
    super.key,
    required this.user,
  });

  final UserPersonModel user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: white.withOpacity(.9),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: SizedBox(
        width: mq.width * .6,
        height: mq.height * .33,
        child: Column(
          children: [
            SizedBox(
              width: mq.width * .6,
              height: mq.height * .28,
              child: Stack(
                children: [
                  Positioned(
                    left: 15,
                    top: 15,
                    child: Text(
                      user.name!,
                      style: GoogleFonts.poppins(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Align(
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(mq.height * .1),
                        child: CachedNetworkImage(
                          width: mq.height * .2,
                          height: mq.height * .2,
                          fit: BoxFit.contain,
                          imageUrl: user.image!,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, AppRoutes.chatPage,
                            arguments: user);
                      },
                      icon: Icon(
                        Icons.message,
                        size: 20,
                        color: blueLight,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        CallController.callId = "1020";
                        CallController.userId = FirebaseService.user.uid;
                        CallController.audio = true;
                        CallController.username =
                            prefs!.getString("name") ?? "Jasim";
                        Navigator.of(context).pushNamed(AppRoutes.callViewPage);
                        FirebaseService.sendCallNotification(
                            "Audio Call", user);
                      },
                      icon: Icon(
                        Icons.call,
                        size: 20,
                        color: blueLight,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        CallController.callId = "1020";
                        CallController.userId = FirebaseService.user.uid;
                        CallController.username =
                            prefs!.getString("name") ?? "Jasim";
                        CallController.audio = false;
                        Navigator.of(context).pushNamed(AppRoutes.callViewPage);
                        FirebaseService.sendCallNotification(
                          "Video Call",
                          user,
                        );
                      },
                      icon: Icon(
                        Icons.video_call,
                        size: 20,
                        color: blueLight,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, AppRoutes.viewUserPage,
                            arguments: user);
                      },
                      icon: Icon(
                        Icons.info_rounded,
                        size: 20,
                        color: blueLight,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
