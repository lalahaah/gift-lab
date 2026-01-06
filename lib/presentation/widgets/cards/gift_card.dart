import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';

/// 기프트랩 Gift Card
///
/// 디자인 가이드:
/// - Elevation: Low (부드럽게 떠 있는 느낌)
/// - Radius: 16px
/// - Padding: 20px
/// - Content: 상품 이미지(1:1 비율) + 하단 텍스트 영역
class GiftCard extends StatelessWidget {
  /// 상품 이미지 URL 또는 위젯
  final String? imageUrl;

  /// 이미지 위젯 (imageUrl 대신 사용 가능)
  final Widget? imageWidget;

  /// 상품명 (제목)
  final String title;

  /// 추천 이유 또는 설명
  final String? description;

  /// 가격 (선택사항)
  final String? price;

  /// 강조 텍스트 (예: "최적가")
  final String? highlightText;

  /// 카드 클릭 이벤트
  final VoidCallback? onTap;

  /// 카드 너비 (기본값: 부모 크기에 맞춤)
  final double? width;

  /// 카드 높이 (기본값: 자동)
  final double? height;

  const GiftCard({
    super.key,
    this.imageUrl,
    this.imageWidget,
    required this.title,
    this.description,
    this.price,
    this.highlightText,
    this.onTap,
    this.width,
    this.height,
  }) : assert(
         imageUrl != null || imageWidget != null,
         'imageUrl 또는 imageWidget 중 하나는 필수입니다.',
       );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1, // Low elevation
      shadowColor: Colors.black.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.cardRadius, // 16px
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.cardRadius,
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.all(20), // 20px padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 상품 이미지 (1:1 비율)
              AspectRatio(
                aspectRatio: 1.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child:
                      imageWidget ??
                      (imageUrl != null
                          ? Image.network(
                              imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: AppColors.labGray,
                                  child: const Icon(
                                    Icons.card_giftcard,
                                    size: 48,
                                    color: AppColors.textGray,
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: AppColors.labGray,
                              child: const Icon(
                                Icons.card_giftcard,
                                size: 48,
                                color: AppColors.textGray,
                              ),
                            )),
                ),
              ),

              AppSpacing.verticalSpaceM,

              // 상품명 (제목)
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textBlack,
                  letterSpacing: -0.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              if (description != null) ...[
                AppSpacing.verticalSpaceXS,
                // 추천 이유 또는 설명
                Text(
                  description!,
                  style: const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textGray,
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              if (price != null || highlightText != null) ...[
                AppSpacing.verticalSpaceS,
                Row(
                  children: [
                    // 가격
                    if (price != null)
                      Text(
                        price!,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textBlack,
                        ),
                      ),
                    const Spacer(),
                    // 강조 텍스트 (예: "최적가")
                    if (highlightText != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.mintSpark.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          highlightText!,
                          style: const TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.mintSpark,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
