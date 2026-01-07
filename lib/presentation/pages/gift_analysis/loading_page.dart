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
      // 1. 광고 로드 시작 (비동기, 기다리지 않음)
      final adLoadFuture = adService.loadInterstitialAd();

      // 2. 최소 로딩 시간 (애니메이션 효과)
      final minTimeFuture = Future.delayed(const Duration(seconds: 3));

      // 3. AI 분석 요청
      final analysisFuture = analysisService.getRecommendations(widget.request);

      // 4. 모든 작업 병렬 대기 (광고 로드는 선택적이지만 여기선 편의상 같이 대기하거나, 타임아웃 둠)
      // 실제 UX: 분석이 빨리 끝나도 최소 3초는 보여줌.
      // 광고가 안 뜨더라도 분석 결과는 보여줘야 함.
      final results = await Future.wait([
        minTimeFuture,
        analysisFuture,
        // 광고 로드는 오래 걸리면 건너뛰기 위해 별도로 await하지 않고,
        // 분석 완료 시점에 로드 상태를 체크하는 게 낫지만,
        // 여기서는 간단히 분석 완료될 때까지 광고도 최대한 로드 기다림.
        adLoadFuture.timeout(const Duration(seconds: 5), onTimeout: () {}),
      ]);

      final recommendations = results[1] as List<GiftRecommendation>;

      if (!mounted) return;

      // 5. 광고 표시 시도
      final adShown = adService.showInterstitialAd();
      debugPrint('Ad shown: $adShown');

      // 6. 결과 페이지로 이동 (광고가 닫힌 후 이동은 AdService 콜백에서 처리해야 정확하지만,
      // 현재 구조상 광고가 모달로 뜨므로, 광고 표시 호출 직후 이동하면 광고 뒤에 결과 페이지가 깔림.
      // 전면 광고는 닫힐 때까지 await할 수 없으므로(show는 void/bool),
      // 보통은 화면 전환을 먼저 하고 광고를 띄우거나,
      // 현재 페이지에서 광고를 띄우고 닫히면 이동함.
      // 여기서는 "현재 페이지 유지 -> 광고 뜸 -> 광고 닫힘 -> 결과 페이지 이동" 흐름이 자연스러움.
      // 하지만 AdService의 콜백을 여기서 알 수 없으므로,
      // AdService를 수정하거나, 아니면 "결과 페이지로 먼저 이동하고 거기서 광고를 띄우는" 방식이 더 쉬움.
      // 또는 간단히: 광고가 표시되었으면 약간의 딜레이 후 이동(광고가 덮음), 아니면 즉시 이동.

      // 수정된 Plan: 결과 페이지로 이동하면서 결과를 넘겨줌.
      // 결과 페이지의 initState에서 광고를 띄우는 게 나을 수도?
      // 아니면 여기서 이동.

      // 여기서는 이동합니다. 광고가 떴다면 광고가 위에 덮일 것입니다.
      _navigateToResult(recommendations);
    } catch (e) {
      // 에러 처리
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('오류가 발생했습니다: $e')));
        context.pop(); // 이전 화면으로 복귀
      }
    }
  }

  void _navigateToResult(List<GiftRecommendation> recommendations) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ResultPage(recommendations: recommendations),
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
