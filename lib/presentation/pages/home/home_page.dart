import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 홈 화면 - 선물 검색 시작 화면
///
/// 사용자가 선물 분석을 시작할 수 있는
/// 앱의 메인 진입점입니다.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('기프트랩')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 로고 또는 아이콘 영역 (추후 추가)
              const Icon(
                Icons.card_giftcard,
                size: 80,
                color: Color(0xFF4F46E5), // Lab Indigo
              ),
              const SizedBox(height: 32),

              // 메인 타이틀
              Text(
                '완벽한 선물을 찾아드려요',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // 서브 타이틀
              Text(
                'AI가 분석한 맞춤형 선물 추천\n입력 → 결과를 최단 경로로',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // CTA 버튼
              ElevatedButton(
                onPressed: () {
                  // TODO: 선물 분석 플로우 시작 (Step 1으로 이동)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('선물 분석 플로우는 다음 단계에서 구현됩니다')),
                  );
                },
                child: const Text('선물 분석 시작하기'),
              ),
              const SizedBox(height: 16),

              // 이전 결과 보기 버튼
              OutlinedButton(
                onPressed: () {
                  context.go('/results');
                },
                child: const Text('이전 결과 보기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
