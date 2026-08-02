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
import 'package:ss_chat/api/apis.dart';
import 'package:ss_chat/models/chat_user.dart';
import 'package:ss_chat/models/groups.dart';
import 'package:ss_chat/pageTransitions/slide_animation.dart';
import 'package:ss_chat/screens/add_member_screen.dart';
import 'package:ss_chat/widgets/fullScreenImage.dart';
import 'package:ss_chat/widgets/model_bottom_sheet.dart';

class ProfileScreenGroup extends StatefulWidget {
  final Group group;
  const ProfileScreenGroup({super.key, required this.group});

  @override
  State<ProfileScreenGroup> createState() => _ProfileScreenGroupState();
}

class _ProfileScreenGroupState extends State<ProfileScreenGroup> {
  //   late final Stream<List<Map<String, dynamic>>> membersStream;

  //   @override
  // void initState() {
  //   super.initState();
  //   membersStream = APIs.getGroupMembersStream(widget.group.members);
  // }

  // --------------------- Build Method ---------------------
  @override
  Widget build(BuildContext context) {
    // var names = widget.user.name.split(' ');
    // String formattedName;

    // if (names.length == 2) {
    //   // Two names → each on separate line
    //   formattedName = '${names[0]}\n${names.skip(1).join(' ')}';
    // } else if (names.length >= 3) {
    //   // Three or more → first two names on first line, rest on second line
    //   formattedName = '${names[0]} ${names[1]}\n${names.sublist(2).join(' ')}';
    // } else {
    //   // Only one name
    //   formattedName = names[0];
    // }

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
              PopupMenuItem(value: 'settings', child: Text('Settings',style: TextStyle(color: Colors.white))),
              PopupMenuItem(value: 'Add Member', child: Text('Add Member',style: TextStyle(color: Colors.white))),
              // PopupMenuItem(value: 'sign out', child: Text('Sign Out')),
            ],
            onSelected: (value) async {
              switch (value) {
                case 'settings':
                  log("Settings clicked");
                  break;
                case 'Add Member':
                  Navigator.of(context).push(
                    SlideFromRightPageRoute(
                      page: AddMemberScreen(groupId: widget.group.id),
                    ),
                  );
                  log('Current Group ID gcs: ${widget.group.id}');
                  log("\nAdd Member clicked");
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

      // body: Stack(
      //   children: [
      //     // --------------------- Profile Picture ---------------------
      //     SizedBox(
      //       height: MediaQuery.of(context).size.width, // square image
      //       width: double.infinity,
      //       child: CachedNetworkImage(
      //         imageUrl: widget.group.groupName,
      //         fit: BoxFit.cover,
      //         placeholder: (context, url) => const Center(
      //           child: CircularProgressIndicator(strokeWidth: 2),
      //         ),
      //         errorWidget: (context, url, error) =>
      //             const Icon(CupertinoIcons.person, size: 30),
      //       ),
      //     ),

      //     // Container(),

      //     // --------------------- Bottom Container ---------------------
      //     Align(
      //       alignment: Alignment.bottomCenter,
      //         child: Container(
      //           height:
      //               MediaQuery.of(context).size.height * 0.45, // take lower part
      //           width: double.infinity,
      //           decoration: const BoxDecoration(
      //             color: Colors.grey,
      //             borderRadius: BorderRadius.only(
      //               topLeft: Radius.circular(30),
      //               topRight: Radius.circular(30),
      //             ),
      //           ),

      //           child: Padding(
      //             padding: const EdgeInsets.all(30),

      //             child: SingleChildScrollView(
      //               physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      //               child: Column(
      //                 // mainAxisAlignment: MainAxisAlignment.end,
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   //Name
      //                   Text(
      //                     widget.group.groupName,
      //                     style: GoogleFonts.workSans(
      //                       fontSize: MediaQuery.of(context).size.height * 0.06,
      //                       fontWeight: FontWeight.w800,
      //                       color: Colors.white,
      //                     ),
      //                   ),
      //                   //Email
      //                   SingleChildScrollView(
      //                     scrollDirection: Axis.horizontal,
      //                     child: GestureDetector(
      //                       onLongPress: () {
      //                         Clipboard.setData(
      //                           ClipboardData(text: widget.group.id),
      //                         );
      //                         ScaffoldMessenger.of(context).showSnackBar(
      //                           SnackBar(
      //                             content: Text(" Copied to Clipboard"),
      //                             behavior: SnackBarBehavior.floating,
      //                           ),
      //                         );
      //                       },
      //                       child: Text(
      //                         widget.group.id,
      //                         style: GoogleFonts.workSans(
      //                           fontSize:
      //                               MediaQuery.of(context).size.height * 0.03,
      //                           color: Colors.white54,
      //                           fontWeight: FontWeight.w400,
      //                         ),
      //                       ),
      //                     ),
      //                   ),
      //                   //About
      //                   Container(
      //                     // color: Colors.black,
      //                     // height: MediaQuery.of(context).size.height * 0.3,
      //                     width: double.infinity,
      //                     child: SingleChildScrollView(
      //                       child: Text(
      //                         '\n${widget.group.admin}',
      //                         style: GoogleFonts.workSans(
      //                           fontSize:
      //                               MediaQuery.of(context).size.height * 0.02,
      //                           fontWeight: FontWeight.w300,
      //                           color: Colors.white,
      //                         ),
      //                       ),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           ),
      //         ),
      //     ),
      //   ],
      // ),
      body: Stack(
        children: [
          // --------------------- Background Image ---------------------
          GestureDetector(
            onTap: () {
                    log('me Profile Image Clicked');
                    if(widget.group.image.trim().isNotEmpty){Navigator.push(context, MaterialPageRoute(builder: (_)=>FullScreenImage(imageUrl: widget.group.image)));}
                  },
            child: SizedBox(
              height: MediaQuery.of(context).size.width,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.group.image,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      CupertinoIcons.person,
                      size: 60,
                      color: Colors.white,
                    ),
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

          // --------------------- Bottom Container ---------------------
          DraggableScrollableSheet(
            initialChildSize: 0.55, // Start height (fraction of screen)
            minChildSize: 0.55, // Minimum height when dragged down
            maxChildSize: 0.90, // Max height when dragged up
            builder: (context, scrollController) {
              return Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 2, 29, 3),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.all(30),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Group Name:',
                            style: GoogleFonts.workSans(
                              fontSize:
                                  max(
                                MediaQuery.of(context).size.height,
                                MediaQuery.of(context).size.width,
                              ) * 0.015,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                            ),
                          ),
                          // Group Name
                          Text(
                            widget.group.groupName,
                            style: GoogleFonts.workSans(
                              fontSize:
                                  max(
                                MediaQuery.of(context).size.height,
                                MediaQuery.of(context).size.width,
                              ) * 0.04,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),

                          // Group ID
                          GestureDetector(
                            onLongPress: () {
                              Clipboard.setData(
                                ClipboardData(text: widget.group.id),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Copied to Clipboard"),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                'id: ${widget.group.id}',
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

                          const SizedBox(height: 20),

                          // --------------------- Admin ---------------------

                          // --------------------- Realtime Group + Members ---------------------
                          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection('groupsBeta')
                                .doc(widget.group.id)
                                .snapshots(),
                            builder: (context, groupSnapshot) {
                              if (groupSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (!groupSnapshot.hasData ||
                                  !groupSnapshot.data!.exists) {
                                return const Text(
                                  'Group not found',
                                  style: TextStyle(color: Colors.white70),
                                );
                              }

                              final groupData = groupSnapshot.data!.data()!;
                              final adminId = groupData['admin'];
                              final memberIds = List<String>.from(
                                groupData['members'],
                              );

                              // Stream for the Admin User
                              return StreamBuilder<
                                DocumentSnapshot<Map<String, dynamic>>
                              >(
                                stream: FirebaseFirestore.instance
                                    .collection('usersBeta')
                                    .doc(adminId)
                                    .snapshots(),
                                builder: (context, adminSnapshot) {
                                  if (adminSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  }

                                  if (!adminSnapshot.hasData ||
                                      !adminSnapshot.data!.exists) {
                                    return const Text(
                                      'Admin not found',
                                      style: TextStyle(color: Colors.white70),
                                    );
                                  }

                                  final adminData = adminSnapshot.data!.data()!;

                                  // Now stream the members
                                  return StreamBuilder<
                                    List<Map<String, dynamic>>
                                  >(
                                    stream: APIs.getGroupMembersStream(
                                      memberIds,
                                    ),
                                    builder: (context, memberSnapshot) {
                                      if (memberSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      }

                                      if (!memberSnapshot.hasData ||
                                          memberSnapshot.data!.isEmpty) {
                                        return const Text(
                                          'No members found',
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                        );
                                      }

                                      final members = memberSnapshot.data!;

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Admin: ${adminData['name']}',
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
                                          const SizedBox(height: 15),

                                          // Members list
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: members.map((user) {
                                              return InkWell(
                                                onTap: () {
                                                  showModalBottomSheet(
                                                    context: context,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    isScrollControlled: true,
                                                    builder: (context) =>
                                                        UserProfileModalSheet(
                                                          user:
                                                              ChatUser.fromJson(
                                                                user,
                                                              ),
                                                        ),
                                                  );
                                                },
                                                child: ListTile(
                                                  contentPadding:
                                                      EdgeInsets.zero,
                                                  leading: CircleAvatar(
                                                    backgroundImage:
                                                        CachedNetworkImageProvider(
                                                          user['image'],
                                                        ),
                                                  ),
                                                  title: Text(
                                                    user['name'],
                                                    style: GoogleFonts.workSans(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    user['email'] ?? '',
                                                    style: GoogleFonts.workSans(
                                                      color: Colors.white54,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),

                          // StreamBuilder<DocumentSnapshot>(
                          //   stream: FirebaseFirestore.instance
                          //       .collection('usersBeta')
                          //       .doc(widget.group.admin)
                          //       .snapshots(),
                          //   builder: (context, adminSnapshot) {
                          //     if (adminSnapshot.connectionState ==
                          //         ConnectionState.waiting) {
                          //       return const CircularProgressIndicator();
                          //     }

                          //     if (!adminSnapshot.hasData ||
                          //         !adminSnapshot.data!.exists) {
                          //       return const Text(
                          //         'Admin not found',
                          //         style: TextStyle(color: Colors.white70),
                          //       );
                          //     }

                          //     final adminData =
                          //         adminSnapshot.data!.data()
                          //             as Map<String, dynamic>;

                          //     return Column(
                          //       crossAxisAlignment: CrossAxisAlignment.start,
                          //       children: [
                          //         Text(
                          //           'Admin: ${adminData['name']}',
                          //           style: GoogleFonts.workSans(
                          //             fontSize:
                          //                 MediaQuery.of(context).size.height *
                          //                 0.02,
                          //             fontWeight: FontWeight.w300,
                          //             color: Colors.white,
                          //           ),
                          //         ),
                          //         const SizedBox(height: 15),

                          //         // --------------------- Members List ---------------------
                          //         StreamBuilder<List<Map<String, dynamic>>>(
                          //       stream: membersStream,
                          //           builder: (context, snapshot) {
                          //             if (snapshot.connectionState ==
                          //                 ConnectionState.waiting) {
                          //               return const Padding(
                          //                 padding: EdgeInsets.all(8.0),
                          //                 child: CircularProgressIndicator(),
                          //               );
                          //             }

                          //             if (!snapshot.hasData ||
                          //                 snapshot.data!.isEmpty) {
                          //               return const Padding(
                          //                 padding: EdgeInsets.all(8.0),
                          //                 child: Text(
                          //                   'No members found',
                          //                   style: TextStyle(
                          //                     color: Colors.white70,
                          //                   ),
                          //                 ),
                          //               );
                          //             }

                          //             final members = snapshot.data!;

                          //             return Column(
                          //               crossAxisAlignment:
                          //                   CrossAxisAlignment.start,
                          //               children: members.map((user) {
                          //                 return InkWell(
                          //                   //ON TAPPING THE USER TILE
                          //                   onTap: () {
                          //                     // Navigator.of(context).push(
                          //                     //   SlideFromRightPageRoute(
                          //                     //     page: ChatScreen(user: ChatUser.fromJson(user)),
                          //                     //     duration: const Duration(
                          //                     //       milliseconds: 100,
                          //                     //     ),
                          //                     //     reverseDuration: const Duration(
                          //                     //       milliseconds: 50,
                          //                     //     ),
                          //                     //   ),
                          //                     // );

                          //                     showModalBottomSheet(
                          //                       context: context,
                          //                       backgroundColor: Colors
                          //                           .transparent, // to show curved top
                          //                       isScrollControlled: true,
                          //                       builder: (context) =>
                          //                           UserProfileModalSheet(
                          //                             user: ChatUser.fromJson(
                          //                               user,
                          //                             ),
                          //                           ),
                          //                     );
                          //                   },
                          //                   child: ListTile(
                          //                     contentPadding: EdgeInsets.zero,
                          //                     leading: CircleAvatar(
                          //                       backgroundImage:
                          //                           CachedNetworkImageProvider(
                          //                             user['image'],
                          //                           ),
                          //                     ),
                          //                     title: Text(
                          //                       user['name'],
                          //                       style: GoogleFonts.workSans(
                          //                         color: Colors.white,
                          //                       ),
                          //                     ),
                          //                     subtitle: Text(
                          //                       user['email'] ?? '',
                          //                       style: GoogleFonts.workSans(
                          //                         color: Colors.white54,
                          //                       ),
                          //                     ),
                          //                   ),
                          //                 );
                          //               }).toList(),
                          //             );
                          //           },
                          //         ),
                          //       ],
                          //     );
                          //   },
                          // ),
                        ],
                      ),
                    ),
                  ),
                  
                  //ADD MEMBER ICON
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          SlideFromRightPageRoute(
                            page: AddMemberScreen(groupId: widget.group.id),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.person_add_alt_1_rounded,
                        color: Colors.white,
                        size: max(
                                MediaQuery.of(context).size.height,
                                MediaQuery.of(context).size.width,
                              ) * 0.03,
                      ),
                    ),
                  ),
                ],
              );
            },
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
