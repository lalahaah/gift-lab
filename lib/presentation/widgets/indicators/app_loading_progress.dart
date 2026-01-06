import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// 기프트랩 Loading Progress Indicator
///
/// 디자인 가이드:
/// - 0% → 80%: 빠르게 진행
/// - 80% → 100%: AI 응답에 맞춰 천천히
class AppLoadingProgress extends StatefulWidget {
  /// 로딩 메시지 (선택사항)
  final String? message;

  /// Micro-copy Animation (점 애니메이션) 표시 여부
  final bool showDots;

  const AppLoadingProgress({super.key, this.message, this.showDots = true});

  @override
  State<AppLoadingProgress> createState() => _AppLoadingProgressState();
}

class _AppLoadingProgressState extends State<AppLoadingProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // 0% → 80%: 빠르게 (처음 1초)
    // 80% → 100%: 천천히 (나머지 2초)
    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 0.8,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 33, // 1초
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.8,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.linear)),
        weight: 67, // 2초
      ),
    ]).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Circular Progress Indicator
        const SizedBox(
          width: 48,
          height: 48,
          child: CircularProgressIndicator(
            strokeWidth: 3.0,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.labIndigo),
          ),
        ),
        if (widget.message != null) ...[
          const SizedBox(height: 24),
          // 메시지 with Dots Animation
          if (widget.showDots)
            _AnimatedDotsText(message: widget.message!)
          else
            Text(
              widget.message!,
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: AppColors.textBlack,
              ),
            ),
        ],
        const SizedBox(height: 16),
        // Linear Progress Indicator
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Column(
              children: [
                LinearProgressIndicator(
                  value: _animation.value,
                  backgroundColor: AppColors.gray100,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.labIndigo,
                  ),
                  minHeight: 4,
                ),
                const SizedBox(height: 8),
                Text(
                  '${(_animation.value * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    color: AppColors.labIndigo,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// Animated Dots Text ("분석 중..." => "분석 중.", "분석 중..", "분석 중...")
class _AnimatedDotsText extends StatefulWidget {
  final String message;

  const _AnimatedDotsText({required this.message});

  @override
  State<_AnimatedDotsText> createState() => _AnimatedDotsTextState();
}

class _AnimatedDotsTextState extends State<_AnimatedDotsText>
    with SingleTickerProviderStateMixin {
  late AnimationController _dotsController;
  int _dotCount = 0;

  @override
  void initState() {
    super.initState();
    _dotsController =
        AnimationController(
          duration: const Duration(milliseconds: 1500),
          vsync: this,
        )..addListener(() {
          setState(() {
            _dotCount = (_dotsController.value * 3).floor() % 4;
          });
        });
    _dotsController.repeat();
  }

  @override
  void dispose() {
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${widget.message}${'.' * _dotCount}',
      style: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        color: AppColors.textBlack,
      ),
    );
  }
}
