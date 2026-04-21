import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/ticket_entity.dart';
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
    return ref.read(ticketRepositoryProvider).getTickets();
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
}

final ticketListProvider = AsyncNotifierProvider<TicketListNotifier, List<TicketEntity>>(() {
  return TicketListNotifier();
});