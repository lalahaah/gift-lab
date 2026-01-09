import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_schemes.dart';
import 'text_themes.dart';
import 'component_themes.dart';
import '../constants/app_colors.dart';

/// 기프트랩 디자인 시스템 - Dark Theme
class AppDarkTheme {
  AppDarkTheme._();

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // darkColorScheme 정의가 필요함 (기존 color_schemes.dart에 추가 예정)
      colorScheme: AppColorSchemes.darkColorScheme,

      textTheme: AppTextThemes.darkTextTheme, // 전용 다크 테마 텍스트
      fontFamily: GoogleFonts.notoSansKr().fontFamily,

      scaffoldBackgroundColor: const Color(0xFF111827), // 전용 어두운 배경

      appBarTheme: AppComponentThemes.appBarTheme.copyWith(
        backgroundColor: const Color(0xFF111827),
        foregroundColor: Colors.white,
      ),

      elevatedButtonTheme: AppComponentThemes.elevatedButtonTheme,
      outlinedButtonTheme: AppComponentThemes.outlinedButtonTheme,
      textButtonTheme: AppComponentThemes.textButtonTheme,

      inputDecorationTheme: AppComponentThemes.inputDecorationTheme.copyWith(
        fillColor: Colors.white.withValues(alpha: 0.05),
      ),

      cardTheme: AppComponentThemes.cardTheme.copyWith(
        color: const Color(0xFF1F2937),
      ),

      bottomNavigationBarTheme: AppComponentThemes.bottomNavigationBarTheme
          .copyWith(
            backgroundColor: const Color(0xFF111827),
            unselectedItemColor: AppColors.gray400,
          ),

      dividerTheme: const DividerThemeData(
        color: Color(0xFF374151),
        thickness: 1.0,
      ),
    );
  }

  static SystemUiOverlayStyle get systemUiOverlayStyle {
    return const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFF111827),
      systemNavigationBarIconBrightness: Brightness.light,
    );
  }
}
