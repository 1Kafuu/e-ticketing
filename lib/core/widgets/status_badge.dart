// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'open': return AppColors.error;
      case 'in progress': return AppColors.warning;
      case 'resolved': return AppColors.success;
      default: return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _getStatusColor()),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(color: _getStatusColor(), fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }
}