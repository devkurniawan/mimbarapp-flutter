import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../../core/theme/app_theme.dart';
import '../models/khutbah_model.dart';
import '../services/speech_text_matcher.dart';
import '../services/voice_teleprompter_controller.dart';
import 'practice_speech_screen.dart';

class TeleprompterScreen extends StatefulWidget {
  final KhutbahModel khutbah;

  const TeleprompterScreen({super.key, required this.khutbah});

  @override
  State<TeleprompterScreen> createState() => _TeleprompterScreenState();
}

class _TeleprompterScreenState extends State<TeleprompterScreen> {
  bool _isPlaying = true;
  bool _isDarkMode = true;
  bool _isWakelockEnabled = true;
  double _fontSize = 26.0;
  double _scrollSpeed = 2.0; // Kecepatan scroll (px/s)
  int _activeParagraphIndex = 0;
  Timer? _timer;
  int _elapsedSeconds = 0;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  // Voice-Activated Teleprompter & Real-Time Highlighter State
  final SpeechTextMatcher _textMatcher = SpeechTextMatcher();
  late final VoiceTeleprompterController _voiceController;
  bool _isVoiceSyncEnabled = false;
  bool _isVoiceListening = false;
  bool _isArabicCueActive = false;
  double _voiceAmplitude = 0.0;
  int _activeWordGlobalIndex = 0;
  String _lastHeardTranscript = '';
  final Map<int, GlobalKey> _sectionKeys = {};
  final GlobalKey _activeWordKey = GlobalKey();

  final List<Map<String, String>> _teleprompterSections = [
    {
      'type': 'muqaddimah',
      'label': 'MUQADDIMAH & SHALAWAT',
      'arabic': 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ، وَالصَّلاَةُ وَالسَّلاَمُ عَلَى أَشْرَفِ الأَنْبِيَاءِ وَالْمُرْسَلِينَ',
      'text': 'Segala puji bagi Allah SWT Tuhan semesta alam. Shalawat serta salam semoga senantiasa tercurahkan kepada junjungan kita Nabi Agung Muhammad SAW, keluarga, dan para sahabatnya.',
    },
    {
      'type': 'ayat',
      'label': 'AYAT UTAMA KHUTBAH',
      'arabic': 'يَا أَيُّهَا الَّذِينَ آمَنُوا لا تَخُونُوا اللَّهَ وَالرَّسُولَ وَتَخُونُوا أَمَانَاتِكُمْ وَأَنْتُمْ تَعْلَمُونَ',
      'text': 'Wahai orang-orang yang beriman! Janganlah kamu mengkhianati Allah dan Rasul dan juga janganlah kamu mengkhianati amanat yang dipercayakan kepadamu, sedang kamu mengetahui. (QS. Al-Anfal: 27)',
    },
    {
      'type': 'isi_1',
      'label': 'KHUTBAH PERTAMA - BAB AMANAH',
      'arabic': 'كُلُّكُمْ رَاعٍ وَكُلُّكُمْ مَسْئُولٌ عَنْ رَعِيَّتِهِ',
      'text': 'Jamaah Shalat Jumat yang dirahmati Allah SWT,\n\nAmanah adalah pondasi tertinggi dalam karakter seorang muslim. Setiap posisi, tugas, dan tanggung jawab yang diembankan di pundak kita merupakan ujian kesetiaan imaniah di hadapan Allah SWT.',
    },
    {
      'type': 'isi_2',
      'label': 'KHUTBAH PERTAMA - PENJELASAN DALIL',
      'arabic': 'إِنَّ اللَّهَ يَأْمُرُكُمْ أَنْ تُؤَدُّوا الأَمَانَاتِ إِلَى أَهْلِهَا',
      'text': 'Sungguh Allah memerintahkan kamu menyerahkan amanat kepada yang berhak megerjakannya. Apabila menetapkan hukum di antara manusia, hendaklah kamu menetapkannya dengan adil.',
    },
    {
      'type': 'doa',
      'label': 'KHUTBAH KEDUA & DOA PENUTUP',
      'arabic': 'اللَّهُمَّ اغْفِرْ لِلْمُسْلِمِينَ وَالْمُسْلِمَاتِ وَالْمُؤْمِنِينَ وَالْمُؤْمِنَاتِ الأَحْيَاءِ مِنْهُمْ وَالأَمْوَاتِ',
      'text': 'Ya Allah ampunilah dosa seluruh kaum muslimin dan muslimat, mukminin dan mukminat, yang masih hidup maupun yang telah wafat. Kabulkanlah doa dan hajat kami. Aamiin ya Rabbal Alamin.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _textMatcher.buildFromSections(_teleprompterSections);
    for (int i = 0; i < _teleprompterSections.length; i++) {
      _sectionKeys[i] = GlobalKey();
    }

    _voiceController = VoiceTeleprompterController(
      onTranscript: _handleVoiceTranscript,
      onSoundLevel: (level) {
        if (mounted && _isVoiceSyncEnabled) {
          setState(() => _voiceAmplitude = level);
        }
      },
      onListeningStateChanged: (listening) {
        if (mounted) {
          setState(() => _isVoiceListening = listening);
        }
      },
      onStatusMessage: (msg) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );

    _enableWakelock();
    _startTimer();
    _scrollController.addListener(_onScrollUpdateActiveSection);
  }

  void _handleVoiceTranscript(String transcript, bool isFinal, double confidence) {
    if (!mounted || !_isVoiceSyncEnabled) return;

    final currentSectionType = _teleprompterSections[_activeParagraphIndex]['type'];
    final match = _textMatcher.matchTranscript(
      spokenTranscript: transcript,
      currentGlobalIndex: _activeWordGlobalIndex,
      currentSectionType: currentSectionType,
    );

    setState(() {
      _lastHeardTranscript = transcript;
      if (match != null) {
        _isArabicCueActive = match.isArabicCueTriggered;
        if (match.matchedGlobalIndex != _activeWordGlobalIndex) {
          _activeWordGlobalIndex = match.matchedGlobalIndex;
          _activeParagraphIndex = match.matchedSectionIndex;
        }
      }
    });

    if (match != null && !match.isArabicCueTriggered) {
      _scrollToActiveWordIfNeeded();
    }
  }

  void _scrollToActiveWordIfNeeded() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final wordContext = _activeWordKey.currentContext;
      if (wordContext != null) {
        Scrollable.ensureVisible(
          wordContext,
          alignment: 0.38, // Eye-level zone (38% dari atas layar sesuai PRD FR-03)
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  Future<void> _toggleVoiceSync() async {
    if (_isVoiceSyncEnabled) {
      await _voiceController.stopVoiceSync();
      if (!mounted) return;
      setState(() {
        _isVoiceSyncEnabled = false;
        _isVoiceListening = false;
        _isArabicCueActive = false;
        _voiceAmplitude = 0.0;
      });
    } else {
      final started = await _voiceController.startVoiceSync();
      if (!mounted) return;
      if (started) {
        setState(() {
          _isVoiceSyncEnabled = true;
          _isPlaying = true; // Aktifkan timer durasi khutbah
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎙️ Voice Sync Aktif: Teks mengikuti suara khutbah Anda'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _onTapWord(ScriptWordToken token) {
    setState(() {
      _activeWordGlobalIndex = token.globalIndex;
      _activeParagraphIndex = token.sectionIndex;
      _isArabicCueActive = false;
    });
    _scrollToActiveWordIfNeeded();
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

  void _onScrollUpdateActiveSection() {
    if (!_scrollController.hasClients) return;
    final offset = _scrollController.offset;
    final itemEstimatedHeight = 280.0;
    final newIndex = (offset / itemEstimatedHeight).floor().clamp(0, _teleprompterSections.length - 1);
    if (newIndex != _activeParagraphIndex) {
      setState(() {
        _activeParagraphIndex = newIndex;
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_isPlaying) {
        setState(() {
          _elapsedSeconds += 1;
        });
        // Jika Voice Sync aktif, scroll dikendalikan oleh suara khatib (bukan timer statis)
        if (!_isVoiceSyncEnabled && _scrollController.hasClients) {
          final maxExtent = _scrollController.position.maxScrollExtent;
          final currentExtent = _scrollController.offset;
          if (currentExtent < maxExtent) {
            _scrollController.jumpTo(currentExtent + (_scrollSpeed * 0.1));
          }
        }
      }
    });
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      final key = event.logicalKey;
      if (key == LogicalKeyboardKey.space ||
          key == LogicalKeyboardKey.enter ||
          key == LogicalKeyboardKey.mediaPlayPause) {
        setState(() {
          _isPlaying = !_isPlaying;
        });
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.arrowDown ||
          key == LogicalKeyboardKey.pageDown ||
          key == LogicalKeyboardKey.audioVolumeDown) {
        // Scroll forward or increase speed
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            (_scrollController.offset + 120.0).clamp(0.0, _scrollController.position.maxScrollExtent),
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
        return KeyEventResult.handled;
      } else if (key == LogicalKeyboardKey.arrowUp ||
          key == LogicalKeyboardKey.pageUp ||
          key == LogicalKeyboardKey.audioVolumeUp) {
        // Scroll backward
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            (_scrollController.offset - 120.0).clamp(0.0, _scrollController.position.maxScrollExtent),
            duration: const Duration(milliseconds: 200),
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
      backgroundColor: _isDarkMode ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final textPrimary = _isDarkMode ? Colors.white : const Color(0xFF0F172A);
        final textSecondary = _isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
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
                      child: Icon(Icons.bluetooth_connected_rounded, color: AppTheme.primaryContainer),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kontrol Remote & Tombol Fisik Mimbar',
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
                _buildRemoteRow(Icons.play_circle_outline_rounded, 'Spasi / Enter / Play-Pause', 'Jeda / Lanjutkan Scroll Otomatis', textPrimary, textSecondary),
                const SizedBox(height: 12),
                _buildRemoteRow(Icons.arrow_downward_rounded, 'Panah Bawah / Page Down / Vol (-)', 'Scroll Cepat ke Bagian Bawah', textPrimary, textSecondary),
                const SizedBox(height: 12),
                _buildRemoteRow(Icons.arrow_upward_rounded, 'Panah Atas / Page Up / Vol (+)', 'Scroll Balik ke Bagian Atas', textPrimary, textSecondary),
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
    _timer?.cancel();
    _voiceController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  String _formatTimerDisplay(int hundredths) {
    final totalSec = hundredths ~/ 10;
    final m = totalSec ~/ 60;
    final s = totalSec % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _jumpToSection(int index) {
    setState(() {
      _activeParagraphIndex = index;
    });
    final targetOffset = index * 260.0;
    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Smart Dynamic Colors according to Light/Dark Mode
    final bgColor = _isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final primaryText = _isDarkMode ? Colors.white : const Color(0xFF0F172A);
    final secondaryText = _isDarkMode ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final arabicText = _isDarkMode ? const Color(0xFF86EFAC) : const Color(0xFF047857);
    final cardBgActive = _isDarkMode ? const Color(0xFF1E293B) : Colors.white;
    final cardBorderActive = _isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final accentEmerald = AppTheme.primaryContainer;

    final currentSectionInfo = _teleprompterSections[_activeParagraphIndex];

    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKeyEvent,
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  // Clean Top Header Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                    color: cardBgActive,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.close_rounded, color: secondaryText),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.khutbah.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: primaryText,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'BAB ${_activeParagraphIndex + 1}/${_teleprompterSections.length} • ${currentSectionInfo['label']}',
                                style: TextStyle(
                                  color: accentEmerald,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Remote Clicker Guide Button
                        IconButton(
                          icon: const Icon(Icons.bluetooth_searching_rounded, size: 20),
                          color: accentEmerald,
                          tooltip: 'Panduan Remote / Clicker',
                          onPressed: _showRemoteGuide,
                        ),
                        // Wakelock Lock Screen Toggle Button
                        IconButton(
                          icon: Icon(
                            _isWakelockEnabled ? Icons.screen_lock_portrait_rounded : Icons.screen_rotation_rounded,
                            size: 20,
                          ),
                          color: _isWakelockEnabled ? const Color(0xFF10B981) : secondaryText,
                          tooltip: _isWakelockEnabled ? 'Layar Nyala (Wakelock Aktif)' : 'Layar Normal',
                          onPressed: _toggleWakelock,
                        ),
                        // AI Voice Practice Coach Button
                        IconButton(
                          icon: const Icon(Icons.mic_rounded, color: Color(0xFF10B981), size: 20),
                          tooltip: 'Latihan Suara & AI Coach',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PracticeSpeechScreen(khutbah: widget.khutbah),
                              ),
                            );
                          },
                        ),
                        // Dark / Light Theme Switcher
                        IconButton(
                          icon: Icon(
                            _isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
                            size: 20,
                            color: _isDarkMode ? const Color(0xFFFDE047) : AppTheme.primaryContainer,
                          ),
                          tooltip: _isDarkMode ? 'Mode Terang' : 'Mode Gelap',
                          onPressed: () {
                            setState(() {
                              _isDarkMode = !_isDarkMode;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                // Top Smart Section Cue Progress Indicator Tabs
                Container(
                  height: 38,
                  color: cardBgActive,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _teleprompterSections.length,
                    itemBuilder: (context, index) {
                      final isActive = index == _activeParagraphIndex;
                      return GestureDetector(
                        onTap: () => _jumpToSection(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: isActive ? accentEmerald : (_isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Bab ${index + 1}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                              color: isActive ? Colors.white : secondaryText,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Reading Area: Clean Speech Cue Cards
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 90.0),
                    itemCount: _teleprompterSections.length,
                    itemBuilder: (context, index) {
                      final section = _teleprompterSections[index];
                      final isCurrentCue = index == _activeParagraphIndex;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(bottom: 24.0),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: isCurrentCue ? cardBgActive : cardBgActive.withAlpha(120),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isCurrentCue ? accentEmerald : cardBorderActive.withAlpha(80),
                            width: isCurrentCue ? 2.0 : 1.0,
                          ),
                          boxShadow: isCurrentCue
                              ? [
                                  BoxShadow(
                                    color: accentEmerald.withAlpha(40),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  )
                                ]
                              : [],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Cue Badge Tag
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isCurrentCue ? accentEmerald : cardBorderActive,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    section['label']!,
                                    style: TextStyle(
                                      color: isCurrentCue ? Colors.white : secondaryText,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ),
                                if (isCurrentCue)
                                  Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF22C55E),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'AKTIF',
                                        style: TextStyle(
                                          color: accentEmerald,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Arabic Tasykil Text
                            if (section['arabic']!.isNotEmpty) ...[
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                padding: _isVoiceSyncEnabled && isCurrentCue && _isArabicCueActive
                                    ? const EdgeInsets.symmetric(horizontal: 10, vertical: 6)
                                    : EdgeInsets.zero,
                                decoration: BoxDecoration(
                                  color: _isVoiceSyncEnabled && isCurrentCue && _isArabicCueActive
                                      ? accentEmerald.withAlpha(45)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  section['arabic']!,
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    color: arabicText,
                                    fontSize: _fontSize + 8,
                                    height: 2.1,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Indonesian Speech Content Text (Interactive Word-by-Word Highlighter)
                            _buildHighlightedSpeechText(
                              sectionIndex: index,
                              fallbackText: section['text']!,
                              isCurrentCue: isCurrentCue,
                              primaryText: primaryText,
                              secondaryText: secondaryText,
                              accentEmerald: accentEmerald,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            // Ultra-Compact Minimalist Floating Bottom Toolbar
            Positioned(
              left: 20,
              right: 20,
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: cardBgActive,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: cardBorderActive, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(25),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Font Size Adjuster Group (Kiri)
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_rounded, size: 16),
                          color: primaryText,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          tooltip: 'Perkecil Font',
                          onPressed: () {
                            setState(() {
                              if (_fontSize > 18.0) _fontSize -= 2.0;
                            });
                          },
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${_fontSize.toInt()}pt',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: secondaryText,
                          ),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(Icons.add_rounded, size: 16),
                          color: primaryText,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          tooltip: 'Perbesar Font',
                          onPressed: () {
                            setState(() {
                              if (_fontSize < 36.0) _fontSize += 2.0;
                            });
                          },
                        ),
                      ],
                    ),

                    // Centered Voice Sync + Play Button & Micro Duration
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Voice Sync Toggle Button (PRD 6.1)
                        GestureDetector(
                          onTap: _toggleVoiceSync,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: _isVoiceSyncEnabled
                                  ? const Color(0xFF10B981).withAlpha(35)
                                  : (_isDarkMode ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: _isVoiceSyncEnabled
                                    ? const Color(0xFF10B981)
                                    : cardBorderActive,
                                width: 1.2,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _isVoiceSyncEnabled ? Icons.mic_rounded : Icons.mic_none_rounded,
                                  size: 15,
                                  color: _isVoiceSyncEnabled
                                      ? const Color(0xFF10B981)
                                      : secondaryText,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _isVoiceSyncEnabled ? 'SYNC' : 'SUARA',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: _isVoiceSyncEnabled
                                        ? const Color(0xFF10B981)
                                        : secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),

                        // Play / Pause + Timer Column
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isPlaying = !_isPlaying;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: accentEmerald,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: accentEmerald.withAlpha(80),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.timer_outlined, size: 9, color: secondaryText),
                                const SizedBox(width: 2),
                                Text(
                                  _formatTimerDisplay(_elapsedSeconds),
                                  style: TextStyle(
                                    color: secondaryText,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    fontFeatures: const [FontFeature.tabularFigures()],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Speed Adjuster Group (Kanan)
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_rounded, size: 16),
                          color: primaryText,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          tooltip: 'Perlambat Scroll',
                          onPressed: () {
                            setState(() {
                              if (_scrollSpeed > 0.5) _scrollSpeed -= 0.5;
                            });
                          },
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${_scrollSpeed.toStringAsFixed(1)}x',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: accentEmerald,
                          ),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(Icons.add_rounded, size: 16),
                          color: primaryText,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          tooltip: 'Percepat Scroll',
                          onPressed: () {
                            setState(() {
                              if (_scrollSpeed < 6.0) _scrollSpeed += 0.5;
                            });
                          },
                        ),
                      ],
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
  }

  /// Membangun tampilan teks kata-demi-kata dengan 3 status visual (FR-01):
  /// 1. Spoken (redup), 2. Active Word (sorotan pill Emerald), 3. Upcoming (kontras penuh).
  /// Mendukung Tap-to-Jump pada kata mana saja.
  Widget _buildHighlightedSpeechText({
    required int sectionIndex,
    required String fallbackText,
    required bool isCurrentCue,
    required Color primaryText,
    required Color secondaryText,
    required Color accentEmerald,
  }) {
    final tokens = _textMatcher.getTokensForSection(sectionIndex);
    if (tokens.isEmpty) {
      return Text(
        fallbackText,
        style: TextStyle(
          color: isCurrentCue ? primaryText : secondaryText,
          fontSize: _fontSize,
          height: 1.7,
          fontWeight: isCurrentCue ? FontWeight.w600 : FontWeight.w400,
        ),
      );
    }

    final List<InlineSpan> spans = [];
    for (int i = 0; i < tokens.length; i++) {
      final token = tokens[i];
      final isSpoken = _isVoiceSyncEnabled && token.globalIndex < _activeWordGlobalIndex;
      final isCurrentWord = _isVoiceSyncEnabled && token.globalIndex == _activeWordGlobalIndex;

      if (isCurrentWord) {
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              key: _activeWordKey,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                color: accentEmerald.withAlpha(65),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: accentEmerald, width: 1.2),
              ),
              child: Text(
                token.originalText,
                style: TextStyle(
                  color: _isDarkMode ? Colors.white : const Color(0xFF064E3B),
                  fontSize: _fontSize,
                  height: 1.4,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: token.originalText,
            recognizer: TapGestureRecognizer()..onTap = () => _onTapWord(token),
            style: TextStyle(
              color: isSpoken
                  ? secondaryText.withAlpha(140)
                  : (isCurrentCue ? primaryText : secondaryText),
              fontSize: _fontSize,
              height: 1.7,
              fontWeight: isCurrentCue ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        );
      }

      if (token.isLineBreakAfter) {
        spans.add(const TextSpan(text: '\n\n'));
      } else if (i < tokens.length - 1) {
        spans.add(const TextSpan(text: ' '));
      }
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}
