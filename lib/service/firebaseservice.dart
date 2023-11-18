import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

import '../const/const.dart';
import '../helper/dialog.dart';
import '../helper/localnotification.dart';
import '../model/messagemodel.dart';
import '../model/userpersonmodel.dart';

class FirebaseService {
  // instance of FirebaseAuth
  static FirebaseAuth auth = FirebaseAuth.instance;

  //instance of Firebase Firestore
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  //instance of Firebase storage
  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  //instance of Firebase message
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  // current User
  static User get user => auth.currentUser!;

//Sign in With Email and Passwords
  static Future<UserCredential> singEmailandPasswordSnapshot(
      {required String email, required String password}) async {
    UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential;
  }

  // Sign in with Gmail
  static Future<UserCredential?> signInWithGoogle(
      {required BuildContext context}) async {
    try {
      await InternetAddress.lookup('google.com');

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      return await auth.signInWithCredential(credential);
    } catch (e) {
      Dialogs.showSnackBar(context, "Error: $e");
      return null;
    }
  }

// user is Exist on Database
  static Future<bool> userExists() async =>
      (await firestore.collection("user").doc(auth.currentUser!.uid).get())
          .exists;



//push New User Data in Firebase Database for sign in with Gmail
  static Future<void> createUserbyGmail() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = UserPersonModel(
        uid: user.uid,
        image: user.photoURL!,
        about: "Battery is Die",
        name: user.displayName!,
        createdAt: time,
        isOnline: false,
        lastActive: time,
        email: user.email!,
        pushToken: "pushToken");
    firestore.collection("user").doc(user.uid).set(chatUser.toJson());
  }

  //Create User With Email and Password
  static Future<UserCredential> createUserWithEmailandPassword(
      {required String email, required String password}) async {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return userCredential;
  }

  //Create User and Post Data  Fireebase
  static Future<void> createUserByEmailPassword(
      {String? name, required UserCredential user}) async {
    UserPersonModel userPersonModel = UserPersonModel(
        uid: user.user!.uid,
        image:
            "https://firebasestorage.googleapis.com/v0/b/ju-chat-4c9c2.appspot.com/o/chatting.png?alt=media&token=42fc8db5-967b-4e02-9003-1c01950ab436&_gl=1*4iwvrf*_ga*MTY5NDEwMjE3MC4xNjkzNDU5NDkx*_ga_CW55HF8NVT*MTY5NzAwMDk0OS4xMzIuMS4xNjk3MDAzMDc2LjQ5LjAuMA..",
        about: "Battery is Die",
        name: name,
        createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
        isOnline: false,
        lastActive: DateTime.now().millisecondsSinceEpoch.toString(),
        email: user.user!.email,
        pushToken: "");
    firestore
        .collection("user")
        .doc(user.user!.uid)
        .set(userPersonModel.toJson());
  }

// Get Firebase Message Token
  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();
    await fMessaging.getToken().then((token) {
      if (token != null) {
        firestore
            .collection("user")
            .doc(user.uid)
            .update({"push_token": token});
        if (kDebugMode) {
          print("push Token: $token");
        }
      }
    });
  }

  // Get All User Infor On Share Preference
  static Future<void> getSelfInfor(BuildContext context) async {
    await firestore
        .collection("user")
        .doc(user.uid)
        .get()
        .then((userData) async {
      UserPersonModel userPersonModel =
          UserPersonModel.fromJson(userData.data()!);
      if (userData.exists) {
        await prefs!.setString('image', userPersonModel.image!);
        await prefs!.setString('name', userPersonModel.name!);
        await prefs!.setString('email', userPersonModel.email!);
        await prefs!.setString('about', userPersonModel.about!);
      }
    });

    //Forground Work
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print(message.notification!.title);
      print(message.notification!.body);

      if (message.notification != null) {
        print(
            'Message also contained a notification: ${message.notification!.title}');
      }

      // LocalNotification.display(message);
      LocalNotification.assomedisplay(message, context);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("Hello Bangladesh background");
      // LocalNotification.display(event);
      LocalNotification.assomedisplay(event, context);
    });
  }

//Current User Details
  static Stream<QuerySnapshot<Map<String, dynamic>>> getCurrentUser() {
    return firestore
        .collection("user")
        .where("uid", isEqualTo: auth.currentUser!.uid)
        .snapshots();
  }

  //useful for getting conversation id
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? "${user.uid}_$id"
      : '${id}_${user.uid}';

//Last Message
  static Stream<QuerySnapshot<Map<String, dynamic>>> lastmesssage(
      UserPersonModel chatUser) {
    return firestore
        .collection("chats/${getConversationID(chatUser.uid!)}/message/")
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  //Get All Message Conversation
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessage(
      UserPersonModel chatUser) {
    return firestore
        .collection("chats/${getConversationID(chatUser.uid!)}/message/")
        .orderBy('sent', descending: true)
        .snapshots();
  }

  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection("user").doc(user.uid).update({
      "is_online": isOnline,
      "last_active": DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  //Get All User
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUser() {
    return firestore
        .collection("user")
        .orderBy("last_active", descending: true)
        .snapshots();
  }

//FirebaseUpddateMessageRead Status
  static Future<void> updateMessgeReadStuts(Message message) async {
    await firestore
        .collection("chats/${getConversationID(message.fromId)}/message/")
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

//Update Profile Image
  static Future<void> updateProfileImage(File file) async {
    final ext = file.path.split(".").last;

    final ref = firebaseStorage.ref().child("profile_picture/${user.uid}.$ext");
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      if (kDebugMode) {
        print("Data Transfered: ${p0.bytesTransferred / 1000} kb ");
      }
    });
    var image = await ref.getDownloadURL();
    await firestore
        .collection("user")
        .doc(user.uid)
        .update({'image': image}).then((value) async {
      await prefs!.setString('image', image);
    });
  }

  static Future<void> updateUserData(
      {required String name, required String about}) async {
    await firestore
        .collection("user")
        .doc(user.uid)
        .update({'name': name, 'about': about});
  }

  static Future<void> updatePushToken() async {
    await firestore.collection("user").doc(user.uid).update({
      'push_token': "push token",
    });
  }

  //send chat image
  static Future<void> sendChatImage(UserPersonModel chatUser, File file) async {
    final ext = file.path.split(".").last;
    if (kDebugMode) {
      print(ext);
    }

    //storage file ref with path
    final ref = firebaseStorage.ref().child(
        "image${getConversationID(chatUser.uid!)}/${DateTime.now().millisecondsSinceEpoch}.$ext");
    //upload image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      if (kDebugMode) {
        print("Data Transfered: ${p0.bytesTransferred / 1000} kb ");
      }
    });
    final imageurl = await ref.getDownloadURL();
    //updateing in firebaseFirestore
    await sendMessage(chatUser, imageurl, Type.image);
  }

  //message to send
  static Future<void> sendMessage(
      UserPersonModel chatuser, String message, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Message messageModel = Message(
        msg: message,
        toId: chatuser.uid!,
        read: "",
        type: type,
        sent: time,
        fromId: user.uid);

    final ref = firestore
        .collection("chats/${getConversationID(chatuser.uid!)}/message/");
    await ref.doc(time).set(messageModel.toJson()).then((value) =>
        sendPushNotification(chatuser, type == Type.text ? message : "image"));

    await firestore
        .collection("user")
        .doc(chatuser.uid)
        .update({'last_active': time});
  }

//for sending push notification

  static Future<void> sendPushNotification(
      UserPersonModel userModel, String msg) async {
    DocumentSnapshot<Map<String, dynamic>> me =
        await firestore.collection("user").doc(user.uid).get();

    var userMe = UserPersonModel.fromDocumentSnapshot(me);

    try {
      var body = {
        "to": userModel.pushToken,
        "notification": {
          "title": userMe.name,
          "body": msg,
          "android_channel_id": "chats",
        },
        "data": <String, dynamic>{
          "data": userMe,
        }
      };

      var response =
          await post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
              headers: {
                HttpHeaders.contentTypeHeader: "application/json",
                HttpHeaders.authorizationHeader:
                    "key=AAAAZrEfRF4:APA91bHBslzzyOtx7hPWmIOQoF-fwcwVQU-JhIxdn7bULYJ6_p_Kxsomdu-ui0xvrsmVSlHiuCe7YMnImSTbAST4XBtgvtmomkapMcLWz74RNyhCNXm5cCPZbWMHFP7s7o3_SOLSvrGJ"
              },
              body: jsonEncode(body));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (e) {
      print("Error Firebase: " + e.toString());
    }
  }

//for sending Call notification
  static Future<void> sendCallNotification(
      String title, UserPersonModel userModel) async {
    DocumentSnapshot<Map<String, dynamic>> me =
        await firestore.collection("user").doc(user.uid).get();

    var userMe = UserPersonModel.fromDocumentSnapshot(me);
    try {
      var body = {
        "to": userModel.pushToken,
        "notification": {
          "title": title,
          "body": "${userMe.name} is ${title} you",
          "android_channel_id": "chats",
        },
        "data": <String, dynamic>{
          "uid": user.uid,
        }
      };

      var response =
          await post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
              headers: {
                HttpHeaders.contentTypeHeader: "application/json",
                HttpHeaders.authorizationHeader:
                    "key=AAAAZrEfRF4:APA91bHBslzzyOtx7hPWmIOQoF-fwcwVQU-JhIxdn7bULYJ6_p_Kxsomdu-ui0xvrsmVSlHiuCe7YMnImSTbAST4XBtgvtmomkapMcLWz74RNyhCNXm5cCPZbWMHFP7s7o3_SOLSvrGJ"
              },
              body: jsonEncode(body));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
    } catch (e) {
      print("Error Firebase: " + e.toString());
    }
  }
}
