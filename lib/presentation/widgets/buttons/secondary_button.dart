import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';

/// 기프트랩 Secondary Button (Outlined)
///
/// 디자인 가이드:
/// - Style: Outlined Border (1.5px)
/// - Border & Text: Lab Indigo
/// - Height: 56px
/// - Radius: 12px
class SecondaryButton extends StatelessWidget {
  /// 버튼 텍스트
  final String text;

  /// 버튼 클릭 이벤트
  final VoidCallback? onPressed;

  /// 버튼이 로딩 중인지 여부
  final bool isLoading;

  /// 버튼 너비 (기본값: double.infinity)
  final double? width;

  /// 버튼 아이콘 (선택사항)
  final IconData? icon;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.width,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 56.0,
      child: OutlinedButton(
        onPressed: isLoading ? null : _handlePressed,
        style:
            OutlinedButton.styleFrom(
              foregroundColor: AppColors.labIndigo,
              disabledForegroundColor: AppColors.textGray.withValues(
                alpha: 0.5,
              ),
              padding: AppSpacing.paddingHorizontalM,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.buttonRadius,
              ),
              side: const BorderSide(color: AppColors.labIndigo, width: 1.5),
            ).copyWith(
              side: WidgetStateProperty.resolveWith<BorderSide>((
                Set<WidgetState> states,
              ) {
                if (states.contains(WidgetState.disabled)) {
                  return BorderSide(
                    color: AppColors.textGray.withValues(alpha: 0.3),
                    width: 1.5,
                  );
                }
                return const BorderSide(color: AppColors.labIndigo, width: 1.5);
              }),
            ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.labIndigo,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.1,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _handlePressed() {
    // Haptic feedback (가벼운 탭 느낌)
    HapticFeedback.lightImpact();
    onPressed?.call();
  }
}
