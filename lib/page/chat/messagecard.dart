import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:saver_gallery/saver_gallery.dart';

import '../../service/firebaseservice.dart';
import '../../const/const.dart';
import '../../const/globalcolor.dart';
import '../../const/method.dart';
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
    bool isMe = FirebaseService.user.uid == widget.message.fromId;

    return InkWell(
      onLongPress: () {
        _showBottonSheet(isMe);
      },
      child: isMe ? _greenWidget() : _blueWidget(),
    );
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
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(mq.width * .033),
                                  topRight: Radius.circular(mq.width * .066),
                                  bottomRight:
                                      Radius.circular(mq.width * .066))),
                          child: Text(
                            widget.message.msg,
                            style: GoogleFonts.poppins(
                                color: white,
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
                              color: messageother,
                              border: Border.all(color: textColor, width: 1),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(mq.width * .03),
                                  topRight: Radius.circular(mq.width * .066),
                                  bottomLeft:
                                      Radius.circular(mq.width * .066))),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(mq.width * .03),
                                topRight: Radius.circular(mq.width * .066),
                                bottomLeft: Radius.circular(mq.width * .066)),
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
                    Methods.getTimeFormatted(context, widget.message.sent),
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

  void _showBottonSheet(bool isMe) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          children: [
            Container(
              height: 4,
              margin: EdgeInsets.symmetric(
                vertical: mq.height * .015,
                horizontal: mq.width * .4,
              ),
              decoration: BoxDecoration(
                  color: grey, borderRadius: BorderRadius.circular(8)),
            ),

            widget.message.type == Type.text
                ?
                //copy option
                _optionItem(
                    icon: const Icon(Icons.copy_all_rounded,
                        color: Colors.blue, size: 26),
                    name: 'Copy Text',
                    onTap: () async {
                      await Clipboard.setData(
                              ClipboardData(text: widget.message.msg))
                          .then((value) {
                        //for hiding bottom sheet
                        Navigator.pop(context);

                        Methods.showSnackBar(context, 'Text Copied!');
                      });
                    })
                :
                //save option
                _optionItem(
                    icon: const Icon(Icons.download_rounded,
                        color: Colors.blue, size: 26),
                    name: 'Save Image',
                    onTap: () async {
                      _getHttp(widget.message.msg);
                      Navigator.pop(context);
                    }),

            //delete option
            if (isMe)
              _optionItem(
                  icon: const Icon(Icons.delete_forever,
                      color: Colors.red, size: 26),
                  name: 'Delete Message',
                  onTap: () async {
                    await FirebaseService.deleteMessage(widget.message)
                        .then((value) {
                      //for hiding bottom sheet
                      Navigator.pop(context);
                    });
                  }),

            //separator or divider
            Divider(
              color: Colors.black54,
              endIndent: mq.width * .04,
              indent: mq.width * .04,
            ),

            //sent time
            _optionItem(
                icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                name: "Sent At: "
                    'Sent At: ${Methods.getmessageTime(context, widget.message.sent)}',
                onTap: () {}),

            //read time
            _optionItem(
                icon: const Icon(Icons.remove_red_eye, color: Colors.green),
                name: widget.message.read.isEmpty
                    ? 'Read At: Not seen yet'
                    : 'Read At: ${Methods.getmessageTime(context, widget.message.read)}',
                onTap: () {}),
          ],
        );
      },
    );
  }

  _optionItem(
      {required Icon icon, required String name, required VoidCallback onTap}) {
    return InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: EdgeInsets.only(
              left: mq.width * .05,
              top: mq.height * .015,
              bottom: mq.height * .015),
          child: Row(children: [
            icon,
            Flexible(
                child: Text('\t\t$name',
                    style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black54,
                        letterSpacing: 0.5)))
          ]),
        ));
  }

  _getHttp(String image) async {
    var response = await Dio()
        .get(image, options: Options(responseType: ResponseType.bytes));
    String picturesPath =
        "ju_chat_${DateTime.now().millisecondsSinceEpoch}.jpg";
    debugPrint(picturesPath);
    final result = await SaverGallery.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: picturesPath,
        androidRelativePath: "Pictures/Ju Chat",
        androidExistNotSave: true);
    debugPrint(result.toString());
    Methods.flutterToast(msg: "Image Successfully Download");
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
                Methods.getmessageTime(context, widget.message.sent),
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
