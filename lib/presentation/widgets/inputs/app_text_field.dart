import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';

/// 기프트랩 TextField
///
/// 디자인 가이드:
/// - Default: Gray 100 배경, Border 없음
/// - Focused: White 배경, Lab Indigo Border (2px)
/// - Radius: 12px
class AppTextField extends StatelessWidget {
  /// 라벨 텍스트
  final String? label;

  /// 힌트 텍스트
  final String? hint;

  /// TextField 초기값
  final String? initialValue;

  /// TextField Controller
  final TextEditingController? controller;

  /// 입력값 변경 콜백
  final ValueChanged<String>? onChanged;

  /// 입력 완료 콜백
  final ValueChanged<String>? onSubmitted;

  /// 유효성 검사 함수
  final String? Function(String?)? validator;

  /// 키보드 타입
  final TextInputType? keyboardType;

  /// 비밀번호 입력 여부
  final bool obscureText;

  /// 최대 줄 수
  final int? maxLines;

  /// 최대 길이
  final int? maxLength;

  /// FocusNode
  final FocusNode? focusNode;

  /// 에러 텍스트
  final String? errorText;

  /// 접두사 아이콘
  final Widget? prefixIcon;

  /// 접미사 아이콘
  final Widget? suffixIcon;

  /// 읽기 전용 여부
  final bool readOnly;

  /// 활성화 여부
  final bool enabled;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.maxLength,
    this.focusNode,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      maxLength: maxLength,
      readOnly: readOnly,
      enabled: enabled,
      style: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        color: AppColors.textBlack,
        letterSpacing: -0.1,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        // Default: Gray 100 배경
        fillColor: AppColors.gray100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.m,
        ),
        // Default: Border 없음
        border: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: BorderSide.none,
        ),
        // Focused: White 배경, Lab Indigo Border (2px)
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.inputRadius,
          borderSide: const BorderSide(color: AppColors.labIndigo, width: 2.0),
        ),
        // Error Border
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
          color: AppColors.textGray.withOpacity(0.6),
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
        ),
        // Error 스타일
        errorStyle: const TextStyle(
          color: AppColors.errorRed,
          fontSize: 12.0,
          fontWeight: FontWeight.w400,
        ),
        // Counter 제거
        counterText: '',
      ),
    );
  }
}
