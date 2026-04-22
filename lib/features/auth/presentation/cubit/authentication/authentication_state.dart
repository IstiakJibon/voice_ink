part of 'authentication_cubit.dart';

class AuthenticationState extends Equatable {
  final bool isLoggedIn;
  final UserEntities user;

  const AuthenticationState({
    this.isLoggedIn = false,
    required this.user,
  });

  @override
  List<Object> get props => [
        isLoggedIn,
        user,
      ];

  AuthenticationState copyWith({
    bool? isLoggedIn,
    UserEntities? user,
  }) {
    return AuthenticationState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'isLoggedIn': isLoggedIn,
      'user': user.toMap(),
    };
  }

  factory AuthenticationState.fromMap(Map<String, dynamic> map) {
    return AuthenticationState(
      isLoggedIn: map['isLoggedIn'] ?? false,
      user: UserEntities.fromJson(map['user'] ?? {}),
    );
  }

  factory AuthenticationState.initial() {
    return AuthenticationState(
      isLoggedIn: false,
      user: UserEntities.initial(),
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthenticationState.fromJson(String source) =>
      AuthenticationState.fromMap(json.decode(source));

  @override
  String toString() =>
      'AuthenticationState(isLoggedIn: $isLoggedIn, user: $user)';
}