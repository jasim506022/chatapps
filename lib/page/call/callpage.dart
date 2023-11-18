import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import '../../const/callcontroller.dart';
import '../../const/const.dart';

class CallViewPage extends StatelessWidget {
  const CallViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(CallController.audio ? "Audio Call" : "VideoCall"),
      ),
      body: ZegoUIKitPrebuiltCall(
          appID: appId,
          appSign: appSignIn,
          userID: CallController.userId,
          userName: CallController.username,
          callID: CallController.callId,
          config: CallController.audio
              ? (ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
                ..onOnlySelfInRoom = (_) => Navigator.of(context).pop())
              : (ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
                ..onOnlySelfInRoom = (_) => Navigator.of(context).pop())),
    );
  }
}
