import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../providers/auth/auth_provider.dart';
import '../../../providers/usage/usage_limit_provider.dart';
import '../../widgets/buttons/primary_button.dart';

/// 홈 화면 - 선물 검색 시작 화면
///
/// 사용자가 선물 분석을 시작할 수 있는
/// 앱의 메인 진입점입니다.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final remainingCount = ref.watch(remainingFreeCountProvider);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.labIndigo.withValues(alpha: 0.05),
              AppColors.mintSpark.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 헤더 영역
                _buildHeader(context, isLoggedIn, remainingCount),
                const SizedBox(height: AppSpacing.xl),

                // 메인 CTA 카드
                _buildMainCard(context),
                const SizedBox(height: AppSpacing.l),

                // 빠른 액세스 영역
                _buildQuickAccess(context, isLoggedIn),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 헤더 영역 (환영 메시지 + 무료 사용 카운터)
  Widget _buildHeader(
    BuildContext context,
    bool isLoggedIn,
    int remainingCount,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 환영 메시지
        Text(
          isLoggedIn ? 'home.welcome_user'.tr() : 'home.welcome_guest'.tr(),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),

        // 게스트 사용자: 무료 사용 카운터
        if (!isLoggedIn) ...[
          const SizedBox(height: AppSpacing.xs),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.m,
              vertical: AppSpacing.s,
            ),
            decoration: BoxDecoration(
              color: AppColors.mintSpark.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.mintSpark.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.stars, size: 16, color: AppColors.mintSpark),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  'home.free_analysis_left'.tr(
                    namedArgs: {'count': remainingCount.toString()},
                  ),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.mintSpark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  /// 메인 CTA 카드 (글래스모피즘 효과)
  Widget _buildMainCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.8),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.labIndigo.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // 아이콘
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.labIndigo, AppColors.mintSpark],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.labIndigo.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.card_giftcard_rounded,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppSpacing.l),

          // 메인 메시지
          Text(
            'home.main_message'.tr(),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textBlack,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.m),

          // 서브 메시지
          Text(
            'home.subtitle_guest'.tr(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textGray,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),

          // CTA 버튼
          PrimaryButton(
            text: 'home.start_analysis'.tr(),
            icon: Icons.auto_awesome,
            onPressed: () {
              // 선물 분석 플로우 시작
              context.push('/gift-analysis');
            },
          ),
        ],
      ),
    );
  }

  /// 빠른 액세스 영역
  Widget _buildQuickAccess(BuildContext context, bool isLoggedIn) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'home.quick_access'.tr(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textBlack,
          ),
        ),
        const SizedBox(height: AppSpacing.m),

        // 이전 결과 보기
        _buildQuickAccessCard(
          context,
          icon: Icons.history,
          title: 'home.view_results'.tr(),
          subtitle: 'results.empty_description'.tr(),
          onTap: () => context.go('/results'),
        ),

        // 로그인 사용자: 기념일 관리
        if (isLoggedIn) ...[
          const SizedBox(height: AppSpacing.m),
          _buildQuickAccessCard(
            context,
            icon: Icons.cake_outlined,
            title: 'home.manage_anniversaries'.tr(),
            subtitle: 'profile.guest_description'.tr(),
            onTap: () => context.go('/profile'),
          ),
        ],
      ],
    );
  }

  /// 빠른 액세스 카드
  Widget _buildQuickAccessCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.l),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.gray100, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.labIndigo.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.labIndigo, size: 24),
            ),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textBlack,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.textGray),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textGray),
          ],
        ),
      ),
    );
  }
}
