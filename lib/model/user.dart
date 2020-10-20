import 'dart:convert';

List<User> userFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<User>.from(data.map((item) => User.fromJson(item)));
}

String userToJson(User data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}

class User {
// Properties
  int id;
  String username;
  String email;
  String password;
  int userable_id;
  String userable_type;

// Constructor
  User({
    this.id,
    this.username,
    this.email,
    this.password,
    this.userable_id,
    this.userable_type,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        password: json["password"],
        userable_id: json["userable_id"],
        userable_type: json["userable_type"],
      );

// Map to json
  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "password": password,
        "userable_id": userable_id,
        "userable_type": userable_type,
      };

// to string
  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email, password: $password, userable_id: $userable_id, userable_type: $userable_type)';
  }
}
