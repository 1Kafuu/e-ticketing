import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

class IdGenerator {
  static String generateTicketId(int sequenceNumber) {
    final String datePart = DateFormat('yyyyMMdd').format(DateTime.now());
    
    final String sequencePart = sequenceNumber.toString().padLeft(3, '0');
    
    return "${AppConstants.ticketIdPrefix}-$datePart-$sequencePart";
  }
}