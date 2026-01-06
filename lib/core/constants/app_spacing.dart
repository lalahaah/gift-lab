import 'package:flutter/material.dart';

/// 기프트랩 디자인 시스템 - 간격 시스템
///
/// 디자인 가이드: 기프트랩(Gift Lab) 디자인 시스템 가이드.rtf
/// 섹션: 6. 레이아웃 및 간격 (Spacing System)
/// 기준: 4px 그리드
class AppSpacing {
  AppSpacing._(); // Private constructor

  // ===== Spacing Values (4px 그리드 기반) =====

  /// Extra Small (4px)
  /// 용도: 아주 가까운 요소
  static const double xs = 4.0;

  /// Small (8px)
  /// 용도: 텍스트와 라벨 사이
  static const double s = 8.0;

  /// Medium (16px)
  /// 용도: 컴포넌트 내부 패딩
  static const double m = 16.0;

  /// Large (20px)
  /// 용도: 화면 좌우 여백 (Safe Area)
  static const double l = 20.0;

  /// Extra Large (24px)
  /// 용도: 섹션 간 간격
  static const double xl = 24.0;

  /// Extra Extra Large (32px+)
  /// 용도: 큰 구분감
  static const double xxl = 32.0;

  // ===== EdgeInsets Presets =====

  /// 모든 방향 xs 패딩
  static const EdgeInsets paddingXS = EdgeInsets.all(xs);

  /// 모든 방향 s 패딩
  static const EdgeInsets paddingS = EdgeInsets.all(s);

  /// 모든 방향 m 패딩
  static const EdgeInsets paddingM = EdgeInsets.all(m);

  /// 모든 방향 l 패딩
  static const EdgeInsets paddingL = EdgeInsets.all(l);

  /// 모든 방향 xl 패딩
  static const EdgeInsets paddingXL = EdgeInsets.all(xl);

  /// 모든 방향 xxl 패딩
  static const EdgeInsets paddingXXL = EdgeInsets.all(xxl);

  /// 가로 방향만 l 패딩 (화면 좌우 여백)
  static const EdgeInsets paddingHorizontalL = EdgeInsets.symmetric(
    horizontal: l,
  );

  /// 가로 방향만 m 패딩
  static const EdgeInsets paddingHorizontalM = EdgeInsets.symmetric(
    horizontal: m,
  );

  /// 세로 방향만 m 패딩
  static const EdgeInsets paddingVerticalM = EdgeInsets.symmetric(vertical: m);

  /// 세로 방향만 xl 패딩
  static const EdgeInsets paddingVerticalXL = EdgeInsets.symmetric(
    vertical: xl,
  );

  // ===== SizedBox Presets =====

  /// xs 높이의 세로 간격
  static const SizedBox verticalSpaceXS = SizedBox(height: xs);

  /// s 높이의 세로 간격
  static const SizedBox verticalSpaceS = SizedBox(height: s);

  /// m 높이의 세로 간격
  static const SizedBox verticalSpaceM = SizedBox(height: m);

  /// l 높이의 세로 간격
  static const SizedBox verticalSpaceL = SizedBox(height: l);

  /// xl 높이의 세로 간격
  static const SizedBox verticalSpaceXL = SizedBox(height: xl);

  /// xxl 높이의 세로 간격
  static const SizedBox verticalSpaceXXL = SizedBox(height: xxl);

  /// xs 너비의 가로 간격
  static const SizedBox horizontalSpaceXS = SizedBox(width: xs);

  /// s 너비의 가로 간격
  static const SizedBox horizontalSpaceS = SizedBox(width: s);

  /// m 너비의 가로 간격
  static const SizedBox horizontalSpaceM = SizedBox(width: m);

  /// l 너비의 가로 간격
  static const SizedBox horizontalSpaceL = SizedBox(width: l);

  /// xl 너비의 가로 간격
  static const SizedBox horizontalSpaceXL = SizedBox(width: xl);
}
