import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/screens/onboarding_screen.dart';
import 'setting_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Custom Header Banner with Deep Emerald Gradient
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 54, left: 24, right: 24, bottom: 48),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppTheme.primaryContainer,
                        AppTheme.primary,
                        Color(0xFF02281D),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Top Row: Title & Action
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Profil Khatib',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SettingScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.settings_outlined, color: Colors.white70),
                            tooltip: 'Pengaturan',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Avatar with Golden Accent Ring
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: AppTheme.secondaryContainer, width: 2.5),
                            ),
                            child: const CircleAvatar(
                              radius: 42,
                              backgroundColor: Colors.white12,
                              child: Text(
                                'AW',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: AppTheme.secondaryContainer,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.verified_rounded, size: 16, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Name & Badges
                      const Text(
                        'Ustadz Ahmad Wijaya, M.A.',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Dai & Khatib Terverifikasi • Masjid Raya Jakarta',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withAlpha(200),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Edit Profile Button Pill
                      InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(30),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withAlpha(50)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.edit_outlined, size: 14, color: Colors.white),
                              SizedBox(width: 6),
                              Text(
                                'Edit Profil',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Main Content Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  // Stat Cards Grid / Row
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                      border: Border.all(color: AppTheme.outlineVariant.withAlpha(60)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(10),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Expanded(child: _StatItem(label: 'Khutbah', value: '42', icon: Icons.menu_book_rounded)),
                        _buildVerticalDivider(),
                        const Expanded(child: _StatItem(label: 'Favorit', value: '18', icon: Icons.bookmark_added_rounded)),
                        _buildVerticalDivider(),
                        const Expanded(child: _StatItem(label: 'Jadwal', value: '3', icon: Icons.event_available_rounded)),
                        _buildVerticalDivider(),
                        const Expanded(child: _StatItem(label: 'Rating', value: '4.9 ★', icon: Icons.star_rounded, isHighlight: true)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Settings Group 1: Naskah & Teleprompter
                  _buildSettingsGroup('Preferensi Naskah & Mimbar', [
                    _SettingsTile(
                      icon: Icons.font_download_rounded,
                      title: 'Jenis Font Arab Naskah',
                      subtitle: 'Amiri (Tashkeel Optimized)',
                      trailingBadge: 'Amiri',
                    ),
                    _SettingsTile(
                      icon: Icons.format_size_rounded,
                      title: 'Ukuran Teks Default',
                      subtitle: '22 px (Sangat Jelas)',
                    ),
                    _SettingsTile(
                      icon: Icons.speed_rounded,
                      title: 'Kecepatan Auto-Scroll',
                      subtitle: 'Sedang (1.2x speed)',
                    ),
                  ]),

                  const SizedBox(height: 16),

                  // Settings Group 2: Tampilan & Aplikasi
                  _buildSettingsGroup('Tampilan & Pengaturan App', [
                    _SettingsTile(
                      icon: Icons.dark_mode_rounded,
                      title: 'Mode Gelap Mimbar',
                      subtitle: 'Mengurangi Silau Saat Di Mimbar',
                      trailingSwitch: false,
                    ),
                    _SettingsTile(
                      icon: Icons.notifications_active_rounded,
                      title: 'Pengingat Waktu Khutbah',
                      subtitle: 'H-1 Jam sebelum Shalat Jumat',
                      trailingSwitch: true,
                    ),
                    _SettingsTile(
                      icon: Icons.cloud_sync_rounded,
                      title: 'Sinkronisasi Cloud',
                      subtitle: 'Tersinkron dengan Akun Google',
                    ),
                  ]),

                  const SizedBox(height: 16),

                  // Settings Group 3: Bantuan & Komunitas
                  _buildSettingsGroup('Informasi & Bantuan', [
                    _SettingsTile(
                      icon: Icons.rocket_launch_rounded,
                      title: 'Panduan & Onboarding Aplikasi',
                      subtitle: 'Lihat pengenalan fitur & keunggulan Mimbar',
                      trailingBadge: 'Buka',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OnboardingScreen(),
                          ),
                        );
                      },
                    ),
                    _SettingsTile(
                      icon: Icons.menu_book_outlined,
                      title: 'Panduan & Adab Khatib',
                      subtitle: 'Tips rukun khutbah & penyampaian',
                    ),
                    _SettingsTile(
                      icon: Icons.share_rounded,
                      title: 'Bagikan Aplikasi Mimbar',
                      subtitle: 'Ajak sesama khatib menggunakan Mimbar',
                    ),
                    _SettingsTile(
                      icon: Icons.info_outline_rounded,
                      title: 'Tentang MimbarAPP',
                      subtitle: 'Versi 1.2.0 (Build Stable)',
                    ),
                  ]),

                  const SizedBox(height: 24),

                  // Logout Button
                  OutlinedButton.icon(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(color: Color(0xFFFECDD3)),
                      backgroundColor: const Color(0xFFFFF1F2),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                      ),
                    ),
                    icon: const Icon(Icons.logout_rounded, size: 20),
                    label: const Text(
                      'Keluar dari Akun',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 32,
      width: 1,
      color: AppTheme.outlineVariant.withAlpha(60),
    );
  }

  Widget _buildSettingsGroup(String header, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            header,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: AppTheme.onSurfaceVariant,
              letterSpacing: 0.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            border: Border.all(color: AppTheme.outlineVariant.withAlpha(60)),
          ),
          child: Column(
            children: List.generate(children.length, (index) {
              final isLast = index == children.length - 1;
              return Column(
                children: [
                  children[index],
                  if (!isLast)
                    Divider(
                      height: 1,
                      thickness: 1,
                      indent: 52,
                      endIndent: 16,
                      color: AppTheme.outlineVariant.withAlpha(30),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final bool isHighlight;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 18,
          color: isHighlight ? AppTheme.secondaryContainer : AppTheme.primaryContainer,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: isHighlight ? AppTheme.secondary : AppTheme.primaryContainer,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppTheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? trailingBadge;
  final bool? trailingSwitch;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailingBadge,
    this.trailingSwitch,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.primaryContainer.withAlpha(15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppTheme.primaryContainer, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: AppTheme.onBackground,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: const TextStyle(fontSize: 12, color: AppTheme.onSurfaceVariant),
            )
          : null,
      trailing: _buildTrailing(),
      onTap: onTap,
    );
  }

  Widget _buildTrailing() {
    if (trailingSwitch != null) {
      return Switch.adaptive(
        value: trailingSwitch!,
        activeTrackColor: AppTheme.primaryContainer,
        activeThumbColor: Colors.white,
        onChanged: (val) {},
      );
    }
    if (trailingBadge != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppTheme.secondaryContainer.withAlpha(30),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.secondaryContainer.withAlpha(80)),
        ),
        child: Text(
          trailingBadge!,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppTheme.secondary,
          ),
        ),
      );
    }
    return const Icon(Icons.chevron_right_rounded, size: 20, color: AppTheme.outline);
  }
}
