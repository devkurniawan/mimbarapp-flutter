import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _adhanNotify = true;
  bool _darkMode = false;
  bool _smartAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Settings',
          style: GoogleFonts.outfit(color: AppColors.primaryMid, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('General'),
            const SizedBox(height: 16),
            _buildSettingCard([
              _buildToggleItem(LucideIcons.bell, 'Adhan Notifications', _adhanNotify, (v) => setState(() => _adhanNotify = v)),
              _buildToggleItem(LucideIcons.moon, 'Dark Mode', _darkMode, (v) => setState(() => _darkMode = v)),
              _buildToggleItem(LucideIcons.zap, 'Smart Alerts', _smartAlerts, (v) => setState(() => _smartAlerts = v)),
            ]),
            const SizedBox(height: 32),
            _buildSectionHeader('Location'),
            const SizedBox(height: 16),
            _buildSettingCard([
              _buildNavigationItem(LucideIcons.mapPin, 'Current Location', 'Jakarta, Indonesia'),
              _buildNavigationItem(LucideIcons.globe, 'Calculation Method', 'Muslim World League'),
            ]),
            const SizedBox(height: 32),
            _buildSectionHeader('Support'),
            const SizedBox(height: 16),
            _buildSettingCard([
              _buildNavigationItem(LucideIcons.shield, 'Privacy Policy', ''),
              _buildNavigationItem(LucideIcons.fileText, 'Terms of Service', ''),
              _buildNavigationItem(LucideIcons.info, 'About App', 'v1.0.4'),
            ]),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'Antigravity Muslim App\nMade with ❤️ by Deepmind',
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(color: Colors.grey, fontSize: 12),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.primaryMid,
      ),
    );
  }

  Widget _buildSettingCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildToggleItem(IconData icon, String title, bool value, Function(bool) onChanged) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryMid, size: 22),
      title: Text(title, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeTrackColor: AppColors.accentGreen,
      ),
    );
  }

  Widget _buildNavigationItem(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryMid, size: 22),
      title: Text(title, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: subtitle.isNotEmpty ? Text(subtitle, style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey)) : null,
      trailing: const Icon(LucideIcons.chevronRight, size: 16, color: Colors.grey),
      onTap: () {},
    );
  }
}
