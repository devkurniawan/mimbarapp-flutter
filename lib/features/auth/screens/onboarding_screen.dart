import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../dashboard/screens/main_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = const [
    OnboardingData(
      badgeText: 'KOLEKSI KHUTBAH',
      badgeColor: AppTheme.secondaryContainer,
      icon: Icons.menu_book_rounded,
      title: 'Koleksi Naskah Khutbah Lengkap & Terstruktur',
      subtitle:
          'Akses ribuan naskah khutbah Jumat, Hari Raya, dan kajian tematik siap pakai dengan rujukan dalil shahih Al-Qur\'an dan Hadits.',
      tags: ['Khutbah Jumat', 'Idul Fitri', 'Dalil Shahih', 'Kajian Tematik'],
      gradientColors: [Color(0xFF064E3B), Color(0xFF003527)],
    ),
    OnboardingData(
      badgeText: 'TELEPROMPTER CERDAS',
      badgeColor: Color(0xFF0284C7),
      icon: Icons.speed_rounded,
      title: 'Tampil Percaya Diri di Atas Mimbar',
      subtitle:
          'Layar prompter bebas silau dengan pengatur kecepatan scroll otomatis, mode naskah full-screen, dan ukuran font jumbo yang nyaman dibaca.',
      tags: ['Auto-Scroll', 'Font Jumbo', 'Bebas Silau', 'Mode Khutbah'],
      gradientColors: [Color(0xFF0369A1), Color(0xFF075985)],
    ),
    OnboardingData(
      badgeText: 'AL-QUR\'AN & IBADAH',
      badgeColor: Color(0xFF10B981),
      icon: Icons.auto_stories_rounded,
      title: 'Al-Qur\'an, Arah Kiblat, & Waktu Sholat',
      subtitle:
          'Kemudahan membaca Al-Qur\'an per ayat, kompas kiblat akurat, pengingat azan, dan digital tasbih dalam genggaman.',
      tags: ['Al-Qur\'an 30 Juz', 'Arah Kiblat', 'Jadwal Sholat', 'Digital Tasbih'],
      gradientColors: [Color(0xFF047857), Color(0xFF064E3B)],
    ),
    OnboardingData(
      badgeText: 'MODE LATIHAN',
      badgeColor: Color(0xFF7C3AED),
      icon: Icons.record_voice_over_rounded,
      title: 'Simulasi & Monitor Durasi Khutbah',
      subtitle:
          'Latih artikulasi dan tempo penyampaian sebelum tampil. Hitung estimasi waktu membaca naskah agar khutbah berjalan tepat waktu.',
      tags: ['Timer Khutbah', 'Hitung Tempo', 'Evaluasi Intonasi', 'Latihan Pidato'],
      gradientColors: [Color(0xFF5B21B6), Color(0xFF4C1D95)],
    ),
    OnboardingData(
      badgeText: 'JADWAL DAKWAH',
      badgeColor: Color(0xFFD97706),
      icon: Icons.event_available_rounded,
      title: 'Kelola Agenda & Lokasi Masjid',
      subtitle:
          'Catat jadwal khutbah di berbagai masjid, atur pengingat otomatis H-1, dan simpan riwayat tema kajian yang telah disajikan.',
      tags: ['Agenda Masjid', 'Pengingat Otomatis', 'Riwayat Tema', 'Catatan Evaluasi'],
      gradientColors: [Color(0xFFB45309), Color(0xFF78350F)],
    ),
  ];

  void _finishOnboarding() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MainScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar (Branding & Skip Button)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // App Brand Logo Indicator
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.mosque_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'MIMBAR',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),

                  // Skip Button
                  if (!isLastPage)
                    TextButton(
                      onPressed: _finishOnboarding,
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.onSurfaceVariant,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      child: const Text(
                        'Lewati',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 36),
                ],
              ),
            ),

            // Main Carousel View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return _buildPageCard(page);
                },
              ),
            ),

            // Bottom Navigation Controls
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0A000000),
                    blurRadius: 16,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Active Page Indicators (Expanding Pill)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 28 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppTheme.primaryContainer
                              : AppTheme.outlineVariant,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Main Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isLastPage
                            ? AppTheme.secondaryContainer
                            : AppTheme.primaryContainer,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shadowColor: isLastPage
                            ? AppTheme.secondaryContainer.withAlpha(100)
                            : AppTheme.primaryContainer.withAlpha(100),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusLg),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isLastPage ? 'Mulai Sekarang' : 'Lanjut',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            isLastPage
                                ? Icons.rocket_launch_rounded
                                : Icons.arrow_forward_rounded,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageCard(OnboardingData page) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          // Visual Hero Card
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: page.gradientColors,
                ),
                boxShadow: [
                  BoxShadow(
                    color: page.gradientColors.first.withAlpha(80),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Decorative Pattern Circles
                  Positioned(
                    top: -40,
                    right: -40,
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withAlpha(15),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -30,
                    left: -30,
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withAlpha(10),
                      ),
                    ),
                  ),

                  // Hero Icon Container
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withAlpha(25),
                            border: Border.all(
                              color: Colors.white.withAlpha(50),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            page.icon,
                            size: 64,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Category Chips Matrix
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: page.tags.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(30),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.white.withAlpha(40),
                                ),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Text Content Section
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Feature Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: page.badgeColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: page.badgeColor.withAlpha(60),
                      ),
                    ),
                    child: Text(
                      page.badgeText,
                      style: TextStyle(
                        color: page.badgeColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Slide Title
                  Text(
                    page.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.onSurface,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Slide Subtitle / Description
                  Text(
                    page.subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String badgeText;
  final Color badgeColor;
  final IconData icon;
  final String title;
  final String subtitle;
  final List<String> tags;
  final List<Color> gradientColors;

  const OnboardingData({
    required this.badgeText,
    required this.badgeColor,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.tags,
    required this.gradientColors,
  });
}
