import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

/// 설정 화면
///
/// 앱 정보, 이용약관, 개인정보처리방침 등을
/// 확인할 수 있는 화면입니다.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('설정')),
      body: SafeArea(
        child: ListView(
          children: [
            // 앱 정보 섹션
            _buildSectionHeader(context, '앱 정보'),
            _buildListTile(
              context,
              icon: Icons.info_outline,
              title: '버전 정보',
              subtitle: 'v1.0.0',
              onTap: () {
                // 버전 정보 표시
              },
            ),

            const Divider(height: 32),

            // 약관 및 정책 섹션
            _buildSectionHeader(context, '약관 및 정책'),
            _buildListTile(
              context,
              icon: Icons.description_outlined,
              title: '이용약관',
              onTap: () {
                // TODO: 이용약관 웹뷰 표시
                _showComingSoonSnackBar(context, '이용약관');
              },
            ),
            _buildListTile(
              context,
              icon: Icons.privacy_tip_outlined,
              title: '개인정보처리방침',
              onTap: () {
                // TODO: 개인정보처리방침 웹뷰 표시
                _showComingSoonSnackBar(context, '개인정보처리방침');
              },
            ),

            const Divider(height: 32),

            // 지원 섹션
            _buildSectionHeader(context, '지원'),
            _buildListTile(
              context,
              icon: Icons.email_outlined,
              title: '문의하기',
              onTap: () {
                // TODO: 이메일 앱 실행
                _showComingSoonSnackBar(context, '문의하기');
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 섹션 헤더 위젯
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: AppColors.textGray,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// 리스트 타일 위젯
  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  /// 준비중 스낵바 표시
  void _showComingSoonSnackBar(BuildContext context, String feature) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$feature 기능은 준비 중입니다')));
  }
}
