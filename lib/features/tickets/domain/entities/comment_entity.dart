class CommentEntity {
  final String id;
  final String senderName;
  final String senderId;
  final String message;
  final DateTime timestamp;
  final List<CommentEntity> replies; // Untuk fitur balas komentar

  const CommentEntity({
    required this.id,
    required this.senderName,
    required this.senderId,
    required this.message,
    required this.timestamp,
    this.replies = const [],
  });
}