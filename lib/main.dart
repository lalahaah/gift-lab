import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'providers/theme/theme_provider.dart';

Future<void> main() async {
  // Flutter 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // EasyLocalization 초기화
  await EasyLocalization.ensureInitialized();

  // Firebase 초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // AdMob 초기화
  MobileAds.instance.initialize();

  runApp(
    // EasyLocalization으로 앱 래핑
    EasyLocalization(
      supportedLocales: const [
        Locale('ko'), // 한국어
        Locale('en'), // 영어
      ],
      path: 'assets/translations', // 번역 파일 경로
      fallbackLocale: const Locale('ko'), // 기본 언어: 한국어
      startLocale: const Locale('ko'), // 앱 시작 시 언어: 한국어
      child: const ProviderScope(child: GiftLabApp()),
    ),
  );
}

class GiftLabApp extends ConsumerWidget {
  const GiftLabApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    // 테마 초기화 (상태바/네비게이션바 스타일 설정)
    AppTheme.initialize(themeMode);

    return MaterialApp.router(
      title: 'app.title'.tr(),
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,

      // 테마 설정
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      // 지역 설장
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
