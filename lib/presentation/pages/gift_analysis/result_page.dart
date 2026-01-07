import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/domain/models/gift_recommendation.dart';
import '../../../providers/auth/auth_provider.dart';
import '../../widgets/buttons/primary_button.dart';

/// 선물 분석 결과 페이지
class ResultPage extends ConsumerWidget {
  final List<GiftRecommendation> recommendations;

  const ResultPage({super.key, required this.recommendations});

  Future<void> _launchCoupangSearch(String keyword) async {
    final encodedKeyword = Uri.encodeComponent(keyword);
    // 쿠팡 검색 URL
    final url = Uri.parse(
      'https://www.coupang.com/np/search?q=$encodedKeyword',
    );

    // 외부 브라우저(또는 쿠팡 앱)로 열기
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final displayName =
        user?.displayName ?? user?.email?.split('@')[0] ?? 'Explorer';

    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'results.title'.tr(),
          style: const TextStyle(
            color: AppColors.textBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false, // 뒤로가기 숨김 (새로운 플로우 시작 유도)
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.textGray),
            onPressed: () => context.go('/'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 결과 헤더 메시지
            Text(
              '$displayName님을 위한\n맞춤 선물 추천입니다 🎁',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textBlack,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xl),

            // 추천 리스트
            ...recommendations.map((item) => _buildGiftCard(context, item)),

            const SizedBox(height: AppSpacing.l),

            // 다시 분석하기 버튼
            OutlinedButton(
              onPressed: () => context.go('/gift-analysis'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: AppColors.labIndigo),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                '다시 분석하기',
                style: TextStyle(
                  color: AppColors.labIndigo,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            // 홈으로 돌아가기 버튼
            TextButton(
              onPressed: () => context.go('/'),
              child: const Text(
                '홈으로 돌아가기',
                style: TextStyle(color: AppColors.textGray),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGiftCard(BuildContext context, GiftRecommendation item) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.l),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 상품 정보 영역
          Padding(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textBlack,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.mintSpark.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.priceRange,
                        style: const TextStyle(
                          color: AppColors.mintSpark,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.m),
                Text(
                  item.reason,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textGray,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),

          // 쿠팡 버튼 영역
          Container(
            color: AppColors.gray50,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.l,
              vertical: AppSpacing.m,
            ),
            child: PrimaryButton(
              text: '쿠팡에서 최저가 찾기',
              icon: Icons.search,
              onPressed: () => _launchCoupangSearch(item.searchKeyword),
            ),
          ),
        ],
      ),
    );
  }
}
