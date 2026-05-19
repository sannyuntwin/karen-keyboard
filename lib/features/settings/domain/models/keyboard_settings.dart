import 'package:flutter/material.dart';

enum AppThemeMode {
  system,
  light,
  dark;

  ThemeMode get asThemeMode {
    switch (this) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  static AppThemeMode fromStorage(String? value) {
    switch (value) {
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      default:
        return AppThemeMode.system;
    }
  }

  String toStorage() => name;
}

class KeyboardSettings {
  const KeyboardSettings({
    required this.onboardingComplete,
    required this.appThemeMode,
    required this.keyboardTheme,
    required this.activeLanguage,
    required this.enabledLanguages,
    required this.showNumberRow,
    required this.keySoundEnabled,
    required this.hapticFeedbackEnabled,
  });

  factory KeyboardSettings.defaults() {
    return const KeyboardSettings(
      onboardingComplete: false,
      appThemeMode: AppThemeMode.system,
      keyboardTheme: 'Ocean',
      activeLanguage: 'English',
      enabledLanguages: ['English', 'Myanmar'],
      showNumberRow: true,
      keySoundEnabled: false,
      hapticFeedbackEnabled: false,
    );
  }

  factory KeyboardSettings.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return KeyboardSettings.defaults();
    }
    final rawLanguages = map['enabledLanguages'];
    final languages = rawLanguages is List
        ? rawLanguages.map((e) => e.toString()).toList()
        : <String>['English', 'Myanmar'];

    return KeyboardSettings(
      onboardingComplete: map['onboardingComplete'] == true,
      appThemeMode: AppThemeMode.fromStorage(map['appThemeMode']?.toString()),
      keyboardTheme: map['keyboardTheme']?.toString() ?? 'Ocean',
      activeLanguage: map['activeLanguage']?.toString() ?? 'English',
      enabledLanguages: languages,
      showNumberRow: map['showNumberRow'] != false,
      keySoundEnabled: map['keySoundEnabled'] == true,
      hapticFeedbackEnabled: map['hapticFeedbackEnabled'] == true,
    );
  }

  final bool onboardingComplete;
  final AppThemeMode appThemeMode;
  final String keyboardTheme;
  final String activeLanguage;
  final List<String> enabledLanguages;
  final bool showNumberRow;
  final bool keySoundEnabled;
  final bool hapticFeedbackEnabled;

  KeyboardSettings copyWith({
    bool? onboardingComplete,
    AppThemeMode? appThemeMode,
    String? keyboardTheme,
    String? activeLanguage,
    List<String>? enabledLanguages,
    bool? showNumberRow,
    bool? keySoundEnabled,
    bool? hapticFeedbackEnabled,
  }) {
    return KeyboardSettings(
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      appThemeMode: appThemeMode ?? this.appThemeMode,
      keyboardTheme: keyboardTheme ?? this.keyboardTheme,
      activeLanguage: activeLanguage ?? this.activeLanguage,
      enabledLanguages: enabledLanguages ?? this.enabledLanguages,
      showNumberRow: showNumberRow ?? this.showNumberRow,
      keySoundEnabled: keySoundEnabled ?? this.keySoundEnabled,
      hapticFeedbackEnabled:
          hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'onboardingComplete': onboardingComplete,
      'appThemeMode': appThemeMode.toStorage(),
      'keyboardTheme': keyboardTheme,
      'activeLanguage': activeLanguage,
      'enabledLanguages': enabledLanguages,
      'showNumberRow': showNumberRow,
      'keySoundEnabled': keySoundEnabled,
      'hapticFeedbackEnabled': hapticFeedbackEnabled,
    };
  }
}
