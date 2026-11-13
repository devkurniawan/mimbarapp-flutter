import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;
import '../../../core/theme/app_theme.dart';

enum TasbihTheme {
  classic,
  digital,
  modern,
}

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  int _count = 0;
  int _totalCount = 0;
  int _target = 33;
  TasbihTheme _currentTheme = TasbihTheme.classic;
  bool _hapticEnabled = true;

  void _increment() {
    if (_hapticEnabled) {
      HapticFeedback.mediumImpact();
    }
    setState(() {
      _count++;
      _totalCount++;
      if (_count > _target) {
        _count = 1;
        if (_hapticEnabled) {
          HapticFeedback.vibrate();
        }
      }
    });
  }

  void _reset() {
    setState(() {
      _count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF0F4F0),
      appBar: AppBar(
        backgroundColor: Colors.white.withValues(alpha: 0.1),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: AppColors.primaryMid),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Digital Tasbih',
          style: GoogleFonts.outfit(
            color: AppColors.primaryMid, 
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _hapticEnabled ? LucideIcons.vibrate : LucideIcons.vibrateOff, 
              color: AppColors.primaryMid,
              size: 20,
            ),
            onPressed: () => setState(() => _hapticEnabled = !_hapticEnabled),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.5,
            colors: [
              Colors.white,
              const Color(0xFFE8F0E8),
              const Color(0xFFDCE6DC),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildTotalStats(),
              Expanded(
                child: GestureDetector(
                  onTap: _increment,
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      padding: const EdgeInsets.all(20),
                      child: _buildMainCounter(),
                    ),
                  ),
                ),
              ),
              _buildControls(),
              _buildThemeSelector(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTotalStats() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
          ),
          child: Column(
            children: [
              Text(
                'Today\'s Progress',
                style: GoogleFonts.outfit(color: AppColors.primaryMid, fontSize: 13, letterSpacing: 1),
              ),
              const SizedBox(height: 4),
              Text(
                '$_totalCount',
                style: GoogleFonts.outfit(
                  color: AppColors.primaryMid,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainCounter() {
    switch (_currentTheme) {
      case TasbihTheme.digital:
        return _DigitalCounter(count: _count, target: _target);
      case TasbihTheme.modern:
        return _ModernCounter(count: _count, target: _target);
      case TasbihTheme.classic:
        return _ClassicCounter(count: _count, target: _target);
    }
  }

  Widget _buildControls() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 30, offset: const Offset(0, 10)),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Target Goal',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.primaryMid.withValues(alpha: 0.7)),
                      ),
                      Text(
                        'Select count',
                        style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  _TargetSelector(
                    currentTarget: _target,
                    onChanged: (val) => setState(() => _target = val),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Divider(color: Colors.white, thickness: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _ActionButton(
                    icon: LucideIcons.rotateCcw,
                    label: 'Reset Progress',
                    onTap: _reset,
                  ),
                  Icon(LucideIcons.moreHorizontal, color: AppColors.primaryMid.withValues(alpha: 0.3)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Choose Model',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _ThemeOption(
                label: 'Classic',
                icon: LucideIcons.circleDot,
                isActive: _currentTheme == TasbihTheme.classic,
                onTap: () => setState(() => _currentTheme = TasbihTheme.classic),
                color: const Color(0xFF8D6E63),
              ),
              _ThemeOption(
                label: 'Digital',
                icon: LucideIcons.layout,
                isActive: _currentTheme == TasbihTheme.digital,
                onTap: () => setState(() => _currentTheme = TasbihTheme.digital),
                color: const Color(0xFF455A64),
              ),
              _ThemeOption(
                label: 'Modern',
                icon: LucideIcons.aperture,
                isActive: _currentTheme == TasbihTheme.modern,
                onTap: () => setState(() => _currentTheme = TasbihTheme.modern),
                color: const Color(0xFF2D6A4F),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ClassicCounter extends StatelessWidget {
  final int count;
  final int target;

  const _ClassicCounter({required this.count, required this.target});

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.brown[50],
              border: Border.all(color: Colors.brown[200]!, width: 12),
              boxShadow: [
                BoxShadow(color: Colors.brown.withValues(alpha: 0.1), blurRadius: 25, spreadRadius: 8),
              ],
            ),
          ),
          // The string/rope connecting beads
          Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.brown[300]!.withValues(alpha: 0.5),
                width: 2,
              ),
            ),
          ),
          // Rotating beads simulation
          ...List.generate(20, (index) {
            final double angle = (index * 18 + (count * 5)) * 3.14 / 180;
            return Transform.translate(
              offset: Offset(130 * math.cos(angle), 130 * math.sin(angle)),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.brown[200]!,
                      Colors.brown[700]!,
                      Colors.brown[900]!,
                    ],
                    stops: const [0.1, 0.7, 1.0],
                    center: const Alignment(-0.3, -0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.4),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
              ),
            );
          }),
          // Tassel (Imam bead part)
          Transform.translate(
            offset: const Offset(0, 160),
            child: Column(
              children: [
                Container(
                  width: 24,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.brown[800],
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      colors: [Colors.brown[700]!, Colors.brown[900]!],
                    ),
                  ),
                ),
                Container(
                  width: 4,
                  height: 30,
                  color: Colors.brown[400],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (i) => Container(
                    width: 2,
                    height: 40,
                    margin: const EdgeInsets.symmetric(horizontal: 1),
                    decoration: BoxDecoration(
                      color: Colors.brown[600],
                      borderRadius: BorderRadius.circular(1),
                    ),
                  )),
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$count',
                style: GoogleFonts.outfit(
                  fontSize: 84, 
                  fontWeight: FontWeight.bold, 
                  color: Colors.brown[900],
                  shadows: [
                    Shadow(color: Colors.white.withValues(alpha: 0.5), offset: const Offset(2, 2), blurRadius: 4),
                  ],
                ),
              ),
              Text(
                '/ $target',
                style: GoogleFonts.outfit(fontSize: 22, color: Colors.brown[600], fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      );
  }
}

class _DigitalCounter extends StatelessWidget {
  final int count;
  final int target;

  const _DigitalCounter({required this.count, required this.target});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 320,
        height: 240,
        decoration: BoxDecoration(
          color: Colors.blueGrey[900],
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.blueGrey[700]!, width: 10),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 25, offset: const Offset(0, 12)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              count.toString().padLeft(4, '0'),
              style: GoogleFonts.shareTechMono(
                fontSize: 90,
                color: Colors.greenAccent,
                shadows: [
                  const Shadow(color: Colors.greenAccent, blurRadius: 10),
                ],
              ),
            ),
            Text(
              'TARGET: $target',
              style: GoogleFonts.shareTechMono(color: Colors.greenAccent.withValues(alpha: 0.5), fontSize: 16),
            ),
          ],
        ),
      );
  }
}

class _ModernCounter extends StatelessWidget {
  final int count;
  final int target;

  const _ModernCounter({required this.count, required this.target});

  @override
  Widget build(BuildContext context) {
    final progress = count / target;
    return Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 300,
            height: 300,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 18,
              backgroundColor: AppColors.accentGreen.withValues(alpha: 0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentGreen),
              strokeCap: StrokeCap.round,
            ),
          ),
          Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: AppColors.accentGreen.withValues(alpha: 0.2), blurRadius: 40, spreadRadius: 8),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$count',
                    style: GoogleFonts.outfit(fontSize: 84, fontWeight: FontWeight.bold, color: AppColors.primaryMid),
                  ),
                  Text(
                    'Goal: $target',
                    style: GoogleFonts.outfit(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: Colors.red[700]),
              const SizedBox(width: 8),
              Text(
                label, 
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold, 
                  color: Colors.red[700],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TargetSelector extends StatelessWidget {
  final int currentTarget;
  final Function(int) onChanged;

  const _TargetSelector({required this.currentTarget, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [33, 99, 100].map((val) {
          final isActive = currentTarget == val;
          return GestureDetector(
            onTap: () => onChanged(val),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isActive ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                boxShadow: isActive ? [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2)),
                ] : [],
              ),
              child: Text(
                '$val',
                style: GoogleFonts.outfit(
                  color: isActive ? AppColors.primaryMid : Colors.grey[600],
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color color;

  const _ThemeOption({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? color : Colors.white.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isActive ? color : Colors.white,
            width: 1.5,
          ),
          boxShadow: isActive ? [
            BoxShadow(
              color: color.withValues(alpha: 0.4), 
              blurRadius: 15, 
              offset: const Offset(0, 8),
            )
          ] : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon, 
              color: isActive ? Colors.white : color.withValues(alpha: 0.5),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.outfit(
                color: isActive ? Colors.white : color.withValues(alpha: 0.7),
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

