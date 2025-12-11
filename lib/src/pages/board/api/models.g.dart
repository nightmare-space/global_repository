// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BoardItem _$BoardItemFromJson(Map<String, dynamic> json) => BoardItem(
      id: (json['id'] as num?)?.toInt(),
      app: json['app'] as String?,
      title: json['title'] as String?,
      status: json['status'] as String?,
      priority: json['priority'] as String?,
      tags: json['tags'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      completedAt: json['completed_at'] == null
          ? null
          : DateTime.parse(json['completed_at'] as String),
      isActive: json['is_active'] as bool?,
      likeCount: (json['like_count'] as num?)?.toInt(),
      description: json['description'] as String,
    );

Map<String, dynamic> _$BoardItemToJson(BoardItem instance) => <String, dynamic>{
      'id': instance.id,
      'app': instance.app,
      'title': instance.title,
      'status': instance.status,
      'priority': instance.priority,
      'tags': instance.tags,
      'description': instance.description,
      'created_at': instance.createdAt?.toIso8601String(),
      'completed_at': instance.completedAt?.toIso8601String(),
      'is_active': instance.isActive,
      'like_count': instance.likeCount,
    };

BoardItems _$BoardItemsFromJson(Map<String, dynamic> json) => BoardItems(
      datas: (json['datas'] as List<dynamic>?)
          ?.map((e) => BoardItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['total_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BoardItemsToJson(BoardItems instance) =>
    <String, dynamic>{
      'datas': instance.datas,
      'total_count': instance.totalCount,
    };
