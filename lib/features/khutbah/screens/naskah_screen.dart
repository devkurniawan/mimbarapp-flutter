import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../../core/theme/app_theme.dart';
import '../models/khutbah_model.dart';

class NaskahScreen extends StatefulWidget {
  final KhutbahModel khutbah;

  const NaskahScreen({super.key, required this.khutbah});

  @override
  State<NaskahScreen> createState() => _NaskahScreenState();
}

class _NaskahScreenState extends State<NaskahScreen> {
  double _fontSize = 18.0;
  bool _isNightMode = false;
  bool _isWakelockEnabled = true;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  List<Map<String, dynamic>> _sections = [];

  @override
  void initState() {
    super.initState();
    _enableWakelock();
    _parseContentToSections();
  }

  void _enableWakelock() async {
    try {
      await WakelockPlus.enable();
      setState(() {
        _isWakelockEnabled = true;
      });
    } catch (_) {}
  }

  void _toggleWakelock() async {
    try {
      if (_isWakelockEnabled) {
        await WakelockPlus.disable();
      } else {
        await WakelockPlus.enable();
      }
      if (!mounted) return;
      setState(() {
        _isWakelockEnabled = !_isWakelockEnabled;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isWakelockEnabled
                ? '🛡️ Layar Terkunci Nyala (Wakelock Aktif)'
                : 'Layar Mengikuti Waktu Standby HP',
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (_) {}
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey;
      if (key == LogicalKeyboardKey.arrowDown ||
          key == LogicalKeyboardKey.pageDown ||
          key == LogicalKeyboardKey.space ||
          key == LogicalKeyboardKey.audioVolumeDown) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            (_scrollController.offset + 220.0).clamp(0.0, _scrollController.position.maxScrollExtent),
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.arrowUp ||
          key == LogicalKeyboardKey.pageUp ||
          key == LogicalKeyboardKey.audioVolumeUp) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            (_scrollController.offset - 220.0).clamp(0.0, _scrollController.position.maxScrollExtent),
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
          );
        }
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  void _showRemoteGuide() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _isNightMode ? const Color(0xFF1E2738) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final textPrimary = _isNightMode ? Colors.white : AppTheme.onSurface;
        final textSecondary = _isNightMode ? const Color(0xFF94A3B8) : AppTheme.onSurfaceVariant;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryContainer.withAlpha(30),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.bluetooth_connected_rounded, color: AppTheme.primaryContainer),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kontrol Remote Naskah Mimbar',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary),
                          ),
                          Text(
                            'Gunakan tombol Bluetooth Clicker / Volume',
                            style: TextStyle(fontSize: 12, color: textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildRemoteRow(Icons.arrow_downward_rounded, 'Panah Bawah / Page Down / Spasi / Vol (-)', 'Scroll Naskah ke Bagian Selanjutnya', textPrimary, textSecondary),
                const SizedBox(height: 12),
                _buildRemoteRow(Icons.arrow_upward_rounded, 'Panah Atas / Page Up / Vol (+)', 'Scroll Naskah ke Bagian Sebelumnya', textPrimary, textSecondary),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _isWakelockEnabled ? const Color(0xFF10B981).withAlpha(20) : const Color(0xFFF59E0B).withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isWakelockEnabled ? Icons.screen_lock_portrait_rounded : Icons.screen_rotation_rounded,
                        color: _isWakelockEnabled ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _isWakelockEnabled ? 'Layar Mimbar Terkunci Tetap Menyala (Wakelock Aktif)' : 'Layar dapat mati otomatis saat tidak disentuh',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRemoteRow(IconData icon, String keys, String desc, Color primary, Color secondary) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.primaryContainer),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(keys, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: primary)),
              Text(desc, style: TextStyle(fontSize: 11, color: secondary)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  void _parseContentToSections() {
    _sections = [
      {
        'number': 1,
        'title': 'Pembukaan (Muqaddimah)',
        'duration': '3 min',
        'content':
            'Alhamdulillah, segala puji bagi Allah SWT yang telah memberikan kita nikmat iman, islam, dan kesehatan sehingga kita dapat berkumpul di tempat yang mulia ini. Shalawat dan salam semoga senantiasa tercurah kepada junjungan kita Nabi Muhammad SAW.',
        'arabic': '',
        'translation': '',
        'tags': [],
        'isExpanded': true,
      },
      {
        'number': 2,
        'title': 'Dalil Utama',
        'duration': '5 min',
        'content':
            '"Padahal mereka tidak disuruh kecuali supaya menyembah Allah dengan memurnikan ketaatan kepada-Nya dalam (menjalankan) agama yang lurus, dan supaya mereka mendirikan shalat dan menunaikan zakat; dan yang demikian itulah agama yang lurus." (QS. Al-Bayyinah: 5)',
        'arabic': widget.khutbah.arabicText,
        'translation': widget.khutbah.translation,
        'tags': ['Poin Penting', 'Ikhlas', 'Ketaatan'],
        'isExpanded': true,
      },
      {
        'number': 3,
        'title': 'Penjelasan & Implementasi',
        'duration': '5 min',
        'content':
            'Sidang yang dirahmati Allah SWT,\n\nAmanah dan keikhlasan adalah pilar utama dalam setiap amalan. Setiap diri kita adalah pemimpin, dan setiap pemimpin akan dimintai pertanggungjawaban atas apa yang dipimpinnya.\n\nBagaimana menjaga niat di era modern dan ciri-ciri amal yang ikhlas, marilah kita senantiasa memegang teguh amanah dalam keluarga, masyarakat, dan pekerjaan kita sehari-hari.',
        'arabic': '',
        'translation': '',
        'tags': ['Implementasi', 'Amanah'],
        'isExpanded': true,
      },
      {
        'number': 4,
        'title': 'Penutup & Doa',
        'duration': '2 min',
        'content':
            'Kesimpulan singkat dan doa penutup.\n\nBarakallahu li wa lakum fil quranil adzim. Semoga Allah memberkahi kita semua dan menjadikan kita hamba-hamba-Nya yang selalu menjaga amanah.\n\nAllahumma sholli ala Muhammad wa ala ali Muhammad.',
        'arabic': 'بَارَكَ اللهُ لِي وَلَكُمْ فِي الْقُرْآنِ الْعَظِيمِ',
        'translation': 'Semoga Allah memberkahi aku dan kamu sekalian dalam Al-Qur\'an yang Agung.',
        'tags': ['Doa', 'Penutup'],
        'isExpanded': true,
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _isNightMode ? const Color(0xFF121824) : AppTheme.background;
    final cardColor = _isNightMode ? const Color(0xFF1E2738) : Colors.white;
    final textColor = _isNightMode ? const Color(0xFFE2E8F0) : AppTheme.onSurface;
    final textSubColor = _isNightMode ? const Color(0xFF94A3B8) : AppTheme.onSurfaceVariant;
    final arabicColor = _isNightMode ? const Color(0xFF6EE7B7) : AppTheme.primary;
    final borderColor = _isNightMode ? const Color(0xFF334155) : AppTheme.outlineVariant.withAlpha(60);

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: const Text('Mode Naskah'),
          backgroundColor: cardColor,
          foregroundColor: textColor,
          elevation: 1,
          actions: [
            IconButton(
              icon: const Icon(Icons.bluetooth_searching_rounded, size: 20),
              color: AppTheme.primaryContainer,
              tooltip: 'Panduan Remote / Clicker',
              onPressed: _showRemoteGuide,
            ),
            IconButton(
              icon: Icon(
                _isWakelockEnabled ? Icons.screen_lock_portrait_rounded : Icons.screen_rotation_rounded,
                size: 20,
              ),
              color: _isWakelockEnabled ? const Color(0xFF10B981) : textSubColor,
              tooltip: _isWakelockEnabled ? 'Layar Nyala (Wakelock Aktif)' : 'Layar Normal',
              onPressed: _toggleWakelock,
            ),
            IconButton(
              icon: Icon(_isNightMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
              onPressed: () {
                setState(() {
                  _isNightMode = !_isNightMode;
                });
              },
              tooltip: _isNightMode ? 'Beralih ke Mode Terang' : 'Beralih ke Mode Gelap',
            ),
            PopupMenuButton<double>(
              icon: const Icon(Icons.format_size_rounded),
              tooltip: 'Ukuran Font Teks Naskah',
              onSelected: (size) {
                setState(() {
                  _fontSize = size;
                });
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 14.0, child: Text('Kecil (14pt)')),
                const PopupMenuItem(value: 18.0, child: Text('Sedang (18pt)')),
                const PopupMenuItem(value: 22.0, child: Text('Besar (22pt)')),
                const PopupMenuItem(value: 26.0, child: Text('Sangat Besar (26pt)')),
              ],
            ),
          ],
        ),
      body: Column(
        children: [
          // Header Summary Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: cardColor,
              border: Border(bottom: BorderSide(color: borderColor)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.khutbah.title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.person_outline_rounded, size: 14, color: AppTheme.primaryContainer),
                    const SizedBox(width: 4),
                    Text(
                      widget.khutbah.speaker,
                      style: TextStyle(fontSize: 12, color: textSubColor, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.timer_outlined, size: 14, color: textSubColor),
                    const SizedBox(width: 4),
                    Text(
                      widget.khutbah.duration,
                      style: TextStyle(fontSize: 12, color: textSubColor),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Naskah Section Cards List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: _sections.length,
              itemBuilder: (context, index) {
                final section = _sections[index];
                final isExpanded = section['isExpanded'] as bool;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    border: Border.all(
                      color: isExpanded ? AppTheme.primaryContainer.withAlpha(120) : borderColor,
                      width: isExpanded ? 1.5 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(_isNightMode ? 30 : 8),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card Header Tile
                        Semantics(
                          button: true,
                          expanded: isExpanded,
                          label: 'Bagian ${section['number']}: ${section['title']}. Durasi ${section['duration']}',
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                section['isExpanded'] = !isExpanded;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  // Number Badge
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: isExpanded
                                          ? AppTheme.primaryContainer
                                          : (_isNightMode ? AppTheme.tagDarkBg : AppTheme.surfaceContainerLow),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${section['number']}',
                                        style: TextStyle(
                                          color: isExpanded
                                              ? Colors.white
                                              : (_isNightMode ? Colors.white70 : AppTheme.primaryContainer),
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Title & Duration
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          section['title'],
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: textColor,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          section['duration'],
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: textSubColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                                    color: textSubColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Expandable Content Area
                        if (isExpanded) ...[
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(height: 1, thickness: 1),
                                const SizedBox(height: 16),

                                // Arabic Box if exists
                                if ((section['arabic'] as String).isNotEmpty) ...[
                                  Semantics(
                                    label: 'Teks Kaligrafi Arab dan Terjemahan',
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryContainer.withAlpha(_isNightMode ? 35 : 15),
                                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                                        border: Border.all(
                                          color: AppTheme.primaryContainer.withAlpha(_isNightMode ? 60 : 30),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            section['arabic'],
                                            textAlign: TextAlign.right,
                                            style: TextStyle(
                                              fontSize: _fontSize + 6,
                                              height: 2.1,
                                              fontWeight: FontWeight.w600,
                                              color: arabicColor,
                                            ),
                                          ),
                                          if ((section['translation'] as String).isNotEmpty) ...[
                                            const SizedBox(height: 8),
                                            Text(
                                              section['translation'],
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: _fontSize - 3,
                                                fontStyle: FontStyle.italic,
                                                color: textSubColor,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                ],

                                // Text Content
                                Text(
                                  section['content'],
                                  style: TextStyle(
                                    fontSize: _fontSize,
                                    height: 1.7,
                                    color: textColor,
                                  ),
                                ),

                                // Tags list
                                if ((section['tags'] as List).isNotEmpty) ...[
                                  const SizedBox(height: 14),
                                  Wrap(
                                    spacing: 6,
                                    runSpacing: 6,
                                    children: (section['tags'] as List<String>).map((tag) {
                                      final isSpecial = tag == 'Poin Penting';
                                      return Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: isSpecial
                                              ? AppTheme.tagAmberBg
                                              : (_isNightMode ? AppTheme.tagDarkBg : AppTheme.tagInfoBg),
                                          borderRadius: BorderRadius.circular(12),
                                          border: isSpecial
                                              ? Border.all(color: AppTheme.tagAmberBorder.withAlpha(100))
                                              : null,
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (isSpecial) ...[
                                              const Icon(Icons.lightbulb_outline_rounded,
                                                  size: 12, color: AppTheme.tagAmberBorder),
                                              const SizedBox(width: 4),
                                            ],
                                            Text(
                                              tag,
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: isSpecial
                                                    ? AppTheme.tagAmberText
                                                    : (_isNightMode ? AppTheme.tagDarkText : AppTheme.tagInfoText),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
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
