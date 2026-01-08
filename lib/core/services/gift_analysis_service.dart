import 'dart:convert';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/gift_request.dart';
import '../domain/models/gift_recommendation.dart';

/// AI 선물 분석 서비스 (Vertex AI via Firebase)
class GiftAnalysisService {
  late final GenerativeModel _model;

  GiftAnalysisService() {
    // Gemini 2.0 Flash 모델 사용 (최신 버전, 빠른 응답 속도)
    _model = FirebaseVertexAI.instance.generativeModel(
      model: 'gemini-2.0-flash',
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json', // JSON 응답 강제
      ),
    );
  }

  /// 선물 추천 요청
  Future<List<GiftRecommendation>> getRecommendations(
    GiftRequest request, {
    List<String> excludeNames = const [],
  }) async {
    final prompt = _buildPrompt(request, excludeNames);

    try {
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      final responseText = response.text;
      if (responseText == null) {
        throw Exception('AI 응답이 비어있습니다.');
      }

      // JSON 파싱
      final List<dynamic> jsonList = jsonDecode(responseText);
      return jsonList.map((json) => GiftRecommendation.fromJson(json)).toList();
    } catch (e) {
      // 에러 처리 (로그 기록 등)
      throw Exception('선물 추천 중 오류가 발생했습니다: $e');
    }
  }

  /// 프롬프트 생성
  String _buildPrompt(GiftRequest request, List<String> excludeNames) {
    final sb = StringBuffer();
    sb.writeln('당신은 최고의 선물 추천 전문가입니다. 다음 정보를 바탕으로 3개의 선물을 추천해주세요.');
    sb.writeln('결과는 반드시 JSON 배열 포맷으로 반환해야 합니다.');
    sb.writeln('');

    if (excludeNames.isNotEmpty) {
      sb.writeln('[이미 추천한 상품 - 제외 필수]');
      for (var name in excludeNames) {
        sb.writeln('- $name');
      }
      sb.writeln('위 상품들은 이미 추천되었으므로 절대 중복되지 않게 완전히 새로운 상품으로 추천해주세요.');
      sb.writeln('');
    }

    sb.writeln('[받는 사람 정보]');
    sb.writeln('- 관계: ${request.relation}');
    sb.writeln(
      '- 성별: ${request.gender == 'male'
          ? '남성'
          : request.gender == 'female'
          ? '여성'
          : '무관'}',
    );
    sb.writeln('- 연령대: ${request.ageGroup}');
    sb.writeln('- 기념일/상황: ${request.occasion}');
    sb.writeln('- 예산 범위: ${request.minBudget}원 ~ ${request.maxBudget}원');

    if (request.mbti != null) {
      sb.writeln('- MBTI: ${request.mbti}');
    }
    if (request.personalityTags.isNotEmpty) {
      sb.writeln('- 성격/취향: ${request.personalityTags.join(', ')}');
    }
    if (request.exclusions != null) {
      sb.writeln('- 제외할 선물: ${request.exclusions}');
    }

    sb.writeln('');
    sb.writeln('[응답 형식 (JSON Array)]');
    sb.writeln('''
[
  {
    "name": "상품명 (구체적으로)",
    "reason": "추천 이유 (친근하고 설득력 있게, 2~3문장)",
    "price_range": "예상 가격대 (예: 3~5만원)",
    "search_keyword": "쿠팡 검색용 키워드 (가장 정확한 상품을 찾을 수 있는 단어 조합)",
    "image_url": "상품의 카테고리를 잘 나타내는 영어 키워드 1단어 (예: diffuser, flower, wallet, watch)"
  }
]
''');
    sb.writeln(
      '추가 규칙: image_url에는 반드시 상품의 본질을 나타내는 영어 단어 1개만 입력하세요. 이 단어는 Unsplash 이미지 검색에 사용됩니다.',
    );
    sb.writeln('');
    sb.writeln('Markdown 코드 블록 없이 순수 JSON 문자열만 반환하세요.');

    return sb.toString();
  }
}

/// Provider 정의
final giftAnalysisServiceProvider = Provider<GiftAnalysisService>((ref) {
  return GiftAnalysisService();
});
