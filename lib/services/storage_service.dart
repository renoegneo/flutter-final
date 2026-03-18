// lib/services/storage_service.dart
//
// Сервис для сохранения и загрузки данных с телефона.
// SharedPreferences — это встроенное хранилище на телефоне (как маленькая база данных).

import 'dart:convert'; // для работы с JSON (формат хранения данных)
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event.dart';
import '../models/settings.dart';

class StorageService {
  // Ключи — это имена "ячеек" в хранилище
  static const String _eventsKey = 'events';
  static const String _settingsKey = 'settings';

  // Загрузить все события из хранилища
  Future<List<Event>> loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_eventsKey);

    // Если данных нет — возвращаем пустой список
    if (jsonString == null) return [];

    // jsonDecode превращает текстовую строку обратно в объект Dart
    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;

    return jsonList
        .map((item) => Event.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  // Сохранить все события в хранилище
  Future<void> saveEvents(List<Event> events) async {
    final prefs = await SharedPreferences.getInstance();
    // jsonEncode превращает объект Dart в текстовую строку для хранения
    final jsonString = jsonEncode(events.map((e) => e.toMap()).toList());
    await prefs.setString(_eventsKey, jsonString);
  }

  // Загрузить настройки
  Future<AppSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_settingsKey);

    if (jsonString == null) return const AppSettings();

    final Map<String, dynamic> map =
        jsonDecode(jsonString) as Map<String, dynamic>;
    return AppSettings.fromMap(map);
  }

  // Сохранить настройки
  Future<void> saveSettings(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(settings.toMap());
    await prefs.setString(_settingsKey, jsonString);
  }
}
