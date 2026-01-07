import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/domain/models/gift_request.dart';

/// 선물 분석 폼 상태
class GiftAnalysisState {
  // Step 1: 관계/성별/연령대
  final String? relation;
  final String? gender;
  final String? ageGroup;

  // Step 2: 기념일 유형
  final String? occasion;

  // Step 3: MBTI 및 성격
  final String? mbti;
  final bool mbtiUnknown; // MBTI 모름 여부
  final List<String> personalityTags;

  // Step 4: 예산
  final int minBudget;
  final int maxBudget;

  // Step 5: 제외 조건
  final String? exclusions;

  const GiftAnalysisState({
    this.relation,
    this.gender,
    this.ageGroup,
    this.occasion,
    this.mbti,
    this.mbtiUnknown = false,
    this.personalityTags = const [],
    this.minBudget = 10000, // 기본값: 1만원
    this.maxBudget = 50000, // 기본값: 5만원
    this.exclusions,
  });

  /// copyWith 메서드
  GiftAnalysisState copyWith({
    String? relation,
    String? gender,
    String? ageGroup,
    String? occasion,
    String? mbti,
    bool? mbtiUnknown,
    List<String>? personalityTags,
    int? minBudget,
    int? maxBudget,
    String? exclusions,
  }) {
    return GiftAnalysisState(
      relation: relation ?? this.relation,
      gender: gender ?? this.gender,
      ageGroup: ageGroup ?? this.ageGroup,
      occasion: occasion ?? this.occasion,
      mbti: mbti ?? this.mbti,
      mbtiUnknown: mbtiUnknown ?? this.mbtiUnknown,
      personalityTags: personalityTags ?? this.personalityTags,
      minBudget: minBudget ?? this.minBudget,
      maxBudget: maxBudget ?? this.maxBudget,
      exclusions: exclusions ?? this.exclusions,
    );
  }

  /// GiftRequest로 변환
  GiftRequest? toGiftRequest() {
    // 필수 항목 체크
    if (relation == null ||
        gender == null ||
        ageGroup == null ||
        occasion == null) {
      return null;
    }

    return GiftRequest(
      relation: relation!,
      gender: gender!,
      ageGroup: ageGroup!,
      occasion: occasion!,
      mbti: mbtiUnknown ? null : mbti,
      personalityTags: personalityTags,
      minBudget: minBudget,
      maxBudget: maxBudget,
      exclusions: exclusions?.isEmpty == true ? null : exclusions,
    );
  }

  /// Step 1 유효성 검사
  bool get isStep1Valid =>
      relation != null && gender != null && ageGroup != null;

  /// Step 2 유효성 검사
  bool get isStep2Valid => occasion != null;

  /// Step 3 유효성 검사 (성격 태그는 선택사항)
  bool get isStep3Valid => mbtiUnknown || mbti != null;

  /// Step 4는 항상 유효 (기본값 존재)
  bool get isStep4Valid => true;

  /// Step 5는 선택사항이므로 항상 유효
  bool get isStep5Valid => true;

  /// 전체 폼 유효성 검사
  bool get isValid =>
      isStep1Valid &&
      isStep2Valid &&
      isStep3Valid &&
      isStep4Valid &&
      isStep5Valid;
}

/// 선물 분석 상태 관리 Provider
class GiftAnalysisNotifier extends StateNotifier<GiftAnalysisState> {
  GiftAnalysisNotifier() : super(const GiftAnalysisState());

  /// Step 1: 관계 설정
  void setRelation(String relation) {
    state = state.copyWith(relation: relation);
  }

  /// Step 1: 성별 설정
  void setGender(String gender) {
    state = state.copyWith(gender: gender);
  }

  /// Step 1: 연령대 설정
  void setAgeGroup(String ageGroup) {
    state = state.copyWith(ageGroup: ageGroup);
  }

  /// Step 2: 기념일 유형 설정
  void setOccasion(String occasion) {
    state = state.copyWith(occasion: occasion);
  }

  /// Step 3: MBTI 설정
  void setMbti(String? mbti) {
    state = state.copyWith(mbti: mbti, mbtiUnknown: false);
  }

  /// Step 3: MBTI 모름 설정
  void setMbtiUnknown(bool unknown) {
    state = state.copyWith(
      mbtiUnknown: unknown,
      mbti: unknown ? null : state.mbti,
    );
  }

  /// Step 3: 성격 태그 추가
  void addPersonalityTag(String tag) {
    if (!state.personalityTags.contains(tag)) {
      state = state.copyWith(personalityTags: [...state.personalityTags, tag]);
    }
  }

  /// Step 3: 성격 태그 제거
  void removePersonalityTag(String tag) {
    state = state.copyWith(
      personalityTags: state.personalityTags.where((t) => t != tag).toList(),
    );
  }

  /// Step 3: 성격 태그 토글
  void togglePersonalityTag(String tag) {
    if (state.personalityTags.contains(tag)) {
      removePersonalityTag(tag);
    } else {
      addPersonalityTag(tag);
    }
  }

  /// Step 4: 예산 범위 설정
  void setBudgetRange(int minBudget, int maxBudget) {
    state = state.copyWith(minBudget: minBudget, maxBudget: maxBudget);
  }

  /// Step 5: 제외 조건 설정
  void setExclusions(String? exclusions) {
    state = state.copyWith(exclusions: exclusions);
  }

  /// 폼 초기화
  void reset() {
    state = const GiftAnalysisState();
  }

  /// 특정 Step으로 이동하기 전 유효성 검사
  bool canProceedToStep(int step) {
    switch (step) {
      case 2:
        return state.isStep1Valid;
      case 3:
        return state.isStep1Valid && state.isStep2Valid;
      case 4:
        return state.isStep1Valid && state.isStep2Valid && state.isStep3Valid;
      case 5:
        return state.isStep1Valid &&
            state.isStep2Valid &&
            state.isStep3Valid &&
            state.isStep4Valid;
      default:
        return true;
    }
  }
}

/// Provider 정의
final giftAnalysisProvider =
    StateNotifierProvider<GiftAnalysisNotifier, GiftAnalysisState>(
      (ref) => GiftAnalysisNotifier(),
    );
