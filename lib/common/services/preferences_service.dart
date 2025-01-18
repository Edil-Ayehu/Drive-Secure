import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _hasSeenOnboardingKey = 'has_seen_onboarding';
  static PreferencesService? _instance;
  final SharedPreferences _prefs;

  PreferencesService._(this._prefs);

  static Future<PreferencesService> getInstance() async {
    if (_instance == null) {
      try {
        final prefs = await SharedPreferences.getInstance();
        _instance = PreferencesService._(prefs);
      } catch (e) {
        // Return a default instance if SharedPreferences fails
        final prefs = await SharedPreferences.getInstance();
        _instance = PreferencesService._(prefs);
      }
    }
    return _instance!;
  }

  bool get hasSeenOnboarding => _prefs.getBool(_hasSeenOnboardingKey) ?? false;

  Future<void> setHasSeenOnboarding() async {
    await _prefs.setBool(_hasSeenOnboardingKey, true);
  }
}