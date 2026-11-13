import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/theme/app_theme.dart';
import '../../khutbah/models/khutbah_model.dart';
import '../../khutbah/screens/khutbah_detail_screen.dart';
import '../../khutbah/screens/teleprompter_screen.dart';
import '../../khutbah/screens/create_screen.dart';
import '../../khutbah/screens/schedule_screen.dart';
import '../../quran/screens/quran_list_screen.dart';
import '../../ibadah/screens/qiblat_screen.dart';
import '../../ibadah/screens/tasbih_screen.dart';
import '../../ibadah/screens/hadits_screen.dart';
import '../../ibadah/screens/zakat_screen.dart';
import '../../ibadah/screens/fasting_screen.dart';
import '../../services/screens/mosque_screen.dart';
import '../../services/screens/halal_food_screen.dart';
import '../../services/screens/donation_screen.dart';
import '../../services/screens/ask_screen.dart';

class UnifiedHomeScreen extends StatefulWidget {
  const UnifiedHomeScreen({super.key});

  @override
  State<UnifiedHomeScreen> createState() => _UnifiedHomeScreenState();
}

class _UnifiedHomeScreenState extends State<UnifiedHomeScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolledPastHeader = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Header hijau memiliki tinggi sekitar 300-340px
    final bool pastHeader = _scrollController.hasClients && _scrollController.offset > 180;
    if (pastHeader != _isScrolledPastHeader) {
      setState(() {
        _isScrolledPastHeader = pastHeader;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final featuredKhutbah = SampleData.sampleKhutbahs.isNotEmpty
        ? SampleData.sampleKhutbahs[0]
        : null;

    final isDarkIcons = _isScrolledPastHeader;
    final topPadding = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDarkIcons ? Brightness.dark : Brightness.light,
        statusBarBrightness: isDarkIcons ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFF003527),
        body: Container(
          color: AppColors.backgroundLight,
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Header Section with Green Mosque Motif (scrolls together with content)
                    const _TopHeaderSection(),
                    const SizedBox(height: 24),

                    // Mimbar Assistant Quick Banner
                    _MimbarQuickBanner(featuredKhutbah: featuredKhutbah),
                    const SizedBox(height: 26),

                    // Islamic & Da'wah Services Grid
                    const _ServiceGridSection(),
                    const SizedBox(height: 26),

                    // Featured Khutbah Card
                    if (featuredKhutbah != null) ...[
                      _FeaturedKhutbahSection(khutbah: featuredKhutbah),
                      const SizedBox(height: 26),
                    ],

                    // Quran Reading Progress
                    const _QuranProgressSection(),
                    const SizedBox(height: 26),

                    // Daily Dawah Section
                    const _DailyDawahSection(),
                    const SizedBox(height: 36),
                  ],
                ),
              ),

              // Glassmorphic status bar overlay when scrolled
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: topPadding > 0 ? topPadding : 24,
                child: AnimatedOpacity(
                  opacity: _isScrolledPastHeader ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 250),
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.75),
                          border: Border(
                            bottom: BorderSide(
                              color: Colors.black.withValues(alpha: 0.05),
                              width: 0.5,
                            ),
                          ),
                        ),
                      ),
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

class _TopHeaderSection extends StatelessWidget {
  const _TopHeaderSection();

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF003527),
            Color(0xFF064E3B),
            Color(0xFF0D533F),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x22003527),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Mosque Silhouette pinned to bottom of the green section
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                3,
                (index) => Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Icon(
                      Icons.mosque,
                      size: 130,
                      color: Colors.white.withAlpha(22),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content inside green header
          Padding(
            padding: EdgeInsets.only(
              top: topPadding > 0 ? topPadding : 16,
              bottom: 20,
            ),
            child: const Column(
              children: [
                _HeaderSection(),
                _PrayerCountdownSection(),
                SizedBox(height: 6),
                _PrayerTimesSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(40),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.mosque_rounded, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'MIMBAR APP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(LucideIcons.mapPin, color: AppColors.accentGold, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        'Jakarta, Indonesia',
                        style: GoogleFonts.outfit(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.accentGold.withAlpha(220),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.calendar_today_rounded, size: 11, color: Colors.white),
                SizedBox(width: 4),
                Text(
                  '11 Jumada 1448 H',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerCountdownSection extends StatelessWidget {
  const _PrayerCountdownSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(40),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'Menuju Waktu Ashar',
            style: GoogleFonts.outfit(
              color: Colors.white.withAlpha(220),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '- 02:45:10',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }
}

class _PrayerTimesSection extends StatelessWidget {
  const _PrayerTimesSection();

  @override
  Widget build(BuildContext context) {
    final times = [
      {'name': 'Subuh', 'time': '04:32', 'active': false},
      {'name': 'Dzuhur', 'time': '11:58', 'active': false},
      {'name': 'Ashar', 'time': '15:14', 'active': true},
      {'name': 'Maghrib', 'time': '18:02', 'active': false},
      {'name': 'Isya', 'time': '19:15', 'active': false},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(35),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withAlpha(45)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: times.map((t) {
          final isActive = t['active'] as bool;
          return Column(
            children: [
              Text(
                t['name'] as String,
                style: GoogleFonts.outfit(
                  color: isActive ? AppColors.accentGold : Colors.white70,
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                t['time'] as String,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _MimbarQuickBanner extends StatelessWidget {
  final KhutbahModel? featuredKhutbah;

  const _MimbarQuickBanner({this.featuredKhutbah});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 15,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryContainer.withAlpha(25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.mic_rounded, color: AppTheme.primaryContainer, size: 18),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Asisten Khutbah & Dakwah',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.tagAmberBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Fitur Utama',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.tagAmberText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Siapkan materi khutbah, latihan vokal & tampil percaya diri di mimbar dengan teleprompter digital.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CreateScreen()),
                    );
                  },
                  icon: const Icon(Icons.edit_note_rounded, size: 16),
                  label: const Text('Tulis Naskah', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryContainer,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (featuredKhutbah != null)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TeleprompterScreen(khutbah: featuredKhutbah!),
                        ),
                      );
                    },
                    icon: const Icon(Icons.speed_rounded, size: 16),
                    label: const Text('Teleprompter', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryContainer,
                      side: const BorderSide(color: AppTheme.primaryContainer),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ServiceGridSection extends StatelessWidget {
  const _ServiceGridSection();

  @override
  Widget build(BuildContext context) {
    final services = [
      {'title': 'Al-Qur\'an', 'icon': LucideIcons.bookOpen, 'color': const Color(0xFF0D6E57), 'bg': const Color(0xFFE8F5F1), 'page': const QuranListScreen()},
      {'title': 'Arah Kiblat', 'icon': LucideIcons.compass, 'color': const Color(0xFF0F766E), 'bg': const Color(0xFFE6F4F2), 'page': const QiblatScreen()},
      {'title': 'Tasbih Digital', 'icon': LucideIcons.circleDot, 'color': const Color(0xFF1E6F68), 'bg': const Color(0xFFEBF5F4), 'page': const TasbihScreen()},
      {'title': 'Jadwal Mimbar', 'icon': LucideIcons.calendar, 'color': const Color(0xFFB45309), 'bg': const Color(0xFFFEF3C7), 'page': const ScheduleScreen()},
      {'title': 'Kumpulan Hadits', 'icon': LucideIcons.library, 'color': const Color(0xFF047857), 'bg': const Color(0xFFECFDF5), 'page': const HaditsScreen()},
      {'title': 'Hitung Zakat', 'icon': LucideIcons.calculator, 'color': const Color(0xFF0369A1), 'bg': const Color(0xFFE0F2FE), 'page': const ZakatScreen()},
      {'title': 'Jadwal Puasa', 'icon': LucideIcons.moon, 'color': const Color(0xFFC2410C), 'bg': const Color(0xFFFFEDD5), 'page': const FastingScreen()},
      {'title': 'Masjid Terdekat', 'icon': LucideIcons.mapPin, 'color': const Color(0xFF991B1B), 'bg': const Color(0xFFFEE2E2), 'page': const MosqueScreen()},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Layanan & Ibadah',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
              InkWell(
                onTap: () {
                  _showMoreServicesModal(context);
                },
                child: Text(
                  'Lainnya',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accentGold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: services.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 8,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, index) {
              final item = services[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => item['page'] as Widget),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (item['bg'] as Color?) ?? Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: (item['color'] as Color).withValues(alpha: 0.15),
                          width: 1,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0A000000),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        item['icon'] as IconData,
                        color: item['color'] as Color,
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['title'] as String,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showMoreServicesModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Layanan Tambahan',
                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(LucideIcons.utensils, color: Colors.orange),
                title: const Text('Kuliner Halal'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const HalalFoodScreen()));
                },
              ),
              ListTile(
                leading: const Icon(LucideIcons.heart, color: Colors.red),
                title: const Text('Infaq & Donasi'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const DonationScreen()));
                },
              ),
              ListTile(
                leading: const Icon(LucideIcons.helpCircle, color: Colors.blue),
                title: const Text('Tanya Ustadz / AI'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AskScreen()));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FeaturedKhutbahSection extends StatelessWidget {
  final KhutbahModel khutbah;

  const _FeaturedKhutbahSection({required this.khutbah});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Naskah Khutbah Pilihan',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => KhutbahDetailScreen(khutbah: khutbah),
                    ),
                  );
                },
                child: Text(
                  'Lihat Detail',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accentGold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        khutbah.category,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryContainer,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, size: 14, color: AppColors.textGrey),
                        const SizedBox(width: 4),
                        Text(
                          khutbah.duration,
                          style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  khutbah.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  khutbah.speaker,
                  style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    khutbah.arabicText,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.8,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuranProgressSection extends StatelessWidget {
  const _QuranProgressSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Target Tilawah Harian',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  'Al-Kahf • Ayat 25-50',
                  style: GoogleFonts.outfit(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: const LinearProgressIndicator(
                          value: 0.82,
                          backgroundColor: Color(0xFFF0F0F0),
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentGold),
                          minHeight: 7,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('82%', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          const Text('📖', style: TextStyle(fontSize: 36)),
        ],
      ),
    );
  }
}

class _DailyDawahSection extends StatelessWidget {
  const _DailyDawahSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kajian & Inspirasi Hari Ini',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          _DawahTile(
            time: '05:00 WIB',
            title: 'Kajian Shubuh: Adab & Akhlak Da\'i',
            subtitle: 'Ustadz Dr. H. Ahmad Wijaya, M.A. • Masjid Raya',
            color: Colors.brown[300]!,
          ),
          const SizedBox(height: 10),
          _DawahTile(
            time: '18:30 WIB',
            title: 'Tadabbur Al-Qur\'an: Makna Amanah',
            subtitle: 'KH. Muhammad Ridwan • Kajian Maghrib',
            color: Colors.teal[300]!,
          ),
        ],
      ),
    );
  }
}

class _DawahTile extends StatelessWidget {
  final String time;
  final String title;
  final String subtitle;
  final Color color;

  const _DawahTile({
    required this.time,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.play_circle_fill, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(time, style: GoogleFonts.outfit(color: AppColors.accentGold, fontSize: 11, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(subtitle, style: GoogleFonts.outfit(color: Colors.grey, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
