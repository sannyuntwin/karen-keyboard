import 'package:flutter/services.dart';
import 'package:modern_keyboard/features/settings/domain/models/keyboard_settings.dart';

class KeyboardPlatformService {
  static const MethodChannel _channel = MethodChannel(
    'modern_keyboard/settings',
  );

  Future<KeyboardSettings> loadSettings() async {
    final result = await _channel.invokeMethod<Map<dynamic, dynamic>>(
      'loadSettings',
    );
    return KeyboardSettings.fromMap(result);
  }

  Future<void> saveSettings(KeyboardSettings settings) async {
    await _channel.invokeMethod<void>('saveSettings', {
      'settings': settings.toMap(),
    });
  }

  Future<void> openInputMethodSettings() async {
    await _channel.invokeMethod<void>('openInputMethodSettings');
  }

  Future<void> showInputMethodPicker() async {
    await _channel.invokeMethod<void>('showInputMethodPicker');
  }
}
