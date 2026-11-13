import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../models/quran_model.dart';

class QuranDetailScreen extends StatefulWidget {
  final int initialIndex;

  const QuranDetailScreen({super.key, required this.initialIndex});

  @override
  State<QuranDetailScreen> createState() => _QuranDetailScreenState();
}

class _QuranDetailScreenState extends State<QuranDetailScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: mockSurahs.length,
      initialIndex: widget.initialIndex,
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(LucideIcons.chevronLeft, color: AppColors.primaryMid),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Surah',
            style: GoogleFonts.outfit(
              color: AppColors.primaryMid,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(LucideIcons.search, color: AppColors.primaryMid),
              onPressed: () {},
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: AppColors.accentGreen,
            labelColor: AppColors.primaryMid,
            unselectedLabelColor: Colors.grey,
            labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold),
            unselectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.normal),
            onTap: (index) {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            tabs: mockSurahs.map((surah) => Tab(text: surah.name)).toList(),
          ),
        ),
        body: Builder(
          builder: (context) {
            final tabController = DefaultTabController.of(context);
            return PageView.builder(
              controller: _pageController,
              itemCount: mockSurahs.length,
              onPageChanged: (index) {
                tabController.animateTo(index);
              },
              itemBuilder: (context, index) {
                final surah = mockSurahs[index];
                return _SurahView(surah: surah);
              },
            );
          },
        ),
      ),
    );
  }
}

class _SurahView extends StatelessWidget {
  final Surah surah;

  const _SurahView({required this.surah});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SurahBanner(surah: surah),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: mockVerses.length,
            separatorBuilder: (context, index) => const Divider(height: 40, color: Color(0xFFE0E0E0)),
            itemBuilder: (context, index) {
              final verse = mockVerses[index];
              return _VerseTile(verse: verse);
            },
          ),
        ),
      ],
    );
  }
}

class _SurahBanner extends StatelessWidget {
  final Surah surah;

  const _SurahBanner({required this.surah});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryMid, AppColors.accentGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGreen.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            surah.name,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            surah.meaning,
            style: GoogleFonts.outfit(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white24, indent: 40, endIndent: 40),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                surah.revelation.toUpperCase(),
                style: GoogleFonts.outfit(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.circle, color: Colors.white, size: 4),
              const SizedBox(width: 8),
              Text(
                '${surah.verseCount} VERSES',
                style: GoogleFonts.outfit(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
            style: GoogleFonts.amiri(
              color: Colors.white,
              fontSize: 28,
            ),
          ),
        ],
      ),
    );
  }
}

class _VerseTile extends StatelessWidget {
  final Verse verse;

  const _VerseTile({required this.verse});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4F2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: AppColors.primaryMid,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${verse.id}',
                    style: GoogleFonts.outfit(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Spacer(),
              const Icon(LucideIcons.share2, color: AppColors.primaryMid, size: 20),
              const SizedBox(width: 16),
              const Icon(LucideIcons.playCircle, color: AppColors.primaryMid, size: 20),
              const SizedBox(width: 16),
              const Icon(LucideIcons.bookmark, color: AppColors.primaryMid, size: 20),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          verse.arabicText,
          textAlign: TextAlign.right,
          style: GoogleFonts.amiri(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2D3E33),
            height: 2,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          verse.translation,
          style: GoogleFonts.outfit(
            fontSize: 14,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
