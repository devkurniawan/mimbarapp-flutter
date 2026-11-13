import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' as math;
import '../../../core/theme/app_theme.dart';

class QiblatScreen extends StatefulWidget {
  const QiblatScreen({super.key});

  @override
  State<QiblatScreen> createState() => _QiblatScreenState();
}

class _QiblatScreenState extends State<QiblatScreen> {
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.locationWhenInUse.request();
    setState(() {
      _hasPermission = status.isGranted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2D5A27),
              Color(0xFF1B4332),
              Color(0xFF0D1F18),
            ],
          ),
        ),
        child: SafeArea(
          child: _hasPermission
              ? StreamBuilder<QiblahDirection>(
                  stream: FlutterQiblah.qiblahStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.accentGreen));
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.white)));
                    }

                    final data = snapshot.data!;
                    return _buildContent(data);
                  },
                )
              : _buildPermissionDenied(),
        ),
      ),
    );
  }

  Widget _buildPermissionDenied() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.mapPinOff, color: Colors.white, size: 64),
          const SizedBox(height: 24),
          Text(
            'Location Permission Required',
            style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'We need your location to calculate the Qibla direction accurately.',
              textAlign: TextAlign.center,
              style: GoogleFonts.outfit(color: Colors.white70, fontSize: 14),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _checkPermission,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Allow Location'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(QiblahDirection data) {
    // Check if user is facing Qibla (within 5 degrees)
    final bool isFacingQibla = data.offset.abs() < 5;

    return Column(
      children: [
        // Custom Top Bar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(LucideIcons.chevronLeft, color: Colors.white),
                onPressed: () {},
              ),
              Text(
                'Qiblat',
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),

        const SizedBox(height: 20),

        Text(
          isFacingQibla ? 'You are facing the Kaaba' : 'Turn your phone to face the Kaaba',
          style: GoogleFonts.outfit(
            color: isFacingQibla ? AppColors.accentGreen : Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),

        const Spacer(),

        // Compass Section
        _CompassWidget(direction: data),

        const Spacer(),

        // Info Section
        Text(
          'The distance from the Kaaba -- km', // Distance requires geolocator separately
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: GoogleFonts.outfit(fontSize: 18, color: Colors.white),
            children: [
              const TextSpan(text: 'Qibla '),
              TextSpan(
                text: '${data.qiblah.toStringAsFixed(0)}°',
                style: GoogleFonts.outfit(
                  color: AppColors.accentGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),

        // Instructions
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'Please keep your phone horizontally and metallic cases or magnetic closure may cause interferences',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 12,
            ),
          ),
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}

class _CompassWidget extends StatelessWidget {
  final QiblahDirection direction;

  const _CompassWidget({required this.direction});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Glow Effect
        Container(
          width: 320,
          height: 320,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: (direction.offset.abs() < 5 ? AppColors.accentGreen : Colors.white).withValues(alpha: 0.1),
                blurRadius: 60,
                spreadRadius: 10,
              ),
            ],
          ),
        ),

        // Rotating Compass Face
        Transform.rotate(
          angle: (direction.direction * (math.pi / 180) * -1),
          child: SizedBox(
            width: 300,
            height: 300,
            child: CustomPaint(
              painter: _CompassPainter(qiblahAngle: direction.qiblah),
            ),
          ),
        ),

        // Fixed Needle (Points to the top of the phone)
        // Or we can rotate the needle by the offset to point to Qibla relative to the phone
        Transform.rotate(
          angle: (direction.offset * (math.pi / 180) * -1),
          child: SizedBox(
            width: 220,
            height: 220,
            child: CustomPaint(
              painter: _NeedlePainter(),
            ),
          ),
        ),
        
        // Marker for Kaaba (Relative to the compass face)
        // Actually it's easier to draw it in the CompassPainter
      ],
    );
  }
}

class _CompassPainter extends CustomPainter {
  final double qiblahAngle;

  _CompassPainter({required this.qiblahAngle});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer Ring (Gold/Bronze)
    final outerPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFD4AF37), Color(0xFF8B732A), Color(0xFFD4AF37)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15;
    canvas.drawCircle(center, radius - 7.5, outerPaint);

    // Inner Dark Face
    final facePaint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius - 15, facePaint);

    // Degree Ticks
    final tickPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..strokeWidth = 1;

    for (int i = 0; i < 360; i += 2) {
      final double angle = (i - 90) * math.pi / 180;
      final double tickLength = i % 10 == 0 ? 15 : 8;
      final start = Offset(
        center.dx + (radius - 15) * math.cos(angle),
        center.dy + (radius - 15) * math.sin(angle),
      );
      final end = Offset(
        center.dx + (radius - 15 - tickLength) * math.cos(angle),
        center.dy + (radius - 15 - tickLength) * math.sin(angle),
      );
      canvas.drawLine(start, end, tickPaint);

      // Numbers
      if (i % 30 == 0) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: '$i',
            style: GoogleFonts.outfit(color: Colors.white, fontSize: 10),
          ),
          textDirection: TextDirection.ltr,
        )..layout();

        final numberRadius = radius - 40;
        canvas.save();
        canvas.translate(
          center.dx + numberRadius * math.cos(angle),
          center.dy + numberRadius * math.sin(angle),
        );
        canvas.rotate(angle + math.pi / 2);
        textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
        canvas.restore();
      }
    }

    // Cardinal Points
    _drawCardinal(canvas, center, radius, 'N', -math.pi / 2);
    _drawCardinal(canvas, center, radius, 'E', 0);
    _drawCardinal(canvas, center, radius, 'S', math.pi / 2);
    _drawCardinal(canvas, center, radius, 'W', math.pi);
    
    // Draw Kaaba icon on the compass face at qiblahAngle
    final qAngle = (qiblahAngle - 90) * math.pi / 180;
    final markerPos = Offset(
      center.dx + (radius - 15) * math.cos(qAngle),
      center.dy + (radius - 15) * math.sin(qAngle),
    );
    
    final markerPaint = Paint()..color = Colors.yellow[700]!;
    canvas.drawCircle(markerPos, 12, markerPaint);
    
    // Draw simple Kaaba silhouette in marker
    final rect = Rect.fromCenter(center: markerPos, width: 12, height: 12);
    canvas.drawRect(rect, Paint()..color = Colors.black);
    canvas.drawRect(Rect.fromLTWH(rect.left, rect.top + 2, rect.width, 2), Paint()..color = Colors.yellow[700]!);
  }

  void _drawCardinal(Canvas canvas, Offset center, double radius, String label, double angle) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: GoogleFonts.outfit(
          color: label == 'N' ? Colors.red : Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final pRadius = radius - 70;
    canvas.save();
    canvas.translate(
      center.dx + pRadius * math.cos(angle),
      center.dy + pRadius * math.sin(angle),
    );
    textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class _NeedlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final length = size.width / 2 - 10;

    final paint = Paint()..style = PaintingStyle.fill;

    // Pointer to Qibla (Top part)
    final path = Path();
    path.moveTo(center.dx, center.dy - length);
    path.lineTo(center.dx - 10, center.dy);
    path.lineTo(center.dx + 10, center.dy);
    path.close();
    canvas.drawPath(path, paint..color = AppColors.accentGreen);

    // Back part
    final path2 = Path();
    path2.moveTo(center.dx, center.dy + 40);
    path2.lineTo(center.dx - 8, center.dy);
    path2.lineTo(center.dx + 8, center.dy);
    path2.close();
    canvas.drawPath(path2, paint..color = Colors.white.withValues(alpha: 0.5));

    // Center Dot
    canvas.drawCircle(center, 5, Paint()..color = Colors.white);
    canvas.drawCircle(center, 3, Paint()..color = AppColors.primaryMid);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
