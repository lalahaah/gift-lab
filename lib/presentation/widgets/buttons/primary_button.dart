import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';

/// 기프트랩 Primary Button (CTA)
///
/// 디자인 가이드:
/// - Height: 56px (Big & Bold)
/// - Background: Lab Indigo
/// - Text: White
/// - Radius: 12px
/// - Shadow: BoxShadow(0, 4, 12, rgba(79, 70, 229, 0.3))
class PrimaryButton extends StatelessWidget {
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

  const PrimaryButton({
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
      child: ElevatedButton(
        onPressed: isLoading ? null : _handlePressed,
        style:
            ElevatedButton.styleFrom(
              backgroundColor: AppColors.labIndigo,
              foregroundColor: AppColors.pureWhite,
              disabledBackgroundColor: AppColors.textGray.withOpacity(0.3),
              disabledForegroundColor: AppColors.pureWhite,
              padding: AppSpacing.paddingHorizontalM,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.buttonRadius,
              ),
              elevation: 0,
              shadowColor: AppColors.labIndigo.withOpacity(0.3),
            ).copyWith(
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
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.pureWhite,
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
