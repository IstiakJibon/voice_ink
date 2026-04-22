import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:voice_ink/features/auth/data/models/user_model.dart';

class UserEntities extends Equatable {
  final String token;
  final String refreshToken;
  final int tokenExpires;
  final User user;

  const UserEntities({
    required this.token,
    required this.refreshToken,
    required this.tokenExpires,
    required this.user,
  });

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'refreshToken': refreshToken,
      'tokenExpires': tokenExpires,
      'user': user.toJson(),
    };
  }

  factory UserEntities.initial() {
    return UserEntities(
      token: '',
      refreshToken: '',
      tokenExpires: 0,
      user: User.empty(),
    );
  }

  @override
  String toString() {
    return 'UserEntities{token: $token, user: ${user.email}}';
  }

  factory UserEntities.fromJson(Map<String, dynamic> map) {
    log(map.toString());
    return UserEntities(
      token: map['token'] ?? '',
      refreshToken: map['refreshToken'] ?? '',
      tokenExpires: map['tokenExpires'] ?? 0,
      user: User.fromJson(map['user'] ?? {}),
    );
  }

  UserEntities copyWith({
    String? token,
    String? refreshToken,
    int? tokenExpires,
    User? user,
  }) {
    return UserEntities(
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      tokenExpires: tokenExpires ?? this.tokenExpires,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [token, refreshToken, tokenExpires, user];
}