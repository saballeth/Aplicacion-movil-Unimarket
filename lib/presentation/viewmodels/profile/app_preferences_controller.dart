import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferencesController extends ChangeNotifier {
  static const String _kDarkMode = 'app_pref_dark_mode';
  static const String _kAutoPlay = 'app_pref_auto_play';
  static const String _kKeepSearchHistory = 'app_pref_keep_search_history';
  static const String _kPersonalizedRecommendations =
      'app_pref_personalized_recommendations';
  static const String _kLanguage = 'app_pref_language';
  static const String _kSearchHistory = 'app_pref_search_history';

  final SharedPreferences preferences;

  bool darkMode = false;
  bool autoPlay = true;
  bool keepSearchHistory = true;
  bool personalizedRecommendations = true;
  String languageCode = 'es';
  final List<String> _searchHistory = [];

  AppPreferencesController(this.preferences);

  ThemeMode get themeMode => darkMode ? ThemeMode.dark : ThemeMode.light;

  Locale get locale => Locale(languageCode);

  String get languageLabel {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'pt':
        return 'Português';
      case 'es':
      default:
        return 'Español';
    }
  }

  List<String> get searchHistory => List.unmodifiable(_searchHistory);

  Future<void> load() async {
    darkMode = preferences.getBool(_kDarkMode) ?? darkMode;
    autoPlay = preferences.getBool(_kAutoPlay) ?? autoPlay;
    keepSearchHistory =
        preferences.getBool(_kKeepSearchHistory) ?? keepSearchHistory;
    personalizedRecommendations =
        preferences.getBool(_kPersonalizedRecommendations) ??
            personalizedRecommendations;
    languageCode = preferences.getString(_kLanguage) ?? languageCode;
    _searchHistory
      ..clear()
      ..addAll(preferences.getStringList(_kSearchHistory) ?? const []);
    notifyListeners();
  }

  Future<void> toggleDarkMode(bool value) async {
    darkMode = value;
    await preferences.setBool(_kDarkMode, value);
    notifyListeners();
  }

  Future<void> toggleAutoPlay(bool value) async {
    autoPlay = value;
    await preferences.setBool(_kAutoPlay, value);
    notifyListeners();
  }

  Future<void> toggleKeepSearchHistory(bool value) async {
    keepSearchHistory = value;
    await preferences.setBool(_kKeepSearchHistory, value);
    if (!value) {
      _searchHistory.clear();
      await preferences.remove(_kSearchHistory);
    }
    notifyListeners();
  }

  Future<void> togglePersonalizedRecommendations(bool value) async {
    personalizedRecommendations = value;
    await preferences.setBool(_kPersonalizedRecommendations, value);
    notifyListeners();
  }

  Future<void> setLanguage(String value) async {
    languageCode = value;
    await preferences.setString(_kLanguage, value);
    notifyListeners();
  }

  Future<void> recordSearch(String query) async {
    if (!keepSearchHistory) {
      return;
    }

    final cleaned = query.trim();
    if (cleaned.isEmpty) {
      return;
    }

    _searchHistory.removeWhere((item) => item.toLowerCase() == cleaned.toLowerCase());
    _searchHistory.insert(0, cleaned);
    if (_searchHistory.length > 8) {
      _searchHistory.removeRange(8, _searchHistory.length);
    }
    await preferences.setStringList(_kSearchHistory, _searchHistory);
    notifyListeners();
  }

  Future<void> clearSearchHistory() async {
    _searchHistory.clear();
    await preferences.remove(_kSearchHistory);
    notifyListeners();
  }
}