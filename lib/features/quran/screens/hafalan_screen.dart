import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../models/quran_model.dart';

class HafalanScreen extends StatefulWidget {
  const HafalanScreen({super.key});

  @override
  State<HafalanScreen> createState() => _HafalanScreenState();
}

class _HafalanScreenState extends State<HafalanScreen> {
  // Mock data for memorization progress
  final List<Map<String, dynamic>> _hafalanList = [
    {'surah': mockSurahs[0], 'progress': 1.0, 'verses': '1-7'},
    {'surah': mockSurahs[1], 'progress': 0.4, 'verses': '1-15'},
    {'surah': mockSurahs[2], 'progress': 0.1, 'verses': '1-5'},
  ];

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
          'Hafalan Quran',
          style: GoogleFonts.outfit(color: AppColors.primaryMid, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plusCircle, color: AppColors.accentGreen),
            onPressed: () => _showAddHafalanDialog(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverallProgress(),
            const SizedBox(height: 32),
            _buildSectionHeader('My Progress'),
            const SizedBox(height: 16),
            _buildHafalanList(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallProgress() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primaryMid,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppColors.primaryMid.withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8)),
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
                  Text('Overall Progress', style: GoogleFonts.outfit(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 4),
                  Text('2 Surahs Memorized', style: GoogleFonts.outfit(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const Icon(LucideIcons.award, color: AppColors.accentGreen, size: 40),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.15,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentGreen),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('15% to 1 Juz', style: GoogleFonts.outfit(color: Colors.white70, fontSize: 12)),
              Text('Keep it up!', style: GoogleFonts.outfit(color: AppColors.accentGreen, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
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

  Widget _buildHafalanList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _hafalanList.length,
      itemBuilder: (context, index) {
        final item = _hafalanList[index];
        final Surah surah = item['surah'];
        final double progress = item['progress'];
        final String verses = item['verses'];

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 4)),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        '${surah.id}',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.primaryMid),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(surah.name, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Verse: $verses', style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ),
                  if (progress == 1.0)
                    const Icon(LucideIcons.checkCircle2, color: AppColors.accentGreen)
                  else
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppColors.primaryMid),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: AppColors.backgroundLight,
                  valueColor: AlwaysStoppedAnimation<Color>(progress == 1.0 ? AppColors.accentGreen : AppColors.primaryMid),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddHafalanDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 24),
            Text('Add New Hafalan', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Select surah and set your progress goal', style: GoogleFonts.outfit(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: mockSurahs.length,
                itemBuilder: (context, index) {
                  final surah = mockSurahs[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(backgroundColor: AppColors.backgroundLight, child: Text('${surah.id}', style: const TextStyle(color: AppColors.primaryMid, fontSize: 12))),
                    title: Text(surah.name, style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
                    subtitle: Text('${surah.verseCount} Verses', style: GoogleFonts.outfit(fontSize: 12)),
                    trailing: const Icon(LucideIcons.plus, size: 20),
                    onTap: () => Navigator.pop(context),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
