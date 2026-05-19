import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:modern_keyboard/main.dart';

void main() {
  const channel = MethodChannel('modern_keyboard/settings');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          if (call.method == 'loadSettings') {
            return <String, dynamic>{
              'onboardingComplete': false,
              'appThemeMode': 'system',
              'keyboardTheme': 'Ocean',
              'activeLanguage': 'English',
              'enabledLanguages': <String>['English', 'Myanmar'],
              'showNumberRow': true,
              'keySoundEnabled': false,
              'hapticFeedbackEnabled': false,
            };
          }
          return true;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  testWidgets('shows onboarding on first launch', (tester) async {
    await tester.pumpWidget(const ModernKeyboardApp());
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Modern Typing'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });
}
