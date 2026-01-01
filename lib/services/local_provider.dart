import 'package:flutter/material.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en'); // default English

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (!['en', 'fr'].contains(locale.languageCode)) return;
    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = const Locale('en'); // fallback to English
    notifyListeners();
  }
}

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en'); // default

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    if (_locale == locale) return; // avoid rebuilds if same
    _locale = locale;
    notifyListeners();
  }
}
