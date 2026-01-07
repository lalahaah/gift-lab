import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../providers/gift_analysis/gift_analysis_provider.dart';

/// Step 5: 피하고 싶은 선물이 있나요?
///
/// 제외하고 싶은 선물을 자유롭게 입력하는 페이지입니다.
class Step5ExclusionsPage extends ConsumerWidget {
  const Step5ExclusionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(giftAnalysisProvider.notifier);

    // TextField 컨트롤러는 상태 유지를 위해 StatefulWidget을 사용하는 것이 일반적이지만,
    // 간단한 구현을 위해 여기서는 생략하고 onChanged로 직접 업데이트합니다.
    // 실제로는 TextEditingController를 사용하고 초기값을 설정해야 합니다.

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 질문
          Text(
            'gift_analysis.step5_title'.tr(),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            'gift_analysis.step5_subtitle'.tr(),
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textGray),
          ),

          const SizedBox(height: AppSpacing.xl),

          // 텍스트 입력 필드
          _buildTextField(context, ref),

          const SizedBox(height: AppSpacing.m),

          // 팁
          Text(
            '입력하지 않고 넘어가셔도 괜찮아요',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textGray),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context, WidgetRef ref) {
    // 초기값을 가져오기 위해 Consumer 사용
    final initialValue = ref.watch(giftAnalysisProvider).exclusions;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: (value) {
          ref.read(giftAnalysisProvider.notifier).setExclusions(value);
        },
        maxLines: 5,
        maxLength: 200,
        decoration: InputDecoration(
          hintText: '예: 꽃다발은 싫어해요, 현금은 성의 없어 보여요, 이미 갖고 있는 향수는 제외해주세요',
          hintStyle: TextStyle(color: AppColors.gray400),
          contentPadding: const EdgeInsets.all(AppSpacing.l),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          counterText: '', // 글자수 카운터 숨김 (필요시 표시)
        ),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
