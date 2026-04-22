import 'package:e_ticketing/features/tickets/domain/entities/ticket_enum.dart';

import '../../domain/entities/ticket_entity.dart';
import '../../domain/entities/comment_entity.dart';
import '../../domain/entities/ticket_history_entity.dart';
import '../../domain/repositories/ticket_repository.dart';
import '../datasources/ticket_local_data_source.dart';
import '../models/ticket_model.dart';

class TicketRepositoryImpl implements TicketRepository {
  final TicketLocalDataSource localDataSource;

  TicketRepositoryImpl({required this.localDataSource});

  @override
  Future<List<TicketEntity>> getTickets() async {
    final ticketMaps = await localDataSource.getTickets();
    return ticketMaps.map((map) => TicketModel.fromJson(map)).toList();
  }

  @override
  Future<void> createTicket(TicketEntity ticket) async {
    final model = TicketModel(
      id: ticket.id,
      title: ticket.title,
      description: ticket.description,
      status: ticket.status,
      priority: ticket.priority,
      createdAt: ticket.createdAt,
      userId: ticket.userId,
      attachments: ticket.attachments,
      comments: ticket.comments,
    );
    await localDataSource.addTicket(model.toJson());
  }

  @override
  Future<void> updateTicket(TicketEntity ticket) async {
    final model = TicketModel(
      id: ticket.id,
      title: ticket.title,
      description: ticket.description,
      status: ticket.status,
      priority: ticket.priority,
      createdAt: ticket.createdAt,
      userId: ticket.userId,
      attachments: ticket.attachments,
      comments: ticket.comments,
    );
    await localDataSource.updateTicket(model.toJson());
  }

  @override
  Future<void> updateTicketStatus(
    String ticketId,
    TicketStatus newStatus,
    String adminName,
  ) async {
    final tickets = await getTickets();
    final index = tickets.indexWhere((t) => t.id == ticketId);

    if (index != -1) {
      final ticket = tickets[index];

      // 1. BUAT OBJEK HISTORY BARU
      final newHistoryEntry = TicketHistoryEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        action: "Status Updated",
        description: "Status tiket diubah menjadi ${newStatus.label}",
        timestamp: DateTime.now(),
        updatedBy: adminName,
      );

      // 2. UPDATE TIKET DENGAN LIST HISTORY YANG BARU
      final updatedTicket = TicketModel(
        id: ticket.id,
        title: ticket.title,
        description: ticket.description,
        status: newStatus, // Update status
        priority: ticket.priority,
        createdAt: ticket.createdAt,
        userId: ticket.userId,
        attachments: ticket.attachments,
        comments: ticket.comments,
        // PENTING: Gabungkan history lama dengan yang baru
        history: [...ticket.history, newHistoryEntry],
      );

      // 3. SIMPAN KEMBALI KE LOCAL DATA SOURCE
      await localDataSource.updateTicket(updatedTicket.toJson());
    }
  }

  @override
  Future<void> addComment(
    String ticketId,
    CommentEntity comment, {
    String? parentCommentId,
  }) async {
    final tickets = await getTickets();
    final index = tickets.indexWhere((t) => t.id == ticketId);

    if (index != -1) {
      final ticket = tickets[index];
      List<CommentEntity> updatedComments = List.from(ticket.comments);

      if (parentCommentId == null) {
        // Komentar utama
        updatedComments.add(comment);
      } else {
        // Cari komentar parent untuk fitur Balas
        final parentIndex = updatedComments.indexWhere(
          (c) => c.id == parentCommentId,
        );
        if (parentIndex != -1) {
          final parent = updatedComments[parentIndex];
          final updatedReplies = List<CommentEntity>.from(parent.replies)
            ..add(comment);

          updatedComments[parentIndex] = CommentEntity(
            id: parent.id,
            senderName: parent.senderName,
            senderId: parent.senderId,
            message: parent.message,
            timestamp: parent.timestamp,
            replies: updatedReplies,
          );
        }
      }

      // Update tiket utuh ke data source
      final updatedTicket = TicketModel(
        id: ticket.id,
        title: ticket.title,
        description: ticket.description,
        status: ticket.status,
        priority: ticket.priority,
        createdAt: ticket.createdAt,
        userId: ticket.userId,
        attachments: ticket.attachments,
        comments: updatedComments,
      );

      await localDataSource.updateTicket(updatedTicket.toJson());
    }
  }
}
