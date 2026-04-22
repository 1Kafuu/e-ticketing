class TicketHistoryEntity {
  final String id;
  final String action; // Contoh: "Status Updated", "Ticket Created"
  final String description; // Contoh: "Status changed from Open to In Progress"
  final DateTime timestamp;
  final String updatedBy;

  const TicketHistoryEntity({
    required this.id,
    required this.action,
    required this.description,
    required this.timestamp,
    required this.updatedBy,
  });
}