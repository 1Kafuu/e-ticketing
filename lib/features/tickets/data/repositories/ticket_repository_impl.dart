import '../../domain/entities/ticket_entity.dart';
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
    );
    await localDataSource.updateTicket(model.toJson());
  }
}