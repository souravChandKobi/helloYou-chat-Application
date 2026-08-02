import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ss_chat/api/apis.dart';
import 'package:ss_chat/pageTransitions/slide_animation.dart';
import 'package:ss_chat/screens/chat_screen_group.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  // --------------------- Text Controller ---------------------
  final _groupNameController = TextEditingController();

  // --------------------- Build Method ---------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --------------------- App Bar ---------------------
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Row(children: [Text('New Group')]),
      ),

      backgroundColor: const Color.fromARGB(255, 0, 12, 1),

      // --------------------- Body ---------------------
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.02,
          bottom: MediaQuery.of(context).size.height * 0.005,
          left: MediaQuery.of(context).size.width * 0.02,
          right: MediaQuery.of(context).size.width * 0.02,
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.image_search_rounded),
              color: Colors.white,
            ),

            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.0,
                  right: MediaQuery.of(context).size.width * 0.05,
                ),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  controller: _groupNameController,
                  decoration: InputDecoration(
                    hintText: 'Group Name',
                    hintStyle: TextStyle(
                      color: const Color.fromARGB(255, 184, 178, 178),
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 47, 49, 48),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.black),
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.black),
                    ),

                    contentPadding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.height * 0.03,
                      vertical: MediaQuery.of(context).size.height * 0.03,
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

      // --------------------- Floating Action Button ---------------------
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_groupNameController.text.trim().isEmpty) return;

          // Create the group and get the returned Group object
          final group = await APIs.createGroup(
            groupName: _groupNameController.text.trim(),
            members: [APIs.user.uid],
          );

          log('Group Created: ${group.groupName}');

          Navigator.of(context).pushAndRemoveUntil(
            SlideFromRightPageRoute(
              page: GroupChatScreen(group: group),
              duration: const Duration(milliseconds: 100), // slower
              reverseDuration: const Duration(milliseconds: 50),
            ),
            (route) => route.isFirst,
          );

          // await APIs.createGroup(groupName: 'Test Create Group', members: [APIs.user.uid,]);
          // log('Group Created');
        },
        backgroundColor: Color(0xFF97d68f),
        child: Icon(Icons.check_rounded, color: Colors.black),
      ),
    );
  }
}
