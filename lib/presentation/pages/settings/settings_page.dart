import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

/// 설정 페이지
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('settings.title'.tr())),
      body: ListView(
        children: [
          // 언어 설정
          _buildSectionHeader(context, 'settings.language'.tr()),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text('settings.select_language'.tr()),
            subtitle: Text(_getCurrentLanguageName(context)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageDialog(context),
          ),
          const Divider(),

          // 앱 정보
          _buildSectionHeader(context, 'settings.app_info'.tr()),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text('settings.version'.tr()),
            subtitle: const Text('1.0.0'),
          ),
          const Divider(),

          // 약관 및 정책
          _buildSectionHeader(context, 'settings.legal'.tr()),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text('settings.terms'.tr()),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 이용약관 웹뷰 표시
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('settings.terms'.tr())));
            },
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text('settings.privacy'.tr()),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 개인정보처리방침 웹뷰 표시
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('settings.privacy'.tr())));
            },
          ),
          const Divider(),

          // 문의하기
          _buildSectionHeader(context, 'settings.support'.tr()),
          ListTile(
            leading: const Icon(Icons.email_outlined),
            title: Text('settings.contact'.tr()),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 이메일 앱 실행
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('settings.contact'.tr())));
            },
          ),
        ],
      ),
    );
  }

  /// 섹션 헤더 위젯
  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// 현재 언어 이름 가져오기
  String _getCurrentLanguageName(BuildContext context) {
    final locale = context.locale;
    if (locale.languageCode == 'ko') {
      return 'settings.korean'.tr();
    } else if (locale.languageCode == 'en') {
      return 'settings.english'.tr();
    }
    return 'settings.korean'.tr();
  }

  /// 언어 선택 다이얼로그 표시
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('settings.select_language'.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<Locale>(
                title: Text('settings.korean'.tr()),
                value: const Locale('ko'),
                groupValue: context.locale,
                onChanged: (Locale? value) {
                  if (value != null) {
                    context.setLocale(value);
                    Navigator.of(dialogContext).pop();
                  }
                },
              ),
              RadioListTile<Locale>(
                title: Text('settings.english'.tr()),
                value: const Locale('en'),
                groupValue: context.locale,
                onChanged: (Locale? value) {
                  if (value != null) {
                    context.setLocale(value);
                    Navigator.of(dialogContext).pop();
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('common.cancel'.tr()),
            ),
          ],
        );
      },
    );
  }
}
