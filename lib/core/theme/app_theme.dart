import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary Palette
  static const Color primaryDark = Color(0xFF003527);
  static const Color primaryMid = Color(0xFF064E3B);
  static const Color primaryLight = Color(0xFF1B4332);
  static const Color accentGreen = Color(0xFFB7D332);
  static const Color accentGold = Color(0xFFFE932C);
  static const Color goldDark = Color(0xFF904D00);

  // Background & Surfaces
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;
  static const Color surfaceContainer = Color(0xFFE6EEFF);

  // Typography & UI
  static const Color textWhite = Colors.white;
  static const Color textDark = Color(0xFF121C2A);
  static const Color textGrey = Color(0xFF757575);
  static const Color textMuted = Color(0xFF9E9E9E);

  // Badges & Accents
  static const Color tagAmberBg = Color(0xFFFEF3C7);
  static const Color tagAmberText = Color(0xFFB45309);
  static const Color tagAmberBorder = Color(0xFFF59E0B);
  static const Color tagInfoBg = Color(0xFFE0F2FE);
  static const Color tagInfoText = Color(0xFF0369A1);
  static const Color tagDarkBg = Color(0xFF334155);
  static const Color tagDarkText = Color(0xFF93C5FD);

  // Shadows & Glass
  static const Color glassWhite = Color(0x33FFFFFF);
  static const Color cardShadow = Color(0x0D000000);
}

class AppTheme {
  // Alias for backward compatibility with MimbarApp
  static const Color primary = AppColors.primaryDark;
  static const Color primaryContainer = AppColors.primaryMid;
  static const Color onPrimary = Colors.white;
  static const Color onPrimaryContainer = Color(0xFF80BEA6);

  static const Color secondary = AppColors.goldDark;
  static const Color secondaryContainer = AppColors.accentGold;
  static const Color onSecondary = Colors.white;
  static const Color onSecondaryContainer = Color(0xFF663500);

  static const Color tertiary = Color(0xFF442800);
  static const Color tertiaryContainer = Color(0xFF623C00);

  static const Color background = AppColors.backgroundLight;
  static const Color onBackground = AppColors.textDark;

  static const Color surface = Colors.white;
  static const Color surfaceContainer = Color(0xFFE6EEFF);
  static const Color surfaceContainerLow = Color(0xFFEFF4FF);
  static const Color onSurface = AppColors.textDark;
  static const Color onSurfaceVariant = Color(0xFF404944);

  static const Color outline = Color(0xFF707974);
  static const Color outlineVariant = Color(0xFFBFC9C3);

  // Tag Badge Colors
  static const Color tagAmberBg = AppColors.tagAmberBg;
  static const Color tagAmberText = AppColors.tagAmberText;
  static const Color tagAmberBorder = AppColors.tagAmberBorder;
  static const Color tagInfoBg = AppColors.tagInfoBg;
  static const Color tagInfoText = AppColors.tagInfoText;
  static const Color tagDarkBg = AppColors.tagDarkBg;
  static const Color tagDarkText = AppColors.tagDarkText;

  // Border Radius
  static const double radiusSm = 4.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;

  // Theme Data
  static ThemeData get lightTheme {
    final textTheme = GoogleFonts.outfitTextTheme().copyWith(
      displayLarge: GoogleFonts.outfit(
        color: AppColors.textWhite,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: GoogleFonts.outfit(
        color: AppColors.primaryDark,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryMid,
        primary: AppColors.primaryMid,
        secondary: AppColors.accentGold,
        surface: Colors.white,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.textDark),
        titleTextStyle: GoogleFonts.outfit(
          color: AppColors.textDark,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 1,
        shadowColor: Colors.black.withAlpha(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: AppColors.primaryMid,
        unselectedItemColor: Color(0xFF9E9E9E),
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),
    );
  }
}

