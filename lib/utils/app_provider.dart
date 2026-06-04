import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum AppCurrency { bdt, usd }

class AppProvider extends ChangeNotifier {
  final Box _settingsBox = Hive.box('settings');

  Locale _locale = const Locale('bn');
  AppCurrency _currency = AppCurrency.bdt;

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
  }

  Locale get locale => _locale;
  AppCurrency get currency => _currency;

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
