package com.example.day_butt

import android.content.Context
import android.os.Build
import android.os.VibrationEffect
import android.os.Vibrator
import android.os.VibratorManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val VIBRATION_CHANNEL = "app.day_butt/vibration"
    private val WIDGET_CHANNEL = "app.day_butt/widget"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, VIBRATION_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "vibrate") {
                val duration = (call.argument<Int>("duration") ?: 45).toLong()
                val amplitude = call.argument<Int>("amplitude") ?: 255
                vibrateDevice(duration, amplitude)
                result.success(true)
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, WIDGET_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "updateWidgetData") {
                try {
                    val prefs = getSharedPreferences(DayButtWidgetProvider.PREFS_NAME, Context.MODE_PRIVATE)
                    val editor = prefs.edit()

                    call.argument<String>("scheduleStatus")?.let { editor.putString(DayButtWidgetProvider.KEY_SCHEDULE_STATUS, it) }
                    call.argument<String>("scheduleTitle")?.let { editor.putString(DayButtWidgetProvider.KEY_SCHEDULE_TITLE, it) }
                    call.argument<String>("scheduleSubtitle")?.let { editor.putString(DayButtWidgetProvider.KEY_SCHEDULE_SUBTITLE, it) }
                    call.argument<String>("caloriesVal")?.let { editor.putString(DayButtWidgetProvider.KEY_CALORIES_VALUE, it) }
                    call.argument<String>("caloriesGoal")?.let { editor.putString(DayButtWidgetProvider.KEY_CALORIES_GOAL, it) }
                    call.argument<String>("expensesVal")?.let { editor.putString(DayButtWidgetProvider.KEY_EXPENSES_VALUE, it) }
                    call.argument<String>("expensesSub")?.let { editor.putString(DayButtWidgetProvider.KEY_EXPENSES_SUB, it) }
                    call.argument<String>("routinesVal")?.let { editor.putString(DayButtWidgetProvider.KEY_ROUTINES_VALUE, it) }
                    call.argument<String>("routinesSub")?.let { editor.putString(DayButtWidgetProvider.KEY_ROUTINES_SUB, it) }
                    call.argument<String>("dateText")?.let { editor.putString(DayButtWidgetProvider.KEY_DATE_TEXT, it) }

                    editor.apply()

                    DayButtWidgetProvider.updateAllWidgets(this)
                    result.success(true)
                } catch (e: Exception) {
                    result.error("WIDGET_UPDATE_ERROR", e.localizedMessage, null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun vibrateDevice(durationMs: Long, amplitude: Int) {
        try {
            val vibrator = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                val vibratorManager = getSystemService(Context.VIBRATOR_MANAGER_SERVICE) as? VibratorManager
                vibratorManager?.defaultVibrator
            } else {
                @Suppress("DEPRECATION")
                getSystemService(Context.VIBRATOR_SERVICE) as? Vibrator
            } ?: return

            if (!vibrator.hasVibrator()) return

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                val clampedAmp = amplitude.coerceIn(1, 255)
                vibrator.vibrate(VibrationEffect.createOneShot(durationMs, clampedAmp))
            } else {
                @Suppress("DEPRECATION")
                vibrator.vibrate(durationMs)
            }
        } catch (_: Exception) {
        }
    }
}
