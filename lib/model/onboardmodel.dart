class OnboardModel {
  String img;
  String text;
  String desc;

  OnboardModel({
    required this.img,
    required this.text,
    required this.desc,
  });
}

List<OnboardModel> onboardModeList = [
  OnboardModel(
    img: "asset/image/onboardimage/message.png",
    text: "Do Real time Message",
    desc:
        "JU Chat apps are programs on your phone  that allow you to chat privately with one or many other users",
  ),
  OnboardModel(
    img: "asset/image/onboardimage/video.png",
    text: "Send Photos and Videos",
    desc:
        "JU Chat apps are programs on your phone  that allow you to sent Video and Photo privately with one or many other users",
  ),
  OnboardModel(
    img: "asset/image/onboardimage/mico.png",
    text: "Send Voice",
    desc:
        "JU Chat apps are programs on your phone  that allow you to sent Voice privately with one or many other users",
  )
];
