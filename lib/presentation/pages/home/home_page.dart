import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../../providers/auth/auth_provider.dart';
import '../../widgets/buttons/primary_button.dart';

/// 홈 화면 - 선물 검색 시작 화면
///
/// 사용자가 선물 분석을 시작할 수 있는
/// 앱의 메인 진입점입니다.
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _loadBannerAd() {
    final adUnitId = Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/6300978111' // 테스트 banner ID
        : 'ca-app-pub-3940256099942544/2934735716';

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(isLoggedInProvider);

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
                _buildHeader(context, ref, isLoggedIn),
                const SizedBox(height: AppSpacing.xl),

                // 메인 CTA 카드
                _buildMainCard(context),
                const SizedBox(height: AppSpacing.l),

                // 빠른 액세스 영역 (로그인 시에만 표시)
                if (isLoggedIn) ...[
                  _buildQuickAccess(context, isLoggedIn),
                  const SizedBox(height: AppSpacing.l),
                ],

                // 하단 광고 영역
                _buildBannerAd(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBannerAd() {
    if (!_isBannerAdLoaded || _bannerAd == null) return const SizedBox.shrink();

    return Container(
      alignment: Alignment.center,
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }

  /// 헤더 영역 (환영 메시지 + 무료 사용 카운터)
  Widget _buildHeader(BuildContext context, WidgetRef ref, bool isLoggedIn) {
    final user = ref.watch(currentUserProvider);
    final displayName =
        user?.displayName ?? user?.email?.split('@')[0] ?? 'Explorer';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 환영 메시지
        Text(
          isLoggedIn
              ? 'home.welcome_user'.tr(namedArgs: {'name': displayName})
              : 'home.welcome_guest'.tr(),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textBlack,
          ),
        ),
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
