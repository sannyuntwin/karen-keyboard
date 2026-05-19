package com.example.modern_keyboard

import android.content.Intent
import android.provider.Settings
import android.view.inputmethod.InputMethodManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "modern_keyboard/settings"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val repository = KeyboardSettingsRepository(applicationContext)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "loadSettings" -> {
                        result.success(repository.getAllSettings())
                    }

                    "saveSettings" -> {
                        val settings =
                            call.argument<Map<String, Any?>>("settings") ?: emptyMap()
                        repository.saveFromMap(settings)
                        result.success(true)
                    }

                    "openInputMethodSettings" -> {
                        val intent = Intent(Settings.ACTION_INPUT_METHOD_SETTINGS).apply {
                            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        }
                        startActivity(intent)
                        result.success(true)
                    }

                    "showInputMethodPicker" -> {
                        val inputMethodManager =
                            getSystemService(INPUT_METHOD_SERVICE) as InputMethodManager
                        inputMethodManager.showInputMethodPicker()
                        result.success(true)
                    }

                    else -> result.notImplemented()
                }
            }
    }
}
