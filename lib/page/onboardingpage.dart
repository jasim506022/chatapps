import 'package:chat_ju/const/approutes.dart';
import 'package:chat_ju/const/globalcolor.dart';
import 'package:chat_ju/page/auth/signpage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../const/const.dart';
import '../model/onboardmodel.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  int currentIndex = 0;
  PageController pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  tourOnboardInfo() async {
    int isViewed = 0;
    await prefs!.setInt('onBoard', isViewed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: white,
        elevation: 0.0,
        actions: [
          TextButton(
              onPressed: () {
                tourOnboardInfo();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignPage(),
                    ));
              },
              child: Text("Skip",
                  style: GoogleFonts.inter(
                      fontSize: 16,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      color: textColor)))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: PageView.builder(
          controller: pageController,
          itemCount: onboardModeList.length,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  onboardModeList[index].img,
                  height: MediaQuery.of(context).size.height * .412,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .012,
                  child: ListView.builder(
                    itemCount: onboardModeList.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * .01,
                            width: MediaQuery.of(context).size.height * .01,
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                                color: currentIndex == index
                                    ? Colors.red
                                    : Colors.brown,
                                shape: BoxShape.circle),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Text(
                  onboardModeList[index].text,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                ),
                Text(onboardModeList[index].desc,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        fontSize: 16,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold,
                        color: textColor)),
                InkWell(
                  onTap: () async {
                    if (index == onboardModeList.length - 1) {
                      await tourOnboardInfo();

                      Navigator.pushReplacementNamed(
                          context, AppRoutes.signpage);
                    }
                    pageController.nextPage(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.bounceIn);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    decoration: BoxDecoration(
                        color: textColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Next",
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.bold,
                              color: white),
                        ),
                        SizedBox(
                          width: mq.width * .033,
                        ),
                        Icon(
                          Icons.arrow_forward_sharp,
                          color: white,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
