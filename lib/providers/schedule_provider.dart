import 'package:flutter/foundation.dart';

import '../models/event.dart';
import '../services/storage_service.dart';

class ScheduleProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();

  List<Event> _allEvents = [];
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  bool _isSelectionMode = false;
  final Set<String> _selectedIds = {};

  List<Event> get allEvents => _allEvents;
  DateTime get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;
  bool get isSelectionMode => _isSelectionMode;
  Set<String> get selectedIds => Set.unmodifiable(_selectedIds);
  int get selectedCount => _selectedIds.length;

  List<Event> get eventsForSelectedDay {
    return _allEvents.where((event) {
      final sameDay = event.dateTime.year == _selectedDate.year &&
          event.dateTime.month == _selectedDate.month &&
          event.dateTime.day == _selectedDate.day;

      if (sameDay) return true;

      if (event.isRecurring) {
        return event.dateTime.weekday == _selectedDate.weekday;
      }

      return false;
    }).toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  Future<void> loadEvents() async {
    _isLoading = true;
    notifyListeners();
    _allEvents = await _storage.loadEvents();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addEvent(Event event) async {
    _allEvents.add(event);
    await _storage.saveEvents(_allEvents);
    notifyListeners();
  }

  Future<void> deleteEvent(String eventId) async {
    _allEvents.removeWhere((e) => e.id == eventId);
    await _storage.saveEvents(_allEvents);
    notifyListeners();
  }

  Future<void> updateEvent(Event updatedEvent) async {
    final index = _allEvents.indexWhere((e) => e.id == updatedEvent.id);
    if (index == -1) return;
    _allEvents[index] = updatedEvent;
    await _storage.saveEvents(_allEvents);
    notifyListeners();
  }

  Future<void> deleteSelected() async {
    _allEvents.removeWhere((e) => _selectedIds.contains(e.id));
    await _storage.saveEvents(_allEvents);
    _exitSelectionMode();
    notifyListeners();
  }

  Future<void> replaceAllEvents(List<Event> events) async {
    _allEvents = List<Event>.from(events)
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    await _storage.saveEvents(_allEvents);
    _exitSelectionMode();
    notifyListeners();
  }

  void enterSelectionMode(String firstId) {
    _isSelectionMode = true;
    _selectedIds.clear();
    _selectedIds.add(firstId);
    notifyListeners();
  }

  void toggleSelection(String id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
      if (_selectedIds.isEmpty) _isSelectionMode = false;
    } else {
      _selectedIds.add(id);
    }
    notifyListeners();
  }

  void exitSelectionMode() {
    _exitSelectionMode();
    notifyListeners();
  }

  void _exitSelectionMode() {
    _isSelectionMode = false;
    _selectedIds.clear();
  }

  void toggleSelectAll() {
    final dayIds = eventsForSelectedDay.map((e) => e.id).toSet();
    if (_selectedIds.containsAll(dayIds)) {
      _selectedIds.removeAll(dayIds);
      if (_selectedIds.isEmpty) _isSelectionMode = false;
    } else {
      _selectedIds.addAll(dayIds);
    }
    notifyListeners();
  }

  Future<void> importEvents(List<Event> events, DateTime targetDate) async {
    final eventsToAdd = events.map((e) {
      final isToday = _isSameDay(e.dateTime, DateTime.now());
      if (!isToday) return e;

      return e.copyWith(
        dateTime: DateTime(
          targetDate.year,
          targetDate.month,
          targetDate.day,
          e.dateTime.hour,
          e.dateTime.minute,
        ),
      );
    }).toList();

    final importDates = eventsToAdd
        .map((e) => DateTime(e.dateTime.year, e.dateTime.month, e.dateTime.day))
        .toSet();

    _allEvents.removeWhere((e) {
      final eventDay =
          DateTime(e.dateTime.year, e.dateTime.month, e.dateTime.day);
      return importDates.contains(eventDay);
    });

    _allEvents.addAll(eventsToAdd);
    await _storage.saveEvents(_allEvents);
    notifyListeners();
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void goToToday() {
    _selectedDate = DateTime.now();
    notifyListeners();
  }

  Set<DateTime> get daysWithEvents {
    return _allEvents
        .map((e) => DateTime(e.dateTime.year, e.dateTime.month, e.dateTime.day))
        .toSet();
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}
