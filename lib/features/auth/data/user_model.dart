class UserModel {
  final String id;
  final String email;
  final String username;

  const UserModel({
    required this.id,
    required this.email,
    required this.username,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String userEmail) {
    return UserModel(
      id: json['id'] as String,
      email: userEmail,
      username: json['username'] as String? ?? 'User',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
    };
  }
}