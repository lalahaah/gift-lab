/// 선물 분석 요청 데이터 모델
///
/// 사용자가 입력한 선물 받는 사람의 정보와
/// 선물 상황에 대한 데이터를 담는 모델입니다.
class GiftRequest {
  /// 선물 받는 사람과의 관계 (예: 연인, 친구, 부모님 등)
  final String relation;

  /// 선물 받는 사람의 성별 (예: 남성, 여성, 무관)
  final String gender;

  /// 선물 받는 사람의 연령대 (예: 20대, 30대 등)
  final String ageGroup;

  /// 기념일 유형 (예: 생일, 집들이, 기념일 등)
  final String occasion;

  /// MBTI 성격 유형 (nullable - "모름" 선택 시 null)
  final String? mbti;

  /// 성격 키워드 리스트 (예: 감성적, 실용적, 덕후기질 등)
  final List<String> personalityTags;

  /// 최소 예산 (원 단위)
  final int minBudget;

  /// 최대 예산 (원 단위)
  final int maxBudget;

  /// 제외하고 싶은 선물 (선택사항)
  final String? exclusions;

  const GiftRequest({
    required this.relation,
    required this.gender,
    required this.ageGroup,
    required this.occasion,
    this.mbti,
    required this.personalityTags,
    required this.minBudget,
    required this.maxBudget,
    this.exclusions,
  });

  /// JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'relation': relation,
      'gender': gender,
      'age_group': ageGroup,
      'occasion': occasion,
      'mbti': mbti,
      'personality_tags': personalityTags,
      'min_budget': minBudget,
      'max_budget': maxBudget,
      'exclusions': exclusions,
    };
  }

  /// JSON에서 생성
  factory GiftRequest.fromJson(Map<String, dynamic> json) {
    return GiftRequest(
      relation: json['relation'] as String,
      gender: json['gender'] as String,
      ageGroup: json['age_group'] as String,
      occasion: json['occasion'] as String,
      mbti: json['mbti'] as String?,
      personalityTags: (json['personality_tags'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      minBudget: json['min_budget'] as int,
      maxBudget: json['max_budget'] as int,
      exclusions: json['exclusions'] as String?,
    );
  }

  /// copyWith 메서드
  GiftRequest copyWith({
    String? relation,
    String? gender,
    String? ageGroup,
    String? occasion,
    String? mbti,
    List<String>? personalityTags,
    int? minBudget,
    int? maxBudget,
    String? exclusions,
  }) {
    return GiftRequest(
      relation: relation ?? this.relation,
      gender: gender ?? this.gender,
      ageGroup: ageGroup ?? this.ageGroup,
      occasion: occasion ?? this.occasion,
      mbti: mbti ?? this.mbti,
      personalityTags: personalityTags ?? this.personalityTags,
      minBudget: minBudget ?? this.minBudget,
      maxBudget: maxBudget ?? this.maxBudget,
      exclusions: exclusions ?? this.exclusions,
    );
  }
}
