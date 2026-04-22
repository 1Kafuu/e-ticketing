import '../entities/ticket_entity.dart';
import '../entities/comment_entity.dart';

abstract class TicketRepository {
  /// Mengambil semua daftar tiket
  Future<List<TicketEntity>> getTickets();

  /// Membuat tiket baru
  Future<void> createTicket(TicketEntity ticket);

  /// Memperbarui data tiket yang sudah ada
  Future<void> updateTicket(TicketEntity ticket);

  Future<void> addComment(String ticketId, CommentEntity comment, {String? parentCommentId});
}