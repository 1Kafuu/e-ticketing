import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color color;
  final bool isDark;

  const StatCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    this.isDark = false,
  });

  // Check if this stat card is for Total Tickets or In Progress
  bool _isPriorityCard() {
    return title == 'Total Tickets' || title == 'In Progress';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Color(0xFF333333) : Colors.grey.shade200,
          width: 1.5,
        ),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
             child: Icon(
               icon,
               color: _isPriorityCard() && isDark
                   ? AppColors.primary
                   : color,
               size: 20,
             ),
          ),
          const SizedBox(height: 12),
           Text(
             count,
             style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                   fontWeight: FontWeight.bold,
                   color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                 ),
           ),
           Text(
             title,
             style: Theme.of(context).textTheme.bodySmall?.copyWith(
                   color: isDark ? AppColors.textSecondaryDark : Colors.grey,
                 ),
           ),
        ],
      ),
    );
  }
}