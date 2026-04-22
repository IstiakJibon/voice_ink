// To parse this JSON data, do
//
//     final OtpVerifyUc = OtpVerifyUcFromJson(jsonString);

import 'dart:convert';

OtpVerifyUc otpVerifyUcFromJson(String str) =>
    OtpVerifyUc.fromJson(json.decode(str));

String otpVerifyUcToJson(OtpVerifyUc data) => json.encode(data.toJson());

class OtpVerifyUc {
  String email;
  int code;

  OtpVerifyUc({
    required this.email,
    required this.code,
  });

  factory OtpVerifyUc.fromJson(Map<String, dynamic> json) => OtpVerifyUc(
        email: json["email"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "code": code,
      };
}
