class ChatUser {
  String image;
  String about;
  String name;
  String createdAt;
  final String id;          // <- id should be final
  bool isOnline;
  String lastActive;
  String pushToken;
  String email;
  String lastMessage;
  String lastMessageTime;

  ChatUser({
    required this.image,
    required this.about,
    required this.name,
    required this.createdAt,
    required this.id,
    required this.isOnline,
    required this.lastActive,
    this.pushToken = '',
    required this.email,
    this.lastMessage = '',
    this.lastMessageTime = '0',
  });

  ChatUser.fromJson(Map<String, dynamic> json)
      : image = json['image'],
        about = json['about'],
        name = json['name'],
        createdAt = json['created_at'],
        id = json['id'],
        isOnline = json['is_online'],
        lastActive = json['last_active'],
        pushToken = json['push_token'] ?? '',
        email = json['email'],
        lastMessage = json['last_message'] ?? '',
        lastMessageTime = json['last_message_time'] ?? '0';

  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'about': about,
      'name': name,
      'created_at': createdAt,
      'id': id,
      'is_online': isOnline,
      'last_active': lastActive,
      'push_token': pushToken,
      'email': email,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime,
    };
  }
}
