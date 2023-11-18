import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../service/firebaseservice.dart';
import '../../const/const.dart';
import '../../const/globalcolor.dart';
import '../../helper/dialog.dart';
import '../../model/messagemodel.dart';
import '../../model/userpersonmodel.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({
    super.key,
    required this.message,
    required this.userPersonModel,
  });

  final Message message;
  final UserPersonModel userPersonModel;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return FirebaseService.user.uid == widget.message.fromId
        ? _greenWidget()
        : _blueWidget();
  }

  Widget _blueWidget() {
    if (widget.message.read.isEmpty) {
      FirebaseService.updateMessgeReadStuts(widget.message);
    }
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: mq.width * .02, vertical: mq.height * .01),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.userPersonModel.image!),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: widget.message.type == Type.text
                      ? Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: mq.width * .02),
                          padding: EdgeInsets.all(mq.width * .04),
                          decoration: BoxDecoration(
                              color: messageother,
                              border: Border.all(color: bgLight, width: 1),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(30),
                                  bottomRight: Radius.circular(30))),
                          child: Text(
                            widget.message.msg,
                            style: GoogleFonts.poppins(
                                color: white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                fontSize: 14),
                          ))
                      : Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: mq.width * .04,
                              vertical: mq.height * .01),
                          padding: EdgeInsets.all(mq.width * .005),
                          decoration: BoxDecoration(
                              color: messageother,
                              border: Border.all(color: textColor, width: 1),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(30),
                                  bottomLeft: Radius.circular(30))),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(30),
                                bottomLeft: Radius.circular(30)),
                            child: CachedNetworkImage(
                              imageUrl: widget.message.msg,
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: mq.width * .04),
                  child: Text(
                    Dialogs.getTimeFormatted(context, widget.message.sent),
                    style: GoogleFonts.poppins(
                        color: textColor.withOpacity(.8),
                        letterSpacing: 1.2,
                        fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// current User
  Widget _greenWidget() {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (widget.message.read.isNotEmpty)
                Icon(
                  Icons.done_all_rounded,
                  color: blueLight,
                  size: 20,
                ),
              Text(
                Dialogs.getmessageTime(context, widget.message.sent),
                style:
                    TextStyle(fontSize: 13, color: textColor.withOpacity(.7)),
              ),
            ],
          ),
          Flexible(
            child: Column(
              children: [
                widget.message.type == Type.text
                    ? Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: mq.width * .04,
                            vertical: mq.height * .01),
                        padding: EdgeInsets.all(mq.width * .04),
                        decoration: BoxDecoration(
                            color: messageOwn,
                            border: Border.all(color: textColor, width: 1),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(30))),
                        child: Text(
                          widget.message.msg,
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              fontSize: 14),
                        ))
                    : Container(
                        height: mq.height * .35,
                        margin: EdgeInsets.symmetric(
                            horizontal: mq.width * .04,
                            vertical: mq.height * .01),
                        padding: EdgeInsets.all(mq.width * .005),
                        decoration: BoxDecoration(
                            color: messageOwn,
                            border: Border.all(color: textColor, width: 1),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(15),
                                bottomLeft: Radius.circular(30))),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.circular(30)),
                          child: CachedNetworkImage(
                            imageUrl: widget.message.msg,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
