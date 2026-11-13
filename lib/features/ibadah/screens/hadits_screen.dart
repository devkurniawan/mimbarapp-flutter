import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class HaditsScreen extends StatelessWidget {
  const HaditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHaditsOfTheDay(),
                  const SizedBox(height: 32),
                  _buildSectionHeader('Buku Hadits'),
                  const SizedBox(height: 16),
                  _buildHaditsBooks(),
                  const SizedBox(height: 32),
                  _buildSectionHeader('Kategori Populer'),
                  const SizedBox(height: 16),
                  _buildCategories(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: AppColors.primaryMid,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Hadits',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
      ),
      leading: const BackButton(color: Colors.white),
      actions: [
        IconButton(icon: const Icon(LucideIcons.search, color: Colors.white), onPressed: () {}),
      ],
    );
  }

  Widget _buildHaditsOfTheDay() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 15, offset: Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.quote, color: AppColors.accentGreen, size: 24),
              const SizedBox(width: 12),
              Text(
                'Hadits Hari Ini',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.primaryMid),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Innamal a\'malu binniyat...',
            style: GoogleFonts.amiri(fontSize: 20, fontWeight: FontWeight.bold, height: 1.8),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 12),
          Text(
            '"Sesungguhnya setiap amal itu bergantung pada niatnya..."',
            style: GoogleFonts.outfit(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Text(
            'HR. Bukhari & Muslim',
            style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.accentGreen),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryMid),
    );
  }

  Widget _buildHaditsBooks() {
    final books = [
      {'name': 'Shahih Bukhari', 'count': '7000+ Hadits', 'color': Colors.blue},
      {'name': 'Shahih Muslim', 'count': '5000+ Hadits', 'color': Colors.green},
      {'name': 'Abu Daud', 'count': '4000+ Hadits', 'color': Colors.orange},
      {'name': 'At-Tirmidzi', 'count': '3000+ Hadits', 'color': Colors.purple},
    ];

    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return Container(
            width: 120,
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (book['color'] as Color).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: (book['color'] as Color).withValues(alpha: 0.2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.book, color: book['color'] as Color, size: 32),
                const SizedBox(height: 12),
                Text(
                  book['name'] as String,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                Text(
                  book['count'] as String,
                  style: GoogleFonts.outfit(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategories() {
    final categories = [
      {'name': 'Adab', 'icon': LucideIcons.smile},
      {'name': 'Iman', 'icon': LucideIcons.shieldCheck},
      {'name': 'Shalat', 'icon': LucideIcons.timer},
      {'name': 'Puasa', 'icon': LucideIcons.sun},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.5,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.grey[100]!),
          ),
          child: Row(
            children: [
              Icon(cat['icon'] as IconData, color: AppColors.accentGreen, size: 20),
              const SizedBox(width: 12),
              Text(
                cat['name'] as String,
                style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      },
    );
  }
}
