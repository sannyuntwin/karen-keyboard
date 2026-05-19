import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modern_keyboard/core/theme/app_theme.dart';
import 'package:modern_keyboard/features/settings/data/keyboard_platform_service.dart';
import 'package:modern_keyboard/features/settings/presentation/controllers/settings_controller.dart';
import 'package:modern_keyboard/features/settings/presentation/screens/onboarding_screen.dart';
import 'package:modern_keyboard/features/settings/presentation/screens/settings_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const ModernKeyboardApp());
}

class ModernKeyboardApp extends StatefulWidget {
  const ModernKeyboardApp({super.key});

  @override
  State<ModernKeyboardApp> createState() => _ModernKeyboardAppState();
}

class _ModernKeyboardAppState extends State<ModernKeyboardApp> {
  late final SettingsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SettingsController(KeyboardPlatformService())..initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Modern Keyboard',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _controller.settings.appThemeMode.asThemeMode,
          home: _controller.isLoading
              ? const _LoadingScreen()
              : _controller.settings.onboardingComplete
              ? SettingsScreen(controller: _controller)
              : OnboardingScreen(
                  onDone: () {
                    _controller.completeOnboarding();
                  },
                ),
        );
      },
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Preparing your keyboard...',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
