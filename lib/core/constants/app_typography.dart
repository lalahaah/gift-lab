import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 기프트랩 디자인 시스템 - 타이포그래피 상수
///
/// 디자인 가이드: 기프트랩(Gift Lab) 디자인 시스템 가이드.rtf
/// 섹션: 3. 타이포그래피 (Typography)
/// 폰트: Noto Sans KR (Pretendard 대체, Google Fonts 제공)
class AppTypography {
  AppTypography._(); // Private constructor

  // ===== Display Styles (헤드라인) =====

  /// Display H1
  /// 크기: 24px, 굵기: Bold (700), 줄 높이: 1.4
  /// 용도: 메인 타이틀, 헤드라인
  static TextStyle get displayH1 => GoogleFonts.notoSansKr(
    fontSize: 24.0,
    fontWeight: FontWeight.w700, // Bold
    height: 1.4,
    letterSpacing: -0.3, // 한글 최적화를 위한 자간
  );

  /// Display H2
  /// 크기: 20px, 굵기: SemiBold (600), 줄 높이: 1.4
  /// 용도: 섹션 타이틀, 카드 상품명
  static TextStyle get displayH2 => GoogleFonts.notoSansKr(
    fontSize: 20.0,
    fontWeight: FontWeight.w600, // SemiBold
    height: 1.4,
    letterSpacing: -0.2,
  );

  // ===== Body Styles (본문) =====

  /// Body 1
  /// 크기: 16px, 굵기: Medium (500), 줄 높이: 1.5
  /// 용도: 본문, 입력 필드, 주요 버튼
  static TextStyle get body1 => GoogleFonts.notoSansKr(
    fontSize: 16.0,
    fontWeight: FontWeight.w500, // Medium
    height: 1.5,
    letterSpacing: -0.1,
  );

  /// Body 2
  /// 크기: 14px, 굵기: Regular (400), 줄 높이: 1.5
  /// 용도: 추천 이유, 보조 설명
  static TextStyle get body2 => GoogleFonts.notoSansKr(
    fontSize: 14.0,
    fontWeight: FontWeight.w400, // Regular
    height: 1.5,
    letterSpacing: 0.0,
  );

  // ===== Caption Style (하단 설명) =====

  /// Caption
  /// 크기: 12px, 굵기: Regular (400), 줄 높이: 1.2
  /// 용도: 하단 설명, 법적 고지
  static TextStyle get caption => GoogleFonts.notoSansKr(
    fontSize: 12.0,
    fontWeight: FontWeight.w400, // Regular
    height: 1.2,
    letterSpacing: 0.0,
  );

  // ===== Button Styles =====

  /// 버튼 텍스트 (Primary Button)
  /// Body 1을 기반으로 함
  static TextStyle get button => GoogleFonts.notoSansKr(
    fontSize: 16.0,
    fontWeight: FontWeight.w600, // SemiBold for emphasis
    height: 1.0,
    letterSpacing: -0.1,
  );

  // ===== Utility Methods =====

  /// 특정 색상을 적용한 Display H1 스타일 반환
  static TextStyle displayH1WithColor(Color color) {
    return displayH1.copyWith(color: color);
  }

  /// 특정 색상을 적용한 Display H2 스타일 반환
  static TextStyle displayH2WithColor(Color color) {
    return displayH2.copyWith(color: color);
  }

  /// 특정 색상을 적용한 Body 1 스타일 반환
  static TextStyle body1WithColor(Color color) {
    return body1.copyWith(color: color);
  }

  /// 특정 색상을 적용한 Body 2 스타일 반환
  static TextStyle body2WithColor(Color color) {
    return body2.copyWith(color: color);
  }

  /// 특정 색상을 적용한 Caption 스타일 반환
  static TextStyle captionWithColor(Color color) {
    return caption.copyWith(color: color);
  }

  /// 기본 폰트 패밀리 이름 (Google Fonts TextTheme 용)
  static String get fontFamily => GoogleFonts.notoSansKr().fontFamily!;
}
