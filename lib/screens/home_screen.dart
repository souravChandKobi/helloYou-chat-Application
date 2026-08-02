import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ss_chat/api/apis.dart';
import 'package:ss_chat/models/chat_user.dart';
import 'package:ss_chat/pageTransitions/slide_animation.dart';
import 'package:ss_chat/screens/auth/login_screen.dart';
import 'package:ss_chat/screens/chat_card_screen.dart';
import 'package:ss_chat/screens/contacts_screen.dart';
import 'package:ss_chat/screens/groups_card_screen.dart';
import 'package:ss_chat/screens/me_profile_screen.dart';
import 'package:ss_chat/xxxxxx/examapleediting.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key,});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // --------------------- Variables ---------------------
  List<ChatUser> list = [];
  late TabController _tabController;
  int _bottomNavBarIndex = 0;

  // --------------------- Init State ---------------------
  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();

    _tabController = TabController(vsync: this, length: 2);

    // keep bottom nav in sync when swiping tabs
    _tabController.addListener(() {
      if (_bottomNavBarIndex != _tabController.index) {
        setState(() {
          _bottomNavBarIndex = _tabController.index;
        });
      }
    });
  }

  // --------------------- Dispose ---------------------
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // --------------------- Build Method ---------------------
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // extendBody: true,
        backgroundColor: Color.fromARGB(255, 0, 12, 1),

        // --------------------- AppBar ---------------------
        appBar: AppBar(
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
              icon: Icon(Icons.more_vert, color: Colors.white),
              offset: Offset(0, kToolbarHeight),
              color: Color.fromARGB(255, 0, 15, 1),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'profile',
                  child: Text('profile', style: TextStyle(color: Colors.white)),
                ),
                PopupMenuItem(
                  value: 'Call Test',
                  child: Text(
                    'Call Test',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                PopupMenuItem(
                  value: 'sign out',
                  child: Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
              onSelected: (value) async {
                switch (value) {
                  case 'profile':
                    log("profile clicked");

                    Navigator.of(context).push(
                      SlideFromRightPageRoute(
                        page: ProfileScreen(user: APIs.me),
                      ),
                    );
                    break;
                  case 'Call Test':
                    log("Call Test clicked");

                    Navigator.of(context).push(
                      SlideFromRightPageRoute(
                        page: EditableProfile()
                      ),
                    );
                    break;
                  case 'sign out':
                    log("Sign Out clicked");
                    await logout();
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

        // --------------------- Body ---------------------
        body: Column(
          children: [
            // TextField(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  const ChatCardScreen(),
                  const GroupsCardScreen(),
                ],
              ),
            ),
          ],
        ),

        // --------------------- Bottom Navigation ---------------------
        bottomNavigationBar: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            backgroundColor: Color.fromARGB(255, 0, 24, 10),
            type: BottomNavigationBarType.fixed,
            currentIndex: _bottomNavBarIndex,
            onTap: (index) {
              setState(() {
                _bottomNavBarIndex = index;
                _tabController.animateTo(index);
              });
            },
            selectedItemColor: Color(0xFF97d68f),
            unselectedItemColor: Colors.grey,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_rounded),
                label: 'Chats',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.groups_2_rounded),
                label: 'Groups',
              ),
            ],
          ),
        ),

        // --------------------- Floating Action Button ---------------------
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            Navigator.of(context).push(
              SlideFromRightPageRoute(
                page: ContactsScreen(),
                duration: const Duration(milliseconds: 100),
                reverseDuration: const Duration(milliseconds: 50),
              ),
            );

            // Navigator.push(context, MaterialPageRoute(builder: (_) => ContactsScreen()));

            // await APIs.createGroup(groupName: 'Test Create Group', members: [APIs.user.uid,]);
            // log('Group Created');
          },
          backgroundColor: Color(0xFF97d68f),
          child: _bottomNavBarIndex == 0
              ? Icon(Icons.add_comment_rounded, color: Colors.black)
              : Icon(Icons.group_add_sharp, color: Colors.black),
        ),

        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  // --------------------- Logout ---------------------
  Future logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn.instance.signOut();
  }
}

// --------------------- Notifications (Commented Out) ---------------------
// Future<void> initializeNotifications() async {
//   const AndroidInitializationSettings androidSettings =
//       AndroidInitializationSettings('@mipmap/ic_launcher');

//   final InitializationSettings initSettings = InitializationSettings(
//     android: androidSettings,
//   );

//   // await flutterLocalNotificationsPlugin.initialize(
//   //   initSettings,
//   //   onDidReceiveNotificationResponse: (details) {
//   //     flutterLocalNotificationsPlugin.cancelAll();
//   //   },
//   // );

//   var result = await FlutterNotificationChannel().registerNotificationChannel(
//     description: 'For showing Message Notification',
//     id: 'chats',
//     importance: NotificationImportance.IMPORTANCE_HIGH,
//     name: 'Chats',
//     visibility: NotificationVisibility.VISIBILITY_PUBLIC,
//     allowBubbles: true,
//     enableVibration: true,
//     enableSound: true,
//     showBadge: true,
//   );
//   log('Notification channel : $result');

//   await FirebaseMessaging.instance.requestPermission(
//     alert: true,
//     badge: true,
//     sound: true,
//   );
// }

// Widget to detect incoming calls
// class IncomingCallButton extends StatelessWidget {
//   final String currentUserId;
//   const IncomingCallButton({super.key, required this.currentUserId});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('calls')
//           .where('calleeId', isEqualTo: currentUserId)
//           .where('status', isEqualTo: 'calling')
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return SizedBox();

//         // Show the first incoming call
//         final doc = snapshot.data!.docs.first;
//         final callId = doc.id;
//         final callerId = doc['callerId'];

//         return ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.green,
//             padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//           ),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => CallScreen(
//                   callId: callId,
//                   isCaller: false,
//                   currentUserId: currentUserId,
//                   otherUserId: callerId,
//                 ),
//               ),
//             );
//           },
//           child: Text('Answer call from $callerId'),
//         );
//       },
//     );
//   }
// }
