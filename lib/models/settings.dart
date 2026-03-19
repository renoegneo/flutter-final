// lib/models/settings.dart
//
// Модель настроек приложения

class AppSettings {
  final bool isDarkMode;
  final bool notificationsEnabled;
  final bool use24HourFormat; // формат времени: 24-часовой или AM/PM
  final String language;      // 'en' или 'ru'
  final int reminderMinutes;  // за сколько минут напоминать
  final int weekStartDay;     // 1 = Понедельник, 7 = Воскресенье

  const AppSettings({
    this.isDarkMode = false,
    this.notificationsEnabled = true,
    this.use24HourFormat = true,
    this.language = 'en',
    this.reminderMinutes = 10,
    this.weekStartDay = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'isDarkMode': isDarkMode,
      'notificationsEnabled': notificationsEnabled,
      'use24HourFormat': use24HourFormat,
      'language': language,
      'reminderMinutes': reminderMinutes,
      'weekStartDay': weekStartDay,
    };
  }

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      isDarkMode: map['isDarkMode'] as bool? ?? false,
      notificationsEnabled: map['notificationsEnabled'] as bool? ?? true,
      use24HourFormat: map['use24HourFormat'] as bool? ?? true,
      language: map['language'] as String? ?? 'en',
      reminderMinutes: map['reminderMinutes'] as int? ?? 10,
      weekStartDay: map['weekStartDay'] as int? ?? 1,
    );
  }

  AppSettings copyWith({
    bool? isDarkMode,
    bool? notificationsEnabled,
    bool? use24HourFormat,
    String? language,
    int? reminderMinutes,
    int? weekStartDay,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      use24HourFormat: use24HourFormat ?? this.use24HourFormat,
      language: language ?? this.language,
      reminderMinutes: reminderMinutes ?? this.reminderMinutes,
      weekStartDay: weekStartDay ?? this.weekStartDay,
    );
  }
}
