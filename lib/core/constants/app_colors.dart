import 'package:flutter/material.dart';

/// 기프트랩 디자인 시스템 - 색상 상수
///
/// 디자인 가이드: 기프트랩(Gift Lab) 디자인 시스템 가이드.rtf
/// 섹션: 2. 컬러 팔레트 (Color System)
class AppColors {
  AppColors._(); // Private constructor to prevent instantiation

  // ===== Primary Colors (브랜드 컬러) =====

  /// Lab Indigo (Primary)
  /// 사용: 주요 버튼, 활성 상태 아이콘, 진행바(Progress)
  /// 의미: 지능(AI), 신뢰, 전문성
  static const Color labIndigo = Color(0xFF4F46E5);

  /// Mint Spark (Secondary/Accent)
  /// 사용: 성공 메시지, 강조 텍스트("최적가"), 선택된 칩
  /// 의미: 해결, 발견, 긍정적 결과
  static const Color mintSpark = Color(0xFF10B981);

  // ===== Neutral Colors (배경 및 텍스트) =====

  /// Pure White (Surface)
  /// 사용: 카드 배경
  static const Color pureWhite = Color(0xFFFFFFFF);

  /// Lab Gray (Background)
  /// 사용: 앱 전체 배경 (차가운 톤의 옅은 회색)
  static const Color labGray = Color(0xFFF3F4F6);

  /// Text Black (Title)
  /// 사용: 제목, 가독성 최우선
  static const Color textBlack = Color(0xFF111827);

  /// Text Gray (Body)
  /// 사용: 설명글, 비활성 텍스트
  static const Color textGray = Color(0xFF6B7280);

  // ===== Semantic Colors (상태) =====

  /// Error Red
  /// 사용: 입력 오류, 경고
  static const Color errorRed = Color(0xFFEF4444);

  /// Kakao Yellow
  /// 사용: 카카오 공유 버튼 전용
  static const Color kakaoYellow = Color(0xFFFEE500);

  // ===== Additional Neutral Shades =====
  /// Gray 100 - TextField 기본 배경
  static const Color gray100 = Color(0xFFF3F4F6);

  /// Gray 300 - Unselected Chip Border
  static const Color gray300 = Color(0xFFD1D5DB);

  // ===== Utility Methods =====

  /// Lab Indigo의 밝기를 조절한 색상을 반환
  /// [lighten] 값이 클수록 더 밝아짐 (0.0 ~ 1.0)
  static Color labIndigoLighten(double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(labIndigo);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  /// Mint Spark의 밝기를 조절한 색상을 반환
  /// [lighten] 값이 클수록 더 밝아짐 (0.0 ~ 1.0)
  static Color mintSparkLighten(double amount) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(mintSpark);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }
}
