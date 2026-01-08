import 'package:go_router/go_router.dart';
import '../../presentation/core/main_scaffold.dart';
import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/results/results_page.dart';
import '../../presentation/pages/profile/profile_page.dart';
import '../../presentation/pages/settings/settings_page.dart';
import '../../presentation/pages/splash/splash_page.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/signup_page.dart';
import '../../presentation/pages/gift_analysis/gift_analysis_flow_page.dart';

/// 기프트랩 앱의 GoRouter 설정
///
/// ShellRoute를 사용하여 바텀 네비게이션을 유지하면서
/// 각 탭 간 전환을 구현합니다.
class AppRouter {
  AppRouter._(); // Private constructor

  /// GoRouter 인스턴스
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      // 기본 경로 리다이렉트
      GoRoute(path: '/', redirect: (context, state) => '/splash'),
      // 스플래시 페이지 (앱 시작 시 표시)
      GoRoute(
        path: '/splash',
        name: 'splash',
        pageBuilder: (context, state) =>
            NoTransitionPage(key: state.pageKey, child: const SplashPage()),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return MainScaffold(child: child);
        },
        routes: [
          // 홈 - 선물 검색 시작 화면
          GoRoute(
            path: '/home',
            name: 'home',
            pageBuilder: (context, state) =>
                NoTransitionPage(key: state.pageKey, child: const HomePage()),
          ),
          // 결과 - AI 추천 결과 리스트
          GoRoute(
            path: '/results',
            name: 'results',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ResultsPage(),
            ),
          ),
          // 프로필 - 사용자 정보 및 분석 이력
          GoRoute(
            path: '/profile',
            name: 'profile',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ProfilePage(),
            ),
          ),
          // 설정 - 앱 설정 및 정보
          GoRoute(
            path: '/settings',
            name: 'settings',
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const SettingsPage(),
            ),
          ),
        ],
      ),
      // 선물 분석 플로우 (바텀 네비게이션 숨김)
      GoRoute(
        path: '/gift-analysis',
        name: 'gift-analysis',
        builder: (context, state) => const GiftAnalysisFlowPage(),
      ),
      // 로그인 페이지
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      // 회원가입 페이지
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignUpPage(),
      ),
    ],
  );
}
