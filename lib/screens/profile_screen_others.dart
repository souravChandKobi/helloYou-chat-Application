import 'dart:developer';
import 'dart:math' hide log;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ss_chat/models/chat_user.dart';
import 'package:ss_chat/widgets/fullScreenImage.dart';

class ProfileScreenOthers extends StatefulWidget {
  final ChatUser user;
  const ProfileScreenOthers({super.key, required this.user});

  @override
  State<ProfileScreenOthers> createState() => _ProfileScreenOthersState();
}

class _ProfileScreenOthersState extends State<ProfileScreenOthers> {
  // --------------------- Build Method ---------------------
  @override
  Widget build(BuildContext context) {
    var names = widget.user.name.split(' ');
    String formattedName;

    if (names.length == 2) {
      // Two names → each on separate line
      formattedName = widget.user.name;
    } else if (names.length >= 3) {
      // Three or more → first two names on first line, rest on second line
      formattedName = '${names[0]} ${names[1]}\n${names.sublist(2).join(' ')}';
    } else {
      // Only one name
      formattedName = names[0];
    }

    //TO CONVERT THE RESOLUTION OF THE PROFILE PICTURE HIGHER
    String ProfilePicture=widget.user.image;
    String hdProfilePicture= ProfilePicture.replaceAll(RegExp(r"s\d+-c"), "s2048-c");
    log("profile picture: $hdProfilePicture");

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),

      // --------------------- AppBar ---------------------
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Row(children: [Text('Profile')]),

        // Options menu (three dots)
        actions: [
          PopupMenuButton<String>(
            color: Color.fromARGB(255, 0, 15, 1),
            icon: Icon(Icons.more_vert, color: Colors.white),
            offset: Offset(0, kToolbarHeight),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'settings',
                child: Text('Settings', style: TextStyle(color: Colors.white)),
              ),
              PopupMenuItem(
                value: 'help',
                child: Text('Help', style: TextStyle(color: Colors.white)),
              ),
              // PopupMenuItem(value: 'sign out', child: Text('Sign Out')),
            ],
            onSelected: (value) async {
              switch (value) {
                case 'settings':
                  log("Settings clicked");
                  break;
                case 'help':
                  log("Help clicked");
                  break;
                // case 'sign out':
                //   log("Sign Out clicked");

                //   await logout();
                //   Navigator.pop(context);
                //   Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(builder: (_) => LoginScreen()),
                //   );
                //   break;
              }
            },
          ),
        ],
      ),

      // --------------------- Body ---------------------
      body: Stack(
        children: [
          // --------------------- Profile Picture ---------------------
          GestureDetector(
            onTap: () {
                    log('me Profile Image Clicked');
                    if(widget.user.image.trim().isNotEmpty){Navigator.push(context, MaterialPageRoute(builder: (_)=>
                    FullScreenImage(imageUrl: hdProfilePicture)
                    // FullScreenImage(imageUrl: hdProfilePicture, user: widget.user)
                    ));}
                  },
            child: SizedBox(
              height: MediaQuery.of(context).size.width + 10, // square image
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  //Profile Picture
                  CachedNetworkImage(
                    // imageUrl: widget.user.image,
                    imageUrl: hdProfilePicture,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(CupertinoIcons.person, size: 30),
                  ),
            
                  // Bottom vignette overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Color.fromARGB(255, 0, 0, 0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Container(),

          // --------------------- Bottom Container ---------------------
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height:
                  MediaQuery.of(context).size.height * 0.45, // take lower part
              width: double.infinity,
              decoration: const BoxDecoration(
                // color: Colors.grey,
                color: Color.fromARGB(255, 2, 29, 3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),

              child: Padding(
                padding: const EdgeInsets.all(30),

                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name:',
                        style: GoogleFonts.workSans(
                          fontSize:
                              max(
                                MediaQuery.of(context).size.height,
                                MediaQuery.of(context).size.width,
                              ) *
                              0.015,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                      //Name
                      Text(
                        formattedName,
                        style: GoogleFonts.workSans(
                          fontSize: max(
                                MediaQuery.of(context).size.height,
                                MediaQuery.of(context).size.width,
                              ) * 0.04,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      //Email
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: GestureDetector(
                          onLongPress: () {
                            Clipboard.setData(
                              ClipboardData(text: widget.user.email),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(" Copied to Clipboard"),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 5, top: 5),
                            child: Text(
                              'id: ${widget.user.email}',
                              style: GoogleFonts.workSans(
                                fontSize:
                                    max(
                                MediaQuery.of(context).size.height,
                                MediaQuery.of(context).size.width,
                              ) * 0.021,
                                color: Colors.white54,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      Text(
                        'About:',
                        style: GoogleFonts.workSans(
                          fontSize: max(
                                MediaQuery.of(context).size.height,
                                MediaQuery.of(context).size.width,
                              ) * 0.015,
                          fontWeight: FontWeight.w300,
                          color: Colors.white,
                        ),
                      ),
                      //About
                      SizedBox(
                        width: double.infinity,
                        child: SingleChildScrollView(
                          child: Text(
                            widget.user.about,
                            style: GoogleFonts.workSans(
                              fontSize:
                                  max(
                                MediaQuery.of(context).size.height,
                                MediaQuery.of(context).size.width,
                              ) * 0.02,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------- Logout ---------------------
  Future logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn.instance.signOut();
  }
}
