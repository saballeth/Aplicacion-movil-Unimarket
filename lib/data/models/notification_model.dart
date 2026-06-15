import 'package:unimarket/domain/entities/notification_entity.dart';

class NotificationModel {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String? body;
  final bool isRead;
  final String? actionUrl;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    this.body,
    this.isRead = false,
    this.actionUrl,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      body: json['body'] as String?,
      isRead: json['is_read'] == 1,
      actionUrl: json['action_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'type': type,
    'title': title,
    'body': body,
    'is_read': isRead ? 1 : 0,
    'action_url': actionUrl,
    'created_at': createdAt.toIso8601String(),
  };

  NotificationEntity toEntity() => NotificationEntity(
    id: id,
    userId: userId,
    type: type,
    title: title,
    body: body,
    isRead: isRead,
    actionUrl: actionUrl,
    createdAt: createdAt,
  );

  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      userId: entity.userId,
      type: entity.type,
      title: entity.title,
      body: entity.body,
      isRead: entity.isRead,
      actionUrl: entity.actionUrl,
      createdAt: entity.createdAt,
    );
  }
}
