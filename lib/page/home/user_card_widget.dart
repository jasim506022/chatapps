import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_ju/const/const.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../const/approutes.dart';
import '../../service/firebaseservice.dart';
import '../../const/globalcolor.dart';
import '../../model/userpersonmodel.dart';
import '../../model/messagemodel.dart';

import 'user_card_dialog_widget.dart';

class UserCardWidget extends StatefulWidget {
  const UserCardWidget({super.key, required this.usermodel});
  final UserPersonModel usermodel;

  @override
  State<UserCardWidget> createState() => _UserCardWidgetState();
}

class _UserCardWidgetState extends State<UserCardWidget> {
  Message? message;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.chatPage,
              arguments: widget.usermodel);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Card(
            color: white,
            elevation: .5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: StreamBuilder(
              stream: FirebaseService.lastmesssage(widget.usermodel),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list =
                    data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
                if (list.isNotEmpty) {
                  message = list[0];
                }
                return _buildListTile();
              },
            ),
          ),
        ));
  }

  Padding _buildListTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        title: Text(
          widget.usermodel.name!,
          style: GoogleFonts.poppins(
              color: blueLight, fontWeight: FontWeight.w700, fontSize: 16),
        ),
        subtitle: Text(
            message != null
                ? message!.type == Type.image
                    ? "Image"
                    : message!.msg
                : widget.usermodel.about!,
            maxLines: 1,
            style: message != null
                ? message!.read.isNotEmpty
                    ? GoogleFonts.poppins(
                        color: textColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 13)
                    : GoogleFonts.poppins(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)
                : GoogleFonts.poppins(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 12)),
        leading: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => UserCardDialogWidget(
                user: widget.usermodel,
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              mq.height * .038,
            ),
            child: CachedNetworkImage(
              height: mq.height * .076,
              width: mq.height * .076,
              fit: BoxFit.fill,
              imageUrl: widget.usermodel.image!,
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
        trailing: widget.usermodel.isOnline! == true
            ? Container(
                height: mq.height * .018,
                width: mq.height * .018,
                decoration: BoxDecoration(color: green, shape: BoxShape.circle),
              )
            : Container(
                height: mq.height * .018,
                width: mq.height * .018,
                decoration: BoxDecoration(color: white, shape: BoxShape.circle),
              ),
      ),
    );
  }
}
