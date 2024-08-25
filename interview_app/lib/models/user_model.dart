class User {
  final int userId;
  final int quota;
  final String email;
  final String nickname;
  final String imageUrl;
  final String password;

  User.fromJson(Map<String, dynamic> json)
      : userId = json['id'],
        email = json['email'] ?? '',
        nickname = json['nickname'] ?? '',
        password = json['password'] ?? '',
        quota = json['quota'],
        imageUrl = json['image'] ?? '';
}
