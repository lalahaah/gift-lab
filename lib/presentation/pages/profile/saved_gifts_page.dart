import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/services/firestore_service.dart';
import '../../../providers/auth/auth_provider.dart';

class SavedGiftsPage extends ConsumerWidget {
  const SavedGiftsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return const Scaffold(body: Center(child: Text('로그인이 필요한 서비스입니다.')));
    }

    final savedGiftsStream = ref.watch(
      firestoreServiceProvider.select((s) => s.getSavedGiftsStream(user.uid)),
    );

    return Scaffold(
      backgroundColor: AppColors.gray50,
      appBar: AppBar(
        title: const Text('저장한 선물'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textBlack,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: savedGiftsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('오류가 발생했습니다: ${snapshot.error}'));
          }

          final gifts = snapshot.data ?? [];

          if (gifts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 64,
                    color: AppColors.textGray.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '저장한 선물이 없습니다.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: AppColors.textGray),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.l),
            itemCount: gifts.length,
            itemBuilder: (context, index) {
              final gift = gifts[index];
              return _buildGiftItem(context, ref, user.uid, gift);
            },
          );
        },
      ),
    );
  }

  Widget _buildGiftItem(
    BuildContext context,
    WidgetRef ref,
    String userId,
    Map<String, dynamic> gift,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.m),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                // LoremFlickr 이미지 (카테고리 활용)
                'https://loremflickr.com/200/200/${Uri.encodeComponent(gift['imageUrl'] ?? 'gift')},gift/all?lock=${gift['name'].hashCode}',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 60,
                  height: 60,
                  color: AppColors.gray100,
                  child: const Icon(
                    Icons.card_giftcard,
                    color: AppColors.textGray,
                  ),
                ),
              ),
            ),
            title: Text(
              gift['name'] ?? '이름 없음',
              style: const TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  gift['priceRange'] ?? '',
                  style: const TextStyle(
                    color: AppColors.labIndigo,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  gift['category'] ?? '기타',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.textGray),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.textGray),
              onPressed: () => _confirmDelete(context, ref, userId, gift['id']),
            ),
          ),
          const Divider(height: 1),
          InkWell(
            onTap: () =>
                _launchCoupangSearch(gift['searchKeyword'] ?? gift['name']),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.search,
                    size: 16,
                    color: AppColors.labIndigo,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '쿠팡에서 최저가 확인하기',
                    style: TextStyle(
                      color: AppColors.labIndigo,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchCoupangSearch(String keyword) async {
    final encodedKeyword = Uri.encodeComponent(keyword);
    final url = Uri.parse(
      'https://www.coupang.com/np/search?q=$encodedKeyword',
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  void _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String userId,
    String docId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('선물 삭제'),
        content: const Text('정말 이 선물을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '취소',
              style: TextStyle(color: AppColors.textGray),
            ),
          ),
          TextButton(
            onPressed: () async {
              try {
                await ref
                    .read(firestoreServiceProvider)
                    .deleteSavedGift(userId: userId, docId: docId);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('삭제되었습니다.')));
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('삭제 실패: $e')));
                }
              }
            },
            child: const Text('삭제', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
