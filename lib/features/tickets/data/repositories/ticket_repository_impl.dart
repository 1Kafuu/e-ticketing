import 'package:e_ticketing/features/tickets/domain/entities/ticket_enum.dart';

import '../../domain/entities/ticket_entity.dart';
import '../../domain/entities/comment_entity.dart';
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
  ) async {
    // 1. Ambil semua tiket yang ada di local storage
    final tickets = await getTickets();

    // 2. Cari indeks tiket yang ingin diupdate
    final index = tickets.indexWhere((t) => t.id == ticketId);

    if (index != -1) {
      // 3. Buat salinan tiket dengan status baru
      final updatedTicket = TicketEntity(
        id: tickets[index].id,
        title: tickets[index].title,
        description: tickets[index].description,
        status: newStatus, // Status baru disisipkan di sini
        priority: tickets[index].priority,
        createdAt: tickets[index].createdAt,
        userId: tickets[index].userId,
        attachments: tickets[index].attachments,
        comments: tickets[index].comments,
      );

      // 4. Simpan kembali ke local storage melalui fungsi updateTicket yang sudah Anda buat
      await updateTicket(updatedTicket);
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
