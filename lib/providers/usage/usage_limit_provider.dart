import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 사용 제한 관리 Provider
///
/// 비로그인 사용자의 무료 분석 횟수를 추적합니다.
/// 최대 10회까지 무료로 사용 가능하며, 초과 시 로그인을 유도합니다.

const int _maxFreeUsageCount = 10;
const String _usageCountKey = 'analysis_usage_count';

/// 현재 사용 횟수 Provider
final usageCountProvider = StateNotifierProvider<UsageCountNotifier, int>((
  ref,
) {
  return UsageCountNotifier();
});

class UsageCountNotifier extends StateNotifier<int> {
  UsageCountNotifier() : super(0) {
    _loadUsageCount();
  }

  SharedPreferences? _prefs;

  /// SharedPreferences에서 사용 횟수 로드
  Future<void> _loadUsageCount() async {
    _prefs = await SharedPreferences.getInstance();
    state = _prefs?.getInt(_usageCountKey) ?? 0;
  }

  /// 분석 횟수 증가
  Future<void> incrementUsage() async {
    _prefs ??= await SharedPreferences.getInstance();
    state++;
    await _prefs!.setInt(_usageCountKey, state);
  }

  /// 사용 횟수 초기화 (로그인 시)
  Future<void> resetUsage() async {
    _prefs ??= await SharedPreferences.getInstance();
    state = 0;
    await _prefs!.setInt(_usageCountKey, 0);
  }
}

/// 무료 사용 가능 여부 Provider
final canUseFreeProvider = Provider<bool>((ref) {
  final usageCount = ref.watch(usageCountProvider);
  return usageCount < _maxFreeUsageCount;
});

/// 남은 무료 사용 횟수 Provider
final remainingFreeCountProvider = Provider<int>((ref) {
  final usageCount = ref.watch(usageCountProvider);
  return (_maxFreeUsageCount - usageCount).clamp(0, _maxFreeUsageCount);
});

/// 최대 무료 사용 횟수 Provider
final maxFreeCountProvider = Provider<int>((ref) => _maxFreeUsageCount);
