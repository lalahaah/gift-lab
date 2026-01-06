import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color_schemes.dart';
import 'text_themes.dart';
import 'component_themes.dart';
import '../constants/app_colors.dart';

/// 기프트랩 디자인 시스템 - Light Theme
///
/// 모든 테마 요소를 통합한 Light ThemeData
class AppLightTheme {
  AppLightTheme._(); // Private constructor

  /// Light ThemeData
  static ThemeData get theme {
    return ThemeData(
      // 기본 설정
      useMaterial3: true,
      brightness: Brightness.light,

      // ColorScheme
      colorScheme: AppColorSchemes.lightColorScheme,

      // TextTheme (Google Fonts 적용)
      textTheme: AppTextThemes.lightTextTheme,

      // 기본 폰트 (Google Fonts - Noto Sans KR)
      fontFamily: GoogleFonts.notoSansKr().fontFamily,

      // Scaffold 배경색
      scaffoldBackgroundColor: AppColors.labGray,

      // AppBar
      appBarTheme: AppComponentThemes.appBarTheme,

      // 버튼 테마
      elevatedButtonTheme: AppComponentThemes.elevatedButtonTheme,
      outlinedButtonTheme: AppComponentThemes.outlinedButtonTheme,
      textButtonTheme: AppComponentThemes.textButtonTheme,

      // 입력 필드 테마
      inputDecorationTheme: AppComponentThemes.inputDecorationTheme,

      // 카드 테마
      cardTheme: AppComponentThemes.cardTheme,

      // Chip 테마
      chipTheme: AppComponentThemes.chipTheme,

      // BottomNavigationBar 테마
      bottomNavigationBarTheme: AppComponentThemes.bottomNavigationBarTheme,

      // FloatingActionButton 테마
      floatingActionButtonTheme: AppComponentThemes.floatingActionButtonTheme,

      // Divider 테마
      dividerTheme: DividerThemeData(
        color: AppColors.gray300,
        thickness: 1.0,
        space: 1.0,
      ),

      // Dialog 테마
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.pureWhite,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // SnackBar 테마
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textBlack,
        contentTextStyle: const TextStyle(
          color: AppColors.pureWhite,
          fontSize: 14.0,
          fontWeight: FontWeight.w400,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Progress Indicator 테마
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.labIndigo,
        linearTrackColor: AppColors.gray100,
      ),

      // Slider 테마
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.labIndigo,
        inactiveTrackColor: AppColors.gray100,
        thumbColor: AppColors.labIndigo,
        overlayColor: AppColors.labIndigo.withValues(alpha: 0.2),
        valueIndicatorColor: AppColors.labIndigo,
        valueIndicatorTextStyle: const TextStyle(
          color: AppColors.pureWhite,
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Switch 테마
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.pureWhite;
          }
          return AppColors.gray300;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.labIndigo;
          }
          return AppColors.gray100;
        }),
      ),

      // CheckBox 테마
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.labIndigo;
          }
          return AppColors.pureWhite;
        }),
        checkColor: WidgetStateProperty.all(AppColors.pureWhite),
        side: const BorderSide(color: AppColors.gray300, width: 2.0),
      ),

      // Radio 테마
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.labIndigo;
          }
          return AppColors.gray300;
        }),
      ),

      // Icon 테마
      iconTheme: const IconThemeData(color: AppColors.textBlack, size: 24.0),

      // SystemUiOverlayStyle (상태바, 네비게이션바)
      // Android/iOS 상단 상태바 스타일
    );
  }

  /// SystemUiOverlayStyle for Light Theme
  /// 상단 상태바와 하단 네비게이션바의 색상 및 아이콘 밝기 설정
  static SystemUiOverlayStyle get systemUiOverlayStyle {
    return const SystemUiOverlayStyle(
      // 상태바 (Status Bar)
      statusBarColor: Colors.transparent, // 투명
      statusBarIconBrightness: Brightness.dark, // 어두운 아이콘 (라이트 테마용)
      statusBarBrightness: Brightness.light, // iOS용
      // 네비게이션바 (Navigation Bar) - Android
      systemNavigationBarColor: AppColors.pureWhite,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: AppColors.gray300,
    );
  }
}
