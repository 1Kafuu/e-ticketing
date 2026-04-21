import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/ticket_entity.dart';
import '../../domain/entities/ticket_enum.dart'; // Pastikan nama file enum benar
import '../providers/ticket_provider.dart';

class CreateTicketScreen extends ConsumerStatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  ConsumerState<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends ConsumerState<CreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  
  TicketPriority _selectedPriority = TicketPriority.medium;
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70, // Kompresi sedikit agar tidak terlalu berat di SharedPreferences
    );
    if (image != null) {
      setState(() {
        _selectedImages.add(File(image.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _submitTicket() async {
    if (!_formKey.currentState!.validate()) return;

    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User session tidak ditemukan")),
      );
      return;
    }

    // Mengambil list tiket saat ini untuk menentukan sequence ID
    final currentTickets = ref.read(ticketListProvider).value ?? [];
    final nextSequence = currentTickets.length + 1;
    
    // Menggunakan IdGenerator kustom kamu
    final ticketId = IdGenerator.generateTicketId(nextSequence);

    final newTicket = TicketEntity(
      id: ticketId,
      title: _titleController.text,
      description: _descController.text,
      status: TicketStatus.open,
      priority: _selectedPriority,
      createdAt: DateTime.now(),
      userId: currentUser.id,
      attachments: _selectedImages.map((file) => file.path).toList(),
    );

    // Tampilkan loading dialog atau indikator jika perlu
    await ref.read(ticketListProvider.notifier).addTicket(newTicket);
    
    if (mounted) {
      Navigator.pop(context); // Kembali ke Dashboard
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Tiket $ticketId berhasil dibuat!"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Create New Ticket"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Judul Masalah", style: textTheme.titleMedium),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: "Contoh: WiFi Kantor Bermasalah",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (v) => v!.isEmpty ? "Judul wajib diisi" : null,
              ),
              const SizedBox(height: 20),
              
              Text("Deskripsi Detail", style: textTheme.titleMedium),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Jelaskan detail kendala Anda...",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (v) => v!.isEmpty ? "Deskripsi wajib diisi" : null,
              ),
              const SizedBox(height: 20),
              
              Text("Prioritas", style: textTheme.titleMedium),
              const SizedBox(height: 8),
              Row(
                children: TicketPriority.values.map((priority) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Text(priority.name.toUpperCase()),
                        selected: _selectedPriority == priority,
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedPriority = priority);
                        },
                        selectedColor: AppColors.primary.withOpacity(0.2),
                        labelStyle: TextStyle(
                          color: _selectedPriority == priority 
                            ? AppColors.primary 
                            : Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              
              Text("Lampiran Gambar", style: textTheme.titleMedium),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _selectedImages.length) {
                      return GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: const Icon(Icons.add_a_photo, color: Colors.grey),
                        ),
                      );
                    }
                    return Stack(
                      children: [
                        Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: FileImage(_selectedImages[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: const CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.red,
                              child: Icon(Icons.close, size: 14, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
              
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _submitTicket,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "SUBMIT TICKET",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}