// To parse this JSON data, do
//
//     final themeChooseModel = themeChooseModelFromJson(jsonString);

import 'dart:convert';
import 'package:voice_ink/features/auth/domain/entities/theme_choose_entities.dart';

ThemeChooseModel themeChooseModelFromJson(String str) =>
    ThemeChooseModel.fromJson(json.decode(str));

String themeChooseModelToJson(ThemeChooseModel data) =>
    json.encode(data.toJson());

// ignore: must_be_immutable
class ThemeChooseModel extends ThemeChooseEntities {
  List<ThemeChoose> data;

  ThemeChooseModel({
    required this.data,
  }) : super(themeChoose: data);

  factory ThemeChooseModel.fromJson(Map<String, dynamic> json) =>
      ThemeChooseModel(
        data: List<ThemeChoose>.from(
            json["data"].map((x) => ThemeChoose.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ThemeChoose {
  int id;
  String name;
  String description;
  String banner;
  String shopType;
  // List<Menu> pages;
  // List<Menu> menus;
  // List<Menu> widgets;
  String status;
  String deletedAt;

  ThemeChoose({
    required this.id,
    required this.name,
    required this.description,
    required this.banner,
    required this.shopType,
    // required this.pages,
    // required this.menus,
    // required this.widgets,
    required this.status,
    required this.deletedAt,
  });

  factory ThemeChoose.fromJson(Map<String, dynamic> json) => ThemeChoose(
        id: json["id"] ?? 0,
        name: json["name"] ?? "",
        description: json["description"] ?? "",
        banner: json["banner"] ?? "",
        shopType: json["shopType"] ?? "",
        // pages: List<Menu>.from(json["pages"].map((x) => Menu.fromJson(x))),
        // menus: List<Menu>.from(json["menus"].map((x) => Menu.fromJson(x))),
        // widgets: List<Menu>.from(json["widgets"].map((x) => Menu.fromJson(x))),
        status: json["status"] ?? "",
        deletedAt: json["deletedAt"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "banner": banner,
        "shopType": shopType,
        // "pages": List<dynamic>.from(pages.map((x) => x.toJson())),
        // "menus": List<dynamic>.from(menus.map((x) => x.toJson())),
        // "widgets": List<dynamic>.from(widgets.map((x) => x.toJson())),
        "status": status,
        "deletedAt": deletedAt,
      };
}

class Menu {
  String name;
  String id;

  Menu({
    required this.name,
    required this.id,
  });

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        name: json["name"] ?? "",
        id: json["id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
      };
}
