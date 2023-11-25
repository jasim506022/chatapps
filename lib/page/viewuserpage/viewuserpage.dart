import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../const/approutes.dart';
import '../../const/const.dart';
import '../../const/globalcolor.dart';
import '../../const/method.dart';

class ViewUserPage extends StatefulWidget {
  const ViewUserPage({
    super.key,
  });

  @override
  State<ViewUserPage> createState() => _ViewUserPageState();
}

class _ViewUserPageState extends State<ViewUserPage> {
  @override
  Widget build(BuildContext context) {
    final dynamic user = ModalRoute.of(context)!.settings.arguments;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "JU Chat",
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: mq.width, height: mq.height * 0.03),
                ClipRRect(
                  borderRadius: BorderRadius.circular(mq.height * 0.1),
                  child: CachedNetworkImage(
                    height: mq.height * 0.2,
                    width: mq.height * 0.2,
                    fit: BoxFit.cover,
                    imageUrl: user.image!,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                SizedBox(height: mq.height * 0.015),
                Text(
                  user.name!,
                  style: GoogleFonts.poppins(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      fontSize: 18),
                ),
                SizedBox(height: mq.height * 0.015),
                user.isOnline!
                    ? Text(
                        Methods.getLastActiveTime(context, user.lastActive!),
                        style: GoogleFonts.poppins(
                            color: textColor.withOpacity(.5),
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      )
                    : Container(),
                SizedBox(height: mq.height * 0.033),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildIconTitle("Message", Icons.message, () {
                      Navigator.pushNamed(context, AppRoutes.chatPage,
                          arguments: user);
                    }),
                    _buildIconTitle("Call", Icons.call, () {
                      Methods.call(context: context, user: user, isAudio: true);
                    }),
                    _buildIconTitle("Video Call", Icons.video_call, () {
                      Methods.call(
                          context: context, user: user, isAudio: false);
                    }),
                  ],
                ),
                SizedBox(
                  height: mq.height * 0.059,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      _buildSingleDetails(user.email, Icons.email),
                      SizedBox(height: mq.height * 0.02),
                      _buildSingleDetails("Media", Icons.video_collection),
                    ],
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Text(
                  "Crate At: ${Methods.getLastActiveTime(context, user.createdAt!)}",
                  style: GoogleFonts.poppins(
                      color: textColor,
                      fontWeight: FontWeight.w500,
                      fontSize: 16),
                ),
                SizedBox(height: mq.height * 0.024),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Row _buildSingleDetails(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 25,
          color: textColor.withOpacity(.7),
        ),
        SizedBox(
          width: mq.width * 0.055,
        ),
        Text(
          title,
          style: GoogleFonts.poppins(
              color: textColor, fontWeight: FontWeight.w500, fontSize: 14),
        ),
      ],
    );
  }

  _buildIconTitle(String title, IconData icon, Function function) {
    return InkWell(
      onTap: () {
        function();
      },
      child: Column(
        children: [
          Icon(
            icon,
            size: 35,
            color: blueLight,
          ),
          Text(
            title,
            style: GoogleFonts.poppins(
                color: blueLight, fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
