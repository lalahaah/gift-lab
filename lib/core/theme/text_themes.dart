import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_typography.dart';
import '../constants/app_colors.dart';

/// 기프트랩 디자인 시스템 - TextTheme 정의
///
/// Flutter의 TextTheme에 디자인 시스템 타이포그래피를 매핑
/// Google Fonts (Noto Sans KR) 사용
class AppTextThemes {
  AppTextThemes._(); // Private constructor

  /// Light TextTheme
  ///
  /// Material Design 3 TextTheme에 디자인 시스템 타이포그래피 매핑
  static TextTheme get lightTextTheme {
    return GoogleFonts.notoSansKrTextTheme(
      TextTheme(
        // Display Styles (가장 큰 텍스트)
        displayLarge: AppTypography.displayH1.copyWith(
          color: AppColors.textBlack,
        ),
        displayMedium: AppTypography.displayH2.copyWith(
          color: AppColors.textBlack,
        ),
        displaySmall: AppTypography.displayH2.copyWith(
          fontSize: 18.0,
          color: AppColors.textBlack,
        ),

        // Headline Styles (헤드라인)
        headlineLarge: AppTypography.displayH1.copyWith(
          color: AppColors.textBlack,
        ),
        headlineMedium: AppTypography.displayH2.copyWith(
          color: AppColors.textBlack,
        ),
        headlineSmall: AppTypography.body1.copyWith(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: AppColors.textBlack,
        ),

        // Title Styles (타이틀)
        titleLarge: AppTypography.displayH2.copyWith(
          color: AppColors.textBlack,
        ),
        titleMedium: AppTypography.body1.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textBlack,
        ),
        titleSmall: AppTypography.body2.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textBlack,
        ),

        // Body Styles (본문)
        bodyLarge: AppTypography.body1.copyWith(color: AppColors.textBlack),
        bodyMedium: AppTypography.body2.copyWith(color: AppColors.textBlack),
        bodySmall: AppTypography.caption.copyWith(color: AppColors.textGray),

        // Label Styles (라벨, 버튼)
        labelLarge: AppTypography.button.copyWith(color: AppColors.textBlack),
        labelMedium: AppTypography.body2.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textBlack,
        ),
        labelSmall: AppTypography.caption.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textGray,
        ),
      ),
    );
  }

  /// Dark TextTheme
  static TextTheme get darkTextTheme {
    return GoogleFonts.notoSansKrTextTheme(
      TextTheme(
        // Display Styles
        displayLarge: AppTypography.displayH1.copyWith(color: Colors.white),
        displayMedium: AppTypography.displayH2.copyWith(color: Colors.white),
        displaySmall: AppTypography.displayH2.copyWith(
          fontSize: 18.0,
          color: Colors.white,
        ),

        // Headline Styles
        headlineLarge: AppTypography.displayH1.copyWith(color: Colors.white),
        headlineMedium: AppTypography.displayH2.copyWith(color: Colors.white),
        headlineSmall: AppTypography.body1.copyWith(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),

        // Title Styles
        titleLarge: AppTypography.displayH2.copyWith(color: Colors.white),
        titleMedium: AppTypography.body1.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleSmall: AppTypography.body2.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),

        // Body Styles
        bodyLarge: AppTypography.body1.copyWith(color: Colors.white),
        bodyMedium: AppTypography.body2.copyWith(color: Colors.white),
        bodySmall: AppTypography.caption.copyWith(
          color: Colors.white.withValues(alpha: 0.7),
        ),

        // Label Styles
        labelLarge: AppTypography.button.copyWith(color: Colors.white),
        labelMedium: AppTypography.body2.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        labelSmall: AppTypography.caption.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.white.withValues(alpha: 0.7),
        ),
      ),
    );
  }

  /// Material Design 3 텍스트 역할별 스타일 가이드
  ///
  /// - displayLarge/Medium/Small: 큰 헤드라인, 히어로 텍스트
  /// - headlineLarge/Medium/Small: 페이지 제목, 섹션 헤더
  /// - titleLarge/Medium/Small: 카드 제목, 리스트 항목 제목
  /// - bodyLarge/Medium/Small: 본문 텍스트
  /// - labelLarge/Medium/Small: 버튼, 라벨, 작은 텍스트
}
