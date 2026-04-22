import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/ticket_entity.dart';
import '../../domain/entities/ticket_enum.dart';
import '../../domain/entities/comment_entity.dart';
import '../../domain/repositories/ticket_repository.dart';
import '../../data/repositories/ticket_repository_impl.dart';
import '../../data/datasources/ticket_local_data_source.dart';
import '../../../../core/providers/shared_prefs_provider.dart';

// 2. Provider untuk Local Data Source
final ticketLocalDataSourceProvider = Provider<TicketLocalDataSource>((ref) {
  final sharedPrefs = ref.watch(sharedPreferencesProvider);
  return TicketLocalDataSourceImpl(sharedPreferences: sharedPrefs);
});

// 3. Provider untuk Repository
final ticketRepositoryProvider = Provider<TicketRepository>((ref) {
  final localDataSource = ref.watch(ticketLocalDataSourceProvider);
  return TicketRepositoryImpl(localDataSource: localDataSource);
});

// 4. Notifier untuk List Tiket
class TicketListNotifier extends AsyncNotifier<List<TicketEntity>> {
  @override
  Future<List<TicketEntity>> build() async {
    final tickets = await ref.read(ticketRepositoryProvider).getTickets();
    return tickets;
  }

  Future<void> refresh() async {
    state = const AsyncLoading(); // Set status ke loading saat refresh
    state = await AsyncValue.guard(() {
      return ref.read(ticketRepositoryProvider).getTickets();
    });
  }

  Future<void> addTicket(TicketEntity ticket) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(ticketRepositoryProvider).createTicket(ticket);
      return ref.read(ticketRepositoryProvider).getTickets();
    });
  }

  Future<void> sendComment({
    required String ticketId,
    required CommentEntity comment,
    String? parentCommentId,
  }) async {
    // Kita tidak gunakan AsyncValue.guard sementara untuk memastikan error terlihat jelas
    try {
      await ref
          .read(ticketRepositoryProvider)
          .addComment(ticketId, comment, parentCommentId: parentCommentId);

      // Ambil data terbaru
      final updatedTickets = await ref
          .read(ticketRepositoryProvider)
          .getTickets();
      state = AsyncValue.data(updatedTickets);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}

final ticketListProvider =
    AsyncNotifierProvider<TicketListNotifier, List<TicketEntity>>(() {
      return TicketListNotifier();
    });

final ticketStatsProvider = Provider<Map<String, int>>((ref) {
  final ticketsAsync = ref.watch(ticketListProvider);
  
  return ticketsAsync.maybeWhen(
    data: (tickets) {
      return {
        'total': tickets.length, // Total tiket [cite: 87]
        'open': tickets.where((t) => t.status == TicketStatus.open).length,
        'inProgress': tickets.where((t) => t.status == TicketStatus.inProgress).length,
        'resolved': tickets.where((t) => t.status == TicketStatus.resolved).length,
        'closed': tickets.where((t) => t.status == TicketStatus.closed).length,
      };
    },
    // Default value saat loading atau error
    orElse: () => {
      'total': 0,
      'open': 0,
      'inProgress': 0,
      'resolved': 0,
      'closed': 0,
    },
  );
});