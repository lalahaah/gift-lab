import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// 기프트랩 디자인 시스템 - ColorScheme 정의
///
/// Flutter의 ColorScheme에 디자인 시스템 색상을 1:1 매핑
class AppColorSchemes {
  AppColorSchemes._(); // Private constructor

  /// Light ColorScheme
  ///
  /// 디자인 시스템의 색상을 Flutter ColorScheme에 매핑
  static final ColorScheme lightColorScheme = ColorScheme.light(
    // Primary Colors
    primary: AppColors.labIndigo, // 주요 버튼, 활성 상태
    onPrimary: AppColors.pureWhite, // Primary 위의 텍스트
    primaryContainer: AppColors.labIndigoLighten(0.9), // Primary의 밝은 버전
    onPrimaryContainer: AppColors.labIndigo, // PrimaryContainer 위의 텍스트
    // Secondary Colors
    secondary: AppColors.mintSpark, // 강조, 성공 메시지
    onSecondary: AppColors.pureWhite, // Secondary 위의 텍스트
    secondaryContainer: AppColors.mintSparkLighten(0.9), // Secondary의 밝은 버전
    onSecondaryContainer: AppColors.mintSpark, // SecondaryContainer 위의 텍스트
    // Error Colors
    error: AppColors.errorRed, // 에러 상태
    onError: AppColors.pureWhite, // Error 위의 텍스트
    errorContainer: const Color(0xFFFFDAD6), // Error의 밝은 버전
    onErrorContainer: const Color(0xFF93000A), // ErrorContainer 위의 텍스트
    // Surface Colors
    surface: AppColors.pureWhite, // 카드, 다이얼로그 배경
    onSurface: AppColors.textBlack, // Surface 위의 텍스트
    surfaceContainerHighest: AppColors.labGray, // 앱 전체 배경
    // Outline
    outline: AppColors.gray300, // Border, Divider
    outlineVariant: AppColors.gray100, // 희미한 Border
    // Shadow
    shadow: Colors.black.withValues(alpha: 0.1), // 그림자
    scrim: Colors.black.withValues(alpha: 0.5), // 오버레이, 모달 배경
    // Brightness
    brightness: Brightness.light,
  );

  /// ColorScheme에서 자주 사용하는 색상들에 대한 편의 메서드

  /// 텍스트 기본 색상 (제목)
  static Color get textPrimary => AppColors.textBlack;

  /// 텍스트 보조 색상 (본문, 설명)
  static Color get textSecondary => AppColors.textGray;

  /// 배경 색상 (앱 전체)
  static Color get background => AppColors.labGray;

  /// 카드 배경 색상
  static Color get cardBackground => AppColors.pureWhite;

  /// 비활성 색상
  static Color get disabled => AppColors.textGray.withValues(alpha: 0.5);

  /// Divider 색상
  static Color get divider => AppColors.gray300;
}
