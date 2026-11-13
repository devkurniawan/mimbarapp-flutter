import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../models/khutbah_model.dart';
import 'teleprompter_screen.dart';
import 'pagination_screen.dart';
import 'naskah_screen.dart';
import 'practice_speech_screen.dart';

class KhutbahDetailScreen extends StatefulWidget {
  final KhutbahModel khutbah;

  const KhutbahDetailScreen({super.key, required this.khutbah});

  @override
  State<KhutbahDetailScreen> createState() => _KhutbahDetailScreenState();
}

class _KhutbahDetailScreenState extends State<KhutbahDetailScreen> {
  void _showReadModeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusXl)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pilih Mode Baca & Latihan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: AppTheme.onSurfaceVariant),
                      tooltip: 'Tutup',
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _buildReadModeOption(
                  ctx,
                  title: 'Teleprompter',
                  subtitle: 'Teks berjalan otomatis dengan kecepatan yang dapat diatur.',
                  icon: Icons.slideshow_rounded,
                  modeValue: 'Teleprompter',
                ),
                const SizedBox(height: 12),
                _buildReadModeOption(
                  ctx,
                  title: 'Latihan Suara (AI Coach)',
                  subtitle: 'Simulasi rekam vokal, ukur WPM, & evaluasi intonasi khutbah.',
                  icon: Icons.mic_rounded,
                  modeValue: 'PracticeSpeech',
                ),
                const SizedBox(height: 12),
                _buildReadModeOption(
                  ctx,
                  title: 'Naskah',
                  subtitle: 'Menampilkan semua konten pidato secara naskah terstruktur.',
                  icon: Icons.article_outlined,
                  modeValue: 'Naskah',
                ),
                const SizedBox(height: 12),
                _buildReadModeOption(
                  ctx,
                  title: 'Paginasi',
                  subtitle: 'Teks dibagi per lembar halaman yang dapat di-swipe.',
                  icon: Icons.auto_stories_rounded,
                  modeValue: 'Paginasi',
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReadModeOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String modeValue,
  }) {
    return Semantics(
      button: true,
      label: '$title. $subtitle',
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          if (modeValue == 'Teleprompter') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TeleprompterScreen(khutbah: widget.khutbah),
              ),
            );
          } else if (modeValue == 'PracticeSpeech') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PracticeSpeechScreen(khutbah: widget.khutbah),
              ),
            );
          } else if (modeValue == 'Paginasi') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PaginationScreen(khutbah: widget.khutbah),
              ),
            );
          } else if (modeValue == 'Naskah') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NaskahScreen(khutbah: widget.khutbah),
              ),
            );
          }
        },
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            border: Border.all(
              color: AppTheme.outlineVariant.withAlpha(60),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.primaryContainer,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppTheme.onSurfaceVariant,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRelatedKhutbahItem(KhutbahModel item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: AppTheme.outlineVariant.withAlpha(60)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => KhutbahDetailScreen(khutbah: item),
            ),
          );
        },
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer.withAlpha(15),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: AppTheme.primaryContainer,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.speaker} • ${item.duration}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: AppTheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter related khutbahs excluding current item
    final relatedKhutbahs =
        SampleData.sampleKhutbahs.where((k) => k.id != widget.khutbah.id).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Khutbah'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border_rounded),
            tooltip: 'Simpan Bookmark',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Bagikan Khutbah',
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 100.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Minimalist Focus Header Banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    border: Border.all(color: AppTheme.outlineVariant.withAlpha(60)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(8),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              widget.khutbah.category,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.timer_outlined,
                                    size: 13, color: AppTheme.primaryContainer),
                                const SizedBox(width: 4),
                                Text(
                                  widget.khutbah.duration,
                                  style: const TextStyle(
                                    color: AppTheme.primaryContainer,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.khutbah.title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.onSurface,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 14,
                            backgroundColor: AppTheme.primaryContainer.withAlpha(20),
                            child: const Icon(Icons.person_rounded,
                                size: 16, color: AppTheme.primaryContainer),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.khutbah.speaker,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Arabic Quran Quote Box
                Semantics(
                  label: 'Ayat Al-Qur\'an dan terjemahan',
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryContainer.withAlpha(15),
                      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                      border: Border.all(color: AppTheme.primaryContainer.withAlpha(50)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.khutbah.arabicText,
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 24,
                            height: 2.0,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.khutbah.translation,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: AppTheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Key Points Card
                const Text(
                  'Poin Penting Khutbah',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    border: Border.all(color: AppTheme.outlineVariant.withAlpha(60)),
                  ),
                  child: Column(
                    children: widget.khutbah.keyPoints.map((point) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle_rounded,
                                size: 18, color: AppTheme.secondaryContainer),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                point,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),

                // Main Text Content Header & Body
                const Text(
                  'Naskah Lengkap',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    border: Border.all(color: AppTheme.outlineVariant.withAlpha(60)),
                  ),
                  child: Text(
                    widget.khutbah.content,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.7,
                      color: AppTheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Related Khutbah Recommendations Section
                if (relatedKhutbahs.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Khutbah Terkait',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${relatedKhutbahs.length} Naskah',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Column(
                    children: relatedKhutbahs.map((item) => _buildRelatedKhutbahItem(item)).toList(),
                  ),
                ],
              ],
            ),
          ),

          // Minimalist Clean White Floating Pill Button
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: AppTheme.outlineVariant.withAlpha(100),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(15),
                      blurRadius: 16,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _showReadModeBottomSheet(context),
                    borderRadius: BorderRadius.circular(30),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.chrome_reader_mode_rounded,
                            color: AppTheme.primaryContainer,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Mode Baca',
                            style: TextStyle(
                              color: AppTheme.onSurface,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              letterSpacing: 0.2,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            Icons.keyboard_arrow_up_rounded,
                            color: AppTheme.onSurfaceVariant,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
