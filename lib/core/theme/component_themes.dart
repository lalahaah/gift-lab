import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';

/// 기프트랩 디자인 시스템 - Component Themes
///
/// 버튼, TextField, Card 등 Flutter 컴포넌트의 테마 정의
class AppComponentThemes {
  AppComponentThemes._(); // Private constructor

  // ===== Elevated Button Theme =====
  /// Primary Button (CTA) 스타일
  static ElevatedButtonThemeData get elevatedButtonTheme {
    return ElevatedButtonThemeData(
      style:
          ElevatedButton.styleFrom(
            backgroundColor: AppColors.labIndigo, // 배경색
            foregroundColor: AppColors.pureWhite, // 텍스트 색상
            minimumSize: const Size(
              double.infinity,
              56,
            ), // 높이: 56px (Big & Bold)
            padding: AppSpacing.paddingHorizontalM,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.buttonRadius, // 12px
            ),
            elevation: 0, // 기본 elevation 없음
            shadowColor: AppColors.labIndigo.withValues(
              alpha: 0.3,
            ), // Shadow 색상
          ).copyWith(
            // Hover, Pressed 상태
            elevation: WidgetStateProperty.resolveWith<double>((
              Set<WidgetState> states,
            ) {
              if (states.contains(WidgetState.pressed)) {
                return 2;
              }
              if (states.contains(WidgetState.hovered)) {
                return 4;
              }
              return 0;
            }),
          ),
    );
  }

  // ===== Outlined Button Theme =====
  /// Secondary Button 스타일
  static OutlinedButtonThemeData get outlinedButtonTheme {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.labIndigo, // 텍스트 색상
        minimumSize: const Size(double.infinity, 56), // 높이: 56px
        padding: AppSpacing.paddingHorizontalM,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.buttonRadius, // 12px
        ),
        side: const BorderSide(
          color: AppColors.labIndigo, // Border 색상
          width: 1.5, // Border 두께
        ),
      ),
    );
  }

  // ===== Text Button Theme =====
  /// Text Button 스타일
  static TextButtonThemeData get textButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.labIndigo, // 텍스트 색상
        padding: AppSpacing.paddingHorizontalM,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.buttonRadius),
      ),
    );
  }

  // ===== Input Decoration Theme =====
  /// TextField 스타일
  static InputDecorationTheme get inputDecorationTheme {
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.gray100, // Default: Gray 100 배경
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.m,
      ),
      border: OutlineInputBorder(
        borderRadius: AppRadius.inputRadius, // 12px
        borderSide: BorderSide.none, // Border 없음
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: AppRadius.inputRadius,
        borderSide: BorderSide.none, // Border 없음
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadius.inputRadius,
        borderSide: const BorderSide(
          color: AppColors.labIndigo, // Focused: Lab Indigo Border (2px)
          width: 2.0,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: AppRadius.inputRadius,
        borderSide: const BorderSide(color: AppColors.errorRed, width: 2.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: AppRadius.inputRadius,
        borderSide: const BorderSide(color: AppColors.errorRed, width: 2.0),
      ),
      // Label 스타일
      labelStyle: const TextStyle(
        color: AppColors.textGray,
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
      ),
      floatingLabelStyle: const TextStyle(
        color: AppColors.labIndigo,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      ),
      // Hint 스타일
      hintStyle: TextStyle(
        color: AppColors.textGray.withValues(alpha: 0.6),
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
      ),
      // Error 스타일
      errorStyle: const TextStyle(
        color: AppColors.errorRed,
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  // ===== Card Theme =====
  /// Gift Card 스타일
  static CardThemeData get cardTheme {
    return CardThemeData(
      color: AppColors.pureWhite, // 카드 배경
      elevation: 1, // Low elevation (부드럽게 떠 있는 느낌)
      shadowColor: Colors.black.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.cardRadius, // 16px
      ),
      margin: EdgeInsets.zero, // 기본 마진 제거 (개별 지정)
    );
  }

  // ===== Chip Theme =====
  /// Selection Chips (MBTI, 키워드 태그 등) 스타일
  static ChipThemeData get chipTheme {
    return ChipThemeData(
      backgroundColor: AppColors.pureWhite, // Unselected 배경
      selectedColor: AppColors.labIndigoLighten(0.9), // Selected 배경
      labelStyle: const TextStyle(
        color: AppColors.textBlack,
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      ),
      secondaryLabelStyle: const TextStyle(
        color: AppColors.labIndigo,
        fontSize: 14.0,
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.s,
      ),
      side: const BorderSide(
        color: AppColors.gray300, // Unselected Border
        width: 1.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.chipRadius, // 12px
      ),
    );
  }

  // ===== App Bar Theme =====
  /// AppBar 스타일
  static AppBarTheme get appBarTheme {
    return const AppBarTheme(
      backgroundColor: AppColors.pureWhite,
      foregroundColor: AppColors.textBlack,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: AppColors.textBlack,
        letterSpacing: -0.2,
      ),
    );
  }

  // ===== Bottom Navigation Bar Theme =====
  /// BottomNavigationBar 스타일 (필요시 사용)
  static BottomNavigationBarThemeData get bottomNavigationBarTheme {
    return const BottomNavigationBarThemeData(
      backgroundColor: AppColors.pureWhite,
      selectedItemColor: AppColors.labIndigo,
      unselectedItemColor: AppColors.textGray,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    );
  }

  // ===== FloatingActionButton Theme =====
  /// FloatingActionButton 스타일 (필요시 사용)
  static FloatingActionButtonThemeData get floatingActionButtonTheme {
    return const FloatingActionButtonThemeData(
      backgroundColor: AppColors.labIndigo,
      foregroundColor: AppColors.pureWhite,
      elevation: 4,
    );
  }
}
