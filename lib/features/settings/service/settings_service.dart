import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const _keyApiUrl = 'api_url';
  static const _keyRefreshInterval = 'refresh_interval';
  static const _keySlaEnabled = 'sla_enabled';
  static const _keyWarningMinutes = 'warning_minutes';
  static const _keyCriticalMinutes = 'critical_minutes';
  static const _keySoundEnable = 'sound_enable';

  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String get apiUrl => _prefs.getString(_keyApiUrl) ?? 'http://127.0.0.1:9000';
  int get refreshInterval => _prefs.getInt(_keyRefreshInterval) ?? 5;
  bool get isSlaEnables => _prefs.getBool(_keySlaEnabled) ?? false;
  int get warningMinutes => _prefs.getInt(_keyWarningMinutes) ?? 30;
  int get criticalMinutes => _prefs.getInt(_keyCriticalMinutes) ?? 60;
  bool get isSoundEnabled => _prefs.getBool(_keySoundEnable) ?? false;

  Future<void> setApiUrl(String value) async {
    final cleanUrl = value.endsWith('/')
        ? value.substring(0, value.length - 1)
        : value;
    await _prefs.setString(_keyApiUrl, cleanUrl);
  }

  Future<void> setRefreshInterval(int value) async =>
      await _prefs.setInt(_keyRefreshInterval, value);

  Future<void> setSlaEnabled(bool value) async =>
      await _prefs.setBool(_keySlaEnabled, value);

  Future<void> setWarningMinutes(int value) async =>
      await _prefs.setInt(_keyWarningMinutes, value);

  Future<void> setCriticalMinutes(int value) async =>
      await _prefs.setInt(_keyCriticalMinutes, value);

  Future<void> setSoundEnabled(bool value) async =>
      await _prefs.setBool(_keySoundEnable, value);
}
