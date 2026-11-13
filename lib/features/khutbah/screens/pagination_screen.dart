import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../../core/theme/app_theme.dart';
import '../models/khutbah_model.dart';

class PaginationScreen extends StatefulWidget {
  final KhutbahModel khutbah;

  const PaginationScreen({super.key, required this.khutbah});

  @override
  State<PaginationScreen> createState() => _PaginationScreenState();
}

class _PaginationScreenState extends State<PaginationScreen> {
  final PageController _pageController = PageController();
  final FocusNode _focusNode = FocusNode();
  int _currentPage = 0;
  double _fontSize = 17.0;
  bool _isWakelockEnabled = true;

  List<Map<String, String>> _pagesData = [];

  @override
  void initState() {
    super.initState();
    _enableWakelock();
    _preparePages();
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
      if (key == LogicalKeyboardKey.arrowRight ||
          key == LogicalKeyboardKey.pageDown ||
          key == LogicalKeyboardKey.space ||
          key == LogicalKeyboardKey.audioVolumeDown) {
        if (_currentPage < _pagesData.length - 1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.arrowLeft ||
          key == LogicalKeyboardKey.pageUp ||
          key == LogicalKeyboardKey.audioVolumeUp) {
        if (_currentPage > 0) {
          _pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
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
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
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
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kontrol Remote Paginasi Mimbar',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.onSurface),
                          ),
                          Text(
                            'Gunakan tombol Bluetooth Clicker / Volume',
                            style: TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildRemoteRow(Icons.arrow_forward_rounded, 'Panah Kanan / Page Down / Spasi / Vol (-)', 'Pindah ke Halaman Berikutnya'),
                const SizedBox(height: 12),
                _buildRemoteRow(Icons.arrow_back_rounded, 'Panah Kiri / Page Up / Vol (+)', 'Kembali ke Halaman Sebelumnya'),
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
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.onSurface),
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

  Widget _buildRemoteRow(IconData icon, String keys, String desc) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.primaryContainer),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(keys, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.onSurface)),
              Text(desc, style: const TextStyle(fontSize: 11, color: AppTheme.onSurfaceVariant)),
            ],
          ),
        ),
      ],
    );
  }

  void _preparePages() {
    _pagesData = [
      {
        'title': 'Muqaddimah & Ayat Utama',
        'arabic': widget.khutbah.arabicText,
        'content': widget.khutbah.translation,
      },
      {
        'title': 'Khutbah Pertama - Poin 1 & 2',
        'arabic': '',
        'content':
            'Sidang Jumat yang dirahmati Allah SWT,\n\nAmanah adalah salah satu pilar utama dalam ajaran Islam. Setiap diri kita adalah pemimpin, dan setiap pemimpin akan dimintai pertanggungjawaban atas apa yang dipimpinnya.\n\nKepemimpinan bukan sekadar jabatan atau kehormatan, melainkan beban berat yang harus ditunaikan dengan penuh keadilan dan kejujuran.',
      },
      {
        'title': 'Khutbah Pertama - Poin 3',
        'arabic': 'كُلُّكُمْ رَاعٍ وَكُلُّكُمْ مَسْئُولٌ عَنْ رَعِيَّتِهِ',
        'content':
            'Nabi SAW bersabda: "Setiap kalian adalah pemimpin dan setiap kalian akan dimintai pertanggungjawaban atas yang dipimpinnya."\n\nOleh karena itu, marilah kita senantiasa memegang teguh amanah dalam keluarga, masyarakat, dan pekerjaan kita sehari-hari.',
      },
      {
        'title': 'Khutbah Kedua & Penutup',
        'arabic': 'بَارَكَ اللهُ لِي وَلَكُمْ فِي الْقُرْآنِ الْعَظِيمِ',
        'content':
            'Barakallahu li wa lakum fil quranil adzim. Semoga Allah memberkahi kita semua dan menjadikan kita hamba-hamba-Nya yang selalu menjaga amanah.\n\nAllahumma sholli ala Muhammad wa ala ali Muhammad.',
      },
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    _focusNode.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  void _showPageSelectorGrid(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusXl)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Lompat ke Halaman',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: AppTheme.onSurfaceVariant),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.5,
                ),
                itemCount: _pagesData.length,
                itemBuilder: (context, index) {
                  final isSelected = _currentPage == index;
                  final page = _pagesData[index];
                  return InkWell(
                    onTap: () {
                      Navigator.pop(ctx);
                      _pageController.animateToPage(
                        index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryContainer : AppTheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                        border: Border.all(
                          color: isSelected ? AppTheme.primaryContainer : AppTheme.outlineVariant.withAlpha(60),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Halaman ${index + 1}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white : AppTheme.primaryContainer,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            page['title']!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              color: isSelected ? Colors.white.withAlpha(200) : AppTheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = _pagesData.length;

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          title: Text('Mode Paginasi (${_currentPage + 1}/$totalPages)'),
          backgroundColor: Colors.white,
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
              color: _isWakelockEnabled ? const Color(0xFF10B981) : AppTheme.onSurfaceVariant,
              tooltip: _isWakelockEnabled ? 'Layar Nyala (Wakelock Aktif)' : 'Layar Normal',
              onPressed: _toggleWakelock,
            ),
            PopupMenuButton<double>(
              icon: const Icon(Icons.format_size_rounded),
              tooltip: 'Ukuran Teks',
              onSelected: (size) {
                setState(() {
                  _fontSize = size;
                });
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 15.0, child: Text('Kecil (15pt)')),
                const PopupMenuItem(value: 17.0, child: Text('Sedang (17pt)')),
                const PopupMenuItem(value: 20.0, child: Text('Besar (20pt)')),
                const PopupMenuItem(value: 24.0, child: Text('Sangat Besar (24pt)')),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.grid_view_rounded),
              tooltip: 'Daftar Halaman',
              onPressed: () => _showPageSelectorGrid(context),
            ),
          ],
        ),
        body: Column(
        children: [
          // Top Progress Bar
          LinearProgressIndicator(
            value: (_currentPage + 1) / totalPages,
            backgroundColor: AppTheme.surfaceContainerLow,
            color: AppTheme.primaryContainer,
            minHeight: 4,
          ),

          // Main PageView Slide Cards
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: totalPages,
              itemBuilder: (context, index) {
                final page = _pagesData[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppTheme.radiusXl),
                      border: Border.all(color: AppTheme.outlineVariant.withAlpha(60)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(10),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Slide Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'HALAMAN ${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                              ),
                              Text(
                                '${index + 1} dari $totalPages',
                                style: const TextStyle(
                                  color: AppTheme.onSurfaceVariant,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            page['title']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primaryContainer,
                            ),
                          ),
                          const Divider(height: 20, thickness: 1),

                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (page['arabic']!.isNotEmpty) ...[
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryContainer.withAlpha(15),
                                        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                                        border: Border.all(
                                          color: AppTheme.primaryContainer.withAlpha(40),
                                        ),
                                      ),
                                      child: Text(
                                        page['arabic']!,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontSize: _fontSize + 6,
                                          height: 2.0,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.primary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                  ],
                                  Text(
                                    page['content']!,
                                    style: TextStyle(
                                      fontSize: _fontSize,
                                      height: 1.7,
                                      color: AppTheme.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Fixed Compact Navigation Controller Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(12),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  // Previous Button
                  Expanded(
                    flex: 4,
                    child: OutlinedButton(
                      onPressed: _currentPage > 0
                          ? () {
                              _pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          : null,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryContainer,
                        side: BorderSide(
                          color: _currentPage > 0
                              ? AppTheme.primaryContainer.withAlpha(80)
                              : AppTheme.outlineVariant.withAlpha(40),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_back_rounded, size: 14),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'Sebelumnya',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Center Dots Indicator
                  Expanded(
                    flex: 3,
                    child: Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            totalPages,
                            (dotIndex) => AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.symmetric(horizontal: 2.5),
                              width: _currentPage == dotIndex ? 16 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: _currentPage == dotIndex
                                    ? AppTheme.primaryContainer
                                    : AppTheme.outlineVariant,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Next Button
                  Expanded(
                    flex: 4,
                    child: ElevatedButton(
                      onPressed: _currentPage < totalPages - 1
                          ? () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryContainer,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              'Selanjutnya',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_rounded, size: 14),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }
}
