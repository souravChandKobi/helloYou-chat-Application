import 'dart:developer';
import 'dart:math' hide log;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ss_chat/main.dart';
import 'package:ss_chat/models/chat_user.dart';
import 'package:ss_chat/screens/auth/login_screen.dart';
import 'package:ss_chat/widgets/fullScreenProfilePhoto.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _editing = false;

  late TextEditingController _nameCtrl;
  late TextEditingController _aboutCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.user.name);
    _aboutCtrl = TextEditingController(text: widget.user.about);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _aboutCtrl.dispose();
    super.dispose();
  }

  // --------------------- Build Method ---------------------
  @override
  Widget build(BuildContext context) {

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
            icon: Icon(Icons.more_vert),
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
              PopupMenuItem(
                value: 'sign out',
                child: Text('Sign Out', style: TextStyle(color: Colors.white)),
              ),
            ],
            onSelected: (value) async {
              switch (value) {
                case 'settings':
                  log("Settings clicked");
                  break;
                case 'help':
                  log("Help clicked");
                  break;
                case 'sign out':
                  log("Sign Out clicked");

                  await logout();
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  );
                  break;
              }
            },
          ),
        ],
      ),

      body: Stack(
        children: [
          // --------------------- Profile Picture ---------------------
          GestureDetector(
            onTap: () {
                    log('me Profile Image Clicked');
                    if(widget.user.image.trim().isNotEmpty){Navigator.push(context, MaterialPageRoute(builder: (_)=>
                    FullScreenProfilePhoto(imageUrl: hdProfilePicture, user: widget.user)
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
                          Colors.black.withOpacity(0.7),
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
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('usersBeta')
                  .doc(widget.user.id)
                  .snapshots(),
              builder: (context, asyncSnapshot) {
                final userData = asyncSnapshot.data?.data() ?? {};
                final name = userData['name'] ?? '';
                final about = userData['about'] ?? '';

                return Stack(
                  children: [
                    Container(
                      height:
                          MediaQuery.of(context).size.height *
                          0.45, // take lower part
                      width: double.infinity,
                      decoration: const BoxDecoration(
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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

                                  // IconButton(
                                  //   onPressed: () {
                                  //     setState(()  {
                                  //       _editing = !_editing;

                                  //       !_editing?
                                  //       firestore.collection('usersBeta').doc(widget.user.id).update({'name':_nameCtrl.text}):
                                  //       log("Name changed");
                                  //     });
                                  //   },
                                  //   icon: Icon(_editing ? Icons.check : Icons.edit),
                                  //   visualDensity: VisualDensity.compact,
                                  // ),
                                ],
                              ),

                              _editing
                                  ? TextField(
                                      controller: _nameCtrl,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        hintText: "Enter your Name",
                                      ),
                                      style: GoogleFonts.workSans(
                                        fontSize:
                                            max(
                                MediaQuery.of(context).size.height,
                                MediaQuery.of(context).size.width,
                              ) *
                                            0.03,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    )
                                  :
                                    //Name
                                    Text(
                                      name,
                                      // widget.user.name,
                                      style: GoogleFonts.workSans(
                                        fontSize:
                                            max(
                                MediaQuery.of(context).size.height,
                                MediaQuery.of(context).size.width,
                              ) *
                                            0.04,
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
                                    padding: const EdgeInsets.only(
                                      bottom: 5,
                                      top: 5,
                                    ),
                                    child: Text(
                                      'id: ${widget.user.email}',
                                      style: GoogleFonts.workSans(
                                        fontSize:
                                            max(
                                MediaQuery.of(context).size.height,
                                MediaQuery.of(context).size.width,
                              ) *
                                            0.021,
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

                              //About
                              SizedBox(
                                width: double.infinity,
                                child: SingleChildScrollView(
                                  child: _editing
                                      ? TextField(
                                          controller: _aboutCtrl,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: "Enter your Name",
                                          ),
                                          style: GoogleFonts.workSans(
                                            fontSize:
                                                max(
                                MediaQuery.of(context).size.height,
                                MediaQuery.of(context).size.width,
                              ) *
                                                0.019,
                                            fontWeight: FontWeight.w300,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          about,
                                          style: GoogleFonts.workSans(
                                            fontSize:
                                                max(
                                MediaQuery.of(context).size.height,
                                MediaQuery.of(context).size.width,
                              ) *
                                                0.02,
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

                    //EDIT INFO Button
                    Positioned(
                      top: 10,
                      right: 10,
                      child: IconButton(
                        onPressed: () {
                                      setState(()  {
                                        _editing = !_editing;

                                        !_editing?
                                        firestore.collection('usersBeta').doc(widget.user.id).update({'name':_nameCtrl.text,
                                        'about': _aboutCtrl.text}):
                                        log("Name changed");
                                      });
                                    },

                        icon: Icon(!_editing?
                          Icons.edit:Icons.save,
                          color: Colors.white38,
                          size: max(
                                MediaQuery.of(context).size.height,
                                MediaQuery.of(context).size.width,
                              ) * 0.03,
                        ),
                      ),
                      // child: ElevatedButton(
                      //   onPressed: () {
                      //     setState(() {
                      //       _editing = !_editing;

                      //       !_editing
                      //           ? firestore
                      //                 .collection('usersBeta')
                      //                 .doc(widget.user.id)
                      //                 .update({
                      //                   'name': _nameCtrl.text,
                      //                   'about': _aboutCtrl.text,
                      //                 })
                      //           : log("Name changed");
                      //     });
                      //   },
                      //   child: !_editing? Icon(Icons.edit_document):Text('Save')
                      // ),
                    ),
                  ],
                );
              },
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
