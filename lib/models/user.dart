import 'dart:convert';

class User {
  User(
      {this.name,
        this.id,
        this.email,
      });

  String? id;
  String? name;

  String? email;


  factory User.fromRawJson(String str) =>
      User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
    id: json["id"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "id": id,
    "email": email,
  };
}
