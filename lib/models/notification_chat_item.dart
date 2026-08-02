import 'package:ss_chat/models/chat_user.dart';
import 'package:ss_chat/models/groups.dart';

class ChatItem {
  final String id; // userId for 1-1, groupId for groups
  final String name; // user name or group name
  final String lastMsg;
  final String lastMsgTime; // timestamp string
  final bool isGroup; // true for group, false for 1-1
  final ChatUser? user; // for 1-on-1
  final Group? group; // for group

  ChatItem({
    required this.id,
    required this.name,
    required this.lastMsg,
    required this.lastMsgTime,
    required this.isGroup,
    this.user,
    this.group,
  });
}
