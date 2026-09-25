package com.example.day_butt

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.RemoteViews
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class DayButtWidgetProvider : AppWidgetProvider() {

    companion object {
        private const val TAG = "DayButtWidget"
        const val PREFS_NAME = "DayButtWidgetPrefs"
        const val KEY_SCHEDULE_STATUS = "schedule_status"
        const val KEY_SCHEDULE_TITLE = "schedule_title"
        const val KEY_SCHEDULE_SUBTITLE = "schedule_subtitle"
        const val KEY_CALORIES_VALUE = "calories_val"
        const val KEY_CALORIES_GOAL = "calories_goal"
        const val KEY_EXPENSES_VALUE = "expenses_val"
        const val KEY_EXPENSES_SUB = "expenses_sub"
        const val KEY_ROUTINES_VALUE = "routines_val"
        const val KEY_ROUTINES_SUB = "routines_sub"
        const val KEY_NOTES_VALUE = "notes_val"
        const val KEY_NOTES_SUB = "notes_sub"
        const val KEY_DATE_TEXT = "date_text"

        // Height thresholds (dp) — each metric row is ~34dp; header ~22dp; schedule card gets remaining
        private const val HEIGHT_COMPACT = 0     // university only
        private const val HEIGHT_SMALL = 130     // + calories
        private const val HEIGHT_MEDIUM = 170    // + expenses
        private const val HEIGHT_LARGE = 210     // + routines
        private const val HEIGHT_EXPANDED = 250  // + notes

        /**
         * Determines which sections are visible based on available height in dp.
         * Returns a LayoutTier enum.
         */
        private fun resolveLayoutTier(heightDp: Int): LayoutTier {
            return when {
                heightDp >= HEIGHT_EXPANDED -> LayoutTier.EXPANDED
                heightDp >= HEIGHT_LARGE    -> LayoutTier.LARGE
                heightDp >= HEIGHT_MEDIUM   -> LayoutTier.MEDIUM
                heightDp >= HEIGHT_SMALL    -> LayoutTier.SMALL
                else                        -> LayoutTier.COMPACT
            }
        }

        fun updateAllWidgets(context: Context) {
            try {
                val appWidgetManager = AppWidgetManager.getInstance(context)
                val componentName = ComponentName(context, DayButtWidgetProvider::class.java)
                val appWidgetIds = appWidgetManager.getAppWidgetIds(componentName)
                if (appWidgetIds != null && appWidgetIds.isNotEmpty()) {
                    for (id in appWidgetIds) {
                        updateAppWidget(context, appWidgetManager, id)
                    }
                }
            } catch (t: Throwable) {
                Log.e(TAG, "Error updating all widgets", t)
            }
        }

        fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            try {
                val prefs = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)

                val scheduleStatus = prefs.getString(KEY_SCHEDULE_STATUS, "FREE") ?: "FREE"
                val scheduleTitle = prefs.getString(KEY_SCHEDULE_TITLE, "No classes scheduled") ?: "No classes scheduled"
                val scheduleSubtitle = prefs.getString(KEY_SCHEDULE_SUBTITLE, "Enjoy your day") ?: "Enjoy your day"

                val caloriesVal = prefs.getString(KEY_CALORIES_VALUE, "0 kcal") ?: "0 kcal"
                val caloriesGoal = prefs.getString(KEY_CALORIES_GOAL, "Goal 2,300") ?: "Goal 2,300"

                val expensesVal = prefs.getString(KEY_EXPENSES_VALUE, "0 EGP") ?: "0 EGP"
                val expensesSub = prefs.getString(KEY_EXPENSES_SUB, "Spent today") ?: "Spent today"

                val routinesVal = prefs.getString(KEY_ROUTINES_VALUE, "0 / 0") ?: "0 / 0"
                val routinesSub = prefs.getString(KEY_ROUTINES_SUB, "Completed") ?: "Completed"

                val notesVal = prefs.getString(KEY_NOTES_VALUE, "0 notes") ?: "0 notes"
                val notesSub = prefs.getString(KEY_NOTES_SUB, "Quick notes") ?: "Quick notes"

                val defaultDate = SimpleDateFormat("EEE, MMM d", Locale.getDefault()).format(Date())
                val dateText = prefs.getString(KEY_DATE_TEXT, defaultDate) ?: defaultDate

                val views = RemoteViews(context.packageName, R.layout.widget_day_butt)

                // ── Determine responsive tier from widget size ──
                val options = appWidgetManager.getAppWidgetOptions(appWidgetId)
                val heightDp = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MAX_HEIGHT, 200)
                val tier = resolveLayoutTier(heightDp)

                Log.d(TAG, "Widget $appWidgetId: heightDp=$heightDp, tier=$tier")

                // ── Apply visibility per tier ──
                views.setViewVisibility(R.id.widget_calories_card,
                    if (tier >= LayoutTier.SMALL) View.VISIBLE else View.GONE)
                views.setViewVisibility(R.id.widget_expenses_card,
                    if (tier >= LayoutTier.MEDIUM) View.VISIBLE else View.GONE)
                views.setViewVisibility(R.id.widget_routines_card,
                    if (tier >= LayoutTier.LARGE) View.VISIBLE else View.GONE)
                views.setViewVisibility(R.id.widget_notes_card,
                    if (tier >= LayoutTier.EXPANDED) View.VISIBLE else View.GONE)

                // Header date
                views.setTextViewText(R.id.widget_date_text, dateText)

                // Schedule
                views.setTextViewText(R.id.widget_schedule_title, scheduleTitle)
                views.setTextViewText(R.id.widget_schedule_subtitle, scheduleSubtitle)

                // Badges
                when (scheduleStatus.uppercase()) {
                    "NOW" -> {
                        views.setViewVisibility(R.id.widget_schedule_badge_now, View.VISIBLE)
                        views.setViewVisibility(R.id.widget_schedule_badge_next, View.GONE)
                        views.setViewVisibility(R.id.widget_schedule_badge_off, View.GONE)
                    }
                    "NEXT" -> {
                        views.setViewVisibility(R.id.widget_schedule_badge_now, View.GONE)
                        views.setViewVisibility(R.id.widget_schedule_badge_next, View.VISIBLE)
                        views.setViewVisibility(R.id.widget_schedule_badge_off, View.GONE)
                    }
                    else -> {
                        views.setViewVisibility(R.id.widget_schedule_badge_now, View.GONE)
                        views.setViewVisibility(R.id.widget_schedule_badge_next, View.GONE)
                        views.setViewVisibility(R.id.widget_schedule_badge_off, View.VISIBLE)
                        views.setTextViewText(R.id.widget_schedule_badge_off, scheduleStatus)
                    }
                }

                // Calories
                views.setTextViewText(R.id.widget_calories_value, caloriesVal)
                views.setTextViewText(R.id.widget_calories_goal, caloriesGoal)

                // Expenses
                views.setTextViewText(R.id.widget_expenses_value, expensesVal)
                views.setTextViewText(R.id.widget_expenses_sub, expensesSub)

                // Routines
                views.setTextViewText(R.id.widget_routines_value, routinesVal)
                views.setTextViewText(R.id.widget_routines_sub, routinesSub)

                // Notes
                views.setTextViewText(R.id.widget_notes_value, notesVal)
                views.setTextViewText(R.id.widget_notes_sub, notesSub)

                // Open app on click
                val intent = Intent(context, MainActivity::class.java).apply {
                    flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
                }
                val pendingIntent = PendingIntent.getActivity(
                    context,
                    0,
                    intent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

                appWidgetManager.updateAppWidget(appWidgetId, views)
            } catch (t: Throwable) {
                Log.e(TAG, "Failed to update widget $appWidgetId", t)
            }
        }
    }

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    /**
     * Called by Android when the user resizes the widget.
     * Re-renders with the new dimensions to show/hide sections responsively.
     */
    override fun onAppWidgetOptionsChanged(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int,
        newOptions: Bundle
    ) {
        updateAppWidget(context, appWidgetManager, appWidgetId)
    }
}

/**
 * Layout tiers ordered from smallest to largest.
 * Uses Comparable so we can do tier >= LayoutTier.MEDIUM.
 */
private enum class LayoutTier {
    COMPACT,    // University only
    SMALL,      // + Calories
    MEDIUM,     // + Expenses
    LARGE,      // + Routines
    EXPANDED    // + Notes
}
