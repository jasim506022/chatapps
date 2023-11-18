import 'package:chat_ju/const/approutes.dart';
import 'package:chat_ju/service/searchprovider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../service/firebaseservice.dart';
import '../../const/globalcolor.dart';
import '../../const/const.dart';
import '../../model/userpersonmodel.dart';
import 'loading_user_card_widget.dart';
import 'user_card_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<UserPersonModel> filterList = [];

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<SearchProvider>(context, listen: false)
        ..setSearch(search: false)
        ..clearSearch();
    });
    FirebaseService.getFirebaseMessagingToken();
    FirebaseService.getSelfInfor(context);
    FirebaseService.updateActiveStatus(true);
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (kDebugMode) {
        print("message: $message");
      }
      if (FirebaseService.auth.currentUser != null) {
        if (message.toString().contains("resumed")) {
          print(message.toString().contains("resumed"));
          FirebaseService.updateActiveStatus(true);
        }
        if (message.toString().contains("paused")) {
          print(message.toString().contains("paused"));
          FirebaseService.updateActiveStatus(false);
        }
      }

      return Future.value(message);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: white,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark));

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Consumer<SearchProvider>(
        builder: (context, searchProvider, child) {
          return WillPopScope(
            onWillPop: () {
              if (searchProvider.isSearch) {
                searchProvider.setSearch();
                return Future.value(false);
              } else {
                return Future.value(true);
              }
            },
            child: SafeArea(
              child: Scaffold(
                backgroundColor: bgLight,
                appBar: _buildAppBar(),
                body: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: Colors.black87,
                          ),
                          SizedBox(
                            width: mq.width * .035,
                          ),
                          Expanded(
                            child: _searchTextFormField(searchProvider),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: StreamBuilder(
                        stream: FirebaseService.getAllUser(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return ListView.builder(
                                itemCount: 10,
                                itemBuilder: (context, index) {
                                  return const LoadingUserCardWidget();
                                },
                              );
                            case ConnectionState.none:
                              return const Center(
                                  child: CircularProgressIndicator());
                            case ConnectionState.active:
                            case ConnectionState.done:
                          }

                          final data = snapshot.data?.docs;
                          List<UserPersonModel> list = data!
                              .map((e) => UserPersonModel.fromJson(e.data()))
                              .toList();

                          filterList = list
                              .where((element) =>
                                  element.uid !=
                                  FirebaseService.auth.currentUser!.uid)
                              .toList();

                          if (filterList.isNotEmpty) {
                            return searchProvider.isSearch &&
                                    searchProvider.seachingList.isEmpty
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 10),
                                      child:
                                          Image.asset("asset/image/nouser.png"),
                                    ),
                                  )
                                : ListView.builder(
                                    padding:
                                        EdgeInsets.only(top: mq.height * .01),
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: searchProvider.isSearch
                                        ? searchProvider.seachingList.length
                                        : filterList.length,
                                    itemBuilder: (context, index) {
                                      return UserCardWidget(
                                        usermodel: searchProvider.isSearch
                                            ? searchProvider.seachingList[index]
                                            : filterList[index],
                                      );
                                    },
                                  );
                          }
                          {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 10),
                                child: Image.asset("asset/image/nouser.png"),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  TextFormField _searchTextFormField(SearchProvider searchProvider) {
    return TextFormField(
      onChanged: (value) {
        searchProvider.clearSearch();
        for (UserPersonModel userPersonModel in filterList) {
          if (userPersonModel.name!
                  .toLowerCase()
                  .contains(value.toLowerCase()) ||
              userPersonModel.email!
                  .toLowerCase()
                  .contains(value.toLowerCase())) {
            searchProvider
              ..addUsersearch(userPersonModel: userPersonModel)
              ..setSearch(search: true);
          }
        }
      },
      style: GoogleFonts.poppins(
          color: Colors.black87,
          fontSize: 14,
          letterSpacing: 1,
          fontWeight: FontWeight.w500),
      decoration: InputDecoration(
          hintText: "Search User",
          hintStyle: GoogleFonts.poppins(color: grey, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          border: InputBorder.none),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: white,
      elevation: 0.0,
      toolbarHeight: MediaQuery.of(context).size.height * 0.082,
      flexibleSpace: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.profilePage);
                  },
                  child: SizedBox(
                    height: mq.height * 0.053,
                    width: mq.height * 0.053,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        prefs!.getString("image") ?? imageNull,
                      ),
                    ),
                  )),
              SizedBox(
                width: mq.width * .035,
              ),
              Text(
                "Inbox",
                style: GoogleFonts.poppins(
                    color: textColor,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(7),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: bgLight),
                child: Icon(
                  Icons.camera_alt,
                  color: textColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
