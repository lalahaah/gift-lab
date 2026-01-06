import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

Future<void> main() async {
  // Flutter 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase 초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 테마 초기화 (상태바/네비게이션바 스타일 설정)
  AppTheme.initialize();

  runApp(
    // Riverpod ProviderScope로 앱 래핑
    const ProviderScope(child: GiftLabApp()),
  );
}

class GiftLabApp extends StatelessWidget {
  const GiftLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Gift Lab',
      debugShowCheckedModeBanner: false,

      // 디자인 시스템 테마 적용
      theme: AppTheme.lightTheme,
      themeMode: AppTheme.themeMode,

      // GoRouter 설정
      routerConfig: AppRouter.router,
    );
  }
}
