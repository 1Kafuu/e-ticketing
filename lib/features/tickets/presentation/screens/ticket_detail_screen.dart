import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/ticket_entity.dart';
import '../widgets/status_badge.dart'; // Menggunakan widget status_badge di folder widgets kamu

class TicketDetailScreen extends StatelessWidget {
  final TicketEntity ticket;

  const TicketDetailScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(ticket.id),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Status & Priority
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatusBadge(status: ticket.status), // Pastikan widget ini menerima enum status
                _buildPriorityTag(ticket.priority),
              ],
            ),
            const SizedBox(height: 20),

            // Title
            Text(
              ticket.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              "Created on: ${ticket.createdAt.toString().split('.')[0]}",
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(height: 40),

            // Description
            const Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              ticket.description,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 30),

            // Attachments
            if (ticket.attachments.isNotEmpty) ...[
              const Text(
                "Attachments",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: ticket.attachments.length,
                  itemBuilder: (context, index) {
                    final path = ticket.attachments[index];
                    return Container(
                      width: 120,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: FileImage(File(path)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityTag(dynamic priority) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        // PERBAIKAN: Gunakan .label (jika sudah ditambah di enum) 
        // atau toString().split('.').last agar tidak error 'name'
        priority.toString().split('.').last.toUpperCase(),
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}