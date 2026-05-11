import 'package:voice_ink/features/folder/domain/entities/folder_entity.dart';

class FolderModel extends FolderEntity {
  const FolderModel({
    required super.id,
    required super.userId,
    required super.name,
    required super.description,
    required super.color,
    required super.parentId,
    required super.itemCount,
    required super.path,
    required super.children,
    required super.createdAt,
    required super.updatedAt,
  });

  factory FolderModel.fromJson(Map<String, dynamic> json) {
    final rawChildren = json['children'];
    final children = rawChildren is List
        ? rawChildren
            .whereType<Map<String, dynamic>>()
            .map((e) => FolderModel.fromJson(e))
            .toList()
        : <FolderModel>[];

    final rawPath = json['path'];
    final path = rawPath is List
        ? rawPath.map((e) => e.toString()).toList()
        : <String>[];

    return FolderModel(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      description: json['description'],
      color: json['color'],
      parentId: json['parentId'],
      itemCount: (json['itemCount'] as num?)?.toInt() ?? 0,
      path: path,
      children: children,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  static List<FolderModel> listFromJson(List<dynamic> json) {
    return json
        .whereType<Map<String, dynamic>>()
        .map((e) => FolderModel.fromJson(e))
        .toList();
  }
}

class FolderListModel extends FolderListEntity {
  const FolderListModel({
    required super.data,
    required super.total,
    required super.page,
    required super.limit,
    required super.hasMore,
    required super.breadcrumbs,
  });

  factory FolderListModel.fromJson(Map<String, dynamic> json) {
    final rawCrumbs = json['breadcrumbs'];
    return FolderListModel(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => FolderModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 8,
      hasMore: json['hasMore'] == true,
      breadcrumbs: rawCrumbs is List
          ? rawCrumbs.map((e) => e.toString()).toList()
          : const [],
    );
  }
}
