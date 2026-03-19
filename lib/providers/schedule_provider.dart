// lib/providers/schedule_provider.dart
// Этот провайдер отвечает за управление расписанием: загрузку, добавление, удаление событий и выбор даты.

import 'package:flutter/foundation.dart';
import '../models/event.dart';
import '../services/storage_service.dart';

class ScheduleProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();

  List<Event> _allEvents = [];    // все события
  DateTime _selectedDate = DateTime.now(); // выбранный день
  bool _isLoading = false;        // идёт ли загрузка

  // Геттеры (getters) — позволяют читать данные снаружи, но не менять напрямую
  List<Event> get allEvents => _allEvents;
  DateTime get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;

  // События только для выбранного дня (с учётом повторяющихся)
  List<Event> get eventsForSelectedDay {
    return _allEvents.where((event) {
      // Проверяем точное совпадение даты
      final sameDay = event.dateTime.year == _selectedDate.year &&
          event.dateTime.month == _selectedDate.month &&
          event.dateTime.day == _selectedDate.day;

      if (sameDay) return true;

      // Для повторяющихся событий — совпадение дня недели
      if (event.isRecurring) {
        return event.dateTime.weekday == _selectedDate.weekday;
      }

      return false;
    }).toList()
      // Сортируем по времени (от раннего к позднему)
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  // Загрузка данных при запуске приложения
  Future<void> loadEvents() async {
    _isLoading = true;
    notifyListeners(); // говорим виджетам "перерисуйтесь"

    _allEvents = await _storage.loadEvents();

    _isLoading = false;
    notifyListeners();
  }

  // Добавить новое событие
  Future<void> addEvent(Event event) async {
    _allEvents.add(event);
    await _storage.saveEvents(_allEvents);
    notifyListeners();
  }

  // Удалить событие по ID
  Future<void> deleteEvent(String eventId) async {
    _allEvents.removeWhere((e) => e.id == eventId);
    await _storage.saveEvents(_allEvents);
    notifyListeners();
  }

  // Добавить список событий (при импорте файла)
  Future<void> importEvents(List<Event> events) async {
    _allEvents.addAll(events);
    await _storage.saveEvents(_allEvents);
    notifyListeners();
  }

  // Сменить выбранную дату (при нажатии в календаре)
  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  // Перейти на сегодня
  void goToToday() {
    _selectedDate = DateTime.now();
    notifyListeners();
  }

  // Дни, в которые есть хотя бы одно событие (для подсветки в календаре)
  Set<DateTime> get daysWithEvents {
    return _allEvents.map((e) {
      return DateTime(e.dateTime.year, e.dateTime.month, e.dateTime.day);
    }).toSet();
  }
}
