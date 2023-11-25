import 'package:awesome_notifications/awesome_notifications.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../const/approutes.dart';
import '../../const/callcontroller.dart';
import '../../const/const.dart';
import '../../const/globalcolor.dart';
import '../../model/userpersonmodel.dart';
import '../firebaseservice.dart';

class LocalNotification {
  static void awesomeinitialize() {
    AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
              channelGroupKey: 'basic_channel_group',
              channelKey: 'chats',
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: Color(0xFF9D50DD),
              ledColor: white)
        ],
        // Channel groups are only visual and are not required
        debug: true);
  }

  static void awesomedisplay(RemoteMessage message,
      [BuildContext? context]) async {
    String title = message.notification!.title!;
    String body = message.notification!.body!;

    if (title.contains("Audio Call") || title.contains("Video Call")) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 10,
            channelKey: 'chats',
            title: title,
            body: body,
          ),
          actionButtons: [
            NotificationActionButton(
                key: "ACCEPT",
                label: "Accept Call",
                color: green,
                autoDismissible: true),
            NotificationActionButton(
                key: "REJECT",
                label: "Recject Call",
                color: red,
                autoDismissible: true),
          ]);
      AwesomeNotifications().setListeners(
        onActionReceivedMethod: (receivedAction) {
          if (receivedAction.buttonKeyPressed == "REJECT") {
          } else if (receivedAction.buttonKeyPressed == "ACCEPT") {
            CallController.callId = "1020";
            CallController.userId = FirebaseService.user.uid;
            CallController.audio = title.contains("Audio Call") ? true : false;
            CallController.username = prefs!.getString("name") ?? "Jasim";
            Navigator.of(context!).pushNamed(AppRoutes.callViewPage);
          }
          return Future.value();
        },
      );
    } else {
      {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: 10,
            channelKey: 'chats',
            title: title,
            body: body,
          ),
        );
        AwesomeNotifications().setListeners(
          onActionReceivedMethod: (receivedAction) {
            Map<String, dynamic> data = message.data;
            Map<String, dynamic> userJson = data['data'];
            UserPersonModel receivedUser = UserPersonModel.fromJson(userJson);
            Navigator.pushNamed(context!, AppRoutes.chatPage,
                arguments: receivedUser);
            return Future.value();
          },
        );
      }
    }
  }
}
