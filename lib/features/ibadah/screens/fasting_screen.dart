import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class FastingScreen extends StatefulWidget {
  const FastingScreen({super.key});

  @override
  State<FastingScreen> createState() => _FastingScreenState();
}

class _FastingScreenState extends State<FastingScreen> {
  final int _qadhaRemaining = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: AppColors.primaryMid),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Fasting Tracker',
          style: GoogleFonts.outfit(color: AppColors.primaryMid, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQadhaCard(),
            const SizedBox(height: 32),
            _buildSectionHeader('Upcoming Sunnah Fast'),
            const SizedBox(height: 16),
            _buildSunnahList(),
            const SizedBox(height: 32),
            _buildSectionHeader('Fasting History'),
            const SizedBox(height: 16),
            _buildHistoryList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppColors.primaryMid,
        icon: const Icon(LucideIcons.plus, color: Colors.white),
        label: Text('Log Fast', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildQadhaCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6A9113), Color(0xFF141517)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Qadha Remaining', style: GoogleFonts.outfit(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('$_qadhaRemaining Days', style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
              const Icon(LucideIcons.calendarClock, color: AppColors.accentGreen, size: 40),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: 0.7, // Simulated progress
                  backgroundColor: Colors.white10,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentGreen),
                  minHeight: 8,
                ),
              ),
              const SizedBox(width: 16),
              Text('70%', style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Keep going! You have almost finished your Qadha.',
            style: GoogleFonts.outfit(color: Colors.white70, fontSize: 12),
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

  Widget _buildSunnahList() {
    final sunnahFasts = [
      {'title': 'Monday Fast', 'date': 'Tomorrow, 12 May', 'icon': LucideIcons.moon},
      {'title': 'Thursday Fast', 'date': '15 May 2026', 'icon': LucideIcons.moon},
      {'title': 'Ayyamul Bidh', 'date': '24-26 May 2026', 'icon': LucideIcons.star},
    ];

    return Column(
      children: sunnahFasts.map((fast) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[100]!),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(fast['icon'] as IconData, color: AppColors.primaryMid, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(fast['title'] as String, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(fast['date'] as String, style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(LucideIcons.chevronRight, size: 16, color: Colors.grey),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHistoryList() {
    final history = [
      {'type': 'Sunnah', 'date': '08 May 2026', 'status': 'Completed'},
      {'type': 'Qadha', 'date': '04 May 2026', 'status': 'Completed'},
      {'type': 'Qadha', 'date': '01 May 2026', 'status': 'Completed'},
    ];

    return Column(
      children: history.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(color: AppColors.accentGreen, shape: BoxShape.circle),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${item['type']} Fasting', style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 14)),
                    Text(item['date']!, style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
              Text(
                item['status']!,
                style: GoogleFonts.outfit(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
