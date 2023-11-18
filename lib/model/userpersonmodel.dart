import 'package:cloud_firestore/cloud_firestore.dart';

class UserPersonModel {
  UserPersonModel({
    required this.uid,
    required this.image,
    required this.about,
    required this.name,
    required this.createdAt,
    required this.isOnline,
    required this.lastActive,
    required this.email,
    required this.pushToken,
  });
  String? uid;
  String? image;
  String? about;
  String? name;
  String? createdAt;
  bool? isOnline;
  String? lastActive;
  String? email;
  String? pushToken;

  factory UserPersonModel.fromJson(Map<String, dynamic> json) {
    return UserPersonModel(
        uid: json['uid'],
        image: json['image'],
        about: json['about'],
        name: json['name'],
        createdAt: json['created_at'],
        isOnline: json['is_online'],
        lastActive: json['last_active'],
        email: json['email'],
        pushToken: json['push_token']);
  }

  factory UserPersonModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> json = snapshot.data()!;
    return UserPersonModel(
        uid: json['uid'],
        image: json['image'],
        about: json['about'],
        name: json['name'],
        createdAt: json['created_at'],
        isOnline: json['is_online'],
        lastActive: json['last_active'],
        email: json['email'],
        pushToken: json['push_token']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['uid'] = uid;
    data['image'] = image;
    data['about'] = about;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['is_online'] = isOnline;
    data['last_active'] = lastActive;
    data['email'] = email;
    data['push_token'] = pushToken;
    return data;
  }
}
