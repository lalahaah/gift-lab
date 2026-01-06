import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';

/// 기프트랩 Selection Chip
///
/// 디자인 가이드:
/// - Unselected: White 배경, Gray 300 Border
/// - Selected: Lab Indigo Light 배경, Lab Indigo Border
/// - Radius: 12px
class AppSelectionChip extends StatelessWidget {
  /// 칩 라벨
  final String label;

  /// 선택 여부
  final bool isSelected;

  /// 선택 변경 콜백
  final ValueChanged<bool>? onSelected;

  /// 아이콘 (선택사항)
  final IconData? icon;

  const AppSelectionChip({
    super.key,
    required this.label,
    required this.isSelected,
    this.onSelected,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColors.labIndigo : AppColors.textGray,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? AppColors.labIndigo : AppColors.textBlack,
            ),
          ),
        ],
      ),
      selected: isSelected,
      onSelected: (value) {
        // Haptic feedback
        HapticFeedback.selectionClick();
        onSelected?.call(value);
      },
      backgroundColor: AppColors.pureWhite,
      selectedColor: AppColors.labIndigoLighten(0.9),
      side: BorderSide(
        color: isSelected ? AppColors.labIndigo : AppColors.gray300,
        width: isSelected ? 2.0 : 1.0,
      ),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.chipRadius),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.s,
      ),
      labelPadding: EdgeInsets.zero,
      showCheckmark: false,
    );
  }
}
