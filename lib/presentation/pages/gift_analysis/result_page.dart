import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/domain/models/gift_recommendation.dart';
import '../../../providers/auth/auth_provider.dart';
import '../../../providers/gift_analysis/gift_analysis_provider.dart';
import '../../widgets/buttons/primary_button.dart';

import '../../../core/domain/models/gift_request.dart';
import '../../../core/services/gift_analysis_service.dart';

/// 선물 분석 결과 페이지
class ResultPage extends ConsumerStatefulWidget {
  final List<GiftRecommendation> recommendations;
  final GiftRequest request;

  const ResultPage({
    super.key,
    required this.recommendations,
    required this.request,
  });

  @override
  ConsumerState<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends ConsumerState<ResultPage> {
  late List<GiftRecommendation> _displayedRecommendations;
  bool _isLoadingMore = false;
  int _moreClickCount = 0;

  @override
  void initState() {
    super.initState();
    _displayedRecommendations = List.from(widget.recommendations);
  }

  Future<void> _loadMoreRecommendations() async {
    final isLoggedIn = ref.read(isLoggedInProvider);
    final maxClicks = isLoggedIn ? 3 : 1;

    if (_moreClickCount >= maxClicks) {
      if (!isLoggedIn) {
        _showLoginRequiredDialog();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('더 이상 추천할 상품이 없어요.')));
      }
      return;
    }

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final analysisService = ref.read(giftAnalysisServiceProvider);
      // 기존 상품명 제외하고 새로운 추천 받기
      final excludeNames = _displayedRecommendations
          .map((r) => r.name)
          .toList();
      final newRecommendations = await analysisService.getRecommendations(
        widget.request,
        excludeNames: excludeNames,
      );

      if (mounted) {
        setState(() {
          _displayedRecommendations.addAll(newRecommendations);
          _moreClickCount++;
          _isLoadingMore = false;
        });
        // 새로운 상품으로 스크롤 유도 (선택 사항)
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('추천을 불러오지 못했습니다: $e')));
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  void _showLoginRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그인이 필요합니다'),
        content: const Text('회원가입/로그인하시면 더 많은 선물을 추천받을 수 있습니다!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.push('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.labIndigo,
            ),
            child: const Text('로그인하기', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

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
  Widget build(BuildContext context) {
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
            onPressed: () {
              ref.read(giftAnalysisProvider.notifier).reset();
              context.go('/home');
            },
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
            ..._displayedRecommendations.map(
              (item) => _buildGiftCard(context, item),
            ),

            const SizedBox(height: AppSpacing.m),

            // 다른 상품 더보기 버튼 (우측 하단 느낌을 위해 Align 사용)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: _isLoadingMore ? null : _loadMoreRecommendations,
                icon: _isLoadingMore
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(
                            AppColors.labIndigo,
                          ),
                        ),
                      )
                    : const Icon(Icons.add_circle_outline, size: 20),
                label: Text(
                  _isLoadingMore ? '불러오는 중...' : '다른 상품 더보기',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.labIndigo,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // 다시 분석하기 버튼
            OutlinedButton(
              onPressed: () {
                ref.read(giftAnalysisProvider.notifier).reset();
                context.go('/gift-analysis');
              },
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
              onPressed: () {
                ref.read(giftAnalysisProvider.notifier).reset();
                context.go('/home');
              },
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
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              color: AppColors.gray100,
              child: Image.network(
                // LoremFlickr를 사용하여 키워드별 고유 이미지를 가져옵니다.
                // lock 파라미터에 상품명의 해시값을 전달하여 3개 상품이 모두 다른 이미지가 나오도록 보장합니다.
                'https://loremflickr.com/800/450/${Uri.encodeComponent(item.imageUrl.isNotEmpty ? item.imageUrl : 'gift')},gift/all?lock=${item.name.hashCode}',
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.gray100,
                  child: const Icon(
                    Icons.card_giftcard,
                    size: 40,
                    color: AppColors.textGray,
                  ),
                ),
              ),
            ),
          ),

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
