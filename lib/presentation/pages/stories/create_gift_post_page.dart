import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/services/firestore_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../providers/auth/auth_provider.dart';
import '../../widgets/buttons/primary_button.dart';

/// 선물 포스트 작성 페이지
class CreateGiftPostPage extends ConsumerStatefulWidget {
  const CreateGiftPostPage({super.key});

  @override
  ConsumerState<CreateGiftPostPage> createState() => _CreateGiftPostPageState();
}

class _CreateGiftPostPageState extends ConsumerState<CreateGiftPostPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('stories.create_post'.tr())),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 이미지 선택 영역
                _buildImagePicker(),
                const SizedBox(height: AppSpacing.l),

                // 제목 입력
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'stories.post_title'.tr(),
                    hintText: 'stories.post_title_hint'.tr(),
                  ),
                  maxLength: 50,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'common.required_fields'.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.m),

                // 내용 입력
                TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    labelText: 'stories.post_content'.tr(),
                    hintText: 'stories.post_content_hint'.tr(),
                    alignLabelWithHint: true,
                  ),
                  maxLength: 500,
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'common.required_fields'.tr();
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.xl),

                // 작성 완료 버튼
                PrimaryButton(
                  text: 'common.save'.tr(),
                  onPressed: _isLoading ? null : _submitPost,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 이미지 선택 위젯
  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor, width: 1),
        ),
        child: _selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  _selectedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 48,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: AppSpacing.s),
                  Text(
                    'stories.add_photo'.tr(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  /// 이미지 선택
  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('common.error'.tr())));
      }
    }
  }

  /// 포스트 제출
  Future<void> _submitPost() async {
    // 유효성 검사
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('stories.photo_required'.tr())));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final currentUser = ref.read(currentUserProvider);
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      // 사용자 프로필 정보 가져오기
      final firestoreService = ref.read(firestoreServiceProvider);
      final profileStream = firestoreService.getUserProfileStream(
        currentUser.uid,
      );
      final profileSnapshot = await profileStream.first;

      final userName =
          profileSnapshot?['displayName'] ??
          currentUser.displayName ??
          currentUser.email?.split('@')[0] ??
          'User';
      final userPhotoUrl = profileSnapshot?['photoUrl'] ?? currentUser.photoURL;

      // 1. 이미지 업로드
      final storageService = ref.read(storageServiceProvider);
      final imageUrl = await storageService.uploadProfileImage(
        userId: currentUser.uid,
        imageFile: _selectedImage!,
      );

      // 2. Firestore에 포스트 저장
      await firestoreService.createGiftPost(
        userId: currentUser.uid,
        userName: userName,
        userPhotoUrl: userPhotoUrl,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        imageUrl: imageUrl,
      );

      // 3. 성공 메시지 및 페이지 닫기
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('stories.post_success'.tr())));
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('common.error'.tr())));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
