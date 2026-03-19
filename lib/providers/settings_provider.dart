// lib/providers/settings_provider.dart
//  

import 'package:flutter/material.dart';
import '../models/settings.dart';
import '../services/storage_service.dart';

class SettingsProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();

  AppSettings _settings = const AppSettings();

  AppSettings get settings => _settings;

  // геттеры для часто используемых настроек
  bool get isDarkMode => _settings.isDarkMode;
  String get language => _settings.language;
  bool get use24HourFormat => _settings.use24HourFormat;

  // загрузить настройки при старте
  Future<void> loadSettings() async {
    _settings = await _storage.loadSettings();
    notifyListeners();
  }

  // Переключить тёмную тему
  Future<void> toggleDarkMode() async {
    _settings = _settings.copyWith(isDarkMode: !_settings.isDarkMode);
    await _storage.saveSettings(_settings);
    notifyListeners();
  }

  // Переключить уведомления
  Future<void> toggleNotifications() async {
    _settings = _settings.copyWith(
      notificationsEnabled: !_settings.notificationsEnabled,
    );
    await _storage.saveSettings(_settings);
    notifyListeners();
  }

  // Переключить формат времени
  Future<void> toggleTimeFormat() async {
    _settings = _settings.copyWith(
      use24HourFormat: !_settings.use24HourFormat,
    );
    await _storage.saveSettings(_settings);
    notifyListeners();
  }

  // Сменить язык
  Future<void> setLanguage(String lang) async {
    _settings = _settings.copyWith(language: lang);
    await _storage.saveSettings(_settings);
    notifyListeners();
  }

  // Установить время напоминания (в минутах)
  Future<void> setReminderMinutes(int minutes) async {
    _settings = _settings.copyWith(reminderMinutes: minutes);
    await _storage.saveSettings(_settings);
    notifyListeners();
  }

  // Установить начало недели
  Future<void> setWeekStartDay(int day) async {
    _settings = _settings.copyWith(weekStartDay: day);
    await _storage.saveSettings(_settings);
    notifyListeners();
  }

  // Форматировать время с учётом настроек
  String formatTime(DateTime dt) {
    if (_settings.use24HourFormat) {
      // "09:30"
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } else {
      // "9:30 AM"
      final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
      final period = dt.hour < 12 ? 'AM' : 'PM';
      return '$hour:${dt.minute.toString().padLeft(2, '0')} $period';
    }
  }
}
