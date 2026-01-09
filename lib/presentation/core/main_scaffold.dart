import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

/// 메인 스캐폴드 - The following changes were made by the replace_file_content tool to:바텀 네비게이션 포함
class MainScaffold extends StatelessWidget {
  /// 현재 화면을 표시하는 자식 위젯
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // 현재 경로를 기반으로 선택된 탭 인덱스 계산
    int getCurrentIndex() {
      final String location = GoRouterState.of(context).uri.path;
      if (location.startsWith('/home')) return 0;
      if (location.startsWith('/stories')) return 1;
      if (location.startsWith('/profile')) return 2;
      if (location.startsWith('/settings')) return 3;
      return 0; // 기본값: 홈
    }

    // 탭 클릭 시 해당 라우트로 이동
    void onItemTapped(int index) {
      switch (index) {
        case 0:
          context.go('/home');
          break;
        case 1:
          context.go('/stories');
          break;
        case 2:
          context.go('/profile');
          break;
        case 3:
          context.go('/settings');
          break;
      }
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: getCurrentIndex(),
        onTap: onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: 'navigation.home'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.auto_stories_outlined),
            activeIcon: const Icon(Icons.auto_stories),
            label: 'navigation.stories'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: 'navigation.profile'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_outlined),
            activeIcon: const Icon(Icons.settings),
            label: 'navigation.settings'.tr(),
          ),
        ],
      ),
    );
  }
}
