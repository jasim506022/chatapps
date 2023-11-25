import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../const/approutes.dart';
import '../../service/firebaseservice.dart';
import '../../const/const.dart';
import '../../const/globalcolor.dart';
import '../../const/method.dart';
import '../../model/messagemodel.dart';
import '../../service/provider/loadingprovider.dart';

import 'messagecard.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> allMessageList = [];

  final _textEditField = TextEditingController();

  bool isEmojio = false;

  @override
  void dispose() {
    _textEditField.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: white,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark));

    final dynamic user = ModalRoute.of(context)!.settings.arguments;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () {
          if (isEmojio) {
            setState(() => isEmojio = !isEmojio);
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: SafeArea(
            child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: mq.height * .082,
            backgroundColor: white,
            flexibleSpace: _appBarWidget(user),
            elevation: .5,
          ),
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseService.getAllMessage(user),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const Center(child: CircularProgressIndicator());
                      case ConnectionState.active:
                      case ConnectionState.done:
                    }

                    final data = snapshot.data?.docs;
                    allMessageList =
                        data!.map((e) => Message.fromJson(e.data())).toList();

                    if (allMessageList.isNotEmpty) {
                      return ListView.builder(
                        padding: EdgeInsets.only(top: mq.height * .01),
                        physics: const BouncingScrollPhysics(),
                        itemCount: allMessageList.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          return MessageCard(
                            message: allMessageList[index],
                            userPersonModel: user,
                          );
                        },
                      );
                    } else {
                      return Center(
                          child: Text(
                        "Say Hii! 👋",
                        style: GoogleFonts.poppins(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            fontSize: 18),
                      ));
                    }
                  },
                ),
              ),
              if (Provider.of<LoadingProvider>(context).isLoading)
                const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ),
              _chatInput(user),
              if (isEmojio)
                SizedBox(
                    height: mq.height * .35,
                    child: EmojiPicker(
                      textEditingController: _textEditField,
                      config: Config(
                        columns: 10,
                        emojiSizeMax: 20 * (Platform.isAndroid ? 1.30 : 1.0),
                      ),
                    )),
            ],
          ),
        )),
      ),
    );
  }

  Widget _appBarWidget(user) {
    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.viewUserPage, arguments: user);
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(mq.width * .023, mq.height * .01,
              mq.height * .01, mq.width * .023),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  mq.height * .029,
                ),
                child: CachedNetworkImage(
                  height: mq.height * .058,
                  width: mq.height * .058,
                  fit: BoxFit.cover,
                  imageUrl: user.image!,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              SizedBox(
                width: mq.width * .022,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user.name!,
                    style: GoogleFonts.poppins(
                        color: textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 14),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                      user.isOnline!
                          ? "Online"
                          : Methods.getLastActiveTime(
                              context, user.lastActive!),
                      style: user.isOnline!
                          ? GoogleFonts.poppins(
                              color: blueLight,
                              fontWeight: FontWeight.w700,
                              fontSize: 12)
                          : GoogleFonts.poppins(
                              color: textColor.withOpacity(.5),
                              fontWeight: FontWeight.w700,
                              fontSize: 12)),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Methods.call(
                            context: context, user: user, isAudio: true);
                       
                      },
                      icon: Icon(
                        Icons.call,
                        color: textColor,
                      )),
                  IconButton(
                      onPressed: () {
                        Methods.call(
                            context: context, user: user, isAudio: false);
                       
                      },
                      icon: Icon(
                        Icons.video_call,
                        color: textColor,
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.more_vert,
                        color: textColor,
                      )),
                ],
              )
            ],
          ),
        ));
  }

  _chatInput(user) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * .01, horizontal: mq.width * .03),
      child: Row(
        children: [
          Expanded(
            child: Consumer<LoadingProvider>(
              builder: (context, loadingProvider, child) {
                return Card(
                  color: white,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: textColor, width: .5),
                      borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              isEmojio = !isEmojio;
                            });
                          },
                          icon: Icon(
                            Icons.emoji_emotions,
                            color: blueLight,
                          )),
                      Expanded(
                          child: TextFormField(
                        onTap: () {
                          if (isEmojio) {
                            setState(() {
                              isEmojio = !isEmojio;
                            });
                          }
                        },
                        controller: _textEditField,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: GoogleFonts.poppins(
                            color: textColor,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            fontSize: 12),
                        decoration: InputDecoration(
                            hintText: 'Typing Soming......',
                            hintStyle: TextStyle(color: grey),
                            border: InputBorder.none),
                      )),
                      IconButton(
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            List<XFile> image =
                                await picker.pickMultiImage(imageQuality: 20);
                            for (var i in image) {
                              loadingProvider.setLoadingValue(
                                  loadingValue: true);
                              if (kDebugMode) {
                                print(
                                    'Image Path ${i.path} Mine Type: ${i.mimeType}');
                              }
                              await FirebaseService.sendChatImage(
                                  user, File(i.path));
                              loadingProvider.setLoadingValue(
                                  loadingValue: false);
                            }
                          },
                          icon: Icon(Icons.image, color: blueLight)),
                      IconButton(
                          onPressed: () async {
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                                source: ImageSource.camera, imageQuality: 20);
                            if (image != null) {
                              if (kDebugMode) {
                                print(
                                    'Image Path ${image.path} Mine Type: ${image.mimeType}');
                              }
                              loadingProvider.setLoadingValue(
                                  loadingValue: true);
                              await FirebaseService.sendChatImage(
                                  user, File(image.path));
                              loadingProvider.setLoadingValue(
                                  loadingValue: false);
                            }
                          },
                          icon:
                              Icon(Icons.camera_alt_outlined, color: blueLight))
                    ],
                  ),
                );
              },
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (_textEditField.text.isNotEmpty) {
                FirebaseService.sendMessage(
                    user, _textEditField.text, Type.text);
                _textEditField.text = '';
              }
            },
            minWidth: 0,
            padding: const EdgeInsets.all(7),
            shape: const CircleBorder(),
            color: green,
            child: Center(
              child: Icon(
                Icons.send,
                color: white,
                size: 28,
              ),
            ),
          )
        ],
      ),
    );
  }
}
