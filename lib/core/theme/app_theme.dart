import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'light_theme.dart';
import 'dark_theme.dart';

/// 기프트랩 디자인 시스템 - Theme Manager
///
/// 앱의 테마를 관리하는 중앙 클래스
/// 현재는 Light Theme만 지원
class AppTheme {
  AppTheme._(); // Private constructor

  /// Light Theme
  static ThemeData get lightTheme => AppLightTheme.theme;

  /// Dark Theme
  static ThemeData get darkTheme => AppDarkTheme.theme;

  /// 테마 초기화
  static void initialize(ThemeMode mode) {
    if (mode == ThemeMode.dark) {
      SystemChrome.setSystemUIOverlayStyle(AppDarkTheme.systemUiOverlayStyle);
    } else {
      SystemChrome.setSystemUIOverlayStyle(AppLightTheme.systemUiOverlayStyle);
    }
  }

  /// 테마 모드 (현재는 Light만 지원)
  static ThemeMode get themeMode => ThemeMode.light;

  /// 디자인 시스템 버전
  static const String version = '1.0.0';

  /// 디자인 시스템 정보
  static const Map<String, String> info = {
    'name': 'Gift Lab Design System',
    'version': version,
    'description': 'Rational Emotion, Focus on Content, Micro-Interaction',
    'primaryColor': 'Lab Indigo (#4F46E5)',
    'secondaryColor': 'Mint Spark (#10B981)',
    'typography': 'Pretendard (fallback: Noto Sans KR)',
  };

  /// 디자인 원칙
  static const List<String> designPrinciples = [
    'Rational Emotion (이성적인 감성)',
    'Focus on Content (콘텐츠 중심)',
    'Micro-Interaction (살아있는 반응)',
  ];
}
