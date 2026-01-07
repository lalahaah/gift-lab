import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/indicators/step_indicator.dart';
import '../../../../providers/gift_analysis/gift_analysis_provider.dart';
import 'steps/step1_relation_page.dart';
import 'steps/step2_occasion_page.dart';
import 'steps/step3_personality_page.dart';
import 'steps/step4_budget_page.dart';
import 'steps/step5_exclusions_page.dart';

/// 선물 분석 메인 플로우 페이지
///
/// 5단계 입력 폼을 PageView로 관리하며,
/// 단계별 진행 상태와 네비게이션을 담당합니다.
class GiftAnalysisFlowPage extends ConsumerStatefulWidget {
  const GiftAnalysisFlowPage({super.key});

  @override
  ConsumerState<GiftAnalysisFlowPage> createState() =>
      _GiftAnalysisFlowPageState();
}

class _GiftAnalysisFlowPageState extends ConsumerState<GiftAnalysisFlowPage> {
  final PageController _pageController = PageController();
  int _currentStep = 1;
  static const int _totalSteps = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps) {
      if (ref
          .read(giftAnalysisProvider.notifier)
          .canProceedToStep(_currentStep + 1)) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('common.required_fields'.tr())));
      }
    } else {
      _finishAnalysis();
    }
  }

  void _prevStep() {
    if (_currentStep > 1) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.pop();
    }
  }

  void _finishAnalysis() {
    // TODO: 분석 요청 로직 구현
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('분석을 시작합니다...')));
    // 임시로 결과 페이지로 이동 (나중에 로딩/광고 로직 추가 필요)
    context.go('/results');
  }

  bool _isNextEnabled() {
    final state = ref.watch(giftAnalysisProvider);
    switch (_currentStep) {
      case 1:
        return state.isStep1Valid;
      case 2:
        return state.isStep2Valid;
      case 3:
        return state.isStep3Valid;
      case 4:
        return state.isStep4Valid;
      case 5:
        return state.isStep5Valid;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _prevStep,
        ),
        title: Text(
          'gift_analysis.title'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // 초기화 후 닫기
              ref.read(giftAnalysisProvider.notifier).reset();
              context.pop();
            },
            child: Text(
              'common.close'.tr(),
              style: TextStyle(color: AppColors.textGray),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Step Indicator
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.l,
              vertical: AppSpacing.m,
            ),
            child: StepIndicator(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
            ),
          ),

          // PageView
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // 버튼으로만 이동
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index + 1;
                });
              },
              children: const [
                Step1RelationPage(),
                Step2OccasionPage(),
                Step3PersonalityPage(),
                Step4BudgetPage(),
                Step5ExclusionsPage(),
              ],
            ),
          ),

          // Bottom Navigation Buttons
          Container(
            padding: const EdgeInsets.all(AppSpacing.l),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: PrimaryButton(
                text: _currentStep == _totalSteps
                    ? '분석 시작하기'
                    : 'common.next'.tr(),
                onPressed: _isNextEnabled() ? _nextStep : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
