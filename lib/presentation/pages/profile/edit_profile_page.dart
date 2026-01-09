import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/services/firestore_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../providers/auth/auth_provider.dart';
import '../../widgets/buttons/primary_button.dart';

/// 프로필 수정 페이지
class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _bioController;

  File? _selectedImage;
  String? _currentPhotoUrl;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    _nameController = TextEditingController(text: user?.displayName ?? '');
    _bioController = TextEditingController(); // 초기값은 Firestore에서 가져와야 함
    _currentPhotoUrl = user?.photoURL;

    // Firestore에서 추가 정보(bio) 로드
    if (user != null) {
      _loadUserProfile(user.uid);
    }
  }

  Future<void> _loadUserProfile(String userId) async {
    try {
      final snapshot = await ref
          .read(firestoreServiceProvider)
          .getUserProfileStream(userId)
          .first;
      if (snapshot != null) {
        if (mounted) {
          setState(() {
            if (snapshot['bio'] != null) {
              _bioController.text = snapshot['bio'];
            }
            // Firestore에 저장된 photoUrl이 있다면 우선 사용 (Auth 프로필보다 최신일 수 있음)
            if (snapshot['photoUrl'] != null) {
              _currentPhotoUrl = snapshot['photoUrl'];
            }
          });
        }
      }
    } catch (e) {
      debugPrint('프로필 정보 로드 실패: $e');
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  /// 이미지 선택
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 70,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      debugPrint('이미지 선택 실패: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('이미지를 불러오는데 실패했습니다.')));
      }
    }
  }

  /// 프로필 저장
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = ref.read(currentUserProvider);
      if (user == null) throw Exception('로그인이 필요합니다.');

      String? photoUrl = _currentPhotoUrl;

      // 1. 이미지가 변경되었다면 Storage에 업로드
      if (_selectedImage != null) {
        photoUrl = await ref
            .read(storageServiceProvider)
            .uploadProfileImage(userId: user.uid, imageFile: _selectedImage!);
      }

      // 2. Firebase Auth 프로필 업데이트 (기본 정보)
      if (user.displayName != _nameController.text ||
          (photoUrl != null && user.photoURL != photoUrl)) {
        await user.updateDisplayName(_nameController.text);
        if (photoUrl != null) {
          await user.updatePhotoURL(photoUrl);
        }
      }

      // 3. Firestore 프로필 업데이트 (추가 정보)
      await ref
          .read(firestoreServiceProvider)
          .updateUserProfile(
            user.uid,
            displayName: _nameController.text,
            bio: _bioController.text,
            photoUrl: photoUrl,
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('프로필이 성공적으로 수정되었습니다.'),
            backgroundColor: AppColors.mintSpark,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('저장 실패: $e'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필 수정'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.m),

              // 프로필 이미지
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.gray100,
                        border: Border.all(color: AppColors.gray200, width: 2),
                        image: _selectedImage != null
                            ? DecorationImage(
                                image: FileImage(_selectedImage!),
                                fit: BoxFit.cover,
                              )
                            : (_currentPhotoUrl != null
                                  ? DecorationImage(
                                      image: NetworkImage(_currentPhotoUrl!),
                                      fit: BoxFit.cover,
                                    )
                                  : null),
                      ),
                      child:
                          (_selectedImage == null && _currentPhotoUrl == null)
                          ? const Icon(
                              Icons.person,
                              size: 60,
                              color: AppColors.gray400,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Material(
                        color: AppColors.labIndigo,
                        shape: const CircleBorder(),
                        elevation: 4,
                        child: InkWell(
                          onTap: _pickImage,
                          customBorder: const CircleBorder(),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // 닉네임 입력
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: '닉네임',
                  hintText: '사용하실 닉네임을 입력하세요',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '닉네임을 입력해주세요';
                  }
                  if (value.length > 10) {
                    return '닉네임은 10자 이내로 입력해주세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.l),

              // 한줄 소개 입력
              TextFormField(
                controller: _bioController,
                maxLength: 50,
                decoration: InputDecoration(
                  labelText: '한줄 소개',
                  hintText: '나를 표현하는 한마디 (선택)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.edit_note),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // 저장 버튼
              PrimaryButton(
                text: '저장하기',
                onPressed: _isLoading ? null : _saveProfile,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
