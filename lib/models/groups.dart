
class Group {
  Group({
    required this.image,
    required this.id,
    required this.admin,
    required this.groupName,
    required this.members,
    required this.createdAt,
    required this.createBy,
    this.lastMsg ='',
    this.lastMsgTime = '',
  });

  final String image;
  final String id;          // Firestore document ID
  final String admin;       // admin userId
  final String groupName;
  final List<String> members;
  final String createdAt;
  final String createBy;
  final String lastMsg;
  final String lastMsgTime;

  // Deserialize Firestore doc -> Group
  factory Group.fromJson(Map<String, dynamic> json, String id) {
    return Group(
      image : json['image'],
      id: id,
      admin: json['admin'] ?? '',
      groupName: json['group_name'] ?? '',
      members: List<String>.from(json['members'] ?? []),
      createdAt: json['createdAt'],
      createBy: json['createdBy'],
      lastMsg: json['lastMsg'],
      lastMsgTime: json['lastMsgTime']
    );
  }

  // Serialize Group -> Firestore
  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'admin': admin,
      'group_name': groupName,
      'members': members,
      'createdAt': createdAt,
      'createdBy': createBy,
      'lastMsg': lastMsg,
      'lastMsgTime': lastMsgTime,
    };
  }
}
