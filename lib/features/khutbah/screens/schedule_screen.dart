import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  String _selectedTab = 'Mendatang'; // 'Mendatang', 'Selesai', 'Semua'
  String _selectedCategory = 'Semua';
  bool _showScrollToTop = false;

  final List<Map<String, dynamic>> _schedules = [
    {
      'id': '1',
      'title': 'Menjaga Amanah dan Integritas Pemimpin Muslim',
      'masjid': 'Masjid Agung Al-Falah',
      'location': 'Jl. R.E. Martadinata No. 45, Bandung',
      'date': 'Jumat, 29 Agustus 2026',
      'time': '11:45 WIB',
      'category': 'Khutbah Jumat',
      'status': 'Mendatang',
      'naskah': 'Sudah Siap (Terhubung)',
      'isUrgent': true,
      'notes': 'Harap tiba 30 menit sebelum azan untuk koordinasi muazin.',
    },
    {
      'id': '2',
      'title': 'Kultum Subuh: Adab Bertetangga dalam Islam',
      'masjid': 'Masjid Nurul Ikhlas',
      'location': 'Komp. Griya Indah Blok C, Bandung',
      'date': 'Ahad, 31 Agustus 2026',
      'time': '05:00 WIB',
      'category': 'Kultum Subuh',
      'status': 'Terjadwal',
      'naskah': 'Belum Dihubungkan',
      'isUrgent': false,
      'notes': 'Pengajian rutin bulanan jamaah bapak-bapak.',
    },
    {
      'id': '3',
      'title': 'Tausiyah Pernikahan: Membangun Keluarga Sakinah',
      'masjid': 'Grand Ballroom Hotel Aryaduta',
      'location': 'Jl. Sumatra No. 51, Bandung',
      'date': 'Sabtu, 5 September 2026',
      'time': '09:30 WIB',
      'category': 'Tausiyah Nikah',
      'status': 'Terjadwal',
      'naskah': 'Draf Naskah',
      'isUrgent': false,
      'notes': 'Acara akad & walimah Ananda Fikri & Aisyah.',
    },
    {
      'id': '4',
      'title': 'Khutbah Jumat: Merawat Persaudaraan di Era Digital',
      'masjid': 'Masjid Istiqamah Bandung',
      'location': 'Jl. Taman Citarum No. 1, Bandung',
      'date': 'Jumat, 22 Agustus 2026',
      'time': '11:45 WIB',
      'category': 'Khutbah Jumat',
      'status': 'Selesai',
      'naskah': 'Telah Diterbitkan',
      'isUrgent': false,
      'notes': 'Berjalan lancar, durasi 18 menit.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });

    _scrollController.addListener(() {
      if (_scrollController.offset > 160 && !_showScrollToTop) {
        setState(() {
          _showScrollToTop = true;
        });
      } else if (_scrollController.offset <= 160 && _showScrollToTop) {
        setState(() {
          _showScrollToTop = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  List<Map<String, dynamic>> get _filteredSchedules {
    return _schedules.where((item) {
      // Tab filter
      if (_selectedTab == 'Mendatang' && item['status'] == 'Selesai') return false;
      if (_selectedTab == 'Selesai' && item['status'] != 'Selesai') return false;

      // Category filter
      if (_selectedCategory != 'Semua' && item['category'] != _selectedCategory) return false;

      // Search filter
      if (_searchQuery.isNotEmpty) {
        final title = (item['title'] as String).toLowerCase();
        final masjid = (item['masjid'] as String).toLowerCase();
        final location = (item['location'] as String).toLowerCase();
        return title.contains(_searchQuery) || masjid.contains(_searchQuery) || location.contains(_searchQuery);
      }
      return true;
    }).toList();
  }

  void _showAddScheduleSheet() {
    final titleController = TextEditingController();
    final masjidController = TextEditingController();
    final locationController = TextEditingController();
    final timeController = TextEditingController(text: '11:45 WIB');
    String category = 'Khutbah Jumat';
    DateTime selectedDate = DateTime.now().add(const Duration(days: 3));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                top: 24,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusXl)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.edit_calendar_rounded, color: AppTheme.primaryContainer, size: 24),
                            SizedBox(width: 10),
                            Text(
                              'Tambah Jadwal Khutbah',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.onSurface),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded, color: AppTheme.outline),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    const Text('Tema / Judul Khutbah', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: 'Contoh: Khutbah Jumat tentang Kebersihan Sampah',
                        filled: true,
                        fillColor: AppTheme.background,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMd)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Nama Masjid / Tempat', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: masjidController,
                                decoration: InputDecoration(
                                  hintText: 'Nama Masjid',
                                  filled: true,
                                  fillColor: AppTheme.background,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMd)),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Kategori', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  color: AppTheme.background,
                                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                                  border: Border.all(color: AppTheme.outlineVariant.withAlpha(80)),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: category,
                                    isExpanded: true,
                                    items: ['Khutbah Jumat', 'Kultum Subuh', 'Tausiyah Nikah', 'Khutbah Id']
                                        .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 12))))
                                        .toList(),
                                    onChanged: (val) {
                                      if (val != null) setModalState(() => category = val);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text('Alamat Lengkap / Kecamatan', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: locationController,
                      decoration: InputDecoration(
                        hintText: 'Lokasi masjid...',
                        filled: true,
                        fillColor: AppTheme.background,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMd)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2027),
                              );
                              if (picked != null) {
                                setModalState(() => selectedDate = picked);
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppTheme.background,
                                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                                border: Border.all(color: AppTheme.outlineVariant.withAlpha(80)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_month_rounded, size: 18, color: AppTheme.primaryContainer),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: timeController,
                            decoration: InputDecoration(
                              hintText: 'Waktu (mis: 11:45 WIB)',
                              filled: true,
                              fillColor: AppTheme.background,
                              prefixIcon: const Icon(Icons.access_time_rounded, size: 18, color: AppTheme.primaryContainer),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMd)),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (titleController.text.trim().isEmpty) return;
                          setState(() {
                            _schedules.insert(0, {
                              'id': DateTime.now().millisecondsSinceEpoch.toString(),
                              'title': titleController.text.trim(),
                              'masjid': masjidController.text.trim().isEmpty ? 'Masjid Utama' : masjidController.text.trim(),
                              'location': locationController.text.trim().isEmpty ? 'Kota Bandung' : locationController.text.trim(),
                              'date': 'Jumat, ${selectedDate.day} Agustus 2026',
                              'time': timeController.text.trim(),
                              'category': category,
                              'status': 'Terjadwal',
                              'naskah': 'Belum Dihubungkan',
                              'isUrgent': false,
                              'notes': 'Baru ditambahkan',
                            });
                          });
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Jadwal khutbah baru berhasil ditambahkan!'),
                              backgroundColor: AppTheme.primaryContainer,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        icon: const Icon(Icons.check_circle_rounded, color: Colors.white),
                        label: const Text('Simpan Jadwal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryContainer,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusLg)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final upcomingCount = _schedules.where((s) => s['status'] != 'Selesai').length;
    final urgentSchedule = _schedules.firstWhere(
      (s) => s['isUrgent'] == true && s['status'] != 'Selesai',
      orElse: () => _schedules.first,
    );

    return Scaffold(
      backgroundColor: AppTheme.background,
      floatingActionButton: AnimatedOpacity(
        opacity: _showScrollToTop ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        child: AnimatedScale(
          scale: _showScrollToTop ? 1.0 : 0.6,
          duration: const Duration(milliseconds: 250),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppTheme.primaryContainer, AppTheme.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryContainer.withAlpha(90),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _showScrollToTop ? _scrollToTop : null,
                child: const Icon(
                  Icons.arrow_upward_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              // Hero Banner, Urgent Spotlight, Search, & Category Chips
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Modern Hero Banner
                      Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppTheme.primary,
                              AppTheme.primaryContainer,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primary.withAlpha(60),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              right: -15,
                              bottom: -15,
                              child: Icon(
                                Icons.calendar_month_rounded,
                                size: 130,
                                color: Colors.white.withAlpha(18),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withAlpha(30),
                                            borderRadius: BorderRadius.circular(100),
                                          ),
                                          child: const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.event_note_rounded, color: Colors.white, size: 14),
                                              SizedBox(width: 6),
                                              Flexible(
                                                child: Text(
                                                  'Agenda Khatib',
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: _showAddScheduleSheet,
                                        icon: const Icon(Icons.add_circle_outline_rounded, size: 16, color: AppTheme.primary),
                                        label: const Text(
                                          'Tambah',
                                          style: TextStyle(color: AppTheme.primary, fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          elevation: 2,
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Jadwal & Tugas Khutbah',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '$upcomingCount Tugas Mendatang • Kelola tanggal, tempat masjid, serta naskah siaran Anda secara rapi.',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white.withAlpha(220),
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Spotlight Card for Next Closest Khutbah
                      if (urgentSchedule['status'] != 'Selesai') ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppTheme.tagAmberBg.withAlpha(180),
                            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                            border: Border.all(color: AppTheme.tagAmberBorder.withAlpha(120), width: 1.2),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.tagAmberBorder.withAlpha(20),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: AppTheme.tagAmberBorder,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Icon(Icons.timer_rounded, color: Colors.white, size: 14),
                                        ),
                                        const SizedBox(width: 6),
                                        const Expanded(
                                          child: Text(
                                            'JADWAL TERDEKAT (2 HARI LAGI)',
                                            style: TextStyle(
                                              fontSize: 10.5,
                                              fontWeight: FontWeight.w800,
                                              color: AppTheme.tagAmberText,
                                              letterSpacing: 0.3,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(color: AppTheme.tagAmberBorder),
                                    ),
                                    child: Text(
                                      urgentSchedule['category'],
                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.tagAmberText),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                urgentSchedule['title'],
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.onSurface),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  const Icon(Icons.mosque_outlined, size: 15, color: AppTheme.secondary),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      '${urgentSchedule['masjid']} • ${urgentSchedule['time']}',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.onSurfaceVariant),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Membuka teleprompter untuk "${urgentSchedule['title']}"'),
                                            backgroundColor: AppTheme.primaryContainer,
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.play_circle_fill_rounded, size: 16, color: Colors.white),
                                      label: const Text('Mode Baca / Teleprompter', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.primaryContainer,
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusMd)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],

                      // Search Bar
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Cari jadwal atau nama masjid...',
                          hintStyle: TextStyle(color: AppTheme.outline.withAlpha(140), fontSize: 13),
                          prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primaryContainer, size: 20),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded, size: 16),
                                  onPressed: () => _searchController.clear(),
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 10),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                            borderSide: BorderSide(color: AppTheme.outlineVariant.withAlpha(60)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                            borderSide: const BorderSide(color: AppTheme.primaryContainer, width: 1.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Category Filter Pills
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: ['Semua', 'Khutbah Jumat', 'Kultum Subuh', 'Tausiyah Nikah'].map((cat) {
                            final isSelected = _selectedCategory == cat;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ChoiceChip(
                                label: Text(cat),
                                selected: isSelected,
                                onSelected: (selected) {
                                  if (selected) setState(() => _selectedCategory = cat);
                                },
                                selectedColor: AppTheme.secondaryContainer.withAlpha(30),
                                backgroundColor: Colors.white,
                                labelStyle: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                  color: isSelected ? AppTheme.secondaryContainer : AppTheme.onSurfaceVariant,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                  side: BorderSide(
                                    color: isSelected ? AppTheme.secondaryContainer : AppTheme.outlineVariant.withAlpha(60),
                                  ),
                                ),
                                showCheckmark: false,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Pinned Fixed Segmented Tab Switcher (Mendatang, Selesai, Semua)
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyScheduleTabDelegate(
                  child: Container(
                    color: AppTheme.background,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                        border: Border.all(color: AppTheme.outlineVariant.withAlpha(60)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(8),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: ['Mendatang', 'Selesai', 'Semua'].map((tab) {
                          final isSelected = _selectedTab == tab;
                          return Expanded(
                            child: InkWell(
                              onTap: () => setState(() => _selectedTab = tab),
                              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.symmetric(vertical: 9),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isSelected ? AppTheme.primaryContainer : Colors.transparent,
                                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                                ),
                                child: Text(
                                  tab,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                    color: isSelected ? Colors.white : AppTheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section Heading & List Count
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Daftar Agenda (${_filteredSchedules.length})',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.onBackground),
                    ),
                    Text(
                      'Filter: $_selectedTab',
                      style: const TextStyle(fontSize: 12, color: AppTheme.outline, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Empty State
                if (_filteredSchedules.isEmpty) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                      border: Border.all(color: AppTheme.outlineVariant.withAlpha(50)),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.event_busy_rounded, size: 54, color: AppTheme.outlineVariant.withAlpha(150)),
                        const SizedBox(height: 12),
                        const Text(
                          'Tidak Ada Jadwal Ditemukan',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.onSurface),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Coba ubah kata kunci pencarian atau tambah jadwal khutbah baru.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  // Schedule Items List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _filteredSchedules.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final item = _filteredSchedules[index];
                      final bool isCompleted = item['status'] == 'Selesai';

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                          border: Border.all(
                            color: item['isUrgent'] == true && !isCompleted
                                ? AppTheme.primaryContainer.withAlpha(80)
                                : AppTheme.outlineVariant.withAlpha(60),
                            width: item['isUrgent'] == true && !isCompleted ? 1.5 : 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(6),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header Row: Category Badge & Status Badge
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: isCompleted
                                            ? Colors.grey.withAlpha(30)
                                            : AppTheme.primaryContainer.withAlpha(18),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        item['category'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: isCompleted ? Colors.grey : AppTheme.primaryContainer,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: isCompleted
                                              ? Colors.green.withAlpha(25)
                                              : AppTheme.secondaryContainer.withAlpha(25),
                                          borderRadius: BorderRadius.circular(100),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              isCompleted ? Icons.check_circle_rounded : Icons.schedule_rounded,
                                              size: 12,
                                              color: isCompleted ? Colors.green : AppTheme.secondaryContainer,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              item['status'],
                                              style: TextStyle(
                                                color: isCompleted ? Colors.green : AppTheme.secondaryContainer,
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        icon: const Icon(Icons.more_vert_rounded, size: 18, color: AppTheme.outline),
                                        onSelected: (action) {
                                          if (action == 'toggle') {
                                            setState(() {
                                              item['status'] = isCompleted ? 'Mendatang' : 'Selesai';
                                            });
                                          } else if (action == 'delete') {
                                            setState(() {
                                              _schedules.removeWhere((s) => s['id'] == item['id']);
                                            });
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Jadwal dihapus')),
                                            );
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            value: 'toggle',
                                            child: Text(isCompleted ? 'Tandai Belum Selesai' : 'Tandai Selesai'),
                                          ),
                                          const PopupMenuItem(
                                            value: 'delete',
                                            child: Text('Hapus Jadwal', style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Title
                              Text(
                                item['title'],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isCompleted ? AppTheme.onSurfaceVariant : AppTheme.onSurface,
                                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // Masjid Name & Address
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.mosque_rounded, size: 16, color: AppTheme.primaryContainer),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['masjid'],
                                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.onSurface),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          item['location'],
                                          style: const TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Date & Time (Wrap for small screens)
                              Wrap(
                                spacing: 12,
                                runSpacing: 4,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.calendar_today_rounded, size: 14, color: AppTheme.secondary),
                                      const SizedBox(width: 6),
                                      Text(
                                        item['date'],
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.onSurface),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.access_time_rounded, size: 14, color: AppTheme.secondary),
                                      const SizedBox(width: 4),
                                      Text(
                                        item['time'],
                                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.onSurface),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Naskah Status Badge & Actions (Wrap to avoid overflow)
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceContainerLow,
                                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                                ),
                                child: Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 8,
                                  runSpacing: 6,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.description_outlined, size: 15, color: AppTheme.primaryContainer),
                                        const SizedBox(width: 6),
                                        Flexible(
                                          child: Text(
                                            item['naskah'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.primaryContainer),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextButton.icon(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Menghubungkan naskah untuk ${item['masjid']}'),
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.link_rounded, size: 14, color: AppTheme.primaryContainer),
                                      label: const Text('Kelola Naskah', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryContainer)),
                                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StickyScheduleTabDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyScheduleTabDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 54.0;

  @override
  double get minExtent => 54.0;

  @override
  bool shouldRebuild(covariant _StickyScheduleTabDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
