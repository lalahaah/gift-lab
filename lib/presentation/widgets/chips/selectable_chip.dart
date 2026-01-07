import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

/// 선택 가능한 칩 위젯
///
/// 단일 선택 또는 다중 선택 모드를 지원하며,
/// 디자인 시스템에 맞는 스타일을 적용합니다.
class SelectableChip extends StatelessWidget {
  /// 칩 라벨
  final String label;

  /// 선택 여부
  final bool isSelected;

  /// 탭 콜백
  final VoidCallback onTap;

  /// 아이콘 (선택사항)
  final IconData? icon;

  const SelectableChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.l,
          vertical: AppSpacing.m,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.labIndigo.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.labIndigo : AppColors.gray100,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: isSelected ? AppColors.labIndigo : AppColors.textGray,
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected ? AppColors.labIndigo : AppColors.textGray,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
