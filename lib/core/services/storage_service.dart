import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;

/// Firebase Storage 서비스
class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// 프로필 이미지 업로드
  ///
  /// [userId] 사용자 ID
  /// [imageFile] 업로드할 이미지 파일
  /// 반환값: 업로드된 이미지의 다운로드 URL
  Future<String> uploadProfileImage({
    required String userId,
    required File imageFile,
  }) async {
    try {
      // 파일 확장자 추출
      final extension = path.extension(imageFile.path);

      // 저장 경로: users/{userId}/profile_image.{ext}
      // 매번 덮어쓰기 위해 동일한 경로 사용 (또는 타임스탬프 추가하여 이력 관리 가능)
      // 여기서는 단순화를 위해 타임스탬프를 추가하여 캐싱 문제 방지
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final ref = _storage.ref().child(
        'users/$userId/profile_${timestamp}$extension',
      );

      // 파일 업로드
      final uploadTask = await ref.putFile(imageFile);

      // 다운로드 URL 획득
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('이미지 업로드 실패: $e');
    }
  }

  /// 파일 삭제 (필요 시 사용)
  Future<void> deleteFile(String fileUrl) async {
    try {
      final ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } catch (e) {
      // 파일이 존재하지 않거나 권한 문제 등 예외 처리
      throw Exception('파일 삭제 실패: $e');
    }
  }
}

/// StorageService Provider
final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});
