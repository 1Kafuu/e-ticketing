import '../../domain/entities/ticket_entity.dart';
import '../../domain/entities/ticket_enum.dart';

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
    };
  }
}
