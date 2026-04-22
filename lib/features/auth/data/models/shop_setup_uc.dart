// To parse this JSON data, do
//
//     final shopSetupUc = shopSetupUcFromJson(jsonString);

import 'dart:convert';

ShopSetupUc shopSetupUcFromJson(String str) =>
    ShopSetupUc.fromJson(json.decode(str));

String shopSetupUcToJson(ShopSetupUc data) => json.encode(data.toJson());

class ShopSetupUc {
  String name;
  // int type;
  String file;
  String customDomain;
  int themeId;
  String? productType;

  ShopSetupUc({
    required this.name,
    //required this.type,
    required this.file,
    required this.customDomain,
    required this.themeId,
    required this.productType,
  });

  factory ShopSetupUc.fromJson(Map<String, dynamic> json) => ShopSetupUc(
        name: json["name"],
        //   type: json["type"],
        file: json["file"],
        customDomain: json["custom_domain"],
        themeId: json["themeId"],
        productType: json["productType"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        //   "type": type,
        "file": file,
        "custom_domain": customDomain,
        "themeId": themeId,
        "productType": productType,
      };
}
