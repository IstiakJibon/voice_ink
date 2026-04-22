class ResetPasswordUc {
  final String password;
  final String hash;
 
  ResetPasswordUc({
    required this.password,
    required this.hash,
  });
 
  Map<String, dynamic> toJson() => {
        "password": password,
        "hash": hash,
      };
}