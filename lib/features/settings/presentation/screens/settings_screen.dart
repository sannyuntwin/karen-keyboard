import 'package:flutter/material.dart';
import 'package:modern_keyboard/features/settings/domain/models/keyboard_settings.dart';
import 'package:modern_keyboard/features/settings/presentation/controllers/settings_controller.dart';
import 'package:modern_keyboard/features/settings/presentation/widgets/section_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.controller});

  final SettingsController controller;

  static const _languages = ['English', 'Myanmar', 'Spanish'];
  static const _themes = ['Ocean', 'Graphite', 'Sunset'];

  @override
  Widget build(BuildContext context) {
    final settings = controller.settings;
    return Scaffold(
      appBar: AppBar(title: const Text('Modern Keyboard'), centerTitle: false),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          SectionCard(
            title: 'Enable Keyboard',
            icon: Icons.keyboard_command_key,
            child: Column(
              children: [
                _InstructionTile(
                  number: 1,
                  text: 'Tap Enable and turn on Modern Keyboard in Android.',
                ),
                const SizedBox(height: 10),
                _InstructionTile(
                  number: 2,
                  text: 'Tap Switch to make it your active keyboard.',
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: controller.openInputMethodSettings,
                        child: const Text('Enable'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: controller.showInputMethodPicker,
                        child: const Text('Switch'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SectionCard(
            title: 'Appearance',
            icon: Icons.palette_outlined,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('App Mode'),
                const SizedBox(height: 8),
                SegmentedButton<AppThemeMode>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(
                      value: AppThemeMode.system,
                      label: Text('System'),
                    ),
                    ButtonSegment(
                      value: AppThemeMode.light,
                      label: Text('Light'),
                    ),
                    ButtonSegment(
                      value: AppThemeMode.dark,
                      label: Text('Dark'),
                    ),
                  ],
                  selected: {settings.appThemeMode},
                  onSelectionChanged: (selection) {
                    controller.setThemeMode(selection.first);
                  },
                ),
                const SizedBox(height: 14),
                const Text('Keyboard Theme'),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _themes.map((theme) {
                    final selected = settings.keyboardTheme == theme;
                    return ChoiceChip(
                      label: Text(theme),
                      selected: selected,
                      onSelected: (_) => controller.setKeyboardTheme(theme),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: _previewGradientForTheme(settings.keyboardTheme),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Keyboard Preview',
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(
                        Icons.keyboard_rounded,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          SectionCard(
            title: 'Language',
            icon: Icons.language,
            child: Wrap(
              spacing: 8,
              children: _languages.map((language) {
                return ChoiceChip(
                  label: Text(language),
                  selected: settings.activeLanguage == language,
                  onSelected: (_) => controller.setActiveLanguage(language),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),
          SectionCard(
            title: 'Keyboard Settings',
            icon: Icons.tune,
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Show number row'),
                  value: settings.showNumberRow,
                  onChanged: controller.setShowNumberRow,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Key sound'),
                  value: settings.keySoundEnabled,
                  onChanged: controller.setKeySoundEnabled,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Haptic feedback'),
                  value: settings.hapticFeedbackEnabled,
                  onChanged: controller.setHapticFeedbackEnabled,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _previewGradientForTheme(String theme) {
    switch (theme) {
      case 'Graphite':
        return const [Color(0xFF37474F), Color(0xFF263238)];
      case 'Sunset':
        return const [Color(0xFFFF7043), Color(0xFFE53935)];
      default:
        return const [Color(0xFF1E88E5), Color(0xFF1565C0)];
    }
  }
}

class _InstructionTile extends StatelessWidget {
  const _InstructionTile({required this.number, required this.text});

  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 12,
          child: Text('$number', style: Theme.of(context).textTheme.labelSmall),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(text)),
      ],
    );
  }
}
