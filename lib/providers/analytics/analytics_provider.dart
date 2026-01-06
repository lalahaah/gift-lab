import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Firebase Analytics 인스턴스 Provider
final firebaseAnalyticsProvider = Provider<FirebaseAnalytics>((ref) {
  return FirebaseAnalytics.instance;
});

/// Analytics Observer Provider (GoRouter와 함께 사용)
final analyticsObserverProvider = Provider<FirebaseAnalyticsObserver>((ref) {
  return FirebaseAnalyticsObserver(
    analytics: ref.watch(firebaseAnalyticsProvider),
  );
});

/// Analytics Service - 이벤트 로깅
class AnalyticsService {
  final FirebaseAnalytics _analytics;

  AnalyticsService(this._analytics);

  /// 화면 조회 이벤트
  Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    await _analytics.logScreenView(
      screenName: screenName,
      screenClass: screenClass,
    );
  }

  /// 선물 분석 시작 이벤트
  Future<void> logGiftAnalysisStart() async {
    await _analytics.logEvent(name: 'gift_analysis_start');
  }

  /// 선물 분석 완료 이벤트
  Future<void> logGiftAnalysisComplete({
    required String targetRelation,
    required String eventType,
  }) async {
    await _analytics.logEvent(
      name: 'gift_analysis_complete',
      parameters: {'target_relation': targetRelation, 'event_type': eventType},
    );
  }

  /// 로그인 이벤트
  Future<void> logLogin(String method) async {
    await _analytics.logLogin(loginMethod: method);
  }

  /// 회원가입 이벤트
  Future<void> logSignUp(String method) async {
    await _analytics.logSignUp(signUpMethod: method);
  }

  /// 사용자 속성 설정
  Future<void> setUserProperties({
    String? userId,
    Map<String, String>? properties,
  }) async {
    if (userId != null) {
      await _analytics.setUserId(id: userId);
    }
    if (properties != null) {
      for (final entry in properties.entries) {
        await _analytics.setUserProperty(name: entry.key, value: entry.value);
      }
    }
  }
}

/// Analytics Service Provider
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService(ref.watch(firebaseAnalyticsProvider));
});
