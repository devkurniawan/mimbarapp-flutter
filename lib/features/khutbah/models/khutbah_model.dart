class KhutbahModel {
  final String id;
  final String title;
  final String theme;
  final String speaker;
  final String duration;
  final String arabicText;
  final String translation;
  final String content;
  final List<String> keyPoints;
  final String category;
  final bool isFavorite;

  KhutbahModel({
    required this.id,
    required this.title,
    required this.theme,
    required this.speaker,
    required this.duration,
    required this.arabicText,
    required this.translation,
    required this.content,
    required this.keyPoints,
    required this.category,
    this.isFavorite = false,
  });
}

class SampleData {
  static List<KhutbahModel> sampleKhutbahs = [
    KhutbahModel(
      id: '1',
      title: 'Menjaga Amanah Kepemimpinan dalam Islam',
      theme: 'Akhlak & Muamalah',
      speaker: 'Ustadz Dr. H. Ahmad Wijaya, M.A.',
      duration: '15 Menit',
      category: 'Khutbah Jumat',
      arabicText: 'يَآ أَيُّهَا الَّذِينَ آمَنُوا لاَ تَخُونُوا اللهَ وَالرَّسُولَ وَتَخُونُوا أَمَانَاتِكُمْ وَأَنْتُمْ تَعْلَمُونَ',
      translation: 'Wahai orang-orang yang beriman! Janganlah kamu mengkhianati Allah dan Rasul dan juga janganlah kamu mengkhianati amanat yang dipercayakan kepadamu, sedang kamu mengetahui. (QS. Al-Anfal: 27)',
      content: '''
Khutbah Pertama:

Alhamdulillah, segala puji bagi Allah SWT yang telah memberikan kita nikmat iman, islam, dan kesehatan sehingga kita dapat berkumpul di tempat yang mulia ini. Shalawat dan salam semoga senantiasa tercurah kepada junjungan kita Nabi Muhammad SAW.

Sidang Jumat yang dirahmati Allah,
Amanah adalah salah satu pilar utama dalam ajaran Islam. Setiap diri kita adalah pemimpin, dan setiap pemimpin akan dimintai pertanggungjawaban atas apa yang dipimpinnya. Kepemimpinan bukan sekadar jabatan atau kehormatan, melainkan beban berat yang harus ditunaikan dengan penuh keadilan dan kejujuran.

Nabi SAW bersabda: "Setiap kalian adalah pemimpin dan setiap kalian akan dimintai pertanggungjawaban atas yang dipimpinnya."

Oleh karena itu, marilah kita senantiasa memegang teguh amanah dalam keluarga, masyarakat, dan pekerjaan kita sehari-hari.

Khutbah Kedua:

Barakallahu li wa lakum fil quranil adzim. Semoga Allah memberkahi kita semua dan menjadikan kita hamba-hamba-Nya yang selalu menjaga amanah.
''',
      keyPoints: [
        'Pentingnya niat yang ikhlas dalam memegang jabatan',
        'Pertanggungjawaban kepemimpinan di akhirat',
        'Menjaga kejujuran dalam muamalah sehari-hari',
      ],
      isFavorite: true,
    ),
    KhutbahModel(
      id: '2',
      title: 'Keutamaan Menuntut Ilmu dan Mengamalkannya',
      theme: 'Pendidikan & Tazkiyatun Nafs',
      speaker: 'KH. Muhammad Ridwan',
      duration: '12 Menit',
      category: 'Pidato / Tausiyah',
      arabicText: 'يَرْفَعِ اللَّهُ الَّذِينَ آمَنُوا مِنْكُمْ وَالَّذِينَ أُوتُوا الْعِلْمَ دَرَجَاتٍ',
      translation: 'Allah akan meninggikan orang-orang yang beriman di antaramu dan orang-orang yang diberi ilmu pengetahuan beberapa derajat. (QS. Al-Mujadilah: 11)',
      content: '''
Bismillahirahmanirrahim. Assalamu’alaikum Warahmatullahi Wabarakatuh.

Puji syukur kehadirat Allah SWT yang telah memberikan nikmat akal dan ilmu pengetahuan. Kaum muslimin dan muslimat yang berbahagia,

Ilmu adalah cahaya yang menerangi kegelapan. Tanpa ilmu, seseorang akan mudah tersesat dalam melangkah. Islam sangat menekankan pentingnya menuntut ilmu dari buaian hingga liang lahad. Namun, ilmu tanpa amal ibarat pohon tanpa buah.

Maka tugas kita bukan hanya mencari ilmu, tetapi juga mengamalkannya dalam kehidupan sehari-hari serta mengajarkannya kepada sesama.
''',
      keyPoints: [
        'Kewajiban menuntut ilmu bagi setiap muslim',
        'Derajat mulia bagi penuntut ilmu',
        'Mengamalkan ilmu sebagai bentuk rasa syukur',
      ],
    ),
    KhutbahModel(
      id: '3',
      title: 'Membangun Keluarga Sakinah Berlandaskan Al-Qur\'an',
      theme: 'Keluarga & Pernikahan',
      speaker: 'Ustadz Salman Al-Farisi',
      duration: '18 Menit',
      category: 'Khutbah Nikah',
      arabicText: 'وَمِنْ آيَاتِهِ أَنْ خَلَقَ لَكُمْ مِنْ أَنْفُسِكُمْ أَزْوَاجًا لِتَسْكُنُوا إِلَيْهَا وَجَعَلَ بَيْنَكُمْ مَوَدَّةً وَرَحْمَةً',
      translation: 'Dan di antara tanda-tanda kekuasaan-Nya ialah Dia menciptakan untukmu istri-istri dari jenismu sendiri, supaya kamu cenderung dan merasa tenteram kepadanya. (QS. Ar-Rum: 21)',
      content: '''
Khutbah Nikah:

Membangun bahtera rumah tangga adalah ibadah sepanjang hayat. Rasa cinta (Mawaddah) dan kasih sayang (Rahmah) harus terus dipupuk dengan saling memahami, mendoakan, dan bersabar.

Kunci keluarga sakinah adalah keterbukaan, komunikasi yang baik, serta menjadikan Al-Qur'an dan Sunnah sebagai pedoman utama ketika menghadapi dinamika kehidupan.
''',
      keyPoints: [
        'Arti Mawaddah wa Rahmah dalam pernikahan',
        'Peran suami dan istri sesuai syariat',
        'Menyelesaikan konflik keluarga secara islami',
      ],
    ),
    KhutbahModel(
      id: '4',
      title: 'Pentingnya Istiqomah dalam Beribadah Pasca Ramadan',
      theme: 'Tazkiyatun Nafs',
      speaker: 'KH. Abdullah Gymnastiar',
      duration: '14 Menit',
      category: 'Khutbah Jumat',
      arabicText: 'فَاسْتَقِمْ كَمَا أُمِرْتَ وَمَنْ تَابَ مَعَكَ',
      translation: 'Maka tetaplah engkau (di jalan yang benar), sebagaimana diperintahkan kepadamu dan (juga) orang yang telah bertobat bersamamu. (QS. Hud: 112)',
      content: 'Isi khutbah tentang keutamaan menjaga konsistensi amalan ibadah...',
      keyPoints: ['Pengertian Istiqomah', 'Menjaga amalan sunnah', 'Menghindari riya'],
      isFavorite: true,
    ),
    KhutbahModel(
      id: '5',
      title: 'Zakat dan Infak sebagai Instrumen Kesejahteraan Umat',
      theme: 'Ekonomi Syariah & Muamalah',
      speaker: 'Dr. Adi Hidayat, Lc., M.A.',
      duration: '20 Menit',
      category: 'Tausiyah',
      arabicText: 'خُذْ مِنْ أَمْوَالِهِمْ صَدَقَةً تُطَهِّرُهُمْ وَتُزَكِّيهِمْ بِهَا',
      translation: 'Ambillah zakat dari sebagian harta mereka, dengan zakat itu kamu membersihkan dan menyucikan mereka. (QS. At-Taubah: 103)',
      content: 'Penjelasan mengenai keberkahan harta yang dikeluarkan zakatnya...',
      keyPoints: ['Peran zakat dalam pengentasan kemiskinan', 'Hikmah pembersihan harta'],
      isFavorite: true,
    ),
    KhutbahModel(
      id: '6',
      title: 'Meneladani Ukhuwah Islamiyah di Era Digital',
      theme: 'Soal Sosial & Kemasyarakatan',
      speaker: 'Ustadz Hanan Attaki, Lc.',
      duration: '16 Menit',
      category: 'Khutbah Jumat',
      arabicText: 'إِنَّمَا الْمُؤْمِنُونَ إِخْوَةٌ فَأَصْلِحُوا بَيْنَ أَخَوَيْكُمْ',
      translation: 'Orang-orang beriman itu sesungguhnya bergandengan saudara... (QS. Al-Hujurat: 10)',
      content: 'Etika bermedia sosial dan menjaga persaudaraan sesama muslim...',
      keyPoints: ['Adab bertabayyun', 'Menjaga lisan dan tulisan di media sosial'],
      isFavorite: true,
    ),
    KhutbahModel(
      id: '7',
      title: 'Merawat Syukur atas Nikmat Kemerdekaan dan Kedamaian',
      theme: 'Kebangsaan & Akhlak',
      speaker: 'KH. Bahauddin Nursalim (Gus Baha)',
      duration: '15 Menit',
      category: 'Khutbah Jumat',
      arabicText: 'وَإِذْ تَأَذَّنَ رَبُّكُمْ لَئِنْ شَكَرْتُمْ لَأَزِيدَنَّكُمْ',
      translation: 'Dan (ingatlah juga), ketika Tuhanmu memaklumkan: "Sesungguhnya jika kamu bersyukur, pasti Kami akan menambah (nikmat) kepadamu..." (QS. Ibrahim: 7)',
      content: 'Refleksi syukur atas nikmat bangsa dan tanah air...',
      keyPoints: ['Menjaga kerukunan', 'Mengisi kemerdekaan dengan karya positif'],
      isFavorite: false,
    ),
    KhutbahModel(
      id: '8',
      title: 'Kiat Mendidik Anak Sholeh di Zaman Gen-Z',
      theme: 'Parenting & Keluarga',
      speaker: 'Ustadz Bendri Jaisyurrahman',
      duration: '17 Menit',
      category: 'Tausiyah',
      arabicText: 'يَآ أَيُّهَا الَّذِينَ آمَنُوا قُوا أَنْفُسَكُمْ وَأَهْلِيكُمْ نَارًا',
      translation: 'Wahai orang-orang yang beriman! Peliharalah dirimu dan keluargamu dari api neraka... (QS. At-Tahrim: 6)',
      content: 'Tantangan dan strategi pengasuhan anak di era modern...',
      keyPoints: ['Pendekatan empati', 'Menjadi teladan utama anak'],
      isFavorite: true,
    ),
    KhutbahModel(
      id: '9',
      title: 'Bahaya Riba dan Solusi Ekonomi Syariah Modern',
      theme: 'Muamalah & Syariah',
      speaker: 'Dr. Erwandi Tarmizi, M.A.',
      duration: '18 Menit',
      category: 'Khutbah Jumat',
      arabicText: 'وَأَحَلَّ اللَّهُ الْبَيْعَ وَحَرَّمَ الرِّبَا',
      translation: 'Allah telah menghalalkan jual beli dan mengharamkan riba. (QS. Al-Baqarah: 275)',
      content: 'Penjelasan fiqih muamalah kontemporer mengenai transaksi keuangan...',
      keyPoints: ['Akibat riba pada keberkahan harta', 'Akad-akad muamalah syariah'],
      isFavorite: true,
    ),
    KhutbahModel(
      id: '10',
      title: 'Meneladani Sifat Fathonah dan Amanah Nabi Muhammad SAW',
      theme: 'Sirah Nabawiyah',
      speaker: 'Prof. Dr. Quraish Shihab, M.A.',
      duration: '15 Menit',
      category: 'Khutbah Jumat',
      arabicText: 'وَإِنَّكَ لَعَلَىٰ خُلُقٍ عَظِيمٍ',
      translation: 'Dan sesungguhnya engkau benar-benar berbudi pekerti yang luhur. (QS. Al-Qalam: 4)',
      content: 'Integrasi sifat Rasulullah dalam integritas profesional kita...',
      keyPoints: ['Pengertian fathonah', 'Amanah dalam pekerjaan'],
      isFavorite: true,
    ),
    KhutbahModel(
      id: '11',
      title: 'Keutamaan Shalat Khusyu dan Dampaknya pada Jiwa',
      theme: 'Tazkiyatun Nafs',
      speaker: 'Ustadz Nouman Ali Khan',
      duration: '22 Menit',
      category: 'Tausiyah',
      arabicText: 'قَدْ أَفْلَحَ الْمُؤْمِنُونَ الَّذِينَ هُمْ فِي صَلَاتِهِمْ خَاشِعُونَ',
      translation: 'Sungguh beruntung orang-orang yang beriman, (yaitu) orang yang khusyuk dalam shalatnya. (QS. Al-Mu\'minun: 1-2)',
      content: 'Resep kedamaian hati lewat perbaikan kualitas shalat lima waktu...',
      keyPoints: ['Makna khusyu', 'Memahami bacaan shalat'],
      isFavorite: false,
    ),
    KhutbahModel(
      id: '12',
      title: 'Adab Berbeda Pendapat dalam Mahzab Fiqih Islam',
      theme: 'Fiqih & Wasathiyah',
      speaker: 'KH. Ahmad Bahauddin Nursalim',
      duration: '19 Menit',
      category: 'Tausiyah',
      arabicText: 'ادْعُ إِلَىٰ سَبِيلِ رَبِّكَ بِالْحِكْمَةِ وَالْمَوْعِظَةِ الْحَسَنَةِ',
      translation: 'Serulah (manusia) kepada jalan Tuhanmu dengan hikmah dan pengajaran yang baik... (QS. An-Nahl: 125)',
      content: 'Toleransi dan kelapangan dada para ulama mazhab terdahulu...',
      keyPoints: ['Memahami khilafiyah', 'Saling menghormati perberdaan'],
      isFavorite: true,
    ),
    KhutbahModel(
      id: '13',
      title: 'Hikmah dan Filosofi Qurban di Hari Raya Idul Adha',
      theme: 'Fiqih Ibadah',
      speaker: 'Ustadz Abdul Somad, Lc., Ph.D.',
      duration: '16 Menit',
      category: 'Khutbah Idul Adha',
      arabicText: 'فَصَلِّ لِرَبِّكَ وَانْحَرْ',
      translation: 'Maka laksanakanlah shalat karena Tuhanmu; dan berkurbanlah. (QS. Al-Kausar: 2)',
      content: 'Meneladani ketauhidan Nabi Ibrahim AS dan keikhlasan Nabi Ismail AS...',
      keyPoints: ['Makna ketaatan', 'Syarat dan keutamaan hewan qurban'],
      isFavorite: false,
    ),
    KhutbahModel(
      id: '14',
      title: 'Menjaga Kebersihan Lingkungan sebagai Bagian dari Iman',
      theme: 'Akhlak Lingkungan',
      speaker: 'Dr. KH. Hilmy Muhammad',
      duration: '13 Menit',
      category: 'Khutbah Jumat',
      arabicText: 'إِنَّ اللَّهَ يُحِبُّ التَّوَّابِينَ وَيُحِبُّ الْمُتَطَهِّرِينَ',
      translation: 'Sesungguhnya Allah menyukai orang-orang yang bertobat dan menyukai orang-orang yang menyucikan diri. (QS. Al-Baqarah: 222)',
      content: 'Tanggung jawab kebersihan fasilitas umum dan kelestarian alam...',
      keyPoints: ['Kebersihan sebagian dari iman', 'Merawat lingkungan hidup'],
      isFavorite: true,
    ),
    KhutbahModel(
      id: '15',
      title: 'Menyambut Kemenangan Jiwa pada Hari Raya Idul Fitri',
      theme: 'Tazkiyatun Nafs',
      speaker: 'KH. Said Aqil Siradj',
      duration: '15 Menit',
      category: 'Khutbah Idul Fitri',
      arabicText: 'وَلِتُكْمِلُوا الْعِدَّةَ وَلِتُكَبِّرُوا اللَّهَ عَلَىٰ مَا هَدَاكُمْ',
      translation: 'Dan hendaknya kamu mencukupkan bilangannya dan mengagungkan Allah atas petunjuk-Nya... (QS. Al-Baqarah: 185)',
      content: 'Pesan kebersihan hati dan silaturahmi di hari raya Idul Fitri...',
      keyPoints: ['Pengertian kembali fitri', 'Mempererat tali silaturahmi'],
      isFavorite: true,
    ),
  ];
}
