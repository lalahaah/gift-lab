import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

/// 예산 범위 슬라이더 위젯
///
/// RangeSlider를 사용하여 최소/최대 예산을 설정합니다.
/// 1만원 ~ 50만원 이상의 범위를 지원합니다.
class BudgetSlider extends StatefulWidget {
  /// 초기 최소 예산
  final int initialMinBudget;

  /// 초기 최대 예산
  final int initialMaxBudget;

  /// 예산 변경 콜백
  final void Function(int min, int max) onBudgetChanged;

  const BudgetSlider({
    super.key,
    this.initialMinBudget = 10000,
    this.initialMaxBudget = 50000,
    required this.onBudgetChanged,
  });

  @override
  State<BudgetSlider> createState() => _BudgetSliderState();
}

class _BudgetSliderState extends State<BudgetSlider> {
  late RangeValues _currentRange;

  // 슬라이더 최소/최대값 (원 단위)
  static const double _min = 10000; // 1만원
  static const double _max = 500000; // 50만원

  @override
  void initState() {
    super.initState();
    _currentRange = RangeValues(
      widget.initialMinBudget.toDouble(),
      widget.initialMaxBudget.toDouble(),
    );
  }

  /// 금액을 읽기 쉬운 형식으로 변환
  String _formatBudget(double value) {
    final intValue = value.toInt();
    if (intValue >= 10000) {
      final manwon = intValue ~/ 10000;
      final remainder = intValue % 10000;
      if (remainder == 0) {
        return '$manwon만원';
      } else {
        return '$manwon만 ${remainder ~/ 1000}천원';
      }
    } else {
      return '${intValue ~/ 1000}천원';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 현재 선택된 예산 범위 표시
        Container(
          padding: const EdgeInsets.all(AppSpacing.l),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.labIndigo.withValues(alpha: 0.1),
                AppColors.mintSpark.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.labIndigo.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '최소 금액',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textGray,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatBudget(_currentRange.start),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.labIndigo,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.arrow_forward, color: AppColors.textGray),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '최대 금액',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textGray,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatBudget(_currentRange.end),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.mintSpark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.l),

        // 슬라이더
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: AppColors.labIndigo,
            inactiveTrackColor: AppColors.gray100,
            thumbColor: Colors.white,
            overlayColor: AppColors.labIndigo.withValues(alpha: 0.2),
            rangeThumbShape: const RoundRangeSliderThumbShape(
              enabledThumbRadius: 14,
              elevation: 4,
            ),
            rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
            trackHeight: 6,
          ),
          child: RangeSlider(
            values: _currentRange,
            min: _min,
            max: _max,
            divisions: 49, // 1만원 단위로 나눔
            onChanged: (RangeValues values) {
              HapticFeedback.selectionClick();
              setState(() {
                _currentRange = values;
              });
            },
            onChangeEnd: (RangeValues values) {
              widget.onBudgetChanged(values.start.toInt(), values.end.toInt());
            },
          ),
        ),

        const SizedBox(height: AppSpacing.m),

        // 프리셋 버튼들
        Wrap(
          spacing: AppSpacing.s,
          runSpacing: AppSpacing.s,
          children: [
            _buildPresetButton('1~3만원', 10000, 30000),
            _buildPresetButton('3~5만원', 30000, 50000),
            _buildPresetButton('5~10만원', 50000, 100000),
            _buildPresetButton('10~20만원', 100000, 200000),
            _buildPresetButton('20만원 이상', 200000, 500000),
          ],
        ),
      ],
    );
  }

  /// 프리셋 버튼
  Widget _buildPresetButton(String label, int min, int max) {
    final isSelected = _currentRange.start == min && _currentRange.end == max;

    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _currentRange = RangeValues(min.toDouble(), max.toDouble());
        });
        widget.onBudgetChanged(min, max);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.s,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.mintSpark.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.mintSpark : AppColors.gray100,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: isSelected ? AppColors.mintSpark : AppColors.textGray,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
