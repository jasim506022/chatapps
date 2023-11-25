import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_ju/const/approutes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../service/firebaseservice.dart';
import '../../const/const.dart';
import '../../const/globalcolor.dart';
import '../../const/method.dart';
import '../../service/provider/loadingprovider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _key = GlobalKey<FormState>();

  final isEdit = false;
  TextEditingController nameETC = TextEditingController();
  TextEditingController aboutETC = TextEditingController();

  @override
  void initState() {
    nameETC.text = prefs!.getString("name") ?? "Jasim";
    aboutETC.text = prefs!.getString("about") ?? "How Are you ";
    super.initState();
  }

  String? _image;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushNamed(context, AppRoutes.homePage);
        return Future.value(true);
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "Profile",
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: red,
            onPressed: () async {
              try {
                final result = await InternetAddress.lookup('google.com');
                if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          "Logout",
                          style: GoogleFonts.poppins(
                              color: red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                        content: Text(
                          "Are you sure you want to Logout",
                          style: GoogleFonts.poppins(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("No")),
                          TextButton(
                              onPressed: () async {
                                Methods.showProgressBar(context);
                                await FirebaseService.updateActiveStatus(false);
                                await FirebaseService.updatePushToken();
                                await FirebaseService.auth
                                    .signOut()
                                    .then((value) async {
                                  await GoogleSignIn()
                                      .signOut()
                                      .then((value) {});
                                }).then((value) {
                                  Navigator.pop(context);
                                  Methods.flutterToast(
                                      msg: "Logout Succeffuly");
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      AppRoutes.signpage, (route) => false);
                                });
                              },
                              child: Text("Yes"))
                        ],
                      );
                    },
                  );
                } else {
                  Methods.flutterToast(msg: "No Internet Connection");
                }
              } on SocketException {
                if (mounted) {
                  Methods.showDialogMethod(
                    context: context,
                    message:
                        "No Internect Connection. Please your Interenet Connection",
                    title: 'No Internet Connection',
                  );
                }
              } catch (error) {
                if (mounted) {
                  Methods.showDialogMethod(
                    context: context,
                    message: "Error: $error",
                    title: 'Error Ocured',
                  );
                }
              }
            },
            label: const Text("Logout"),
            icon: const Icon(Icons.logout),
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: mq.width, height: mq.height * 0.03),
                Stack(
                  children: [
                    _image != null
                        ? ClipRRect(
                            borderRadius:
                                BorderRadius.circular(mq.height * 0.116),
                            child: Image.file(
                              File(_image!),
                              height: mq.height * 0.232,
                              width: mq.height * 0.232,
                              fit: BoxFit.fill,
                            ),
                          )
                        : ClipRRect(
                            borderRadius:
                                BorderRadius.circular(mq.height * 0.116),
                            child: CachedNetworkImage(
                              height: mq.height * 0.232,
                              width: mq.height * 0.232,
                              fit: BoxFit.fill,
                              imageUrl: prefs!.getString("image") ?? imageNull,
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: MaterialButton(
                        padding: const EdgeInsets.all(6),
                        color: Colors.redAccent,
                        shape: const CircleBorder(),
                        onPressed: () {
                          _showBottonSheet();
                        },
                        child: Icon(
                          size: 25,
                          Icons.camera_alt_outlined,
                          color: white,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: mq.height * 0.03),
                Text(
                  prefs!.getString("email") ?? "Bangladesh",
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: mq.height * 0.03),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _key,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameETC,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          obscureText: false,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Field Doen't be empty";
                            }
                            return null;
                          },
                          style: GoogleFonts.poppins(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                              fillColor:
                                  const Color.fromARGB(255, 234, 233, 233),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(15))),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: aboutETC,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          maxLines: null,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Field Doen't be empty";
                            }
                            return null;
                          },
                          style: GoogleFonts.poppins(
                              color: textColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                              fillColor:
                                  const Color.fromARGB(255, 234, 233, 233),
                              filled: true,
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(15))),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: mq.height * 0.05),
                Consumer<LoadingProvider>(
                  builder: (context, LoadingProvider, child) {
                    return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            minimumSize: Size(mq.width * .4, mq.height * .055)),
                        onPressed: () {
                          if (_key.currentState!.validate()) {
                            _key.currentState!.save();
                            LoadingProvider.setLoadingValue(loadingValue: true);
                            FirebaseService.updateUserData(
                              name: nameETC.text,
                              about: aboutETC.text,
                            ).then((value) {
                              LoadingProvider.setLoadingValue(
                                  loadingValue: false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Sucessfully Update")));
                              Navigator.pushNamed(context, AppRoutes.homePage);
                            });
                          }
                        },
                        child: LoadingProvider.isLoading
                            ? CircularProgressIndicator(
                                backgroundColor: white,
                              )
                            : Text("Update"));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBottonSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(
                color: grey,
                height: mq.height * 0.012,
              ),
              SizedBox(
                height: mq.height * 0.023,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  "Select Profile Photo",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
              SizedBox(
                height: mq.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  bottoSheetMethod(
                      title: 'Camera',
                      icon: Icons.camera_alt,
                      function: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.camera);
                        if (image != null) {
                          print(
                              'Image Path ${image.path} Mine Type: ${image.mimeType}');
                          setState(() {
                            _image = image.path;
                          });

                          FirebaseService.updateProfileImage(
                            File(
                              _image!,
                            ),
                          );

                          Navigator.pop(context);
                        }
                      }),
                  const SizedBox(
                    width: 30,
                  ),
                  bottoSheetMethod(
                      title: 'Gallery',
                      icon: Icons.image,
                      function: () async {
                        final ImagePicker picker = ImagePicker();
                        final XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          print(
                              'Image Path ${image.path} Mine Type: ${image.mimeType}');
                          setState(() {
                            _image = image.path;
                          });

                          FirebaseService.updateProfileImage(
                            File(
                              _image!,
                            ),
                          );

                          Navigator.pop(context);
                        }
                      }),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Column bottoSheetMethod(
      {required String title,
      required IconData icon,
      required VoidCallback function}) {
    return Column(
      children: [
        InkWell(
          onTap: function,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: blueLight.withOpacity(.7), width: 1)),
            child: Icon(
              icon,
              color: blueLight,
            ),
          ),
        ),
        Text(
          title,
          style: GoogleFonts.poppins(
              fontSize: 12, color: textColor.withOpacity(.7)),
        )
      ],
    );
  }
}
