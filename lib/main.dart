import 'package:chat_ju/page/auth/forgetpasswordpage.dart';
import 'package:chat_ju/page/profile/profilepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'const/approutes.dart';
import 'const/const.dart';
import 'const/globalcolor.dart';
import 'firebase_options.dart';
import 'helper/localnotification.dart';
import 'page/auth/signpage.dart';
import 'page/auth/signuppage.dart';
import 'page/chat/chatspage.dart';
import 'page/home/homepage.dart';
import 'page/splashpage.dart';
import 'page/call/callpage.dart';
import 'page/viewuserpage/viewuserpage.dart';
import 'service/loadingprovider.dart';
import 'service/searchprovider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  prefs = await SharedPreferences.getInstance();
  // LocalNotification.initialize();
  LocalNotification.assomeinitialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LoadingProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Chat Apps',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: textColor),
            backgroundColor: white,
            titleTextStyle: GoogleFonts.poppins(
                color: textColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontSize: 16),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashPage(),
          AppRoutes.signpage: (context) => SignPage(),
          AppRoutes.signUpPage: (context) => SignUpPage(),
          AppRoutes.homePage: (context) => HomePage(),
          AppRoutes.chatPage: (context) => ChatPage(),
          AppRoutes.profilePage: (context) => ProfilePage(),
          AppRoutes.viewUserPage: (context) => ViewUserPage(),
          AppRoutes.callViewPage: (context) => CallViewPage(),
          AppRoutes.forgetpasswordpage: (context) => ForgetPasswordPage(),
        },
      ),
    );
  }
}

Future<void> backgroundHandle(RemoteMessage message) async {
  LocalNotification.assomedisplay(message);
}
