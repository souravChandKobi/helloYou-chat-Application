import 'dart:convert';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'package:ss_chat/api/access_firebase_token.dart';
import 'package:ss_chat/models/chat_user.dart';
import 'package:ss_chat/models/group_messages.dart';
import 'package:ss_chat/models/groups.dart';
import 'package:ss_chat/models/message.dart';

final firestoreAppId = dotenv.env['firestoreAppId'];

class APIs {
  
  // ---------------------------------------------------------------------------
  // Firebase Instances
  // ---------------------------------------------------------------------------

  static FirebaseAuth auth = FirebaseAuth.instance; // Firebase Authentication
  static FirebaseFirestore firestore = FirebaseFirestore.instance; // Firestore
  static FirebaseMessaging fMessaging = FirebaseMessaging.instance; // FCM

  // ---------------------------------------------------------------------------
  // Current User Information
  // ---------------------------------------------------------------------------

  static late ChatUser me; // Currently logged-in user

  static User get user => auth.currentUser!; // Get Firebase current user

  // ---------------------------------------------------------------------------
  // Firebase Messaging Token Handling
  // ---------------------------------------------------------------------------

  static Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();
    String? t = await fMessaging.getToken();

    me.pushToken = t!;

    await firestore.collection('usersBeta').doc(me.id).update({
      'push_token': t,
    });

    log('Push Token: $t');
    }

  // ---------------------------------------------------------------------------
  // Push Notification (1:1 Chat)
  // ---------------------------------------------------------------------------

  static Future<void> sendPushNotification(
    ChatUser chatUser,
    String msg,
    // String msgId,
  ) async {
    if (chatUser.pushToken.isEmpty) {
      log('Cannot send push notification: empty token');
      return;
    }

    AccessFirebaseToken accessToken = AccessFirebaseToken(); // Service Account
    String bearerToken = await accessToken.getAccessToken();

    final body = {
      "message": {
        "token": chatUser.pushToken,
        "notification": {"title": me.name, "body": msg},
        "android": {
          "notification": {
            "channel_id": "chats",
            "tag": "chat_${me.id}",
            "default_sound": true,
            "default_vibrate_timings": true,
          },
        },
        "data": {
          // "msgId": msgId,
          "fromId": me.id,
          "toId": chatUser.id,
          "type": "chat_message",
        },
      },
    };

    try {
      var res = await post(
        Uri.parse(
          'https://fcm.googleapis.com/v1/projects/$firestoreAppId/messages:send',
        ),
        headers: {
          "content-Type": "application/json",
          'Authorization': 'Bearer $bearerToken',
        },
        body: jsonEncode(body),
      );

      log('USER ID: ${me.id}');
      log("Response statusCode: ${res.statusCode}");
      log("Response body: ${res.body}");
    } catch (e) {
      log("\nsendPushNotification: $e");
    }
  }

  // ---------------------------------------------------------------------------
  // User Account Management
  // ---------------------------------------------------------------------------

  // Check if user exists in Firestore
  static Future<bool> userExists() async {
    return (await firestore.collection('usersBeta').doc(user.uid).get()).exists;
  }

  // Fetch current user information
  static Future<void> getSelfInfo() async {
    await firestore.collection('usersBeta').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = ChatUser.fromJson(user.data()!);

        await getFirebaseMessagingToken(); // May throw exception due to multiple requests
        log('\nCurrent user Data: ${user.data()}');
      } else {
        await createUser().then((onValue) => getSelfInfo());
      }
    });

    // String photoURL= user.photoURL.toString();

    // String hdProfilePicture = photoURL.replaceAll(RegExp(r"s\d+-c"), "s2048-c");
    // log("profile picture: $hdProfilePicture");


  }

  // Create a new user in Firestore
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUser(
      id: user.uid,
      name: user.displayName.toString(),
      email: user.email.toString(),
      about: "Hey, I'm using hello you!",
      image: (user.photoURL.toString()).replaceAll(RegExp(r"s\d+-c"), "s2048-c"),
      createdAt: time,
      isOnline: false,
      lastActive: time,
      pushToken: '',
    );

    return await firestore
        .collection('usersBeta')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  // ---------------------------------------------------------------------------
  // User List and Activity
  // ---------------------------------------------------------------------------

  // Stream: All users sorted by last message time
  static Stream<List<ChatUser>> getAllUsers() {
    return firestore
        .collection('usersBeta')
        .where('id', isNotEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs.map((e) => ChatUser.fromJson(e.data())).toList();
          list.sort(
            (a, b) => int.parse(b.lastMessageTime)
                .compareTo(int.parse(a.lastMessageTime)),
          );
          return list;
        });
  }

  // Update user's online or last active status
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('usersBeta').doc(user.uid).update({
      'push_token': me.pushToken,
    });
  }

  // ---------------------------------------------------------------------------
  // Chat Screen APIs
  // ---------------------------------------------------------------------------

  // Generate unique conversation ID
  static String getConversationID(String id) =>
      user.uid.hashCode <= id.hashCode ? '${user.uid}_$id' : '${id}_${user.uid}';

  // Stream: All messages in a conversation
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
    ChatUser chatUser,
  ) {
    return firestore
        .collection('chatsBeta/${getConversationID(chatUser.id)}/messages/')
        .snapshots();
  }

  // Send a chat message
  static Future<void> sendMessage(ChatUser chatUser, String msg, Type type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final Message message = Message(
      msg: msg,
      toId: chatUser.id,
      read: '',
      type: type,
      fromId: user.uid,
      sentAt: time,
      dbReceivedAt: '',
    );

    final ref = firestore.collection('chatsBeta/${getConversationID(chatUser.id)}/messages/').doc(time);

   await ref.set({
    ...message.toJson(),
    'dbReceivedAt': FieldValue.serverTimestamp(), 
  }).then((_) {
    // Send push notification after successful write
    sendPushNotification(
      chatUser,
      message.type == Type.text ? msg : 'image',
    );
  });
        // Save message with server timestamp for receivedAt
  // await ref.doc(time).set({
  //   ...message.toJson(),
  //   'dbReceivedAt': FieldValue.serverTimestamp(), // Firestore will handle server time
  // });

    // Update last message info for both users
    await firestore.collection('usersBeta').doc(user.uid).update({
      'last_message': msg,
      'last_message_time': time,
    });

    await firestore.collection('usersBeta').doc(chatUser.id).update({
      'last_message': msg,
      'last_message_time': time,
    });
  }

  // Stream: Last message in a conversation
  static Stream<Message?> getLastMessage(ChatUser chatUser) {
    final conversationId = getConversationID(chatUser.id);

    return firestore
        .collection('chatsBeta/$conversationId/messages')
        .orderBy('sentAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return null;
          return Message.fromJson(snapshot.docs.first.data());
        });
  }

  // Update message read status
  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chatsBeta/${getConversationID(message.fromId)}/messages/')
        .doc(message.sentAt)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  // ---------------------------------------------------------------------------
  // Group Chat APIs
  // ---------------------------------------------------------------------------

  // Create a new group
  static Future<Group> createGroup({
    required String groupName,
    required List<String> members,
    String? image
  }) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final groupId = firestore.collection('groupsBeta').doc().id;

    // Convert nullable to non-nullable for your Group model
  final String safeImage = image ?? '';

    try {
      await firestore.collection('groupsBeta').doc(groupId).set({
        'image': safeImage,
        'id': groupId,
        'group_name': groupName,
        'admin': user.uid,
        'members': members,
        'createdAt': time,
        'createdBy': user.displayName,
        'lastMsg': '',
        'lastMsgTime': '',
      });
    } catch (e) {
      log('Error creating group: $e');
    }

    return Group(
      image: safeImage,
      id: groupId,
      groupName: groupName,
      admin: user.uid,
      members: members,
      createdAt: time,
      createBy: user.displayName ?? 'Unknown',
    );
  }

  // Stream: All groups user is a member of
  static Stream<List<Group>> getAllGroups() {
    return firestore
        .collection('groupsBeta')
        .where('members', arrayContains: user.uid)
        .snapshots()
        .map((snapshot) {
          final list = snapshot.docs
              .map((doc) => Group.fromJson(doc.data(), doc.id))
              .toList();

          list.sort((a, b) =>
              b.groupName.toLowerCase().compareTo(a.groupName.toLowerCase()));

          return list;
        });
  }

  // Stream: All messages in a group
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllGroupMessages(
    String groupId,
  ) {
    return firestore
        .collection('groupsBeta/$groupId/group_messages')
        .orderBy('sentAt', descending: true)
        .snapshots();
  }

  // Send a message to a group
  static Future<void> sendGroupMessage(String groupId, String msg, groupMessageType type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final messageId = firestore.collection('groupsBeta').doc().id;

    final message = {
      'id': messageId,
      'groupId': groupId,
      'fromId': user.uid,
      'fromName': user.displayName,
      'msg': msg,
      'type': type.name,
      'sentAt': time,
      'read': '',
    };

    await firestore
        .collection('groupsBeta')
        .doc(groupId)
        .collection('group_messages')
        .doc(messageId)
        .set(message);

    await firestore.collection('groupsBeta').doc(groupId).update({
      'lastMsg': msg,
      'lastMsgTime': time,
    });

    // Fetch members from Firestore
    final groupDoc = await firestore.collection('groupsBeta').doc(groupId).get();

    if (groupDoc.exists) {
      final groupData = groupDoc.data()!;
      final List<dynamic> memberIds = groupData['members'] ?? [];

      final members = await Future.wait(
        memberIds.map((id) async {
          final userDoc = await firestore.collection('usersBeta').doc(id).get();
          return ChatUser.fromJson(userDoc.data()!);
        }),
      );

      await sendGroupPushNotification(
        members,
        groupData['group_name'] ?? 'Group',
        msg,
        groupId,
      );
    }
  }

  // Update group message read status
  static Future<void> updateGroupMessageReadStatus(
    GroupMessage groupMessage,
  ) async {
    if (groupMessage.id.isEmpty || groupMessage.groupId.isEmpty) {
      log("Error: groupId or message id is empty");
      return;
    }

    await firestore
        .collection('groupsBeta')
        .doc(groupMessage.groupId)
        .collection('group_messages')
        .doc(groupMessage.id)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  // Stream: Last message in a group
  static Stream<Message?> getGroupLastMessage(String groupId) {
    return firestore
        .collection('groupsBeta/$groupId/group_messages')
        .orderBy('sentAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return null;
          return Message.fromJson(snapshot.docs.first.data());
        });
  }

  // ---------------------------------------------------------------------------
  // Group Push Notifications
  // ---------------------------------------------------------------------------

  static Future<void> sendGroupPushNotification(
    List<ChatUser> members,
    String groupName,
    String msg,
    String groupId,
  ) async {
    final recipients = members.where((m) => m.id != me.id).toList();
    

    if (recipients.isEmpty) {
      log("No recipients to send group notifications");
      return;
    }

    AccessFirebaseToken accessToken = AccessFirebaseToken();
    String bearerToken = await accessToken.getAccessToken();

    for (var member in recipients) {
      if (member.pushToken.isEmpty) continue;

      final body = {
        "message": {
          "token": member.pushToken,
          "notification": {
            "title": "$groupName (${me.name})",
            "body": msg,
          },
          "android": {
            "notification": {
              "channel_id": "chats",
              "tag": "group_$groupId",
              "default_sound": true,
              "default_vibrate_timings": true,
            },
          },
          "data": {
            "type": "group_chat_message",
            "groupId": groupId,
            "fromId": me.id,
          }
        },
      };

      try {
        var res = await post(
          Uri.parse(
            'https://fcm.googleapis.com/v1/projects/$firestoreAppId/messages:send',
          ),
          headers: {
            "content-Type": "application/json",
            'Authorization': 'Bearer $bearerToken',
          },
          body: jsonEncode(body),
        );
        log("Sent to ${member.name}, status: ${res.statusCode}");
      } catch (e) {
        log("sendGroupNotification error: $e");
      }
    }
  }

  // ---------------------------------------------------------------------------
  // fetch members from the Users collection
  // ---------------------------------------------------------------------------

  // Stream: fetch group members dynamically
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// --------------------- Stream of Group Members ---------------------
  static Stream<List<Map<String, dynamic>>> getGroupMembersStream(List<String> memberIds) {
    if (memberIds.isEmpty) {
      // Return an empty stream if no members
      return Stream.value([]);
    }

    // Listen to changes in the 'usersBeta' collection where 'id' is in memberIds
    return _firestore
        .collection('usersBeta')
        .where('id', whereIn: memberIds)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }



  // ---------------------------------------------------------------------------
// Listen to messages to track sending → sent
// ---------------------------------------------------------------------------
// static void listenToMessageStatus(ChatUser chatUser, void Function(Message message) onUpdate) {
//   final chatId = getConversationID(chatUser.id);

//   FirebaseFirestore.instance
//       .collection('chatsBeta/$chatId/messages')
//       .orderBy('sentAt')
//       .snapshots(includeMetadataChanges: true)
//       .listen((snapshot) {
//     for (var change in snapshot.docChanges) {
//       final doc = change.doc;
//       final data = doc.data()!;
//       final isPending = doc.metadata.hasPendingWrites;

//       // Create a Message object
//       final message = Message.fromJson(data);
//       message.status = isPending ? 'sending' : 'sent';

//       // Callback to the caller (e.g., ChatScreen) to update UI
//       onUpdate(message);
//     }
//   });
// }


// static void listenToMessageStatus(ChatUser chatUser, void Function(Message message) onUpdate) {
//   final chatId = getConversationID(chatUser.id);

//   FirebaseFirestore.instance
//       .collection('chatsBeta/$chatId/messages')
//       .orderBy('sentAt')
//       .snapshots(includeMetadataChanges: true)
//       .listen((snapshot) {
//     for (var change in snapshot.docChanges) {
//       final doc = change.doc;
//       final data = doc.data()!;
//       final message = Message.fromJson(data);

//       // Only update messages sent by the current user
//       if (message.fromId != user.uid) continue;

//       // Determine status
//       message.status = doc.metadata.hasPendingWrites ? 'sending' : 'sent';

//       // Call the callback to update UI
//       onUpdate(message);
//     }
//   });
// }


//To update Profile Photo
static Future<void> updateProfilePhoto(String url) async {
  return firestore.collection('usersBeta').doc(APIs.me.id).update({
    'image': url,
  });
}



}


