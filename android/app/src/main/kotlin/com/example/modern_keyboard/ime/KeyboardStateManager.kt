package com.example.modern_keyboard.ime

import android.os.SystemClock

class KeyboardStateManager(initialLanguages: List<String>) {
    private var lastShiftPressTime: Long = 0L

    var isShifted: Boolean = false
        private set

    var isCapsLockEnabled: Boolean = false
        private set

    var languages: List<String> = initialLanguages.ifEmpty { listOf("English") }
        private set

    var languageIndex: Int = 0
        private set

    val currentLanguage: String
        get() = languages.getOrElse(languageIndex) { "English" }

    fun refreshLanguages(updated: List<String>) {
        languages = updated.ifEmpty { listOf("English") }
        if (languageIndex >= languages.size) {
            languageIndex = 0
        }
    }

    fun onShiftPressed() {
        val now = SystemClock.elapsedRealtime()
        val doubleTap = now - lastShiftPressTime < 360L
        if (doubleTap) {
            isCapsLockEnabled = !isCapsLockEnabled
            isShifted = isCapsLockEnabled
        } else if (!isCapsLockEnabled) {
            isShifted = !isShifted
        }
        lastShiftPressTime = now
    }

    fun onLanguageSwitchPressed() {
        languageIndex = (languageIndex + 1) % languages.size
    }

    fun onCharacterCommitted() {
        if (isShifted && !isCapsLockEnabled) {
            isShifted = false
        }
    }
}
