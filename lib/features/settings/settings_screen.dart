import 'package:flutter/material.dart';
import 'package:home_rental_management/core/localization/app_localizations.dart';
import '../../../core/widgets/custom_app_bar.dart';

import 'package:provider/provider.dart';
import '../../utils/app_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBar(
        title: localizations.settings,
        showBackButton: false,
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
                        value: AppCurrency.bdt,
                        child: Text('BDT (৳)'),
                      ),
                      DropdownMenuItem(
                        value: AppCurrency.usd,
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
                    value: appProvider.notificationsEnabled,
                    onChanged: (value) {
                      appProvider.setNotificationsEnabled(value);
                    },
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
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.5),
            ),
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
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Theme.of(context).colorScheme.onPrimaryContainer, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
            )
          : null,
      trailing:
          trailing ?? (onTap != null ? Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurfaceVariant) : null),
      onTap: onTap,
    );
  }
}
