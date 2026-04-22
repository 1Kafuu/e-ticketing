import '../../domain/entities/ticket_entity.dart';
import '../../domain/entities/ticket_enum.dart';
import '../../domain/entities/comment_entity.dart';

class TicketModel extends TicketEntity {
  const TicketModel({
    required super.id,
    required super.title,
    required super.description,
    required super.status,
    required super.priority,
    required super.createdAt,
    required super.userId,
    super.attachments,
    super.comments,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      priority: TicketPriority.values.firstWhere(
        (e) => e.label == json['priority'], // Cek berdasarkan label
        orElse: () => TicketPriority.medium,
      ),
      status: TicketStatus.values.firstWhere(
        (e) => e.label == json['status'], // Cek berdasarkan label
        orElse: () => TicketStatus.open,
      ),
      createdAt: DateTime.parse(json['createdAt']),
      userId: json['userId'],
      attachments: List<String>.from(json['attachments'] ?? []),
      comments: _commentsFromJson(json['comments'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status.label, // Simpan labelnya saja: "Open"
      'priority': priority.label, // Simpan labelnya saja: "Low"
      'createdAt': createdAt.toIso8601String(),
      'userId': userId,
      'attachments': attachments,
      'comments': _commentsToJson(comments),
    };
  }

  static List<CommentEntity> _commentsFromJson(List<dynamic>? json) {
    if (json == null) return [];
    return json
        .map(
          (c) => CommentEntity(
            id: c['id'],
            senderName: c['senderName'],
            senderId: c['senderId'],
            message: c['message'],
            timestamp: DateTime.parse(c['timestamp']),
            replies: _commentsFromJson(c['replies']), // Rekursif untuk balasan
          ),
        )
        .toList();
  }

  static List<Map<String, dynamic>> _commentsToJson(
    List<CommentEntity> comments,
  ) {
    return comments
        .map(
          (c) => {
            'id': c.id,
            'senderName': c.senderName,
            'senderId': c.senderId,
            'message': c.message,
            'timestamp': c.timestamp.toIso8601String(),
            'replies': _commentsToJson(c.replies), // Rekursif untuk balasan
          },
        )
        .toList();
  }
}
