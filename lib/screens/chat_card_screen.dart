import 'package:flutter/material.dart';
import 'package:ss_chat/api/apis.dart';
import 'package:ss_chat/models/chat_user.dart';
import 'package:ss_chat/widgets/chat_user_card.dart';

/// --------------------- Chat Card Screen ---------------------
class ChatCardScreen extends StatefulWidget {
  const ChatCardScreen({super.key});

  @override
  State<ChatCardScreen> createState() => _ChatCardScreenState();
}

class _ChatCardScreenState extends State<ChatCardScreen> {
  List<ChatUser> list = [];

  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: APIs.getAllUsers(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return const Center(child: CircularProgressIndicator());

          case ConnectionState.active:
          case ConnectionState.done:

            /// --------------------- Commented Code ---------------------
            // final data = snapshot.data?.docs;
            // list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

            final list = snapshot.data ?? [];

            if (list.isNotEmpty) {
              return ListView.builder(
                itemCount: list.length,
                // physics: BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: 8),
                itemBuilder: (context, index) {
                  return ChatUserCard(user: list[index]);
                },
              );
            } else {
              return const Center(
                child: Text(
                  'No Connections Found!',
                  style: TextStyle(fontSize: 22),
                ),
              );
            }
        }
      },
    );
  }
}
