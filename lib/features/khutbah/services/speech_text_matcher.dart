import 'dart:math';

/// Representasi satu kata di dalam naskah khutbah yang telah ditokenisasi.
class ScriptWordToken {
  final int globalIndex;
  final int sectionIndex;
  final int wordIndexInSection;
  final String originalText;
  final String normalizedText;
  final bool isLineBreakAfter;

  const ScriptWordToken({
    required this.globalIndex,
    required this.sectionIndex,
    required this.wordIndexInSection,
    required this.originalText,
    required this.normalizedText,
    this.isLineBreakAfter = false,
  });
}

/// Hasil pencocokan suara terhadap naskah.
class SpeechMatchResult {
  final int matchedGlobalIndex;
  final int matchedSectionIndex;
  final int matchedWordIndexInSection;
  final double confidenceScore;
  final bool isArabicCueTriggered;
  final int wordsAdvanced;

  const SpeechMatchResult({
    required this.matchedGlobalIndex,
    required this.matchedSectionIndex,
    required this.matchedWordIndexInSection,
    required this.confidenceScore,
    this.isArabicCueTriggered = false,
    this.wordsAdvanced = 0,
  });
}

/// Engine Algoritma Sliding Window Fuzzy Text Alignment (FR-02 & FR-04).
/// Dirancang khusus untuk menyelaraskan transkrip Speech-to-Text Bahasa Indonesia
/// dan serapan istilah Islami dengan naskah khutbah secara real-time.
class SpeechTextMatcher {
  final List<ScriptWordToken> _tokens = [];
  final Map<int, List<ScriptWordToken>> _sectionTokensMap = {};

  /// Jendela pencarian ke depan (+12 kata) dan ke belakang (-2 kata) sesuai PRD FR-02.
  static const int lookAheadWindow = 12;
  static const int lookBehindWindow = 2;

  /// Ambang batas kemiripan minimum Levenshtein (68% sesuai PRD FR-02).
  static const double similarityThreshold = 0.68;

  /// Daftar kata kunci fonetik bacaan Arab populer untuk memicu highlight bagian Arab (FR-04).
  static const Map<String, List<String>> arabicPhoneticTriggers = {
    'muqaddimah': [
      'alhamdulillahi',
      'alhamdulillah',
      'rabbil',
      'alamin',
      'wassalatu',
      'wassalamu',
      'asyrafil',
      'anbiya',
      'mursalin',
    ],
    'ayat': [
      'audzubillah',
      'bismillah',
      'ayyuhalladzina',
      'amanu',
      'takhunullaha',
      'amanatikum',
      'antum',
      'talamun',
    ],
    'isi_1': [
      'kullukum',
      'rain',
      'masulun',
      'raiyyatihi',
    ],
    'isi_2': [
      'innallaha',
      'yamurukum',
      'tuaddul',
      'amanati',
      'ahliha',
    ],
    'doa': [
      'allahummaghfir',
      'allahumma',
      'muslimina',
      'muslimat',
      'muminina',
      'muminat',
      'ahya',
      'amwat',
      'amin',
      'aamiin',
    ],
  };

  List<ScriptWordToken> get tokens => List.unmodifiable(_tokens);

  List<ScriptWordToken> getTokensForSection(int sectionIndex) {
    return _sectionTokensMap[sectionIndex] ?? const [];
  }

  int get totalWords => _tokens.length;

  /// Membangun indeks token kata dari seluruh bagian naskah khutbah.
  void buildFromSections(List<Map<String, dynamic>> sections) {
    _tokens.clear();
    _sectionTokensMap.clear();

    int globalIdx = 0;

    for (int sIdx = 0; sIdx < sections.length; sIdx++) {
      final rawText = (sections[sIdx]['text'] ?? '').toString();
      final sectionList = <ScriptWordToken>[];

      // Pisahkan berdasarkan paragraf/baris terlebih dahulu agar line-break terjaga di UI
      final paragraphs = rawText.split('\n');
      int wordInSecIdx = 0;

      for (int pIdx = 0; pIdx < paragraphs.length; pIdx++) {
        final paragraph = paragraphs[pIdx].trim();
        if (paragraph.isEmpty) continue;

        final rawWords = paragraph.split(RegExp(r'\s+'));
        for (int wIdx = 0; wIdx < rawWords.length; wIdx++) {
          final word = rawWords[wIdx];
          if (word.isEmpty) continue;

          final isLastInParagraph =
              (wIdx == rawWords.length - 1) && (pIdx < paragraphs.length - 1);

          final token = ScriptWordToken(
            globalIndex: globalIdx,
            sectionIndex: sIdx,
            wordIndexInSection: wordInSecIdx,
            originalText: word,
            normalizedText: normalizePhonetic(word),
            isLineBreakAfter: isLastInParagraph,
          );

          _tokens.add(token);
          sectionList.add(token);
          globalIdx++;
          wordInSecIdx++;
        }
      }

      _sectionTokensMap[sIdx] = sectionList;
    }
  }

  /// Normalisasi teks & ejaan serapan Arab-Indonesia (PRD FR-02).
  /// Contoh: "Shalawat," -> "salawat", "Khutbah" -> "kutbah", "Amanat" -> "amanah"
  static String normalizePhonetic(String input) {
    var text = input.toLowerCase();

    // Hapus tanda baca dan simbol non-alfanumerik kecuali spasi
    text = text.replaceAll(RegExp(r'[^\w\s]'), '');

    // Normalisasi singkatan populer dalam naskah khutbah
    if (text == 'swt') return 'subhanahu';
    if (text == 'saw') return 'salallahu';
    if (text == 'qs') return 'quran';

    // Standarisasi fonetik serapan Arab-Indonesia
    text = text
        .replaceAll('sh', 's')
        .replaceAll('sy', 's')
        .replaceAll('kh', 'k')
        .replaceAll('dz', 'z')
        .replaceAll('zh', 'z')
        .replaceAll('th', 't')
        .replaceAll('dh', 'd')
        .replaceAll('gh', 'g')
        .replaceAll('aa', 'a')
        .replaceAll('ii', 'i')
        .replaceAll('uu', 'u')
        .replaceAll('oo', 'o');

    // Penyetaraan akhiran serapan yang sering tertukar di STT (amanat <-> amanah, shalat <-> sholat)
    if (text == 'amanat') text = 'amanah';
    if (text == 'solat' || text == 'salat') text = 'salat';
    if (text == 'jamaah' || text == 'jemaah') text = 'jamaah';
    if (text == 'mukminin' || text == 'muminin') text = 'mukminin';
    if (text == 'mukminat' || text == 'muminat') text = 'mukminat';
    if (text == 'selawat' || text == 'solawat') text = 'salawat';

    return text.trim();
  }

  /// Mengecek apakah transkrip STT mengandung pemicu bacaan Arab pada bagian aktif.
  bool checkArabicTrigger(String transcript, String sectionType) {
    final triggers = arabicPhoneticTriggers[sectionType];
    if (triggers == null || triggers.isEmpty) return false;

    final spokenWords = transcript
        .toLowerCase()
        .split(RegExp(r'\s+'))
        .map(normalizePhonetic)
        .where((w) => w.length >= 3)
        .toList();

    for (final spoken in spokenWords.reversed.take(5)) {
      for (final trigger in triggers) {
        if (calculateSimilarity(spoken, normalizePhonetic(trigger)) >= 0.72) {
          return true;
        }
      }
    }
    return false;
  }

  /// Mencocokkan partial/final transcript dari STT dengan posisi kata aktif saat ini
  /// menggunakan Sliding Window (-2 s/d +12 kata) dan N-Gram Locking.
  SpeechMatchResult? matchTranscript({
    required String spokenTranscript,
    required int currentGlobalIndex,
    String? currentSectionType,
  }) {
    if (_tokens.isEmpty || spokenTranscript.trim().isEmpty) return null;

    final rawSpokenWords = spokenTranscript
        .trim()
        .split(RegExp(r'\s+'))
        .map(normalizePhonetic)
        .where((w) => w.isNotEmpty)
        .toList();

    if (rawSpokenWords.isEmpty) return null;

    // Ambil maksimal 4 kata terakhir yang baru saja diucapkan oleh khatib
    final recentSpoken = rawSpokenWords.length > 4
        ? rawSpokenWords.sublist(rawSpokenWords.length - 4)
        : rawSpokenWords;

    final safeCurrentIdx = currentGlobalIndex.clamp(0, _tokens.length - 1);
    final windowStart = max(0, safeCurrentIdx - lookBehindWindow);
    final windowEnd = min(_tokens.length - 1, safeCurrentIdx + lookAheadWindow);

    int bestMatchIndex = -1;
    double bestScore = 0.0;

    // 1. Prioritas Utama: Pencocokan Bigram / Trigram (2-3 kata berurutan) untuk mengunci frase (N-Gram Locking)
    if (recentSpoken.length >= 2) {
      final spokenLastTwo =
          recentSpoken.sublist(recentSpoken.length - 2); // [w1, w2]

      for (int i = windowStart; i < windowEnd; i++) {
        final sim1 = calculateSimilarity(
          spokenLastTwo[0],
          _tokens[i].normalizedText,
        );
        final sim2 = calculateSimilarity(
          spokenLastTwo[1],
          _tokens[i + 1].normalizedText,
        );

        final avgSim = (sim1 * 0.45) + (sim2 * 0.55);
        // Bonus kedekatan posisi agar tidak melompat terlalu jauh jika ada frase mirip
        final distancePenalty = ((i + 1 - safeCurrentIdx).abs() * 0.012);
        final finalScore = avgSim - distancePenalty;

        if (avgSim >= similarityThreshold && finalScore > bestScore) {
          bestScore = finalScore;
          bestMatchIndex = i + 1;
        }
      }
    }

    // 2. Jika belum ketemu Bigram, cek kata terakhir (Single Word Match di Sliding Window)
    if (bestMatchIndex == -1) {
      final lastSpokenWord = recentSpoken.last;
      // Abaikan kata super pendek (<= 2 huruf) jika sendirian agar tidak lompat karena noise
      if (lastSpokenWord.length >= 3) {
        for (int i = windowStart; i <= windowEnd; i++) {
          final targetWord = _tokens[i].normalizedText;
          if (targetWord.isEmpty) continue;

          final sim = calculateSimilarity(lastSpokenWord, targetWord);
          final distancePenalty = ((i - safeCurrentIdx).abs() * 0.018);
          final weightedScore = sim - distancePenalty;

          if (sim >= similarityThreshold && weightedScore > bestScore) {
            bestScore = weightedScore;
            bestMatchIndex = i;
          }
        }
      }
    }

    // 3. Cek juga apakah kata kedua dari belakang cocok dengan posisi tepat berikutnya
    // (berguna ketika kata paling ujung dari partial STT masih terpotong setengah suku kata)
    if (bestMatchIndex == -1 && recentSpoken.length >= 2) {
      final secondLastWord = recentSpoken[recentSpoken.length - 2];
      if (secondLastWord.length >= 3) {
        for (int i = safeCurrentIdx;
            i <= min(windowEnd, safeCurrentIdx + 5);
            i++) {
          final sim =
              calculateSimilarity(secondLastWord, _tokens[i].normalizedText);
          if (sim >= 0.75 && sim > bestScore) {
            bestScore = sim;
            bestMatchIndex = i;
          }
        }
      }
    }

    if (bestMatchIndex != -1 && bestMatchIndex >= safeCurrentIdx - 1) {
      final matchedToken = _tokens[bestMatchIndex];
      final advanced = max(0, bestMatchIndex - safeCurrentIdx);

      return SpeechMatchResult(
        matchedGlobalIndex: matchedToken.globalIndex,
        matchedSectionIndex: matchedToken.sectionIndex,
        matchedWordIndexInSection: matchedToken.wordIndexInSection,
        confidenceScore: bestScore.clamp(0.0, 1.0),
        wordsAdvanced: advanced,
      );
    }

    // 4. Cek apakah khatib sedang membaca bagian teks Arab
    if (currentSectionType != null &&
        checkArabicTrigger(spokenTranscript, currentSectionType)) {
      final currentToken = _tokens[safeCurrentIdx];
      return SpeechMatchResult(
        matchedGlobalIndex: currentToken.globalIndex,
        matchedSectionIndex: currentToken.sectionIndex,
        matchedWordIndexInSection: currentToken.wordIndexInSection,
        confidenceScore: 0.85,
        isArabicCueTriggered: true,
        wordsAdvanced: 0,
      );
    }

    return null;
  }

  /// Menghitung kemiripan dua kata menggunakan Levenshtein Similarity Ratio (0.0 - 1.0)
  /// ditambah dukungan Prefix Matching untuk partial speech recognition.
  static double calculateSimilarity(String s1, String s2) {
    if (s1 == s2) return 1.0;
    if (s1.isEmpty || s2.isEmpty) return 0.0;

    // Jika kata yang diucapkan adalah awalan (prefix) dari kata panjang di naskah (minimal 4 huruf)
    if (s1.length >= 4 && s2.startsWith(s1)) {
      return 0.78 + (s1.length / s2.length) * 0.2;
    }
    if (s2.length >= 4 && s1.startsWith(s2)) {
      return 0.78 + (s2.length / s1.length) * 0.2;
    }

    final distance = _levenshteinDistance(s1, s2);
    final maxLen = max(s1.length, s2.length);
    return (1.0 - (distance / maxLen)).clamp(0.0, 1.0);
  }

  static int _levenshteinDistance(String s1, String s2) {
    final len1 = s1.length;
    final len2 = s2.length;

    List<int> prevRow = List<int>.generate(len2 + 1, (i) => i);
    List<int> currRow = List<int>.filled(len2 + 1, 0);

    for (int i = 1; i <= len1; i++) {
      currRow[0] = i;
      for (int j = 1; j <= len2; j++) {
        final cost = (s1[i - 1] == s2[j - 1]) ? 0 : 1;
        currRow[j] = min(
          min(currRow[j - 1] + 1, prevRow[j] + 1),
          prevRow[j - 1] + cost,
        );
      }
      final temp = prevRow;
      prevRow = currRow;
      currRow = temp;
    }
    return prevRow[len2];
  }
}

