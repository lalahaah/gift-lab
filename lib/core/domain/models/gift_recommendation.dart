/// AI가 추천한 선물 정보 모델
class GiftRecommendation {
  /// 상품명 (예: "프리미엄 디퓨저 세트")
  final String name;

  /// 추천 이유 (예: "향기에 민감한 20대 여성에게 인기 있는 선물입니다.")
  final String reason;

  /// 예상 가격대 (예: "3~5만원")
  final String priceRange;

  /// 검색 키워드 (쿠팡 검색용, 예: "프리미엄 디퓨저")
  final String searchKeyword;

  /// 대표 이미지 카테고리 (예: "diffuser", "wallet")
  final String imageUrl;

  GiftRecommendation({
    required this.name,
    required this.reason,
    required this.priceRange,
    required this.searchKeyword,
    required this.imageUrl,
  });

  factory GiftRecommendation.fromJson(Map<String, dynamic> json) {
    return GiftRecommendation(
      name: json['name'] as String,
      reason: json['reason'] as String,
      priceRange: json['price_range'] as String,
      searchKeyword: json['search_keyword'] as String,
      imageUrl: json['image_url'] ?? '',
    );
  }
}
