import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../models/khutbah_model.dart';
import '../services/speech_text_matcher.dart';
import '../services/voice_teleprompter_controller.dart';

class PracticeSpeechScreen extends StatefulWidget {
  final KhutbahModel khutbah;

  const PracticeSpeechScreen({super.key, required this.khutbah});

  @override
  State<PracticeSpeechScreen> createState() => _PracticeSpeechScreenState();
}

class _PracticeSpeechScreenState extends State<PracticeSpeechScreen>
    with TickerProviderStateMixin {
  bool _isRecording = false;
  bool _isPaused = false;
  bool _hasRecorded = false;

  // Playback States
  bool _isPlayingMyAudio = false;
  bool _isPlayingRefAudio = false;
  int _playbackPositionMs = 0;
  int _recordedTotalDurationMs = 0;
  Timer? _playbackTimer;

  // Recording timer & metrics
  int _elapsedMilliseconds = 0;
  Timer? _recordTimer;
  int _activeSectionIndex = 0;
  double _currentWpm = 0.0;
  double _averageWpm = 0.0;
  final List<double> _wpmHistory = [];

  // Waveform animation
  late AnimationController _waveController;
  late AnimationController _pulseController;
  final Random _random = Random();
  List<double> _waveAmplitudes = List.generate(32, (index) => 0.2);

  // Real-Time Speech WPM & Alignment (PRD FR-05)
  final SpeechTextMatcher _speechMatcher = SpeechTextMatcher();
  late final VoiceTeleprompterController _voiceController;
  bool _isRealVoiceActive = false;
  int _activeWordGlobalIndex = 0;
  int _verifiedSpokenWords = 0;

  final List<Map<String, dynamic>> _sections = [
    {
      'type': 'muqaddimah',
      'label': 'MUQADDIMAH',
      'arabic':
          'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ، وَالصَّلاَةُ وَالسَّلاَمُ عَلَى أَشْرَفِ الأَنْبِيَاءِ وَالْمُرْسَلِينَ',
      'text':
          'Segala puji bagi Allah SWT Tuhan semesta alam. Shalawat serta salam semoga senantiasa tercurahkan kepada junjungan kita Nabi Agung Muhammad SAW, keluarga, dan para sahabatnya.',
      'wpmTargetMin': 100,
      'wpmTargetMax': 125,
      'refAudioDuration': '00:28',
      'refDurationMs': 28000,
      'score': null,
    },
    {
      'type': 'ayat',
      'label': 'AYAT UTAMA',
      'arabic':
          'يَا أَيُّهَا الَّذِينَ آمَنُوا لا تَخُونُوا اللَّهَ وَالرَّسُولَ وَتَخُونُوا أَمَانَاتِكُمْ وَأَنْتُمْ تَعْلَمُونَ',
      'text':
          'Wahai orang-orang yang beriman! Janganlah kamu mengkhianati Allah dan Rasul dan juga janganlah kamu mengkhianati amanat yang dipercayakan kepadamu, sedang kamu mengetahui.',
      'wpmTargetMin': 90,
      'wpmTargetMax': 115,
      'refAudioDuration': '00:32',
      'refDurationMs': 32000,
      'score': null,
    },
    {
      'type': 'isi_1',
      'label': 'KHUTBAH I - PEMBUKA',
      'arabic': 'كُلُّكُمْ رَاعٍ وَكُلُّكُمْ مَسْئُولٌ عَنْ رَعِيَّتِهِ',
      'text':
          'Jamaah Shalat Jumat yang dirahmati Allah SWT, Amanah adalah pondasi tertinggi dalam karakter seorang muslim. Setiap posisi, tugas, dan amanat yang diembankan di pundak kita merupakan ujian kesetiaan di hadapan Allah SWT.',
      'wpmTargetMin': 110,
      'wpmTargetMax': 135,
      'refAudioDuration': '00:45',
      'refDurationMs': 45000,
      'score': null,
    },
    {
      'type': 'isi_2',
      'label': 'KHUTBAH I - INTI',
      'arabic': 'إِنَّ اللَّهَ يَأْمُرُكُمْ أَنْ تُؤَدُّوا الأَمَانَاتِ إِلَى أَهْلِهَا',
      'text':
          'Sungguh Allah memerintahkan kamu menyerahkan amanat kepada yang berhak menerimanya. Dan apabila menetapkan hukum di antara manusia, hendaklah kamu menetapkannya dengan adil dan bijaksana.',
      'wpmTargetMin': 110,
      'wpmTargetMax': 135,
      'refAudioDuration': '00:40',
      'refDurationMs': 40000,
      'score': null,
    },
    {
      'type': 'doa',
      'label': 'KHUTBAH II & DOA',
      'arabic':
          'اللَّهُمَّ اغْفِرْ لِلْمُسْلِمِينَ وَالْمُسْلِمَاتِ وَالْمُؤْمِنِينَ وَالْمُؤْمِنَاتِ الأَحْيَاءِ مِنْهُمْ وَالأَمْوَاتِ',
      'text':
          'Ya Allah ampunilah dosa seluruh kaum muslimin dan muslimat, mukminin dan mukminat, yang masih hidup maupun yang telah wafat. Kabulkanlah doa, taubat, dan hajat kebaikan kami.',
      'wpmTargetMin': 95,
      'wpmTargetMax': 120,
      'refAudioDuration': '00:36',
      'refDurationMs': 36000,
      'score': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    _speechMatcher.buildFromSections(_sections);
    _voiceController = VoiceTeleprompterController(
      onTranscript: _handlePracticeTranscript,
      onSoundLevel: (level) {
        if (mounted && _isRecording && !_isPaused) {
          setState(() {
            _isRealVoiceActive = true;
            _waveAmplitudes = List.generate(32, (i) {
              final variation = _random.nextDouble() * 0.25;
              return (level * (0.6 + sin(i * 0.5).abs() * 0.4) + variation).clamp(0.08, 1.0);
            });
          });
        }
      },
    );

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  void _handlePracticeTranscript(String transcript, bool isFinal, double confidence) {
    if (!mounted || !_isRecording || _isPaused) return;
    final sectionType = _sections[_activeSectionIndex]['type'] as String?;
    final match = _speechMatcher.matchTranscript(
      spokenTranscript: transcript,
      currentGlobalIndex: _activeWordGlobalIndex,
      currentSectionType: sectionType,
    );

    if (match != null && match.matchedGlobalIndex >= _activeWordGlobalIndex) {
      setState(() {
        _isRealVoiceActive = true;
        _verifiedSpokenWords += match.wordsAdvanced;
        _activeWordGlobalIndex = match.matchedGlobalIndex;

        final minutes = _elapsedMilliseconds / 60000.0;
        if (minutes > 0.03 && _verifiedSpokenWords > 0) {
          _currentWpm = (_verifiedSpokenWords / minutes).clamp(40.0, 220.0);
          _wpmHistory.add(_currentWpm);
        }
      });
    }
  }

  @override
  void dispose() {
    _recordTimer?.cancel();
    _playbackTimer?.cancel();
    _voiceController.dispose();
    _waveController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  int _countWords(String text) {
    return text.trim().split(RegExp(r'\s+')).where((s) => s.isNotEmpty).length;
  }

  void _toggleRecording() {
    if (_isRecording) {
      // STOP RECORDING
      _recordTimer?.cancel();
      _voiceController.stopVoiceSync();
      _recordedTotalDurationMs = _elapsedMilliseconds;
      _hasRecorded = true;
      _isRecording = false;
      _isPaused = false;

      // Calculate final section average score
      if (_wpmHistory.isNotEmpty) {
        _averageWpm = _wpmHistory.reduce((a, b) => a + b) / _wpmHistory.length;
      } else {
        _averageWpm = _currentWpm;
      }

      final targetMin = _sections[_activeSectionIndex]['wpmTargetMin'] as int;
      final targetMax = _sections[_activeSectionIndex]['wpmTargetMax'] as int;
      int score = 85;
      if (_averageWpm >= targetMin && _averageWpm <= targetMax) {
        score = 96;
      } else if ((_averageWpm - targetMin).abs() < 15 || (_averageWpm - targetMax).abs() < 15) {
        score = 88;
      } else {
        score = 76;
      }
      _sections[_activeSectionIndex]['score'] = score;

      setState(() {});
    } else {
      // START RECORDING
      _stopAllPlaybacks();
      final sectionTokens = _speechMatcher.getTokensForSection(_activeSectionIndex);
      setState(() {
        _isRecording = true;
        _isPaused = false;
        _hasRecorded = false;
        _isRealVoiceActive = false;
        _elapsedMilliseconds = 0;
        _currentWpm = 0.0;
        _verifiedSpokenWords = 0;
        _activeWordGlobalIndex = sectionTokens.isNotEmpty ? sectionTokens.first.globalIndex : 0;
        _wpmHistory.clear();
      });
      _voiceController.startVoiceSync();

      final totalWords = _countWords(_sections[_activeSectionIndex]['text'] as String);

      _recordTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (!_isPaused) {
          setState(() {
            _elapsedMilliseconds += 100;
            final seconds = _elapsedMilliseconds / 1000.0;

            // Generate realistic dynamic audio wave amplitude
            _waveAmplitudes = List.generate(32, (i) {
              final noise = _random.nextDouble() * 0.4;
              final wave = sin(i * 0.4 + seconds * 5).abs() * 0.6;
              return (noise + wave).clamp(0.1, 1.0);
            });

            // Calculate live WPM (gunakan Real Voice WPM jika mikrofon aktif, fallback ke estimasi jika simulasi)
            if (!_isRealVoiceActive) {
              if (seconds > 2.0) {
                final minutes = seconds / 60.0;
                final targetDurationSec = (_sections[_activeSectionIndex]['refDurationMs'] as int) / 1000.0;
                final estimatedWordsRead = min(totalWords.toDouble(), (seconds / targetDurationSec) * totalWords);
                final rawWpm = estimatedWordsRead / minutes;
                _currentWpm = rawWpm.clamp(60.0, 180.0);
                _wpmHistory.add(_currentWpm);
              } else {
                _currentWpm = 112.0;
              }
            }
          });
        }
      });
    }
  }

  void _togglePauseRecording() {
    if (!_isRecording) return;
    setState(() {
      _isPaused = !_isPaused;
    });
  }

  void _stopAllPlaybacks() {
    _playbackTimer?.cancel();
    setState(() {
      _isPlayingMyAudio = false;
      _isPlayingRefAudio = false;
      _playbackPositionMs = 0;
    });
  }

  void _togglePlayMyAudio() {
    if (_isPlayingMyAudio) {
      _playbackTimer?.cancel();
      setState(() {
        _isPlayingMyAudio = false;
      });
    } else {
      _stopAllPlaybacks();
      setState(() {
        _isPlayingMyAudio = true;
      });

      _playbackTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        setState(() {
          if (_playbackPositionMs < _recordedTotalDurationMs) {
            _playbackPositionMs += 100;
          } else {
            _playbackTimer?.cancel();
            _isPlayingMyAudio = false;
            _playbackPositionMs = 0;
          }
        });
      });
    }
  }

  void _togglePlayRefAudio() {
    final refDuration = _sections[_activeSectionIndex]['refDurationMs'] as int;
    if (_isPlayingRefAudio) {
      _playbackTimer?.cancel();
      setState(() {
        _isPlayingRefAudio = false;
      });
    } else {
      _stopAllPlaybacks();
      setState(() {
        _isPlayingRefAudio = true;
      });

      _playbackTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        setState(() {
          if (_playbackPositionMs < refDuration) {
            _playbackPositionMs += 100;
          } else {
            _playbackTimer?.cancel();
            _isPlayingRefAudio = false;
            _playbackPositionMs = 0;
          }
        });
      });
    }
  }

  String _formatDuration(int ms) {
    final totalSeconds = ms ~/ 1000;
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    final tenths = (ms % 1000) ~/ 100;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}.$tenths';
  }

  Map<String, dynamic> _getWpmAnalysis(double wpm) {
    final targetMin = _sections[_activeSectionIndex]['wpmTargetMin'] as int;
    final targetMax = _sections[_activeSectionIndex]['wpmTargetMax'] as int;

    if (wpm == 0) {
      return {'label': 'Siap Merekam', 'color': AppTheme.onSurfaceVariant, 'icon': Icons.speed_rounded};
    } else if (wpm < targetMin) {
      return {'label': 'Tempo Lambat / Khusyuk', 'color': const Color(0xFF3B82F6), 'icon': Icons.hourglass_bottom_rounded};
    } else if (wpm <= targetMax) {
      return {'label': 'Tempo Ideal Mimbar', 'color': const Color(0xFF10B981), 'icon': Icons.check_circle_rounded};
    } else {
      return {'label': 'Terlalu Cepat', 'color': const Color(0xFFEF4444), 'icon': Icons.warning_amber_rounded};
    }
  }

  void _showRecapModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: ListView(
                controller: scrollController,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.outlineVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryContainer.withAlpha(20),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.workspace_premium_rounded, color: AppTheme.primaryContainer),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rekapitulasi Evaluasi Khutbah',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.onSurface),
                            ),
                            Text(
                              'Hasil analisis tempo, artikulasi & ritme',
                              style: TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Overall Score Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF064E3B), Color(0xFF047857)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF064E3B).withAlpha(60),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text('Skor Keseluruhan', style: TextStyle(color: Colors.white70, fontSize: 11)),
                            const SizedBox(height: 4),
                            Text(
                              '${_sections.where((s) => s['score'] != null).isEmpty ? 92 : (_sections.where((s) => s['score'] != null).map((s) => s['score'] as int).reduce((a, b) => a + b) ~/ _sections.where((s) => s['score'] != null).length)}%',
                              style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                        Container(width: 1, height: 40, color: Colors.white30),
                        Column(
                          children: [
                            const Text('Rata-rata WPM', style: TextStyle(color: Colors.white70, fontSize: 11)),
                            const SizedBox(height: 4),
                            Text(
                              '${_averageWpm > 0 ? _averageWpm.toInt() : 118} WPM',
                              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        Container(width: 1, height: 40, color: Colors.white30),
                        const Column(
                          children: [
                            Text('Kestabilan Nafas', style: TextStyle(color: Colors.white70, fontSize: 11)),
                            SizedBox(height: 4),
                            Text('Sangat Baik', style: TextStyle(color: Color(0xFF86EFAC), fontSize: 14, fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Performa Per Bagian Naskah:',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.onSurface),
                  ),
                  const SizedBox(height: 12),
                  ..._sections.map((section) {
                    final score = section['score'] ?? 88;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppTheme.outlineVariant.withAlpha(40)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              section['label'] as String,
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Target: ${section['wpmTargetMin']}-${section['wpmTargetMax']} WPM',
                              style: const TextStyle(fontSize: 11, color: AppTheme.onSurfaceVariant),
                            ),
                          ),
                          Text(
                            '$score%',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF047857)),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryContainer,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Tutup & Lanjutkan Latihan', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentSection = _sections[_activeSectionIndex];
    final wpmInfo = _getWpmAnalysis(_isRecording ? _currentWpm : _averageWpm);
    final targetMin = currentSection['wpmTargetMin'] as int;
    final targetMax = currentSection['wpmTargetMax'] as int;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppTheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Studio Latihan Suara & WPM',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.onSurface,
              ),
            ),
            Text(
              widget.khutbah.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined, color: AppTheme.primaryContainer),
            tooltip: 'Rekapitulasi Evaluasi',
            onPressed: _showRecapModal,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Section Horizontal Tab Navigation
            Container(
              height: 48,
              color: Colors.white,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                itemCount: _sections.length,
                itemBuilder: (context, index) {
                  final isActive = index == _activeSectionIndex;
                  final hasScore = _sections[index]['score'] != null;
                  return GestureDetector(
                    onTap: () {
                      if (_isRecording) _toggleRecording();
                      _stopAllPlaybacks();
                      setState(() {
                        _activeSectionIndex = index;
                        _elapsedMilliseconds = 0;
                        _currentWpm = 0;
                        _averageWpm = 0;
                        _hasRecorded = false;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: isActive ? AppTheme.primaryContainer : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isActive ? AppTheme.primaryContainer : Colors.transparent,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        children: [
                          Text(
                            _sections[index]['label'] as String,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                              color: isActive ? Colors.white : AppTheme.onSurfaceVariant,
                            ),
                          ),
                          if (hasScore) ...[
                            const SizedBox(width: 4),
                            const Icon(Icons.check_circle_rounded, size: 12, color: Color(0xFF86EFAC)),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Main Content Area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dynamic WPM Gauge & Cadence Indicator Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.outlineVariant.withAlpha(60)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(8),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(wpmInfo['icon'] as IconData, size: 18, color: wpmInfo['color'] as Color),
                                  const SizedBox(width: 8),
                                  Text(
                                    wpmInfo['label'] as String,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: wpmInfo['color'] as Color,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Target: $targetMin-$targetMax WPM',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Live WPM Speedometer Bar
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final currentVal = _isRecording ? _currentWpm : _averageWpm;
                              final normalized = (currentVal / 180.0).clamp(0.0, 1.0);
                              return Column(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        height: 10,
                                        width: constraints.maxWidth,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF1F5F9),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                      ),
                                      // Zone ideal indicator (100-135 WPM)
                                      Positioned(
                                        left: constraints.maxWidth * (targetMin / 180.0),
                                        width: constraints.maxWidth * ((targetMax - targetMin) / 180.0),
                                        child: Container(
                                          height: 10,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF10B981).withAlpha(60),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                      // Active bar pointer
                                      AnimatedContainer(
                                        duration: const Duration(milliseconds: 150),
                                        height: 10,
                                        width: constraints.maxWidth * normalized,
                                        decoration: BoxDecoration(
                                          color: wpmInfo['color'] as Color,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('60 (Lambat)', style: TextStyle(fontSize: 10, color: AppTheme.onSurfaceVariant)),
                                      Text('115 (Ideal Mimbar)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF047857))),
                                      Text('180 (Cepat)', style: TextStyle(fontSize: 10, color: AppTheme.onSurfaceVariant)),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Script Cue Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.outlineVariant.withAlpha(60)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(8),
                            blurRadius: 12,
                            offset: const Offset(0, 3),
                          ),
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
                                  color: AppTheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  currentSection['label'] as String,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.timer_outlined, size: 14, color: AppTheme.onSurfaceVariant),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Est: ${currentSection['refAudioDuration']}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Arabic Text
                          if ((currentSection['arabic'] as String).isNotEmpty) ...[
                            Text(
                              currentSection['arabic'] as String,
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(
                                fontSize: 24,
                                height: 2.1,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryContainer,
                              ),
                            ),
                            const SizedBox(height: 14),
                          ],

                          // Speech Text
                          Text(
                            currentSection['text'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.8,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Audio Studio Playback Card (Suara Saya & Audio Referensi)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.outlineVariant.withAlpha(60)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Pemutar Evaluasi Rekaman & Referensi',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.onSurface),
                          ),
                          const SizedBox(height: 12),

                          // Option 1: Play My Voice
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _hasRecorded ? const Color(0xFFF0FDF4) : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: _hasRecorded ? const Color(0xFF86EFAC) : AppTheme.outlineVariant.withAlpha(40),
                              ),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: _hasRecorded ? _togglePlayMyAudio : null,
                                  icon: Icon(
                                    _isPlayingMyAudio ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                                    size: 36,
                                    color: _hasRecorded ? const Color(0xFF047857) : AppTheme.outlineVariant,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Rekaman Suara Saya',
                                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.onSurface),
                                      ),
                                      Text(
                                        _hasRecorded
                                            ? '${_formatDuration(_isPlayingMyAudio ? _playbackPositionMs : _recordedTotalDurationMs)} • Rata-rata ${_averageWpm.toInt()} WPM'
                                            : 'Belum ada rekaman untuk bab ini',
                                        style: const TextStyle(fontSize: 11, color: AppTheme.onSurfaceVariant),
                                      ),
                                    ],
                                  ),
                                ),
                                if (_hasRecorded)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF10B981).withAlpha(20),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${currentSection['score'] ?? 90}% Skor',
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF047857)),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Option 2: Play Reference Audio
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceContainerLow,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppTheme.outlineVariant.withAlpha(40)),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: _togglePlayRefAudio,
                                  icon: Icon(
                                    _isPlayingRefAudio ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                                    size: 36,
                                    color: AppTheme.primaryContainer,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Audio Contoh / Referensi Khatib',
                                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.onSurface),
                                      ),
                                      Text(
                                        'Durasi: ${currentSection['refAudioDuration']} • Ustadz Teladan',
                                        style: const TextStyle(fontSize: 11, color: AppTheme.onSurfaceVariant),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Audio Recorder Controller Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Timer & Dynamic Audio Waveform
                  Row(
                    children: [
                      // Duration Pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _isRecording ? const Color(0xFFEF4444).withAlpha(15) : AppTheme.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _isRecording ? const Color(0xFFEF4444) : AppTheme.outlineVariant,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _formatDuration(_elapsedMilliseconds),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                fontFeatures: [FontFeature.tabularFigures()],
                                color: AppTheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Live Dynamic Audio Visualizer Bars
                      Expanded(
                        child: SizedBox(
                          height: 28,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: List.generate(_waveAmplitudes.length, (i) {
                              final amp = _isRecording && !_isPaused ? _waveAmplitudes[i] : 0.15;
                              return Container(
                                width: 3,
                                height: (amp * 26).clamp(4.0, 26.0),
                                decoration: BoxDecoration(
                                  color: _isRecording
                                      ? (amp > 0.6 ? const Color(0xFFFE932C) : AppTheme.primaryContainer)
                                      : AppTheme.outlineVariant.withAlpha(100),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Controls: Pause, Mic/Stop, Reset
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: _isRecording ? _togglePauseRecording : null,
                        icon: Icon(
                          _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                          size: 26,
                          color: _isRecording ? AppTheme.onSurface : AppTheme.outlineVariant,
                        ),
                        tooltip: _isPaused ? 'Lanjutkan Rekam' : 'Jeda Rekam',
                      ),

                      GestureDetector(
                        onTap: _toggleRecording,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: _isRecording ? const Color(0xFFEF4444) : AppTheme.primaryContainer,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (_isRecording ? const Color(0xFFEF4444) : AppTheme.primaryContainer).withAlpha(80),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: (_elapsedMilliseconds > 0 || _hasRecorded)
                            ? () {
                                _recordTimer?.cancel();
                                _stopAllPlaybacks();
                                setState(() {
                                  _isRecording = false;
                                  _isPaused = false;
                                  _elapsedMilliseconds = 0;
                                  _currentWpm = 0;
                                  _averageWpm = 0;
                                  _hasRecorded = false;
                                });
                              }
                            : null,
                        icon: Icon(
                          Icons.refresh_rounded,
                          size: 26,
                          color: (_elapsedMilliseconds > 0 || _hasRecorded) ? AppTheme.onSurface : AppTheme.outlineVariant,
                        ),
                        tooltip: 'Ulangi Rekaman',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
