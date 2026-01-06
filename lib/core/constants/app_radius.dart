import 'package:flutter/material.dart';

/// 기프트랩 디자인 시스템 - Border Radius 상수
///
/// 디자인 가이드: 기프트랩(Gift Lab) 디자인 시스템 가이드.rtf
/// 섹션: 5. UI 컴포넌트 (Component Library)
/// 특징: 부드러운 사각형으로 부드러움 인상
class AppRadius {
  AppRadius._(); // Private constructor

  // ===== Radius Values =====

  /// 버튼 Radius (12px)
  /// 용도: Primary Button, Secondary Button, TextField
  static const double button = 12.0;

  /// 카드 Radius (16px)
  /// 용도: Gift Card, 결과 카드
  static const double card = 16.0;

  /// 입력 필드 Radius (12px)
  /// 용도: TextField, Input components
  static const double input = 12.0;

  /// 칩 Radius (일반적으로 버튼과 동일)
  /// 용도: Selection Chips (MBTI, 키워드 태그 등)
  static const double chip = 12.0;

  // ===== BorderRadius Presets =====

  /// 버튼용 BorderRadius
  static BorderRadius get buttonRadius => BorderRadius.circular(button);

  /// 카드용 BorderRadius
  static BorderRadius get cardRadius => BorderRadius.circular(card);

  /// 입력 필드용 BorderRadius
  static BorderRadius get inputRadius => BorderRadius.circular(input);

  /// 칩용 BorderRadius
  static BorderRadius get chipRadius => BorderRadius.circular(chip);

  // ===== Radius Presets =====

  /// 버튼용 Radius
  static Radius get buttonRadiusValue => Radius.circular(button);

  /// 카드용 Radius
  static Radius get cardRadiusValue => Radius.circular(card);

  /// 입력 필드용 Radius
  static Radius get inputRadiusValue => Radius.circular(input);

  /// 칩용 Radius
  static Radius get chipRadiusValue => Radius.circular(chip);
}
