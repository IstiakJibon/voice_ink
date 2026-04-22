class ForgotPasswordUc {
  final String email;
 
  ForgotPasswordUc({
    required this.email,
  });
 
  Map<String, dynamic> toJson() => {
        "email": email,
      };
}
 