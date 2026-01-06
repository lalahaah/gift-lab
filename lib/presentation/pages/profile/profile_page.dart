import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/usage/usage_limit_provider.dart';
import '../../../providers/auth/auth_provider.dart';

/// 프로필 페이지
///
/// 게스트 모드와 로그인 모드에 따라 다른 UI를 표시합니다.
/// - 게스트: 로그인 유도 + 무료 사용 횟수 표시
/// - 로그인: 사용자 정보, 분석 이력, 기념일 등
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Firebase Auth 상태에서 로그인 여부 확인
    final isLoggedIn = ref.watch(isLoggedInProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('프로필')),
      body: SafeArea(
        // ignore: dead_code
        child: isLoggedIn
            ? _buildLoggedInView(context, ref)
            : _buildGuestView(context, ref),
      ),
    );
  }

  /// 게스트 모드 UI - 로그인 유도
  Widget _buildGuestView(BuildContext context, WidgetRef ref) {
    // UsageLimitProvider에서 실제 사용 횟수 가져오기
    final maxFreeCount = ref.watch(maxFreeCountProvider);
    final remainingCount = ref.watch(remainingFreeCountProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 프로필 아이콘
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                size: 50,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 24),

            // 게스트 안내
            Text(
              '로그인하고 더 많은 기능을 사용하세요',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // 무료 사용 횟수 표시
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    '무료 사용 가능 횟수',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$remainingCount / $maxFreeCount회',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // 로그인 버튼
            ElevatedButton(
              onPressed: () {
                // TODO: 로그인 페이지로 이동
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('로그인 기능은 다음 단계에서 구현됩니다')),
                );
              },
              child: const Text('로그인'),
            ),
            const SizedBox(height: 12),

            // 회원가입 버튼
            OutlinedButton(
              onPressed: () {
                // TODO: 회원가입 페이지로 이동
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('회원가입 기능은 다음 단계에서 구현됩니다')),
                );
              },
              child: const Text('회원가입'),
            ),

            const SizedBox(height: 32),

            // 로그인 혜택 안내
            _buildBenefitsList(context),
          ],
        ),
      ),
    );
  }

  /// 로그인 혜택 리스트
  Widget _buildBenefitsList(BuildContext context) {
    final benefits = ['무제한 선물 분석', '분석 이력 저장 및 관리', '기념일 관리', '맞춤 추천 서비스'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '로그인 후 이용 가능한 기능',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        const SizedBox(height: 12),
        ...benefits.map(
          (benefit) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(benefit, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 로그인 사용자 UI
  Widget _buildLoggedInView(BuildContext context, WidgetRef ref) {
    // TODO: 사용자 정보, 분석 이력, 기념일 등 표시
    return const Center(child: Text('로그인 사용자 프로필 (추후 구현)'));
  }
}
