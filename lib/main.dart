import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    hide NotificationVisibility;
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:flutter_notification_channel/notification_visibility.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ss_chat/helper/notification_lifecycle_event_handler.dart';
import 'package:ss_chat/models/chat_user.dart';
import 'package:ss_chat/models/groups.dart';
import 'package:ss_chat/screens/chat_screen.dart';
import 'package:ss_chat/screens/chat_screen_group.dart';
import 'package:ss_chat/screens/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// --------------------- Global Variables ---------------------

/// Global navigator key used to navigate from notification callbacks
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Flutter Local Notifications plugin instance
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    ChatUser? user;


/// --------------------- Main Entry Point ---------------------
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: "keys.env");
  await _initializeFirebase();
  await initializeNotifications();
  

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  runApp(MyApp());
}

/// --------------------- Root Widget ---------------------
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    setupNotificationNavigation();

//     Connectivity().onConnectivityChanged.listen((result) async {
//   if (result != ConnectivityResult.none) {
//     // Find all unsent messages (sentAt == '')
//     final chats = await firestore.collectionGroup('messages')
//         .where('fromId', isEqualTo: user!.id)
//         .where('sentAt', isEqualTo: '')
//         .get();

//     for (var doc in chats.docs) {
//       await doc.reference.update({
//         'sentAt': DateTime.now().millisecondsSinceEpoch.toString(),
//       });
//     }
//     log('✅ Resent pending messages');
//   }
// });


    // Clear all notifications when app starts or comes to foreground
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _clearAllNotifications();
    });

    // Also clear notifications whenever app resumes
    WidgetsBinding.instance.addObserver(
      NotificationLifeCycleEventHandler(
        resumeCallBack: () async => _clearAllNotifications(),
      ),
    );
  }

  // --------------------- Notification Helpers ---------------------

  /// Cancels all displayed notifications
  void _clearAllNotifications() {
    flutterLocalNotificationsPlugin.cancelAll();
  }

  /// Handles navigation triggered from notifications
  void setupNotificationNavigation() {
    // App in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleNotificationNavigation(message);
    });

    // App terminated
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) handleNotificationNavigation(message);
    });
  }

  /// Directs the user to the appropriate screen based on notification data
  Future<void> handleNotificationNavigation(RemoteMessage message) async {
    final data = message.data;

    // --------------------- Private Chat ---------------------
    if (data['type'] == 'chat_message') {
      final chatUserId = data['fromId'];

      // Fetch ChatUser from Firestore
      final doc = await FirebaseFirestore.instance
          .collection('usersBeta')
          .doc(chatUserId)
          .get();

      if (!doc.exists) return;

      final chatUser = ChatUser.fromJson(doc.data()!);

      // Navigate to private chat screen
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => ChatScreen(user: chatUser)),
        (route) => route.isFirst,
      );
    }

    // --------------------- Group Chat ---------------------
    if (data['type'] == 'group_chat_message') {
      final groupId = data['groupId'];

      // Fetch group data from Firestore
      final doc = await FirebaseFirestore.instance
          .collection('groupsBeta')
          .doc(groupId)
          .get();

      if (!doc.exists) return;

      final group = Group.fromJson(doc.data()!, doc.id);

      // Navigate to group chat screen
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => GroupChatScreen(group: group)),
        (route) => route.isFirst,
      );
    }
  }

  // --------------------- Build ---------------------
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'helloYou!',
      theme: ThemeData(
        textTheme: GoogleFonts.workSansTextTheme(
          Theme.of(context).textTheme.apply(
            bodyColor: Colors.white70, // global text color
            displayColor: Colors.white, // for headlines
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromARGB(255, 2, 29, 3),
          titleTextStyle: GoogleFonts.workSans(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      home: FirebaseAuth.instance.currentUser != null
          ? HomeScreen()
          : LoginScreen(),
    );
  }
}

/// --------------------- Firebase Initialization ---------------------
Future<void> _initializeFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

/// --------------------- Notifications Setup ---------------------
Future<void> initializeNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initSettings = InitializationSettings(
    android: androidSettings,
  );

  // Register notification channel
  var result = await FlutterNotificationChannel().registerNotificationChannel(
    description: 'For showing message notifications',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chats',
    visibility: NotificationVisibility.VISIBILITY_PUBLIC,
    allowBubbles: true,
    enableVibration: true,
    enableSound: true,
    showBadge: true,
  );

  log('Notification channel: $result');

  // Request notification permission (Android 13+)
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
}
