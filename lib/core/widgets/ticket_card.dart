// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class TicketCard extends StatelessWidget {
  final String title;
  final String date;
  final String status;
  final double progress; // 0.0 - 1.0
  final VoidCallback onTap;

  const TicketCard({
    super.key,
    required this.title,
    required this.date,
    required this.status,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(date, style: const TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(status, style: const TextStyle(color: AppColors.warning, fontSize: 12, fontWeight: FontWeight.w600)),
                Text("${(progress * 100).toInt()}%", style: const TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.warning),
              borderRadius: BorderRadius.circular(10),
            ),
          ],
        ),
      ),
    );
  }
}