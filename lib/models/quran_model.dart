class Surah {
  final int id;
  final String name;
  final String arabicName;
  final String meaning;
  final int verseCount;
  final String revelation;

  Surah({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.meaning,
    required this.verseCount,
    required this.revelation,
  });
}

class Verse {
  final int id;
  final String arabicText;
  final String translation;

  Verse({
    required this.id,
    required this.arabicText,
    required this.translation,
  });
}

final List<Surah> mockSurahs = [
  Surah(id: 1, name: 'Al-Fatihah', arabicName: 'الفاتحة', meaning: 'The Opening', verseCount: 7, revelation: 'Meccan'),
  Surah(id: 2, name: 'Al-Baqarah', arabicName: 'البقرة', meaning: 'The Cow', verseCount: 286, revelation: 'Medinan'),
  Surah(id: 3, name: 'Ali \'Imran', arabicName: 'آل عمران', meaning: 'Family of Imran', verseCount: 200, revelation: 'Medinan'),
  Surah(id: 4, name: 'An-Nisa\'', arabicName: 'النساء', meaning: 'The Women', verseCount: 176, revelation: 'Medinan'),
  Surah(id: 5, name: 'Al-Ma\'idah', arabicName: 'المائدة', meaning: 'The Table Spread', verseCount: 120, revelation: 'Medinan'),
  Surah(id: 6, name: 'Al-An\'am', arabicName: 'الأنعام', meaning: 'The Cattle', verseCount: 165, revelation: 'Meccan'),
  Surah(id: 7, name: 'Al-A\'raf', arabicName: 'الأعراف', meaning: 'The Heights', verseCount: 206, revelation: 'Meccan'),
];

final List<Verse> mockVerses = [
  Verse(id: 1, arabicText: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ', translation: 'In the name of Allah, the Entirely Merciful, the Especially Merciful.'),
  Verse(id: 2, arabicText: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ', translation: '[All] praise is [due] to Allah, Lord of the worlds -'),
  Verse(id: 3, arabicText: 'الرَّحْمَٰنِ الرَّحِيمِ', translation: 'The Entirely Merciful, the Especially Merciful,'),
  Verse(id: 4, arabicText: 'مَالِكِ يَوْمِ الدِّينِ', translation: 'Sovereign of the Day of Recompense.'),
  Verse(id: 5, arabicText: 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ', translation: 'It is You we worship and You we ask for help.'),
];
