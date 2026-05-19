# Modern Keyboard (Flutter + Kotlin IME)

A starter Android keyboard project with:
- Flutter UI for onboarding and settings (Material 3)
- Native Kotlin `InputMethodService` keyboard
- `MethodChannel` bridge for settings/actions
- `SharedPreferences` storage
- Portrait-focused UI and responsive keyboard rows

## Folder Structure

```text
lib/
  core/theme/app_theme.dart
  features/settings/
    data/keyboard_platform_service.dart
    domain/models/keyboard_settings.dart
    presentation/controllers/settings_controller.dart
    presentation/screens/onboarding_screen.dart
    presentation/screens/settings_screen.dart
    presentation/widgets/section_card.dart

android/app/src/main/
  AndroidManifest.xml
  kotlin/com/example/modern_keyboard/
    MainActivity.kt
    KeyboardSettingsRepository.kt
    ime/
      ModernKeyboardService.kt
      KeyboardStateManager.kt
  res/
    layout/ime_keyboard_view.xml
    xml/modern_keyboard_method.xml
    values/strings.xml
    values/ime_styles.xml
    values/dimens.xml
    drawable/key_background.xml
    drawable/key_special_background.xml
    drawable/key_space_background.xml
```

## MethodChannel Contract

Channel: `modern_keyboard/settings`

Methods:
- `loadSettings`
- `saveSettings`
- `openInputMethodSettings`
- `showInputMethodPicker`

## Input Method Setup (Android)

1. Install and open the app.
2. Tap **Enable** in the app.
3. In Android Settings, enable **Modern Keyboard**.
4. Go back and tap **Switch**.
5. Pick **Modern Keyboard** from the input picker.

## Run

```bash
flutter pub get
flutter run
```
