import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum AppCurrency { bdt, usd }

class AppProvider extends ChangeNotifier {
  final Box _settingsBox = Hive.box('settings');

  Locale _locale = const Locale('bn');
  AppCurrency _currency = AppCurrency.bdt;
  ThemeMode _themeMode = ThemeMode.system;
  bool _notificationsEnabled = true;

  AppProvider() {
    _loadSettings();
  }

  void _loadSettings() {
    final langCode = _settingsBox.get('languageCode', defaultValue: 'bn');
    _locale = Locale(langCode);
    
    final currencyStr = _settingsBox.get('currency', defaultValue: 'bdt');
    _currency = AppCurrency.values.firstWhere(
      (e) => e.toString() == 'AppCurrency.$currencyStr',
      orElse: () => AppCurrency.bdt,
    );
    
    final themeStr = _settingsBox.get('themeMode', defaultValue: 'system');
    _themeMode = ThemeMode.values.firstWhere(
      (e) => e.name == themeStr,
      orElse: () => ThemeMode.system,
    );
    
    _notificationsEnabled = _settingsBox.get('notificationsEnabled', defaultValue: true);
  }

  Locale get locale => _locale;
  AppCurrency get currency => _currency;
  ThemeMode get themeMode => _themeMode;
  bool get notificationsEnabled => _notificationsEnabled;

  void setLocale(Locale locale) {
    _locale = locale;
    _settingsBox.put('languageCode', locale.languageCode);
    notifyListeners();
  }

  void setCurrency(AppCurrency currency) {
    _currency = currency;
    _settingsBox.put('currency', currency.name);
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    _settingsBox.put('themeMode', mode.name);
    notifyListeners();
  }
  
  void setNotificationsEnabled(bool enabled) {
    _notificationsEnabled = enabled;
    _settingsBox.put('notificationsEnabled', enabled);
    notifyListeners();
  }

  String formatCurrency(double amount) {
    if (_currency == AppCurrency.bdt) {
      return '৳${amount.toStringAsFixed(0)}';
    }
    return '\$${amount.toStringAsFixed(2)}';
  }

  String formatNumber(int number) {
    if (_locale.languageCode == 'bn') {
      return _toBengaliNumber(number.toString());
    }
    return number.toString();
  }

  String _toBengaliNumber(String num) {
    const bengaliNumerals = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    return num.replaceAllMapped(
      RegExp(r'\d'),
      (match) => bengaliNumerals[int.parse(match.group(0)!)],
    );
  }
}
