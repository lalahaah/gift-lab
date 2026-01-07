import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// AdMob 광고 관리 서비스
class AdService {
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;

  /// AdMob SDK 초기화
  Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  /// 전면 광고 로드
  Future<void> loadInterstitialAd() async {
    // 테스트 광고 단위 ID 사용
    final adUnitId = Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/1033173712'
        : 'ca-app-pub-3940256099942544/4411468910';

    await InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('AdMob: Interstitial ad loaded.');
          _interstitialAd = ad;
          _isAdLoaded = true;
          _interstitialAd!.fullScreenContentCallback =
              FullScreenContentCallback(
                onAdDismissedFullScreenContent: (ad) {
                  debugPrint('AdMob: Ad dismissed.');
                  ad.dispose();
                  _interstitialAd = null;
                  _isAdLoaded = false;
                },
                onAdFailedToShowFullScreenContent: (ad, error) {
                  debugPrint('AdMob: Ad failed to show: $error');
                  ad.dispose();
                  _interstitialAd = null;
                  _isAdLoaded = false;
                },
              );
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('AdMob: Interstitial ad failed to load: $error');
          _interstitialAd = null;
          _isAdLoaded = false;
        },
      ),
    );
  }

  /// 전면 광고 표시
  /// 광고가 로드되어 있으면 표시하고 true 반환, 아니면 false 반환
  bool showInterstitialAd() {
    if (_interstitialAd != null && _isAdLoaded) {
      _interstitialAd!.show();
      _interstitialAd = null; // 표시 시작하면 객체 해제 준비
      _isAdLoaded = false;
      return true;
    } else {
      debugPrint('AdMob: Warning: Ad not loaded yet.');
      return false;
    }
  }
}

/// AdService Provider
final adServiceProvider = Provider<AdService>((ref) => AdService());
