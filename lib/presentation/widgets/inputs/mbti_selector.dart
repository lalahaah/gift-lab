import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

/// MBTI 선택 위젯
///
/// E/I, N/S, T/F, J/P 4가지 차원을 토글 버튼으로 선택하고,
/// "모름" 옵션도 제공합니다.
class MbtiSelector extends StatefulWidget {
  /// 초기 MBTI 값
  final String? initialMbti;

  /// 초기 모름 상태
  final bool initialUnknown;

  /// MBTI 변경 콜백
  final ValueChanged<String?> onMbtiChanged;

  /// 모름 상태 변경 콜백
  final ValueChanged<bool> onUnknownChanged;

  const MbtiSelector({
    super.key,
    this.initialMbti,
    this.initialUnknown = false,
    required this.onMbtiChanged,
    required this.onUnknownChanged,
  });

  @override
  State<MbtiSelector> createState() => _MbtiSelectorState();
}

class _MbtiSelectorState extends State<MbtiSelector> {
  // 각 차원의 선택 상태 (true = 왼쪽, false = 오른쪽)
  bool? _eOrI; // E(true) / I(false)
  bool? _nOrS; // N(true) / S(false)
  bool? _tOrF; // T(true) / F(false)
  bool? _jOrP; // J(true) / P(false)

  bool _isUnknown = false;

  @override
  void initState() {
    super.initState();
    _isUnknown = widget.initialUnknown;

    if (widget.initialMbti != null && widget.initialMbti!.length == 4) {
      _eOrI = widget.initialMbti![0] == 'E';
      _nOrS = widget.initialMbti![1] == 'N';
      _tOrF = widget.initialMbti![2] == 'T';
      _jOrP = widget.initialMbti![3] == 'J';
    }
  }

  /// 현재 선택된 MBTI 문자열 생성
  String? get _currentMbti {
    if (_eOrI == null || _nOrS == null || _tOrF == null || _jOrP == null) {
      return null;
    }
    return '${_eOrI! ? 'E' : 'I'}${_nOrS! ? 'N' : 'S'}${_tOrF! ? 'T' : 'F'}${_jOrP! ? 'J' : 'P'}';
  }

  /// MBTI 변경 시 호출
  void _updateMbti() {
    widget.onMbtiChanged(_currentMbti);
  }

  /// 모름 체크박스 토글
  void _toggleUnknown(bool? value) {
    setState(() {
      _isUnknown = value ?? false;
    });
    widget.onUnknownChanged(_isUnknown);

    if (_isUnknown) {
      // 모름 선택 시 MBTI 초기화
      setState(() {
        _eOrI = null;
        _nOrS = null;
        _tOrF = null;
        _jOrP = null;
      });
      widget.onMbtiChanged(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // MBTI 토글 버튼들
        Opacity(
          opacity: _isUnknown ? 0.3 : 1.0,
          child: AbsorbPointer(
            absorbing: _isUnknown,
            child: Column(
              children: [
                _buildToggle('E', 'I', _eOrI, (val) {
                  setState(() => _eOrI = val);
                  _updateMbti();
                }),
                const SizedBox(height: AppSpacing.m),
                _buildToggle('N', 'S', _nOrS, (val) {
                  setState(() => _nOrS = val);
                  _updateMbti();
                }),
                const SizedBox(height: AppSpacing.m),
                _buildToggle('T', 'F', _tOrF, (val) {
                  setState(() => _tOrF = val);
                  _updateMbti();
                }),
                const SizedBox(height: AppSpacing.m),
                _buildToggle('J', 'P', _jOrP, (val) {
                  setState(() => _jOrP = val);
                  _updateMbti();
                }),
              ],
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.l),

        // 선택된 MBTI 표시
        if (!_isUnknown && _currentMbti != null)
          Container(
            padding: const EdgeInsets.all(AppSpacing.m),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.labIndigo.withValues(alpha: 0.1),
                  AppColors.mintSpark.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.labIndigo.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.psychology, color: AppColors.labIndigo, size: 20),
                const SizedBox(width: AppSpacing.s),
                Text(
                  _currentMbti!,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.labIndigo,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: AppSpacing.m),

        // 모름 체크박스
        InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            _toggleUnknown(!_isUnknown);
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s,
              vertical: AppSpacing.s,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _isUnknown,
                    onChanged: _toggleUnknown,
                    activeColor: AppColors.labIndigo,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.s),
                Text(
                  'MBTI를 모르겠어요',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.textBlack),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// 토글 버튼 빌더
  Widget _buildToggle(
    String leftLabel,
    String rightLabel,
    bool? value,
    ValueChanged<bool> onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildToggleButton(
            label: leftLabel,
            isSelected: value == true,
            onTap: () {
              HapticFeedback.lightImpact();
              onChanged(true);
            },
          ),
        ),
        const SizedBox(width: AppSpacing.m),
        Expanded(
          child: _buildToggleButton(
            label: rightLabel,
            isSelected: value == false,
            onTap: () {
              HapticFeedback.lightImpact();
              onChanged(false);
            },
          ),
        ),
      ],
    );
  }

  /// 토글 버튼 (개별)
  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.l),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.labIndigo.withValues(alpha: 0.9)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.labIndigo
                : AppColors.gray100.withValues(alpha: 0.5),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.labIndigo.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: isSelected ? Colors.white : AppColors.textGray,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
