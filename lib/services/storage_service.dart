// lib/services/storage_service.dart


import 'dart:convert'; // для работы с JSON (формат хранения данных)
import 'package:shared_preferences/shared_preferences.dart';
import '../models/event.dart';
import '../models/settings.dart';

class StorageService {
  static const String _eventsKey = 'events';
  static const String _settingsKey = 'settings';

  Future<List<Event>> loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_eventsKey);

    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;

    return jsonList
        .map((item) => Event.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  // Сохранить все события в хранилище
  Future<void> saveEvents(List<Event> events) async {
    final prefs = await SharedPreferences.getInstance();
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
