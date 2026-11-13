import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _titleController = TextEditingController();
  final _arabicController = TextEditingController();
  final _contentController = TextEditingController();
  String _selectedCategory = 'Khutbah Jumat';
  int _estimatedDurationMinutes = 15;
  final bool _isAutoSaveEnabled = true;

  final List<String> _quickMuqaddimahTemplates = [
    'إنَّ الحَمْدَ للهِ نَحْمَدُهُ وَنَسْتَعِينُهُ وَنَسْتَغْفِرُهُ...',
    'الْحَمْدُ لِلَّهِ الَّذِي هَدَانَا لِهَٰذَا وَمَا كُنَّا لِنَهْتَدِيَ لَوْلَا أَنْ هَدَانَا اللَّهُ...',
    'أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ...',
  ];

  final List<String> _structureTags = [
    '+ Pembukaan',
    '+ Ayat Utama',
    '+ Khutbah I',
    '+ Doa / Penutup Khutbah I',
    '+ Khutbah II',
    '+ Doa Penutup',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _arabicController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _insertStructureTag(String tag) {
    final cleanTag = tag.replaceAll('+ ', '');
    final currentText = _contentController.text;
    final addition = '\n\n=== $cleanTag ===\n';
    _contentController.text = '$currentText$addition';
    _contentController.selection = TextSelection.fromPosition(
      TextPosition(offset: _contentController.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 16.0, bottom: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Penolong / Hero Card
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
                  color: AppTheme.primary.withAlpha(50),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  top: -20,
                  child: Icon(
                    Icons.auto_stories_rounded,
                    size: 140,
                    color: Colors.white.withAlpha(15),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                            ),
                            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 20),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Penyusun Khutbah',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(25),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _isAutoSaveEnabled ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
                                  color: Colors.white70,
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _isAutoSaveEnabled ? 'Tersimpan' : 'Draft',
                                  style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Susun naskah khutbah Anda dengan struktur lengkap, kutipan Al-Qur\'an/Hadits, dan estimasi durasi pembacaan secara intuitif.',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.45,
                          color: Colors.white.withAlpha(220),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Metadata Grid (Kategori, Sasaran Jamaah, Estimasi Waktu)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              border: Border.all(color: AppTheme.surfaceContainer),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(6),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.tune_rounded, size: 18, color: AppTheme.secondary),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Pengaturan & Meta Khutbah',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.onSurface),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    // Kategori Dropdown
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Kategori', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.outline)),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: AppTheme.background,
                              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                              border: Border.all(color: AppTheme.outlineVariant.withAlpha(60)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedCategory,
                                isExpanded: true,
                                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppTheme.primaryContainer),
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.onSurface),
                                items: ['Khutbah Jumat', 'Khutbah Idul Fitri', 'Khutbah Idul Adha', 'Khutbah Nikah', 'Tausiyah / Ceramah']
                                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => _selectedCategory = val);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Estimasi Durasi
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Estimasi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.outline)),
                          const SizedBox(height: 6),
                          Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: AppTheme.background,
                              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                              border: Border.all(color: AppTheme.outlineVariant.withAlpha(60)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.timer_outlined, size: 15, color: AppTheme.secondaryContainer),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      '$_estimatedDurationMinutes Menit',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.onSurface),
                                    ),
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
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Input Judul
          const Text('Judul Khutbah / Tema Utama', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.onBackground)),
          const SizedBox(height: 8),
          TextField(
            controller: _titleController,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: 'Contoh: Meneladani Sifat Amanah dan Kejujuran Rasulullah SAW',
              hintStyle: TextStyle(color: AppTheme.outline.withAlpha(140), fontWeight: FontWeight.normal, fontSize: 14),
              prefixIcon: const Icon(Icons.title_rounded, color: AppTheme.primaryContainer, size: 20),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                borderSide: BorderSide(color: AppTheme.outlineVariant.withAlpha(90)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                borderSide: const BorderSide(color: AppTheme.primaryContainer, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Arabic Muqaddimah Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.format_quote_rounded, size: 18, color: AppTheme.primaryContainer),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Muqaddimah & Ayat Arab',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.onBackground),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusXl)),
                    ),
                    builder: (context) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pilih Template Muqaddimah',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primary),
                            ),
                            const SizedBox(height: 4),
                            const Text('Pilih muqaddimah populer untuk langsung dimasukkan ke teks:', style: TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant)),
                            const SizedBox(height: 16),
                            ..._quickMuqaddimahTemplates.map((template) => Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                title: Text(template, textAlign: TextAlign.right, style: const TextStyle(fontSize: 16, height: 1.6)),
                                onTap: () {
                                  setState(() {
                                    _arabicController.text = template;
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                            )),
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: const Icon(Icons.bookmark_added_rounded, size: 15, color: AppTheme.secondaryContainer),
                label: const Text('Template', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.secondaryContainer)),
                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _arabicController,
            maxLines: 3,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 19, height: 1.8, fontWeight: FontWeight.w500, fontFamily: 'Roboto'),
            decoration: InputDecoration(
              hintText: 'أدْخِلْ النَّصَّ الْعَرَبِيَّ هُنَا...',
              hintStyle: TextStyle(color: AppTheme.outline.withAlpha(120), fontSize: 16),
              filled: true,
              fillColor: AppTheme.surfaceContainerLow.withAlpha(120),
              contentPadding: const EdgeInsets.all(16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                borderSide: BorderSide(color: AppTheme.primaryContainer.withAlpha(40)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                borderSide: const BorderSide(color: AppTheme.primaryContainer, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Main Editor Header & Quick Tags
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Isi Naskah Khutbah', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.onBackground)),
              Text(
                '${_contentController.text.split(' ').where((w) => w.isNotEmpty).length} Kata',
                style: const TextStyle(fontSize: 12, color: AppTheme.outline, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Quick Structure Insert Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            child: Row(
              children: _structureTags.map((tag) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
                  child: InkWell(
                    onTap: () => _insertStructureTag(tag),
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: AppTheme.primaryContainer.withAlpha(40)),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.primaryContainer),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 6),

          // Content Editor
          TextField(
            controller: _contentController,
            maxLines: 12,
            onChanged: (text) {
              final words = text.split(' ').where((w) => w.isNotEmpty).length;
              setState(() {
                _estimatedDurationMinutes = (words / 100).ceil().clamp(5, 45);
              });
            },
            style: const TextStyle(fontSize: 15, height: 1.65, color: AppTheme.onSurface),
            decoration: InputDecoration(
              hintText: 'Tuliskan poin-poin khutbah pertama, pengingat ketakwaan, hingga doa di khutbah kedua...',
              hintStyle: TextStyle(color: AppTheme.outline.withAlpha(140), fontSize: 14),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(16),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                borderSide: BorderSide(color: AppTheme.outlineVariant.withAlpha(90)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                borderSide: const BorderSide(color: AppTheme.primaryContainer, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Draf berhasil disimpan!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.save_as_rounded, size: 18, color: AppTheme.primaryContainer),
                  label: const Text(
                    'Simpan Draf',
                    style: TextStyle(color: AppTheme.primaryContainer, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusLg)),
                    side: const BorderSide(color: AppTheme.primaryContainer, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Khutbah berhasil diterbitkan & siap dibaca!'),
                        backgroundColor: AppTheme.primaryContainer,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.publish_rounded, size: 18, color: Colors.white),
                  label: const Text(
                    'Terbitkan',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppTheme.primaryContainer,
                    elevation: 3,
                    shadowColor: AppTheme.primaryContainer.withAlpha(80),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusLg)),
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

