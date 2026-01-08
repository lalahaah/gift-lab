import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/firestore_service.dart';
import '../../../providers/auth/auth_provider.dart';

class AnniversaryPage extends ConsumerStatefulWidget {
  const AnniversaryPage({super.key});

  @override
  ConsumerState<AnniversaryPage> createState() => _AnniversaryPageState();
}

class _AnniversaryPageState extends ConsumerState<AnniversaryPage> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    if (user == null) {
      return const Scaffold(body: Center(child: Text('로그인이 필요한 서비스입니다.')));
    }

    final anniversaryStream = ref.watch(
      firestoreServiceProvider.select(
        (s) => s.getAnniversariesStream(user.uid),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('기념일 관리'), centerTitle: true),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: anniversaryStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('오류가 발생했습니다: ${snapshot.error}'));
          }

          final anniversaries = snapshot.data ?? [];

          if (anniversaries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cake_outlined, size: 64, color: AppColors.gray100),
                  const SizedBox(height: 16),
                  Text(
                    '등록된 기념일이 없습니다.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: AppColors.textGray),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '+ 버튼을 눌러 기념일을 추가해보세요',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.textGray),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: anniversaries.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              try {
                final item = anniversaries[index];
                final docId = item['id'] as String;
                final date = item['date'] as DateTime?;
                final title = item['title']?.toString() ?? '제목 없음';

                if (date == null) return const SizedBox.shrink();

                // 날짜 비교를 위해 시간 제거 (자정 기준)
                final now = DateTime.now();
                final today = DateTime(now.year, now.month, now.day);
                final targetDate = DateTime(date.year, date.month, date.day);
                final daysLeft = targetDate.difference(today).inDays;

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.gray100),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                    title: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      DateFormat('yyyy.MM.dd').format(date),
                      style: TextStyle(color: AppColors.textGray),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // D-Day Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: daysLeft >= 0 && daysLeft <= 7
                                ? AppColors.labPink.withOpacity(0.1)
                                : AppColors.gray100,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            daysLeft == 0
                                ? 'Today'
                                : daysLeft > 0
                                ? 'D-$daysLeft'
                                : '지남',
                            style: TextStyle(
                              color: daysLeft >= 0 && daysLeft <= 7
                                  ? AppColors.labPink
                                  : AppColors.textGray,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Edit/Delete Menu
                        PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert, color: AppColors.gray400),
                          onSelected: (value) {
                            if (value == 'edit') {
                              _showAnniversaryDialog(
                                context,
                                user.uid,
                                docId: docId,
                                initialTitle: title,
                                initialDate: date,
                              );
                            } else if (value == 'delete') {
                              _confirmDelete(context, user.uid, docId);
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, size: 20),
                                  SizedBox(width: 8),
                                  Text('수정'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete,
                                    size: 20,
                                    color: Colors.red,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '삭제',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              } catch (e) {
                return const SizedBox.shrink(); // 렌더링 에러 시 숨김 처리
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAnniversaryDialog(context, user.uid),
        backgroundColor: AppColors.labIndigo,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// 기념일 추가/수정 다이얼로그
  void _showAnniversaryDialog(
    BuildContext context,
    String userId, {
    String? docId,
    String? initialTitle,
    DateTime? initialDate,
  }) {
    final titleController = TextEditingController(text: initialTitle);
    DateTime? selectedDate = initialDate;
    final isEdit = docId != null;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text(isEdit ? '기념일 수정' : '기념일 추가'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: '기념일 제목',
                    hintText: '예: 여자친구 생일',
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: Text(
                    selectedDate == null
                        ? '날짜 선택'
                        : DateFormat('yyyy-MM-dd').format(selectedDate!),
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  contentPadding: EdgeInsets.zero,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2000), // 과거 날짜도 선택 가능하도록
                      lastDate: DateTime.now().add(
                        const Duration(days: 365 * 5),
                      ),
                    );
                    if (date != null) {
                      setState(() => selectedDate = date);
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('취소', style: TextStyle(color: AppColors.textGray)),
              ),
              TextButton(
                onPressed: () async {
                  if (titleController.text.isEmpty || selectedDate == null) {
                    return;
                  }
                  try {
                    if (isEdit) {
                      await ref
                          .read(firestoreServiceProvider)
                          .updateAnniversary(
                            userId: userId,
                            docId: docId,
                            title: titleController.text,
                            date: selectedDate!,
                          );
                    } else {
                      await ref
                          .read(firestoreServiceProvider)
                          .saveAnniversary(
                            userId: userId,
                            title: titleController.text,
                            date: selectedDate!,
                          );
                    }
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  } catch (e) {
                    // 에러 처리
                    if (context.mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('오류가 발생했습니다: $e')));
                    }
                  }
                },
                child: Text(isEdit ? '수정' : '추가'),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 삭제 확인 다이얼로그
  void _confirmDelete(BuildContext context, String userId, String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('기념일 삭제'),
        content: const Text('정말로 이 기념일을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('취소', style: TextStyle(color: AppColors.textGray)),
          ),
          TextButton(
            onPressed: () async {
              try {
                await ref
                    .read(firestoreServiceProvider)
                    .deleteAnniversary(userId: userId, docId: docId);
                if (context.mounted) {
                  Navigator.of(context).pop();
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
