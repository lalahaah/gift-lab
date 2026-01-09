import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../core/constants/app_spacing.dart';
import '../../../core/services/firestore_service.dart';
import '../../../providers/auth/auth_provider.dart';

/// 선물 이야기 페이지 - 사용자들의 선물 포스트 피드
class GiftStoriesPage extends ConsumerStatefulWidget {
  const GiftStoriesPage({super.key});

  @override
  ConsumerState<GiftStoriesPage> createState() => _GiftStoriesPageState();
}

class _GiftStoriesPageState extends ConsumerState<GiftStoriesPage> {
  String _sortBy = 'createdAt'; // 'createdAt' 또는 'likeCount'

  @override
  void initState() {
    super.initState();
    // timeago 한국어 설정
    timeago.setLocaleMessages('ko', timeago.KoMessages());
  }

  @override
  Widget build(BuildContext context) {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final firestoreService = ref.watch(firestoreServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('stories.title'.tr()),
        actions: [
          // 정렬 옵션 메뉴
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _sortBy = value;
              });
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'createdAt',
                child: Text('stories.sort_latest'.tr()),
              ),
              PopupMenuItem(
                value: 'likeCount',
                child: Text('stories.sort_popular'.tr()),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Icon(
                    _sortBy == 'createdAt' ? Icons.schedule : Icons.favorite,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _sortBy == 'createdAt'
                        ? 'stories.sort_latest'.tr()
                        : 'stories.sort_popular'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Icon(Icons.arrow_drop_down, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: firestoreService.getGiftPostsStream(orderBy: _sortBy),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('common.error'.tr()));
          }

          final posts = snapshot.data ?? [];

          if (posts.isEmpty) {
            return _buildEmptyState(context);
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.m),
            itemCount: posts.length,
            separatorBuilder: (context, index) =>
                const SizedBox(height: AppSpacing.m),
            itemBuilder: (context, index) {
              return _buildPostCard(context, posts[index], isLoggedIn);
            },
          );
        },
      ),
      floatingActionButton: isLoggedIn
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/stories/create'),
              icon: const Icon(Icons.add),
              label: Text('stories.create_post'.tr()),
            )
          : null,
    );
  }

  /// 빈 상태 UI
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_stories_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: AppSpacing.l),
            Text(
              'stories.empty_title'.tr(),
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              'stories.empty_description'.tr(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// 포스트 카드 위젯
  Widget _buildPostCard(
    BuildContext context,
    Map<String, dynamic> post,
    bool isLoggedIn,
  ) {
    final currentUser = ref.watch(currentUserProvider);
    final isMyPost = currentUser != null && post['userId'] == currentUser.uid;
    final likes = List<String>.from(post['likes'] ?? []);
    final isLiked = currentUser != null && likes.contains(currentUser.uid);
    final likeCount = post['likeCount'] ?? 0;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).dividerColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 사용자 정보 헤더
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Row(
              children: [
                // 프로필 사진
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.primaryContainer,
                  backgroundImage: post['userPhotoUrl'] != null
                      ? NetworkImage(post['userPhotoUrl'])
                      : null,
                  child: post['userPhotoUrl'] == null
                      ? Text(
                          (post['userName'] ?? 'U')[0].toUpperCase(),
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: AppSpacing.m),
                // 이름 및 시간
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post['userName'] ?? 'Unknown',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _formatTime(post['createdAt']),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                // 삭제 버튼 (본인 포스트만)
                if (isMyPost)
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _deletePost(context, post['id']),
                  ),
              ],
            ),
          ),

          // 선물 이미지
          AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              post['imageUrl'],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Icon(Icons.broken_image, size: 48),
              ),
            ),
          ),

          // 제목 및 내용
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post['title'] ?? '',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.s),
                Text(
                  post['content'] ?? '',
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // 좋아요 버튼 및 카운트
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.m,
              0,
              AppSpacing.m,
              AppSpacing.m,
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: isLoggedIn
                      ? () => _toggleLike(post['id'])
                      : () => _showLoginRequired(context),
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : null,
                  ),
                ),
                Text(
                  '$likeCount ${'stories.likes'.tr()}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 시간 포맷팅
  String _formatTime(dynamic timestamp) {
    if (timestamp == null) return '';

    final dateTime = timestamp is DateTime ? timestamp : DateTime.now();
    final locale = context.locale.languageCode;

    return timeago.format(dateTime, locale: locale);
  }

  /// 좋아요 토글
  Future<void> _toggleLike(String postId) async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    try {
      await ref
          .read(firestoreServiceProvider)
          .toggleLikePost(postId: postId, userId: currentUser.uid);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('common.error'.tr())));
      }
    }
  }

  /// 포스트 삭제
  Future<void> _deletePost(BuildContext context, String postId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('common.delete'.tr()),
        content: Text('stories.delete_confirm'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('common.cancel'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'common.delete'.tr(),
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) return;

      await ref
          .read(firestoreServiceProvider)
          .deleteGiftPost(postId: postId, userId: currentUser.uid);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('stories.delete_success'.tr())));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('common.error'.tr())));
      }
    }
  }

  /// 로그인 필요 안내
  void _showLoginRequired(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('stories.login_required'.tr())));
  }
}
