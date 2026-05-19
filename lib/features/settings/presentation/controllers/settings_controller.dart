import 'package:flutter/foundation.dart';
import 'package:modern_keyboard/features/settings/data/keyboard_platform_service.dart';
import 'package:modern_keyboard/features/settings/domain/models/keyboard_settings.dart';

class SettingsController extends ChangeNotifier {
  SettingsController(this._platformService);

  final KeyboardPlatformService _platformService;

  KeyboardSettings _settings = KeyboardSettings.defaults();
  bool _isLoading = true;

  KeyboardSettings get settings => _settings;
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    try {
      _settings = await _platformService.loadSettings();
    } catch (_) {
      _settings = KeyboardSettings.defaults();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> completeOnboarding() async {
    _settings = _settings.copyWith(onboardingComplete: true);
    await _persist();
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    _settings = _settings.copyWith(appThemeMode: mode);
    await _persist();
  }

  Future<void> setKeyboardTheme(String themeName) async {
    _settings = _settings.copyWith(keyboardTheme: themeName);
    await _persist();
  }

  Future<void> setActiveLanguage(String language) async {
    _settings = _settings.copyWith(activeLanguage: language);
    await _persist();
  }

  Future<void> setShowNumberRow(bool enabled) async {
    _settings = _settings.copyWith(showNumberRow: enabled);
    await _persist();
  }

  Future<void> setKeySoundEnabled(bool enabled) async {
    _settings = _settings.copyWith(keySoundEnabled: enabled);
    await _persist();
  }

  Future<void> setHapticFeedbackEnabled(bool enabled) async {
    _settings = _settings.copyWith(hapticFeedbackEnabled: enabled);
    await _persist();
  }

  Future<void> openInputMethodSettings() {
    return _platformService.openInputMethodSettings();
  }

  Future<void> showInputMethodPicker() {
    return _platformService.showInputMethodPicker();
  }

  Future<void> _persist() async {
    notifyListeners();
    await _platformService.saveSettings(_settings);
  }
}
