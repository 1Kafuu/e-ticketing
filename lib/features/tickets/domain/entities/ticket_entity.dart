import 'ticket_enum.dart';

class TicketEntity {
  final String id;
  final String title;
  final String description;
  final TicketStatus status;
  final TicketPriority priority;
  final DateTime createdAt;
  final String userId;
  final List<String> attachments;

  const TicketEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.createdAt,
    required this.userId,
    this.attachments = const [],
  });
}