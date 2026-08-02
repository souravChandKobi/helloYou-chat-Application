import 'dart:developer';
import 'dart:math' hide log;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ss_chat/api/apis.dart';
import 'package:ss_chat/models/chat_user.dart';

/// --------------------- Add Member Screen ---------------------
class AddMemberScreen extends StatefulWidget {
  final String groupId;
  const AddMemberScreen({super.key, required this.groupId});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  // Controller for the email input field
  final _memberEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: APIs.getAllUsers(),
      builder: (context, snapshot) {
        // Storing the list of users data in listOfUsers
        final listOfUsers = snapshot.data ?? [];
        final emailList = listOfUsers.map((u) => u.email).toList();

        return Scaffold(
          /// --------------------- App Bar ---------------------
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Row(children: [Text('Add Members')]),
          ),

          backgroundColor: const Color.fromARGB(255, 0, 12, 1),

          /// --------------------- Body ---------------------
          body: Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.03,
              bottom: MediaQuery.of(context).size.height * 0.005,
              left: MediaQuery.of(context).size.width * 0.02,
              right: MediaQuery.of(context).size.width * 0.02,
            ),
            child: Row(
              children: [
                // IconButton(
                //   onPressed: () {},
                //   icon: const Icon(Icons.image_search_rounded, color: Colors.white),
                // ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                      right: MediaQuery.of(context).size.width * 0.05,
                    ),
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: _memberEmailController,
                      decoration: InputDecoration(
                        hintText: 'Email address',
                        hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 184, 178, 178),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 47, 49, 48),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal:
                              max(
                                MediaQuery.of(context).size.height,
                                MediaQuery.of(context).size.width,
                              ) *
                              0.03,
                          vertical:
                              max(
                                MediaQuery.of(context).size.height,
                                MediaQuery.of(context).size.width,
                              ) *
                              0.03,
                        ),
                      ),
                    ),
                  ),
                ),

                // IconButton(
                //   onPressed: () {},
                //   icon: Icon(Icons.image_search_rounded),
                // ),
              ],
            ),
          ),

          /// --------------------- Floating Action Button ---------------------
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              if (_memberEmailController.text.trim().isEmpty) return;

              final typedEmail = _memberEmailController.text.trim();

              // Find user to add
              late final ChatUser userToAdd;
              try {
                userToAdd = listOfUsers.firstWhere(
                  (u) => u.email.toLowerCase() == typedEmail.toLowerCase(),
                );
              } catch (e) {
                log('Error: $e');
                _memberEmailController.clear();
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'User Not Found!!!',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Color.fromARGB(255, 175, 0, 0),
                    showCloseIcon: true,
                  ),
                );
                return;
              }

              log("listOfUsers: $emailList");

              if (emailList.contains(typedEmail)) {
                log('Email: $userToAdd');
                await FirebaseFirestore.instance
                    .collection('groupsBeta')
                    .doc(widget.groupId)
                    .update({
                      'members': FieldValue.arrayUnion([userToAdd.id]),
                    });

                _memberEmailController.clear();

                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Added ${userToAdd.name} to the group',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    backgroundColor: Colors.green,
                    showCloseIcon: true,
                  ),
                );

                log('CURRENT GROUP ID: ${widget.groupId}');
              } else {
                log('User not found!!');
              }

              /// --------------------- Commented Code ---------------------
              // final userToAdd = listOfUsers
              //     .firstWhere(
              //       (u) => u.email.toLowerCase() == typedEmail.toLowerCase(),
              //       orElse: () => null,
              //     )
              //     .id;

              // if (userToAdd != null) {
              //   // add to Firestore
              // } else {
              //   // user not found
              // }

              // Create the group and get the returned Group object
              // final group = await APIs.createGroup(
              //   groupName: _memberEmailController.text.trim(),
              //   members: [APIs.user.uid],
              // );
              // log('Member Added: ${group.groupName}');
              // Navigator.of(context).pushAndRemoveUntil(
              //   SlideFromRightPageRoute(
              //     page: GroupChatScreen(group: group),
              //     duration: const Duration(milliseconds: 100), // slower
              //     reverseDuration: const Duration(milliseconds: 50),
              //   ),
              //   (route)=>route.isFirst,
              // );
            },
            backgroundColor: const Color(0xFF97d68f),
            child: const Icon(Icons.check_rounded, color: Colors.black),
          ),
        );
      },
    );
  }
}
