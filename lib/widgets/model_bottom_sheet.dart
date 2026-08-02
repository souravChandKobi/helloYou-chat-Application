import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ss_chat/models/chat_user.dart';
import 'package:ss_chat/pageTransitions/slide_animation.dart';
import 'package:ss_chat/screens/chat_screen.dart';
import 'package:ss_chat/screens/me_profile_screen.dart';

class UserProfileModalSheet extends StatelessWidget {
  final ChatUser user;
  const UserProfileModalSheet({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height:
          max(
            MediaQuery.of(context).size.height,
            MediaQuery.of(context).size.width,
          ) *
          0.38,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 2, 29, 3),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            //Profile picture
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: ClipOval(
                child: SizedBox(
                  height:
                      max(
                        MediaQuery.of(context).size.height,
                        MediaQuery.of(context).size.width,
                      ) *
                      0.08,
                  width:
                      max(
                        MediaQuery.of(context).size.height,
                        MediaQuery.of(context).size.width,
                      ) *
                      0.08,
                  child: CachedNetworkImage(
                    imageUrl: user.image,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      CupertinoIcons.person,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Text(
              //NAME
              user.name,
              style: GoogleFonts.workSans(
                color: Colors.white,
                fontSize:
                    max(
                      MediaQuery.of(context).size.height,
                      MediaQuery.of(context).size.width,
                    ) *
                    0.04,
                fontWeight: FontWeight.w600,
              ),
            ),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: GestureDetector(
                onLongPress: () {
                  Clipboard.setData(ClipboardData(text: user.email));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(" Copied to Clipboard"),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                //Email
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Text(
                    user.email,
                    style: GoogleFonts.workSans(
                      fontSize:
                          max(
                            MediaQuery.of(context).size.height,
                            MediaQuery.of(context).size.width,
                          ) *
                          0.019,
                      color: Colors.white70,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(bottom: 10, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //message icon
                  Material(
                    elevation: 1, // controls the shadow depth
                    color: Color.fromARGB(255, 2, 29, 3),
                    borderRadius: BorderRadius.circular(
                      12,
                    ), // optional rounded corners
                    shadowColor: const Color.fromARGB(133, 255, 255, 255),
                    child: Container(
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.all(Radius.circular(20)),
                      //   color: Color.fromARGB(255, 3, 44, 3),
                      // ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            SlideFromRightPageRoute(
                              page: ChatScreen(user: user),
                              duration: const Duration(
                                milliseconds: 100,
                              ), // slower
                              reverseDuration: const Duration(milliseconds: 50),
                            ),
                            (route) => route.isFirst,
                          );
                        },
                        icon: Icon(Icons.message_rounded),
                        iconSize:
                            max(
                              MediaQuery.of(context).size.height,
                              MediaQuery.of(context).size.width,
                            ) *
                            0.048,
                        // color: Color(0xFF97d68f),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  //call icon
                  Material(
                    elevation: 1, // controls the shadow depth
                    color: Color.fromARGB(255, 2, 29, 3),
                    borderRadius: BorderRadius.circular(
                      12,
                    ), // optional rounded corners
                    shadowColor: const Color.fromARGB(133, 255, 255, 255),
                    child: Container(
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.all(Radius.circular(20)),
                      //   color: Colors.amber,
                      // ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.call_outlined),
                        iconSize:
                            max(
                              MediaQuery.of(context).size.height,
                              MediaQuery.of(context).size.width,
                            ) *
                            0.048,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  //video call icon
                  Material(
                    elevation: 1, // controls the shadow depth
                    color: Color.fromARGB(255, 2, 29, 3),
                    borderRadius: BorderRadius.circular(
                      12,
                    ), // optional rounded corners
                    shadowColor: const Color.fromARGB(133, 255, 255, 255),
                    child: Container(
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.all(Radius.circular(20)),
                      //   color: Colors.amber,
                      // ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.video_call),
                        iconSize:
                            max(
                              MediaQuery.of(context).size.height,
                              MediaQuery.of(context).size.width,
                            ) *
                            0.048,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  SlideFromRightPageRoute(
                    page: ProfileScreen(user: user),
                    duration: const Duration(milliseconds: 100),
                    reverseDuration: const Duration(milliseconds: 50),
                  ),
                );
              },
              icon: Icon(Icons.info_outline_rounded),
              iconSize:
                  max(
                    MediaQuery.of(context).size.height,
                    MediaQuery.of(context).size.width,
                  ) *
                  0.05,
              color: Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}
