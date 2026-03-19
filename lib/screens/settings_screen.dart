// lib/screens/settings_screen.dart


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../l10n/app_strings.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Получаем провайдер настроек и строки для текущего языка
    final settings = context.watch<SettingsProvider>();
    final strings = AppStrings(settings.language);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.settings),
      ),
      body: ListView(
        children: [

          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: Text(strings.notifications),
            value: settings.settings.notificationsEnabled,
            onChanged: (_) => settings.toggleNotifications(),
          ),

          const Divider(height: 1),

          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: Text(strings.darkMode),
            value: settings.isDarkMode,
            onChanged: (_) => settings.toggleDarkMode(),
          ),

          const Divider(height: 1),

          ListTile(
            leading: const Icon(Icons.access_time_outlined),
            title: Text(strings.timeFormat),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  settings.use24HourFormat ? strings.hour24 : strings.hour12,
                  style: TextStyle(color: Colors.grey[500]),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
            onTap: () => _showTimeFormatPicker(context, settings, strings),
          ),

          const Divider(height: 1),

          ListTile(
            leading: const Icon(Icons.language_outlined),
            title: Text(strings.languageLabel),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  settings.language == 'ru' ? 'Русский' : 'English',
                  style: TextStyle(color: Colors.grey[500]),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
            onTap: () => _showLanguagePicker(context, settings),
          ),

          const Divider(height: 1),

          ListTile(
            leading: const Icon(Icons.alarm_outlined),
            title: Text(strings.reminder),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  strings.minutesBefore(settings.settings.reminderMinutes),
                  style: TextStyle(color: Colors.grey[500]),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
            onTap: () => _showReminderPicker(context, settings, strings),
          ),

          const Divider(height: 1),

          ListTile(
            leading: const Icon(Icons.calendar_today_outlined),
            title: Text(strings.weekStart),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  settings.settings.weekStartDay == 1
                      ? strings.monday
                      : strings.sunday,
                  style: TextStyle(color: Colors.grey[500]),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
            onTap: () => _showWeekStartPicker(context, settings, strings),
          ),

          const Divider(height: 1),
        ],
      ),
    );
  }

  void _showTimeFormatPicker(
    BuildContext context,
    SettingsProvider settings,
    AppStrings strings,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          ListTile(
            title: Text(strings.hour24),
            trailing: settings.use24HourFormat
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              if (!settings.use24HourFormat) settings.toggleTimeFormat();
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(strings.hour12),
            trailing: !settings.use24HourFormat
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              if (settings.use24HourFormat) settings.toggleTimeFormat();
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Диалог выбора языка
  void _showLanguagePicker(BuildContext context, SettingsProvider settings) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          ListTile(
            title: const Text('English'),
            trailing: settings.language == 'en'
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              settings.setLanguage('en');
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Русский'),
            trailing: settings.language == 'ru'
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              settings.setLanguage('ru');
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Диалог выбора времени напоминания
  void _showReminderPicker(
    BuildContext context,
    SettingsProvider settings,
    AppStrings strings,
  ) {
    // Доступные варианты в минутах
    const options = [5, 10, 15, 30, 60];

    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          ...options.map((minutes) => ListTile(
                title: Text(strings.minutesBefore(minutes)),
                trailing: settings.settings.reminderMinutes == minutes
                    ? const Icon(Icons.check, color: Colors.blue)
                    : null,
                onTap: () {
                  settings.setReminderMinutes(minutes);
                  Navigator.pop(context);
                },
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // Диалог выбора начала недели
  void _showWeekStartPicker(
    BuildContext context,
    SettingsProvider settings,
    AppStrings strings,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          ListTile(
            title: Text(strings.monday),
            trailing: settings.settings.weekStartDay == 1
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              settings.setWeekStartDay(1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(strings.sunday),
            trailing: settings.settings.weekStartDay == 7
                ? const Icon(Icons.check, color: Colors.blue)
                : null,
            onTap: () {
              settings.setWeekStartDay(7);
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
