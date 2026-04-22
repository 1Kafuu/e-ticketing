import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/pref_keys.dart';

abstract class TicketLocalDataSource {
  Future<void> saveTickets(List<Map<String, dynamic>> tickets);
  Future<List<Map<String, dynamic>>> getTickets();
  Future<void> addTicket(Map<String, dynamic> ticket);
  Future<void>  updateTicket(Map<String, dynamic> updatedTicket);
  Future<void> deleteTicket(String ticketId);
}

class TicketLocalDataSourceImpl implements TicketLocalDataSource {
  final SharedPreferences sharedPreferences;

  TicketLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<Map<String, dynamic>>> getTickets() async {
    // Menggunakan PrefsKeys.ticketData agar seragam dengan Auth
    final jsonString = sharedPreferences.getString(PrefsKeys.ticketData);
    if (jsonString != null) {
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.map((e) => e as Map<String, dynamic>).toList();
    }
    return [];
  }

  @override
  Future<void> saveTickets(List<Map<String, dynamic>> tickets) async {
    await sharedPreferences.setString(PrefsKeys.ticketData, jsonEncode(tickets));
  }

  @override
  Future<void> addTicket(Map<String, dynamic> ticket) async {
    final tickets = await getTickets();
    tickets.add(ticket);
    await saveTickets(tickets);
  }

  @override
  Future<void> updateTicket(Map<String, dynamic> updatedTicket) async {
    final tickets = await getTickets();
    final index = tickets.indexWhere((t) => t['id'] == updatedTicket['id']);
    if (index != -1) {
      tickets[index] = updatedTicket;
      await saveTickets(tickets);
    }
  }

  @override
  Future<void> deleteTicket(String ticketId) async {
    final tickets = await getTickets();
    tickets.removeWhere((t) => t['id'] == ticketId);
    await saveTickets(tickets);
  }
}