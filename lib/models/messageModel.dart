class MessageModel {
  final String message;
  final UserModel user;
  final String id;
  final String time;

  MessageModel(
      {required this.message,
      required this.user,
      required this.id,
      required this.time});
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      message: json['message'],
      id: json['id'],
      time: json['time'],
      user: UserModel.fromJson(json['user']),
    );
  }
  toJson() {
    return {'id': id, 'time': time, 'user': user, 'message': message};
  }
}

class UserModel {
  final String id;
  final String name;
  UserModel({required this.id, required this.name});
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
    );
  }
  toJSon() {
    return {'id': id, 'name': name};
  }
}
