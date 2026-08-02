
class GroupMessage {
  GroupMessage({
    required this.id,
    required this.msg,
    required this.groupId,
    required this.fromId,
    required this.fromName,
    required this.type,
    required this.sentAt,
    required this.read,
  });

  late final String id;
  late final String msg;
  late final String groupId; // instead of toId
  late final String fromId;
  late final String fromName;
  late final groupMessageType type;
  late final String sentAt; // better as DateTime/Timestamp
  late final String read;

  // Deserialize Firestore doc -> Message
  GroupMessage.fromJson(Map<String, dynamic> json)
    : msg = json['msg'] ?? '',
      groupId = json['groupId'] ?? '',
      fromId = json['fromId'] ?? '',
      fromName = json['fromName'] ?? '',
      type = groupMessageType.values.firstWhere(
        (e) => e.name == (json['type'] ?? 'text'),
        orElse: () => groupMessageType.text,
      ),
      sentAt = json['sentAt'].toString(),
      read = json['read'].toString(),
      id = json['id'] ?? '';

  /// Deserialize Firestore doc -> Message
  // factory GroupMessage.fromDoc(String id, Map<String, dynamic> json) {
  //   return GroupMessage(
  //     id: id,
  //     msg: json['msg'] ?? '',
  //     groupId: json['groupId'] ?? '',
  //     fromId: json['fromId'] ?? '',
  //     type: groupMessageType.values.firstWhere(
  //       (e) => e.name == (json['type'] ?? 'text'),
  //       orElse: () => groupMessageType.text,
  //     ),
  //     sentAt: json['sentAt']?.toString() ?? '',
  //     read: json['read']?.toString() ?? '',
  //   );
  // }

  // Serialize Message -> Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id, // <-- MUST BE HERE
      'msg': msg,
      'groupId': groupId,
      'fromId': fromId,
      'fromName': fromName,
      'type': type.name,
      'sentAt': sentAt,
      'read': read,
    };
  }
}

enum groupMessageType { text, image }
