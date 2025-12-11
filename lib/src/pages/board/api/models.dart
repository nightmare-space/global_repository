import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

// {
//     "items": [
//         {
//             "title": "Moonlight需要单独为sula编译一份，单Activity的",
//             "description": "",
//             "status": "ABANDONED",
//             "priority": "P4",
//             "tags": null,
//             "app": "KANBAN_README",
//             "id": 67,
//             "created_at": "2025-09-01T16:15:02.849146",
//             "completed_at": null,
//             "is_active": true,
//             "like_count": 0
//         },
//     ],
//     "total_count": 67
// }
@JsonSerializable()
class BoardItem {
  BoardItem({
    this.id,
    this.app,
    this.title,
    this.status,
    this.priority,
    this.tags,
    this.createdAt,
    this.completedAt,
    this.isActive,
    this.likeCount,
    required this.description,
  });

  final int? id;
  final String? app;
  final String? title;
  final String? status;
  final String? priority;
  final String? tags;
  final String description;

  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @JsonKey(name: 'completed_at')
  final DateTime? completedAt;

  @JsonKey(name: 'is_active')
  final bool? isActive;

  @JsonKey(name: 'like_count')
  int? likeCount;

  factory BoardItem.fromJson(Map<String, dynamic> json) => _$BoardItemFromJson(json);
  Map<String, dynamic> toJson() => _$BoardItemToJson(this);

  @override
  String toString() => toJson().toString();
}

extension BoardItemX on BoardItem {
  void increaseLikeCount() {
    likeCount = (likeCount ?? 0) + 1;
  }
}

@JsonSerializable()
class BoardItems {
  BoardItems({
    this.datas,
    this.totalCount,
  });

  final List<BoardItem>? datas;

  @JsonKey(name: 'total_count')
  final int? totalCount;

  factory BoardItems.fromJson(Map<String, dynamic> json) => _$BoardItemsFromJson(json);
  Map<String, dynamic> toJson() => _$BoardItemsToJson(this);

  @override
  String toString() => toJson().toString();
}
