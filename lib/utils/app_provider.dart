import 'package:flutter/material.dart';

enum AppCurrency { BDT, USD }

class AppProvider extends ChangeNotifier {
  Locale _locale = const Locale('bn'); // Default to Bengali for Bangladesh
  AppCurrency _currency = AppCurrency.BDT; // Default to BDT

  Locale get locale => _locale;
  AppCurrency get currency => _currency;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  void setCurrency(AppCurrency currency) {
    _currency = currency;
    notifyListeners();
  }

  String formatCurrency(double amount) {
    if (_currency == AppCurrency.BDT) {
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
