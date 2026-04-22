import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/ticket_entity.dart';
import '../../domain/entities/comment_entity.dart';
import '../widgets/status_badge.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/ticket_provider.dart';

class TicketDetailScreen extends ConsumerStatefulWidget {
  final TicketEntity ticket;
  const TicketDetailScreen({super.key, required this.ticket});

  @override
  ConsumerState<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends ConsumerState<TicketDetailScreen> {
  final TextEditingController _commentController = TextEditingController();
  CommentEntity? _replyingTo;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    // 1. Pantau perubahan list tiket secara global
    final ticketsAsync = ref.watch(ticketListProvider);

    return ticketsAsync.when(
      data: (tickets) {
        TicketEntity currentTicket;
        try {
          currentTicket = tickets.firstWhere((t) => t.id == widget.ticket.id);
        } catch (_) {
          currentTicket = widget.ticket;
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(title: Text(currentTicket.id)),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- INFORMASI TIKET ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StatusBadge(status: currentTicket.status),
                          _buildPriorityTag(currentTicket.priority),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        currentTicket.title,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Created on: ${currentTicket.createdAt.toString().split('.')[0]}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const Divider(height: 40),
                      const Text(
                        "Description",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentTicket.description,
                        style: const TextStyle(fontSize: 15, height: 1.5),
                      ),
                      const SizedBox(height: 30),

                      // --- LAMPIRAN ---
                      if (currentTicket.attachments.isNotEmpty) ...[
                        const Text(
                          "Attachments",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildAttachmentList(currentTicket.attachments),
                      ],

                      const Divider(height: 50),

                      // --- KOMENTAR (Menggunakan currentTicket) ---
                      const Text(
                        "Comments",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),

                      if (currentTicket.comments.isEmpty)
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              "Belum ada komentar",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: currentTicket.comments.length,
                          itemBuilder: (context, index) {
                            return _buildCommentItem(
                              currentTicket.comments[index],
                            );
                          },
                        ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              // 3. Bar Input Komentar
              _buildCommentInput(user, currentTicket.id),
            ],
          ),
        );
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, s) => Scaffold(body: Center(child: Text("Error: $e"))),
    );
  }

  // Helper Widget: List Lampiran
  Widget _buildAttachmentList(List<String> paths) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: paths.length,
        itemBuilder: (context, index) {
          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: FileImage(File(paths[index])),
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  // Helper Widget: Item Komentar Rekursif
  Widget _buildCommentItem(CommentEntity comment, {bool isReply = false}) {
    return Padding(
      padding: EdgeInsets.only(left: isReply ? 40.0 : 0.0, bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  comment.senderName[0],
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                comment.senderName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                "${comment.timestamp.hour}:${comment.timestamp.minute.toString().padLeft(2, '0')}",
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(comment.message),
          ),
          if (!isReply)
            TextButton(
              onPressed: () => setState(() => _replyingTo = comment),
              child: const Text("Balas", style: TextStyle(fontSize: 12)),
            ),
          if (comment.replies.isNotEmpty)
            ...comment.replies.map(
              (reply) => _buildCommentItem(reply, isReply: true),
            ),
        ],
      ),
    );
  }

  // Helper Widget: Input Bar
  Widget _buildCommentInput(dynamic user, String ticketId) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_replyingTo != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              margin: const EdgeInsets.only(bottom: 8),
              color: Colors.grey.shade100,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Membalas ${_replyingTo!.senderName}...",
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 16),
                    onPressed: () => setState(() => _replyingTo = null),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: "Tulis komentar...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send, color: AppColors.primary),
                onPressed: () async {
                  if (_commentController.text.trim().isEmpty) return;
                  final newComment = CommentEntity(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    senderName: user?.name ?? "User",
                    senderId: user?.id ?? "unknown",
                    message: _commentController.text,
                    timestamp: DateTime.now(),
                    replies: [],
                  );
                  await ref
                      .read(ticketListProvider.notifier)
                      .sendComment(
                        ticketId: ticketId,
                        comment: newComment,
                        parentCommentId: _replyingTo?.id,
                      );
                  _commentController.clear();
                  setState(() => _replyingTo = null);
                  FocusScope.of(context).unfocus();
                },
              ),
            ],
          ),
        ],
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
        priority.toString().split('.').last.toUpperCase(),
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}
