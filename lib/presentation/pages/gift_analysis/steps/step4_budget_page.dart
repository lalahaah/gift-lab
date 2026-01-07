import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../providers/gift_analysis/gift_analysis_provider.dart';
import '../../../widgets/inputs/budget_slider.dart';

/// Step 4: 예산은 어느 정도인가요?
///
/// 예산 범위를 설정하는 페이지입니다.
class Step4BudgetPage extends ConsumerWidget {
  const Step4BudgetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(giftAnalysisProvider);
    final notifier = ref.read(giftAnalysisProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 질문
          Text(
            'gift_analysis.step4_title'.tr(),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            'gift_analysis.step4_subtitle'.tr(),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textGray),
          ),

          const SizedBox(height: AppSpacing.xl),

          // 예산 슬라이더
          BudgetSlider(
            initialMinBudget: state.minBudget,
            initialMaxBudget: state.maxBudget,
            onBudgetChanged: (min, max) {
              notifier.setBudgetRange(min, max);
            },
          ),

          const SizedBox(height: AppSpacing.xl),

          // 안내 메시지
          Container(
            padding: const EdgeInsets.all(AppSpacing.l),
            decoration: BoxDecoration(
              color: AppColors.mintSpark.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.mintSpark.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.mintSpark,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: Text(
                    '선택하신 예산 범위 내에서 최적의 선물을 추천해드려요',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textBlack,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
