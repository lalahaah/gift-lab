import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/domain/models/gift_request.dart';
import '../../../core/domain/models/gift_recommendation.dart';
import '../../../core/services/ad_service.dart';
import '../../../core/services/gift_analysis_service.dart';
import '../../../core/services/firestore_service.dart';
import '../../../providers/auth/auth_provider.dart';
import 'result_page.dart';

/// 분석 진행 중 로딩 페이지
///
/// AI 분석 요청과 전면 광고 로드를 병렬로 수행합니다.
class LoadingPage extends ConsumerStatefulWidget {
  final GiftRequest request;

  const LoadingPage({super.key, required this.request});

  @override
  ConsumerState<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends ConsumerState<LoadingPage> {
  String _loadingMessage = '기프트랩 AI가 선물을 고르고 있어요...';
  late Timer _messageTimer;
  final List<String> _messages = [
    '받는 분의 취향을 분석하고 있어요...',
    '특별한 날에 어울리는 선물을 찾고 있어요...',
    '예산에 맞는 최적의 상품을 검색 중이에요...',
    '거의 다 찾았어요! 조금만 기다려주세요...',
  ];

  @override
  void initState() {
    super.initState();
    _startMessageRotation();
    _startAnalysisProcess();
  }

  @override
  void dispose() {
    _messageTimer.cancel();
    super.dispose();
  }

  void _startMessageRotation() {
    int index = 0;
    _messageTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _loadingMessage = _messages[index % _messages.length];
          index++;
        });
      }
    });
  }

  Future<void> _startAnalysisProcess() async {
    final adService = ref.read(adServiceProvider);
    final analysisService = ref.read(giftAnalysisServiceProvider);

    try {
      // 1. 광고 로드 시작 (비동기)
      final adLoadFuture = adService.loadInterstitialAd();

      // 2. 최소 로딩 시간 (3초)
      final minTimeFuture = Future.delayed(const Duration(seconds: 3));

      // 3. AI 분석 요청 (15초 타임아웃 추가)
      final analysisFuture = analysisService
          .getRecommendations(widget.request)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw TimeoutException('AI 분석 시간이 초과되었습니다. 다시 시도해주세요.');
            },
          );

      debugPrint('분석 프로세스 시작...');

      // 4. 병렬 대기
      final results = await Future.wait([
        minTimeFuture,
        analysisFuture,
        // 광고 로드는 오래 걸리면 건너뛰기
        adLoadFuture.timeout(const Duration(seconds: 5), onTimeout: () {}),
      ]);

      final recommendations = results[1] as List<GiftRecommendation>;
      debugPrint('AI 분석 완료: ${recommendations.length}개 추천됨');

      // 선물 추천 이력 저장 (비차단 방식으로 변경하여 UI 지연 방지)
      _saveHistoryInBackground(recommendations);

      if (!mounted) return;

      // 5. 광고 표시 시도
      adService.showInterstitialAd();

      // 6. 결과 페이지로 이동
      _navigateToResult(recommendations);
    } catch (e) {
      debugPrint('분석 중 에러 발생: $e');
      if (mounted) {
        String message = '오류가 발생했습니다. 다시 시도해주세요.';
        if (e is TimeoutException) {
          message = '연결 상태가 불안정하여 AI 분석이 중단되었습니다.';
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
        context.pop(); // 이전 화면으로 복귀
      }
    }
  }

  /// 백그라운드에서 히스토리 저장 (실패해도 흐름에 지장 없음)
  void _saveHistoryInBackground(List<GiftRecommendation> recommendations) {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    ref
        .read(firestoreServiceProvider)
        .saveGiftHistory(
          userId: user.uid,
          giftData: {
            'relation': widget.request.relation,
            'occasion': widget.request.occasion,
            'ageGroup': widget.request.ageGroup,
            'gender': widget.request.gender,
            'mbti': widget.request.mbti,
            'recommendations': recommendations
                .map(
                  (r) => {
                    'name': r.name,
                    'reason': r.reason,
                    'price_range': r.priceRange,
                    'image_url': r.imageUrl,
                    'search_keyword': r.searchKeyword,
                  },
                )
                .toList(),
          },
        )
        .catchError((e) {
          debugPrint('이력 백그라운드 저장 실패: $e');
        });
  }

  void _navigateToResult(List<GiftRecommendation> recommendations) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ResultPage(
          recommendations: recommendations,
          request: widget.request,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 로딩 인디케이터 (커스텀 or 기본)
            Container(
              width: 120,
              height: 120,
              padding: const EdgeInsets.all(AppSpacing.l),
              decoration: BoxDecoration(
                color: AppColors.labIndigo.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const CircularProgressIndicator(
                strokeWidth: 4,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.labIndigo),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // 로딩 메시지
            Text(
              _loadingMessage,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textBlack,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              '잠시만 기다려주세요',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textGray),
            ),
          ],
        ),
      ),
    );
  }
}
