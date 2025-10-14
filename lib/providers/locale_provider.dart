import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('tr'); // Default to Turkish
  static const String _localeKey = 'selected_locale';

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  /// Load saved locale from SharedPreferences
  Future<void> _loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final localeCode = prefs.getString(_localeKey);
      if (localeCode != null) {
        _locale = Locale(localeCode);
        notifyListeners();
      }
    } catch (e) {
      print('Error loading locale: $e');
    }
  }

  /// Change locale and save to SharedPreferences
  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;

    try {
      _locale = locale;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, locale.languageCode);
      notifyListeners();
    } catch (e) {
      print('Error saving locale: $e');
    }
  }

  /// Toggle between Turkish and English
  Future<void> toggleLanguage() async {
    final newLocale = _locale.languageCode == 'tr' 
        ? const Locale('en') 
        : const Locale('tr');
    await setLocale(newLocale);
  }

  /// Get current language name
  String get currentLanguageName {
    return _locale.languageCode == 'tr' ? 'Türkçe' : 'English';
  }

  /// Check if current locale is Turkish
  bool get isTurkish => _locale.languageCode == 'tr';

  /// Check if current locale is English
  bool get isEnglish => _locale.languageCode == 'en';
}
