import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../providers/gift_analysis/gift_analysis_provider.dart';
import '../../../widgets/inputs/mbti_selector.dart';
import '../../../widgets/chips/selectable_chip.dart';

/// Step 3: 그 사람은 어떤 사람인가요?
///
/// MBTI와 성격 키워드를 선택하는 페이지입니다.
class Step3PersonalityPage extends ConsumerWidget {
  const Step3PersonalityPage({super.key});

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
            'gift_analysis.step3_title'.tr(),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            'gift_analysis.step3_subtitle'.tr(),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textGray),
          ),

          const SizedBox(height: AppSpacing.xl),

          // MBTI 선택
          _buildSectionTitle(context, 'MBTI'),
          const SizedBox(height: AppSpacing.m),
          MbtiSelector(
            initialMbti: state.mbti,
            initialUnknown: state.mbtiUnknown,
            onMbtiChanged: (mbti) => notifier.setMbti(mbti),
            onUnknownChanged: (unknown) => notifier.setMbtiUnknown(unknown),
          ),

          const SizedBox(height: AppSpacing.xl),

          // 성격 키워드 선택
          _buildSectionTitle(context, '성격 키워드 (선택사항)'),
          const SizedBox(height: AppSpacing.s),
          Text(
            '그 사람을 가장 잘 표현하는 키워드를 선택해주세요',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textGray),
          ),
          const SizedBox(height: AppSpacing.m),
          _buildPersonalityTags(context, state.personalityTags, notifier),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.textBlack,
      ),
    );
  }

  /// 성격 키워드 칩들
  Widget _buildPersonalityTags(
    BuildContext context,
    List<String> selectedTags,
    GiftAnalysisNotifier notifier,
  ) {
    final tags = [
      {'value': 'emotional', 'label': '감성적인'},
      {'value': 'practical', 'label': '실용적인'},
      {'value': 'otaku', 'label': '덕후 기질'},
      {'value': 'careful', 'label': '신중한'},
      {'value': 'spontaneous', 'label': '즉흥적인'},
      {'value': 'trendy', 'label': '트렌디한'},
      {'value': 'classic', 'label': '클래식한'},
      {'value': 'active', 'label': '활동적인'},
      {'value': 'calm', 'label': '차분한'},
      {'value': 'unique', 'label': '개성있는'},
      {'value': 'simple', 'label': '심플한'},
      {'value': 'luxury', 'label': '럭셔리한'},
    ];

    return Wrap(
      spacing: AppSpacing.m,
      runSpacing: AppSpacing.m,
      children: tags.map((tag) {
        final value = tag['value'] as String;
        final label = tag['label'] as String;

        return SelectableChip(
          label: label,
          isSelected: selectedTags.contains(value),
          onTap: () => notifier.togglePersonalityTag(value),
        );
      }).toList(),
    );
  }
}
