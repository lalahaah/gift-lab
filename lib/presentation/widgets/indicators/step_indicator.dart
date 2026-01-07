import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

/// Step 진행 상태 인디케이터
///
/// 현재 단계와 전체 단계를 표시하며,
/// Progress bar 형태로 시각화합니다.
class StepIndicator extends StatelessWidget {
  /// 현재 단계 (1부터 시작)
  final int currentStep;

  /// 전체 단계 수
  final int totalSteps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    final progress = currentStep / totalSteps;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Step 숫자 표시
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Step $currentStep',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.labIndigo,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '$currentStep / $totalSteps',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textGray),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.m),

        // Progress bar
        Stack(
          children: [
            // 배경 트랙
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.gray100,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            // 진행 트랙
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                height: 6,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.labIndigo, AppColors.mintSpark],
                  ),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.labIndigo.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
