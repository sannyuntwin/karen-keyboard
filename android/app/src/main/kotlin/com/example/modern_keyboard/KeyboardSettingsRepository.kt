package com.example.modern_keyboard

import android.content.Context
import android.content.SharedPreferences

class KeyboardSettingsRepository(context: Context) {
    private val prefs: SharedPreferences =
        context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE)

    fun getAllSettings(): Map<String, Any> {
        return mapOf(
            KEY_ONBOARDING_COMPLETE to prefs.getBoolean(KEY_ONBOARDING_COMPLETE, false),
            KEY_APP_THEME_MODE to prefs.getString(KEY_APP_THEME_MODE, "system").orEmpty(),
            KEY_KEYBOARD_THEME to prefs.getString(KEY_KEYBOARD_THEME, "Ocean").orEmpty(),
            KEY_ACTIVE_LANGUAGE to prefs.getString(KEY_ACTIVE_LANGUAGE, "English").orEmpty(),
            KEY_ENABLED_LANGUAGES to getEnabledLanguages(),
            KEY_SHOW_NUMBER_ROW to prefs.getBoolean(KEY_SHOW_NUMBER_ROW, true),
            KEY_KEY_SOUND to prefs.getBoolean(KEY_KEY_SOUND, false),
            KEY_HAPTIC_FEEDBACK to prefs.getBoolean(KEY_HAPTIC_FEEDBACK, false),
        )
    }

    fun saveFromMap(settings: Map<String, Any?>) {
        val editor = prefs.edit()
        settings.forEach { (key, value) ->
            when (key) {
                KEY_ONBOARDING_COMPLETE -> editor.putBoolean(key, value as? Boolean ?: false)
                KEY_APP_THEME_MODE,
                KEY_KEYBOARD_THEME,
                KEY_ACTIVE_LANGUAGE -> editor.putString(key, value?.toString())

                KEY_SHOW_NUMBER_ROW,
                KEY_KEY_SOUND,
                KEY_HAPTIC_FEEDBACK -> editor.putBoolean(key, value as? Boolean ?: false)

                KEY_ENABLED_LANGUAGES -> {
                    val languages = (value as? List<*>)?.map { it.toString() }
                        ?: listOf("English", "Myanmar")
                    editor.putString(key, languages.joinToString(separator = ","))
                }
            }
        }
        editor.apply()
    }

    fun getEnabledLanguages(): List<String> {
        val saved = prefs.getString(KEY_ENABLED_LANGUAGES, "English,Myanmar").orEmpty()
        return saved.split(",").map { it.trim() }.filter { it.isNotEmpty() }
    }

    companion object {
        const val PREF_NAME = "modern_keyboard_prefs"
        const val KEY_ONBOARDING_COMPLETE = "onboardingComplete"
        const val KEY_APP_THEME_MODE = "appThemeMode"
        const val KEY_KEYBOARD_THEME = "keyboardTheme"
        const val KEY_ACTIVE_LANGUAGE = "activeLanguage"
        const val KEY_ENABLED_LANGUAGES = "enabledLanguages"
        const val KEY_SHOW_NUMBER_ROW = "showNumberRow"
        const val KEY_KEY_SOUND = "keySoundEnabled"
        const val KEY_HAPTIC_FEEDBACK = "hapticFeedbackEnabled"
    }
}
