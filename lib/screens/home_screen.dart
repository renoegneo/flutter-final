// lib/screens/home_screen.dart
// главный экран с расписанием на день

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/event.dart';
import '../providers/schedule_provider.dart';
import '../providers/settings_provider.dart';
import '../l10n/app_strings.dart';
import '../widgets/event_tile.dart';
import '../widgets/add_event_dialog.dart';
import '../widgets/delete_event_dialog.dart';
import '../widgets/burger_menu.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = context.watch<ScheduleProvider>();
    final settings = context.watch<SettingsProvider>();
    final strings = AppStrings(settings.language);

    final events = scheduleProvider.eventsForSelectedDay;
    final selectedDate = scheduleProvider.selectedDate;

    final dateFormatter = DateFormat(
      settings.language == 'ru' ? 'EEEE, d MMMM' : 'EEEE, MMMM d',
      settings.language == 'ru' ? 'ru' : 'en',
    );
    final dateTitle = dateFormatter.format(selectedDate);

    return Scaffold(
      drawer: const BurgerMenu(),

      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          if (!_isToday(selectedDate))
            TextButton(
              onPressed: scheduleProvider.goToToday,
              child: Text(strings.today),
            ),
        ],
      ),

      body: scheduleProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : events.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.event_note,
                          size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        strings.noEvents,
                        style: TextStyle(color: Colors.grey[500], fontSize: 16),
                      ),
                    ],
                  ),
                )
              // Список событий
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return EventTile(
                      event: event,
                      onDelete: () => _confirmDelete(context, event.id, event.title, strings),
                    );
                  },
                ),

      // кнопка добавления события
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEvent(context, selectedDate),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddEvent(BuildContext context, DateTime date) async {
    final Event? newEvent = await showDialog<Event>(
      context: context,
      builder: (_) => AddEventDialog(initialDate: date),
    );

    if (newEvent != null && context.mounted) {
      await context.read<ScheduleProvider>().addEvent(newEvent);
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    String eventId,
    String eventTitle,
    AppStrings strings,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => DeleteEventDialog(eventTitle: eventTitle),
    );

    if (confirmed == true && context.mounted) {
      await context.read<ScheduleProvider>().deleteEvent(eventId);
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}