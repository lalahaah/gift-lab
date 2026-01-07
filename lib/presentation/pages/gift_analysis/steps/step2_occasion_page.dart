import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../providers/gift_analysis/gift_analysis_provider.dart';

/// Step 2: 어떤 날인가요?
///
/// 기념일 유형을 선택하는 페이지입니다.
class Step2OccasionPage extends ConsumerWidget {
  const Step2OccasionPage({super.key});

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
            'gift_analysis.step2_title'.tr(),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            'gift_analysis.step2_subtitle'.tr(),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textGray),
          ),

          const SizedBox(height: AppSpacing.xl),

          // 기념일 유형 그리드
          _buildOccasionGrid(context, state.occasion, notifier),
        ],
      ),
    );
  }

  /// 기념일 유형 그리드
  Widget _buildOccasionGrid(
    BuildContext context,
    String? selected,
    GiftAnalysisNotifier notifier,
  ) {
    final occasions = [
      {'value': 'birthday', 'label': '생일', 'icon': Icons.cake, 'emoji': '🎂'},
      {
        'value': 'housewarming',
        'label': '집들이',
        'icon': Icons.home,
        'emoji': '🏠',
      },
      {
        'value': 'anniversary',
        'label': '기념일',
        'icon': Icons.favorite,
        'emoji': '💕',
      },
      {
        'value': 'casual',
        'label': '가벼운 선물',
        'icon': Icons.card_giftcard,
        'emoji': '🎁',
      },
      {
        'value': 'apology',
        'label': '사과',
        'icon': Icons.volunteer_activism,
        'emoji': '🙏',
      },
      {
        'value': 'confession',
        'label': '고백',
        'icon': Icons.favorite_border,
        'emoji': '💌',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.m,
        mainAxisSpacing: AppSpacing.m,
        childAspectRatio: 1.1,
      ),
      itemCount: occasions.length,
      itemBuilder: (context, index) {
        final occasion = occasions[index];
        final value = occasion['value'] as String;
        final label = occasion['label'] as String;
        final emoji = occasion['emoji'] as String;
        final isSelected = selected == value;

        return InkWell(
          onTap: () => notifier.setOccasion(value),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.l),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.labIndigo.withValues(alpha: 0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.labIndigo : AppColors.gray100,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.labIndigo.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 이모지
                Text(emoji, style: const TextStyle(fontSize: 40)),
                const SizedBox(height: AppSpacing.m),
                // 라벨
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isSelected
                        ? AppColors.labIndigo
                        : AppColors.textBlack,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
