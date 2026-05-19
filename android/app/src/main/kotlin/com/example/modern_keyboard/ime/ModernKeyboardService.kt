package com.example.modern_keyboard.ime

import android.graphics.Color
import android.inputmethodservice.InputMethodService
import android.view.View
import android.view.inputmethod.EditorInfo
import android.widget.Button
import android.widget.LinearLayout
import com.example.modern_keyboard.KeyboardSettingsRepository
import com.example.modern_keyboard.R

class ModernKeyboardService : InputMethodService(), View.OnClickListener {
    private lateinit var repository: KeyboardSettingsRepository
    private lateinit var keyboardState: KeyboardStateManager

    private lateinit var rootLayout: LinearLayout
    private lateinit var numberRow: LinearLayout
    private lateinit var shiftKey: Button
    private lateinit var languageKey: Button

    private val alphabetKeys = mutableListOf<Button>()
    private val numberKeys = mutableListOf<Button>()
    private val allKeys = mutableListOf<Button>()

    private val englishLayout = listOf(
        "q", "w", "e", "r", "t", "y", "u", "i", "o", "p",
        "a", "s", "d", "f", "g", "h", "j", "k", "l",
        "z", "x", "c", "v", "b", "n", "m",
    )

    private val myanmarLayout = listOf(
        "ဆ", "တ", "န", "မ", "အ", "ပ", "က", "င", "သ", "စ",
        "ေ", "ျ", "ိ", "်", "ါ", "့", "ူ", "ု", "လ",
        "ဖ", "ထ", "ခ", "ဂ", "ဟ", "ဝ", "ယ",
    )

    override fun onCreate() {
        super.onCreate()
        repository = KeyboardSettingsRepository(applicationContext)
        keyboardState = KeyboardStateManager(repository.getEnabledLanguages())
    }

    override fun onCreateInputView(): View {
        val view = layoutInflater.inflate(R.layout.ime_keyboard_view, null)
        bindViews(view)
        applyPersistedSettings()
        refreshLanguage()
        refreshShiftState()
        return view
    }

    override fun onStartInputView(info: EditorInfo?, restarting: Boolean) {
        super.onStartInputView(info, restarting)
        keyboardState.refreshLanguages(repository.getEnabledLanguages())
        applyPersistedSettings()
        refreshLanguage()
        refreshShiftState()
    }

    override fun onClick(view: View?) {
        val button = view as? Button ?: return
        when (button.id) {
            R.id.key_backspace -> currentInputConnection.deleteSurroundingText(1, 0)
            R.id.key_enter -> {
                val action = currentInputEditorInfo?.imeOptions?.and(EditorInfo.IME_MASK_ACTION)
                if (action != null && action != EditorInfo.IME_ACTION_NONE) {
                    currentInputConnection.performEditorAction(action)
                } else {
                    currentInputConnection.commitText("\n", 1)
                }
            }

            R.id.key_space -> currentInputConnection.commitText(" ", 1)
            R.id.key_emoji -> currentInputConnection.commitText("\uD83D\uDE0A", 1)
            R.id.key_shift -> {
                keyboardState.onShiftPressed()
                refreshShiftState()
                refreshLanguage()
            }

            R.id.key_language -> {
                keyboardState.onLanguageSwitchPressed()
                refreshLanguage()
            }

            else -> {
                val committed = if (keyboardState.isShifted) {
                    button.text.toString().uppercase()
                } else {
                    button.text.toString().lowercase()
                }
                currentInputConnection.commitText(committed, 1)
                keyboardState.onCharacterCommitted()
                refreshShiftState()
                refreshLanguage()
            }
        }
    }

    private fun bindViews(view: View) {
        rootLayout = view.findViewById(R.id.keyboard_root)
        numberRow = view.findViewById(R.id.row_numbers)
        shiftKey = view.findViewById(R.id.key_shift)
        languageKey = view.findViewById(R.id.key_language)
        alphabetKeys.clear()
        numberKeys.clear()
        allKeys.clear()

        val numberIds = intArrayOf(
            R.id.key_1, R.id.key_2, R.id.key_3, R.id.key_4, R.id.key_5,
            R.id.key_6, R.id.key_7, R.id.key_8, R.id.key_9, R.id.key_0,
        )
        numberIds.forEach { id ->
            val key = view.findViewById<Button>(id)
            numberKeys.add(key)
        }

        val keyIds = intArrayOf(
            R.id.key_q, R.id.key_w, R.id.key_e, R.id.key_r, R.id.key_t,
            R.id.key_y, R.id.key_u, R.id.key_i, R.id.key_o, R.id.key_p,
            R.id.key_a, R.id.key_s, R.id.key_d, R.id.key_f, R.id.key_g,
            R.id.key_h, R.id.key_j, R.id.key_k, R.id.key_l,
            R.id.key_z, R.id.key_x, R.id.key_c, R.id.key_v, R.id.key_b,
            R.id.key_n, R.id.key_m,
        )

        keyIds.forEach { id ->
            val key = view.findViewById<Button>(id)
            alphabetKeys.add(key)
        }

        val actionKeyIds = intArrayOf(
            R.id.key_backspace,
            R.id.key_enter,
            R.id.key_space,
            R.id.key_emoji,
            R.id.key_shift,
            R.id.key_language,
            R.id.key_dot,
        )

        numberKeys.forEach { it.setOnClickListener(this) }
        alphabetKeys.forEach { it.setOnClickListener(this) }
        actionKeyIds.forEach { id -> view.findViewById<Button>(id).setOnClickListener(this) }
        allKeys.addAll(numberKeys)
        allKeys.addAll(alphabetKeys)
        actionKeyIds.forEach { id -> allKeys.add(view.findViewById(id)) }
    }

    private fun applyPersistedSettings() {
        val settings = repository.getAllSettings()
        val showNumberRow = settings[KeyboardSettingsRepository.KEY_SHOW_NUMBER_ROW] as? Boolean ?: true
        val appThemeMode = settings[KeyboardSettingsRepository.KEY_APP_THEME_MODE] as? String ?: "system"

        numberRow.visibility = if (showNumberRow) View.VISIBLE else View.GONE

        val darkModeEnabled = appThemeMode == "dark"
        if (darkModeEnabled) {
            rootLayout.setBackgroundColor(Color.parseColor("#1A1E24"))
            allKeys.forEach { it.setTextColor(Color.WHITE) }
        } else {
            rootLayout.setBackgroundColor(Color.parseColor("#DCE4EF"))
            allKeys.forEach { it.setTextColor(Color.BLACK) }
        }
    }

    private fun refreshLanguage() {
        val active = keyboardState.currentLanguage
        val keysForLanguage = if (active == "Myanmar") myanmarLayout else englishLayout
        val caseTransform: (String) -> String = if (keyboardState.isShifted) {
            { value -> value.uppercase() }
        } else {
            { value -> value.lowercase() }
        }

        alphabetKeys.zip(keysForLanguage).forEach { (button, label) ->
            button.text = caseTransform(label)
        }
        languageKey.text = if (active == "Myanmar") "MM" else "EN"
    }

    private fun refreshShiftState() {
        shiftKey.text = when {
            keyboardState.isCapsLockEnabled -> "CAPS"
            keyboardState.isShifted -> "SHIFT"
            else -> "\u21E7"
        }
    }
}
