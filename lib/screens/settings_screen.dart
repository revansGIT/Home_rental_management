import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../utils/app_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          localizations.appSettings,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language Setting
            _SettingsSection(
              title: localizations.language,
              children: [
                _SettingsTile(
                  icon: Icons.language,
                  title: localizations.displayLanguage,
                  trailing: DropdownButton<Locale>(
                    value: appProvider.locale,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: Locale('en'),
                        child: Text('English'),
                      ),
                      DropdownMenuItem(
                        value: Locale('bn'),
                        child: Text('বাংলা'),
                      ),
                    ],
                    onChanged: (locale) {
                      if (locale != null) {
                        appProvider.setLocale(locale);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Currency Setting
            _SettingsSection(
              title: localizations.currency,
              children: [
                _SettingsTile(
                  icon: Icons.attach_money,
                  title: localizations.setCurrency,
                  trailing: DropdownButton<AppCurrency>(
                    value: appProvider.currency,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: AppCurrency.BDT,
                        child: Text('BDT (৳)'),
                      ),
                      DropdownMenuItem(
                        value: AppCurrency.USD,
                        child: Text('USD (\$)'),
                      ),
                    ],
                    onChanged: (currency) {
                      if (currency != null) {
                        appProvider.setCurrency(currency);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Notifications
            _SettingsSection(
              title: localizations.notifications,
              children: [
                _SettingsTile(
                  icon: Icons.notifications,
                  title: localizations.notifications,
                  subtitle: localizations.notificationDesc,
                  trailing: Switch(
                    value: true,
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Appearance
            _SettingsSection(
              title: 'Appearance',
              children: [
                _SettingsTile(
                  icon: Icons.dark_mode,
                  title: localizations.darkMode,
                  subtitle: localizations.enableDarkTheme,
                  trailing: Switch(
                    value: false,
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Data & Security
            _SettingsSection(
              title: localizations.dataSecurity,
              children: [
                _SettingsTile(
                  icon: Icons.backup,
                  title: localizations.backupRestore,
                  subtitle: localizations.backupDesc,
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.security,
                  title: localizations.privacySecurity,
                  subtitle: localizations.privacyDesc,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Support
            _SettingsSection(
              title: localizations.support,
              children: [
                _SettingsTile(
                  icon: Icons.help_outline,
                  title: localizations.helpCenter,
                  subtitle: localizations.helpDesc,
                  onTap: () {},
                ),
                _SettingsTile(
                  icon: Icons.contact_support,
                  title: localizations.contactSupport,
                  subtitle: localizations.supportDesc,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),

            // App Info
            _SettingsSection(
              title: 'About',
              children: [
                _SettingsTile(
                  icon: Icons.info_outline,
                  title: localizations.appVersion,
                  trailing: const Text('1.0.0'),
                ),
                _SettingsTile(
                  icon: Icons.schedule,
                  title: localizations.lastBackup,
                  trailing: const Text('Jan 26, 2024'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.logout),
                label: Text(localizations.logout),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.blue[700], size: 24),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            )
          : null,
      trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right) : null),
      onTap: onTap,
    );
  }
}
