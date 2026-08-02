class Message {
  Message({
    required this.msg,
    required this.toId,
    required this.read,
    required this.type,
    required this.fromId,
    required this.sentAt,
    this.dbReceivedAt = '',
    this.status = 'sending', // default status
  });

  late final String msg;
  late final String toId;
  late final String read;
  late final String fromId;
  late final String sentAt;
  late final Type type;
  late final String dbReceivedAt;

  // NEW: status for UI (sending / sent / delivered)
  late String status;

  // --------------------- From JSON ---------------------
  Message.fromJson(Map<String, dynamic> json) {
    msg = json['msg'].toString();
    toId = json['toId'].toString();
    read = json['read'].toString();
    fromId = json['fromId'].toString();
    sentAt = json['sentAt'].toString();
    dbReceivedAt = json['dbReceivedAt']?.toString() ?? '';
    status = json['status']?.toString() ?? 'sending';

    type = Type.values.firstWhere(
      (e) => e.name == json['type'].toString(),
      orElse: () => Type.text,
    );
  }

  // --------------------- To JSON ---------------------
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['msg'] = msg;
    data['toId'] = toId;
    data['read'] = read;
    data['type'] = type.name;
    data['fromId'] = fromId;
    data['sentAt'] = sentAt;
    data['dbReceivedAt'] = dbReceivedAt;
    data['status'] = status; // include status
    return data;
  }
}

enum Type { text, image }
