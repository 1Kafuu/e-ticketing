import 'package:flutter/material.dart' hide TextField;
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/text_field.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        // Meniru bagian kiri AppBar: Welcome User
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hi Jenifer!", style: textTheme.headlineLarge),
            Text("Good Morning", style: textTheme.bodyMedium),
          ],
        ),
        actions: [
          // Meniru tombol lonceng notifikasi (FR-007)
          IconButton(
            onPressed: () {}, // Logika ke halaman notifikasi
            icon: const Icon(Icons.notifications_none),
          ),
          // Meniru bagian menu burger di kanan
          IconButton(
            onPressed: () {}, 
            icon: const Icon(Icons.grid_view),
          ),
        ],
      ),
      
      // Floating Action Button sesuai referensi (FR-005: Membuat tiket)
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {}, // Logika ke Create Ticket Screen
        backgroundColor: AppColors.primary,
        elevation: 10,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 30,),
      ),
      
      // Bottom Navigation Bar sesuai referensi
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: SizedBox(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(icon: const Icon(Icons.home_outlined), onPressed: () {}),
              IconButton(icon: const Icon(Icons.library_books_outlined), onPressed: () {}),
              const SizedBox(width: 48), // Spacer untuk Notch FAB
              IconButton(icon: const Icon(Icons.payment_outlined), onPressed: () {}),
              IconButton(icon: const Icon(Icons.person_pin_outlined), onPressed: () {}),
            ],
          ),
        ),
      ),
      
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Baris Search sesuai desain
              const SizedBox(height: 8),
              _buildSearchSection(),
              
              // 2. Banner "Welcome" sesuai desain
              const SizedBox(height: 24),
              _buildWelcomeBanner(context),
              
              // 3. Section "Ongoing Tickets" sesuai desain
              const SizedBox(height: 24),
              _buildOngoingSection(context),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Helper: Search Section
  Widget _buildSearchSection() {
    return const CustomTextField (
        label: "Search", 
        hint: "Search tickets...",
        icon: Icons.search,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
          hintText: "Search",
          hintStyle: TextStyle(color: AppColors.textSecondary),
          filled: true,
          fillColor: Colors.white, // Meniru warna accent bersih
          contentPadding: EdgeInsets.symmetric(horizontal: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
            borderSide: BorderSide.none,
          ),
        ),
    );
  }

  // Widget Helper: Welcome Banner
  Widget _buildWelcomeBanner(BuildContext context) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15.0),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Row(
      children: [
        Image(
          image: const AssetImage('assets/images/welcome_illustration.png'), 
          width: 80,
          height: 80,
          errorBuilder: (context, error, stackTrace) {
            return const SizedBox( 
              width: 80, 
              height: 80, 
              child: Icon(Icons.image),
            );
          },
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Welcome!", style: Theme.of(context).textTheme.titleLarge),
              Text("Let's manage your tickets smoothly.", style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ],
    ),
  );
}

  // Widget Helper: Ongoing Tickets Section
  Widget _buildOngoingSection(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Ongoing Tickets", style: Theme.of(context).textTheme.titleLarge),
            TextButton(
              onPressed: () {}, 
              child: const Text("view all", style: TextStyle(color: AppColors.textSecondary)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // GridView untuk meniru tata letak Ongoing Projects
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.8, // Menyesuaikan tinggi card
          ),
          itemCount: 2, // Mock: Hanya 2 tiket berjalan
          itemBuilder: (context, index) {
            // Kita akan menggunakan widget stateless "TicketCard" yang nanti akan dibuat di core
            return _buildTicketCardMock(context); 
          },
        ),
      ],
    );
  }

  // MOCK WIDGET: Ticket Card (Berdasarkan model data)
  Widget _buildTicketCardMock(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primary, // Card warna utama sesuai desain
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("May 20, 2026", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70)),
          const SizedBox(height: 8),
          Text("IT Helpdesk App", style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white)),
          Text("Status: In Progress", style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.warning)),
          const Spacer(),
          // Meniru Progress Bar di reference
          LinearProgressIndicator(
            value: 0.6, // Mock Progress 60%
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.warning),
            borderRadius: BorderRadius.circular(5.0),
          ),
          const SizedBox(height: 4),
          const Text("60%", style: TextStyle(color: Colors.white, fontSize: 10)),
        ],
      ),
    );
  }
}