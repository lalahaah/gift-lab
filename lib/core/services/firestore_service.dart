import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Firestore 데이터 관리 서비스
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// 선물 추천 이력 저장
  ///
  /// [userId] 사용자 ID
  /// [giftData] 저장할 데이터 (관계, 연령대, 추천 결과 등)
  Future<void> saveGiftHistory({
    required String userId,
    required Map<String, dynamic> giftData,
  }) async {
    try {
      await _db.collection('users').doc(userId).collection('gift_history').add({
        ...giftData,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('이력 저장 실패: $e');
    }
  }

  /// 선물 추천 이력 조회
  Stream<List<Map<String, dynamic>>> getGiftHistoryStream(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('gift_history')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            // Timestamp to DateTime 변환
            if (data['createdAt'] is Timestamp) {
              data['createdAt'] = (data['createdAt'] as Timestamp).toDate();
            }
            return data;
          }).toList();
        });
  }

  /// 기념일 저장
  Future<void> saveAnniversary({
    required String userId,
    required String title,
    required DateTime date,
  }) async {
    try {
      await _db.collection('users').doc(userId).collection('anniversaries').add(
        {
          'title': title,
          'date': Timestamp.fromDate(date),
          'remind_days': 7, // 기본값 7일 전 알림
          'createdAt': FieldValue.serverTimestamp(),
        },
      );
    } catch (e) {
      throw Exception('기념일 저장 실패: $e');
    }
  }

  /// 기념일 조회
  Stream<List<Map<String, dynamic>>> getAnniversariesStream(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('anniversaries')
        .orderBy('date', descending: false)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            if (data['date'] is Timestamp) {
              data['date'] = (data['date'] as Timestamp).toDate();
            }
            return data;
          }).toList();
        });
  }

  /// 기념일 수정
  Future<void> updateAnniversary({
    required String userId,
    required String docId,
    required String title,
    required DateTime date,
  }) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('anniversaries')
          .doc(docId)
          .update({
            'title': title,
            'date': Timestamp.fromDate(date),
            'updatedAt': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      throw Exception('기념일 수정 실패: $e');
    }
  }

  /// 기념일 삭제
  Future<void> deleteAnniversary({
    required String userId,
    required String docId,
  }) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('anniversaries')
          .doc(docId)
          .delete();
    } catch (e) {
      throw Exception('기념일 삭제 실패: $e');
    }
  }

  // --- 저장한 선물 관련 메서드 ---

  /// 선물 추천 결과 저장
  Future<void> saveGiftRecommendation({
    required String userId,
    required String name,
    required String priceRange,
    required String reason,
    required String imageUrl,
    required String searchKeyword,
    required String category,
  }) async {
    try {
      await _db.collection('users').doc(userId).collection('saved_gifts').add({
        'name': name,
        'priceRange': priceRange,
        'reason': reason,
        'imageUrl': imageUrl,
        'searchKeyword': searchKeyword,
        'category': category,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('선물 저장 실패: $e');
    }
  }

  /// 저장한 선물 목록 조회
  Stream<List<Map<String, dynamic>>> getSavedGiftsStream(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('saved_gifts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['id'] = doc.id;
            if (data['createdAt'] is Timestamp) {
              data['createdAt'] = (data['createdAt'] as Timestamp).toDate();
            }
            return data;
          }).toList();
        });
  }

  Future<void> deleteSavedGift({
    required String userId,
    required String docId,
  }) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('saved_gifts')
          .doc(docId)
          .delete();
    } catch (e) {
      throw Exception('저장된 선물 삭제 실패: $e');
    }
  }

  // --- 사용자 프로필 관련 메서드 ---

  /// 사용자 프로필 업데이트
  ///
  /// [userId] 사용자 ID
  /// [displayName] 닉네임 (선택)
  /// [bio] 자기소개 (선택)
  /// [photoUrl] 프로필 이미지 URL (선택)
  Future<void> updateUserProfile(
    String userId, {
    String? displayName,
    String? bio,
    String? photoUrl,
  }) async {
    try {
      final updates = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (displayName != null) updates['displayName'] = displayName;
      if (bio != null) updates['bio'] = bio;
      if (photoUrl != null) updates['photoUrl'] = photoUrl;

      // merge: true 옵션으로 문서가 없으면 생성하고 있으면 병합
      await _db
          .collection('users')
          .doc(userId)
          .set(updates, SetOptions(merge: true));
    } catch (e) {
      throw Exception('프로필 업데이트 실패: $e');
    }
  }

  /// 사용자 프로필 스트림 조회
  Stream<Map<String, dynamic>?> getUserProfileStream(String userId) {
    return _db.collection('users').doc(userId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return snapshot.data();
      }
      return null;
    });
  }
}

/// FirestoreService Provider
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});
