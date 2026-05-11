import 'package:equatable/equatable.dart';

class FolderEntity extends Equatable {
  final String? id;
  final String? userId;
  final String? name;
  final String? description;
  final String? color;
  final String? parentId;
  final int itemCount;
  final List<String> path;
  final List<FolderEntity> children;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FolderEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.color,
    required this.parentId,
    required this.itemCount,
    required this.path,
    required this.children,
    required this.createdAt,
    required this.updatedAt,
  });

  FolderEntity copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    String? color,
    String? parentId,
    int? itemCount,
    List<String>? path,
    List<FolderEntity>? children,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FolderEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      parentId: parentId ?? this.parentId,
      itemCount: itemCount ?? this.itemCount,
      path: path ?? this.path,
      children: children ?? this.children,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        description,
        color,
        parentId,
        itemCount,
        path,
        children,
        createdAt,
        updatedAt,
      ];
}

class FolderListEntity extends Equatable {
  final List<FolderEntity> data;
  final int total;
  final int page;
  final int limit;
  final bool hasMore;
  final List<String> breadcrumbs;

  const FolderListEntity({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
    required this.hasMore,
    required this.breadcrumbs,
  });

  factory FolderListEntity.empty() {
    return const FolderListEntity(
      data: [],
      total: 0,
      page: 1,
      limit: 8,
      hasMore: false,
      breadcrumbs: [],
    );
  }

  @override
  List<Object?> get props => [data, total, page, limit, hasMore, breadcrumbs];
}
