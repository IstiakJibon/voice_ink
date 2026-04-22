import 'dart:convert';

import 'package:voice_ink/features/auth/domain/entities/user_entities.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel extends UserEntities {
  @override
  final String token;
  @override
  final String refreshToken;
  @override
  final int tokenExpires;
  @override
  final User user;

  UserModel({
    required this.token,
    required this.refreshToken,
    required this.tokenExpires,
    required this.user,
  }) : super(
          token: token,
          refreshToken: refreshToken,
          tokenExpires: tokenExpires,
          user: user,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        token: json["token"] ?? "",
        refreshToken: json["refreshToken"] ?? "",
        tokenExpires: json["tokenExpires"] ?? 0,
        user: User.fromJson(json["user"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "refreshToken": refreshToken,
        "tokenExpires": tokenExpires,
        "user": user.toJson(),
      };
}

class User {
  final String id;
  final String email;
  final String provider;
  final String socialId;
  final String firstName;
  final String lastName;
  final String phone;
  final String photo;
  final String avatarUrl;
  final Role role;
  final Status status;
  final String subscriptionTier;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  User({
    required this.id,
    required this.email,
    required this.provider,
    required this.socialId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.photo,
    required this.avatarUrl,
    required this.role,
    required this.status,
    required this.subscriptionTier,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"]?.toString() ?? "",
        email: json["email"] ?? "",
        provider: json["provider"] ?? "",
        socialId: json["socialId"] ?? "",
        firstName: json["firstName"] ?? "",
        lastName: json["lastName"] ?? "",
        phone: json["phone"] ?? "",
        photo: json["photo"] ?? "",
        avatarUrl: json["avatarUrl"] ?? "",
        role: Role.fromJson(json["role"] ?? {}),
        status: Status.fromJson(json["status"] ?? {}),
        subscriptionTier: json["subscriptionTier"] ?? "",
        createdAt: json["createdAt"] != null
            ? DateTime.tryParse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.tryParse(json["updatedAt"])
            : null,
        deletedAt: json["deletedAt"] != null
            ? DateTime.tryParse(json["deletedAt"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "provider": provider,
        "socialId": socialId,
        "firstName": firstName,
        "lastName": lastName,
        "phone": phone,
        "photo": photo,
        "avatarUrl": avatarUrl,
        "role": role.toJson(),
        "status": status.toJson(),
        "subscriptionTier": subscriptionTier,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "deletedAt": deletedAt?.toIso8601String(),
      };

  factory User.empty() => User(
        id: "",
        email: "",
        provider: "",
        socialId: "",
        firstName: "",
        lastName: "",
        phone: "",
        photo: "",
        avatarUrl: "",
        role: Role.empty(),
        status: Status.empty(),
        subscriptionTier: "",
        createdAt: null,
        updatedAt: null,
        deletedAt: null,
      );
}

class Role {
  final int id;
  final String name;

  Role({
    required this.id,
    required this.name,
  });

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  factory Role.empty() => Role(id: 0, name: "");
}

class Status {
  final int id;
  final String name;

  Status({
    required this.id,
    required this.name,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };

  factory Status.empty() => Status(id: 0, name: "");
}