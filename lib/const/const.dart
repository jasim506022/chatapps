import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const int appId = 53269067; // add your appId here
const String appSignIn =
    "5699df7041ab5affef86ad681a21b5a6d369ac7c7d9ca8768644c3852e87e2c9"; // add your appSignIn here

// Size
late Size mq;

// ‍ Share Preference;
SharedPreferences? prefs;

// For Onboarding
int? isviewed;


// For Null Image
String imageNull =
    "https://firebasestorage.googleapis.com/v0/b/ju-chat-4c9c2.appspot.com/o/chatting.png?alt=media&token=42fc8db5-967b-4e02-9003-1c01950ab436&_gl=1*4iwvrf*_ga*MTY5NDEwMjE3MC4xNjkzNDU5NDkx*_ga_CW55HF8NVT*MTY5NzAwMDk0OS4xMzIuMS4xNjk3MDAzMDc2LjQ5LjAuMA..";
