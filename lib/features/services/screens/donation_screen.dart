import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class DonationScreen extends StatelessWidget {
  const DonationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatsCard(),
                  const SizedBox(height: 32),
                  _buildSectionHeader('Categories'),
                  const SizedBox(height: 16),
                  _buildCategories(),
                  const SizedBox(height: 32),
                  _buildSectionHeader('Active Campaigns'),
                  const SizedBox(height: 16),
                  _buildCampaignList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primaryMid,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Donation',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
      ),
      leading: const BackButton(color: Colors.white),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryMid, AppColors.accentGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGreen.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Total Donation',
            style: GoogleFonts.outfit(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            'Rp 2.500.000',
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.heart, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'You have helped 12 programs this month',
                    style: GoogleFonts.outfit(color: Colors.white, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryMid,
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text('See All', style: GoogleFonts.outfit(color: AppColors.accentGreen)),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    final categories = [
      {'name': 'Mosque', 'icon': LucideIcons.home},
      {'name': 'Orphan', 'icon': LucideIcons.user},
      {'name': 'Health', 'icon': LucideIcons.activity},
      {'name': 'Disaster', 'icon': LucideIcons.flame},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categories.map((cat) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 4)),
                ],
              ),
              child: Icon(cat['icon'] as IconData, color: AppColors.primaryMid),
            ),
            const SizedBox(height: 8),
            Text(
              cat['name'] as String,
              style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildCampaignList() {
    return Column(
      children: [
        _buildCampaignCard(
          title: 'Emergency Aid for Palestine',
          organizer: 'ACT Foundation',
          collected: 150000000,
          target: 200000000,
          daysLeft: 5,
          color: Colors.red[400]!,
        ),
        const SizedBox(height: 20),
        _buildCampaignCard(
          title: 'Build Al-Ikhlas Mosque',
          organizer: 'Local Committee',
          collected: 75000000,
          target: 100000000,
          daysLeft: 24,
          color: AppColors.accentGreen,
        ),
      ],
    );
  }

  Widget _buildCampaignCard({
    required String title,
    required String organizer,
    required double collected,
    required double target,
    required int daysLeft,
    required Color color,
  }) {
    final progress = collected / target;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mock Image Placeholder
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Center(child: Icon(LucideIcons.image, color: color, size: 40)),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  organizer,
                  style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Collected', style: GoogleFonts.outfit(color: Colors.grey, fontSize: 11)),
                        Text(
                          'Rp ${collected.toInt()}',
                          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: color),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Days Left', style: GoogleFonts.outfit(color: Colors.grey, fontSize: 11)),
                        Text(
                          '$daysLeft',
                          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
