class UserChat {
  late String image;
  late String name;
  late String about;
  late String lastActive;
  late bool isOnline;
  late String id;
  late String createAt;
  late String email;
  late String pushToken;
  late bool isTyping;
  UserChat({
    required this.image,
    required this.name,
    required this.about,
    required this.lastActive,
    required this.isOnline,
    required this.id,
    required this.createAt,
    required this.email,
    required this.pushToken,
    required this.isTyping,
  });

  UserChat.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    name = json['name'] ?? '';
    about = json['about'] ?? '';
    lastActive = json['last_active'] ?? '';
    isOnline = json['is_online'] ?? '';
    id = json['id'] ?? '';
    createAt = json['create_at'] ?? '';
    email = json['email'] ?? '';
    pushToken = json['push_token'] ?? '';
    isTyping = json['is_typing'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    data['about'] = about;
    data['last_active'] = lastActive;
    data['is_online'] = isOnline;
    data['id'] = id;
    data['create_at'] = createAt;
    data['email'] = email;
    data['push_token'] = pushToken;
    data['is_typing'] = isTyping;
    return data;
  }
}
