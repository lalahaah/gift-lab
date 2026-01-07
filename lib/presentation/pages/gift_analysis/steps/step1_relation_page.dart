import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../providers/gift_analysis/gift_analysis_provider.dart';
import '../../../widgets/chips/selectable_chip.dart';

/// Step 1: 누구에게 선물하나요?
///
/// 관계, 성별, 연령대를 선택하는 페이지입니다.
class Step1RelationPage extends ConsumerWidget {
  const Step1RelationPage({super.key});

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
            'gift_analysis.step1_title'.tr(),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            'gift_analysis.step1_subtitle'.tr(),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textGray),
          ),

          const SizedBox(height: AppSpacing.xl),

          // 관계 선택
          _buildSectionTitle(context, '관계'),
          const SizedBox(height: AppSpacing.m),
          _buildRelationButtons(context, state.relation, notifier),

          const SizedBox(height: AppSpacing.xl),

          // 성별 선택
          _buildSectionTitle(context, '성별'),
          const SizedBox(height: AppSpacing.m),
          _buildGenderChips(context, state.gender, notifier),

          const SizedBox(height: AppSpacing.xl),

          // 연령대 선택
          _buildSectionTitle(context, '연령대'),
          const SizedBox(height: AppSpacing.m),
          _buildAgeGroupChips(context, state.ageGroup, notifier),
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

  /// 관계 선택 버튼들 (큰 버튼 형태)
  Widget _buildRelationButtons(
    BuildContext context,
    String? selected,
    GiftAnalysisNotifier notifier,
  ) {
    final relations = [
      {'value': 'lover', 'label': '연인', 'icon': Icons.favorite},
      {'value': 'friend', 'label': '친구', 'icon': Icons.people},
      {'value': 'parent', 'label': '부모님', 'icon': Icons.family_restroom},
      {'value': 'colleague', 'label': '직장동료', 'icon': Icons.work},
      {'value': 'other', 'label': '기타', 'icon': Icons.more_horiz},
    ];

    return Column(
      children: relations.map((relation) {
        final value = relation['value'] as String;
        final label = relation['label'] as String;
        final icon = relation['icon'] as IconData;
        final isSelected = selected == value;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.m),
          child: InkWell(
            onTap: () => notifier.setRelation(value),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.l),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.labIndigo.withValues(alpha: 0.1)
                    : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? AppColors.labIndigo : AppColors.gray100,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.labIndigo
                          : AppColors.gray100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      color: isSelected ? Colors.white : AppColors.textGray,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.m),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isSelected
                          ? AppColors.labIndigo
                          : AppColors.textBlack,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// 성별 선택 칩들
  Widget _buildGenderChips(
    BuildContext context,
    String? selected,
    GiftAnalysisNotifier notifier,
  ) {
    final genders = [
      {'value': 'male', 'label': '남성'},
      {'value': 'female', 'label': '여성'},
      {'value': 'any', 'label': '무관'},
    ];

    return Wrap(
      spacing: AppSpacing.m,
      runSpacing: AppSpacing.m,
      children: genders.map((gender) {
        final value = gender['value'] as String;
        final label = gender['label'] as String;

        return SelectableChip(
          label: label,
          isSelected: selected == value,
          onTap: () => notifier.setGender(value),
        );
      }).toList(),
    );
  }

  /// 연령대 선택 칩들
  Widget _buildAgeGroupChips(
    BuildContext context,
    String? selected,
    GiftAnalysisNotifier notifier,
  ) {
    final ageGroups = [
      {'value': '10s', 'label': '10대'},
      {'value': '20s', 'label': '20대'},
      {'value': '30s', 'label': '30대'},
      {'value': '40s', 'label': '40대'},
      {'value': '50s+', 'label': '50대 이상'},
    ];

    return Wrap(
      spacing: AppSpacing.m,
      runSpacing: AppSpacing.m,
      children: ageGroups.map((age) {
        final value = age['value'] as String;
        final label = age['label'] as String;

        return SelectableChip(
          label: label,
          isSelected: selected == value,
          onTap: () => notifier.setAgeGroup(value),
        );
      }).toList(),
    );
  }
}
