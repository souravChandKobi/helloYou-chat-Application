import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ss_chat/pageTransitions/slide_animation.dart';
import 'package:ss_chat/screens/create_group_screen.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  // --------------------- Build Method ---------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 12, 1),

      // --------------------- App Bar ---------------------
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Row(
          children: [
            Image.asset('images/icon.png', height: 30),
            SizedBox(width: 10),
            Text('helloYou!', style: TextStyle(color: Colors.white)),
          ],
        ),

        //options menu 3 dot
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white), // three-dot icon
            // Offset: x=0, y = AppBar height (kToolbarHeight) + extra spacing
            offset: Offset(0, kToolbarHeight),
            color: Color.fromARGB(255, 0, 15, 1),

            // offset: Offset(0, 55),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'profile',
                child: Text('profile', style: TextStyle(color: Colors.white)),
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
                case 'profile':
                  log("profile clicked");

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (_) => ProfileScreen(user: APIs.me),
                  //   ),
                  // );
                  break;
                case 'help':
                  log("Help clicked");
                  break;
                case 'sign out':
                  log("Sign Out clicked");

                  // await logout();
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(builder: (_) => LoginScreen()),
                  // );

                  break;
              }
            },
          ),
        ],
      ),

      // --------------------- Body ---------------------
      body: Column(
        children: [

          // --------------------- Create New Group Card ---------------------
          SizedBox(
            height: 80,
            width: double.infinity,
            child: Card(
              //chat cards design
              margin: EdgeInsets.symmetric(horizontal: 0, vertical: 2),
              shape: BoxBorder.symmetric(),
              color: Color.fromARGB(255, 0, 12, 1),
              child: InkWell(
                onTap: () async {
                  await Future.delayed(Duration(milliseconds: 150));
                  // await APIs.createGroup(
                  //   groupName: 'Test Create Group',
                  //   members: [APIs.user.uid],
                  // );
                  // log('Group Created');

                  Navigator.of(context).push(
                    SlideFromRightPageRoute(
                      page: CreateGroupScreen(),
                      duration: const Duration(milliseconds: 100), // slower
                      reverseDuration: const Duration(milliseconds: 50),
                    ),
                  );
                },
                child: Center(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xFF97d68f),
                      child: Icon(Icons.group_add_outlined),
                    ),

                    title: Text(
                      'New Group',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // --------------------- Add New Contact Card ---------------------
          SizedBox(
            height: 80,
            width: double.infinity,
            child: Card(
              //chat cards design
              margin: EdgeInsets.symmetric(horizontal: 0, vertical: 2),
              shape: BoxBorder.symmetric(),
              color: Color.fromARGB(255, 0, 12, 1),
              child: InkWell(
                onTap: () async {
                  await Future.delayed(Duration(milliseconds: 150));
                },
                child: Center(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 40,
                      backgroundColor: Color(0xFF97d68f),
                      child: Icon(Icons.person_add_alt_outlined),
                    ),

                    title: Text(
                      'New Contact',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
