import 'dart:io';
import 'package:flutter/material.dart';
import '../../domain/entities/ticket_entity.dart';
import '../../../../core/theme/app_colors.dart';

class TicketCard extends StatelessWidget {
  final TicketEntity ticket;
  const TicketCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        // 1. Ganti Row jadi Column
        crossAxisAlignment:
            CrossAxisAlignment.start, // 2. Ratakan konten ke kiri
        children: [
          // Thumbnail Gambar (Sekarang di paling atas)
          if (ticket.attachments.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ticket.attachments.first.startsWith('http')
                  ? Image.network(
                      ticket.attachments.first,
                      width: double.infinity, // 3. Lebar penuh
                      height: 100, // 4. Sesuaikan tinggi gambar
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      File(ticket.attachments.first),
                      width: double.infinity,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
            )
          else
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.image_outlined, color: AppColors.primary),
            ),

          const SizedBox(height: 12), // Beri jarak antara gambar dan teks
          // Info Tiket
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                // Gunakan Row di sini agar judul dan badge status tetap sejajar menyamping
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      ticket.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(ticket.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      ticket.status.label,
                      style: TextStyle(
                        color: _getStatusColor(ticket.status),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                ticket.description,
                maxLines: 2, // Deskripsi bisa lebih panjang dikit
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(dynamic status) {
    // Logika warna berdasarkan TicketStatus enum
    return AppColors.primary; // Placeholder
  }
}
