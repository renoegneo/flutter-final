// lib/screens/calendar_screen.dart
// экран с календарём для выбора дня

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/schedule_provider.dart';
import '../providers/settings_provider.dart';
import '../l10n/app_strings.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // текущий месяц
  late DateTime _displayedMonth;

  @override
  void initState() {
    super.initState();
    final selected = context.read<ScheduleProvider>().selectedDate;
    _displayedMonth = DateTime(selected.year, selected.month, 1);
  }

  // Перейти к предыдущему месяцу
  void _prevMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1, 1);
    });
  }

  // Перейти к следующему месяцу
  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheduleProvider = context.watch<ScheduleProvider>();
    final settings = context.watch<SettingsProvider>();
    final strings = AppStrings(settings.language);

    final selectedDate = scheduleProvider.selectedDate;
    final daysWithEvents = scheduleProvider.daysWithEvents;
    final today = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.calendar),
      ),
      body: Column(
        children: [
          // Навигация по месяцам
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _prevMonth,
                ),
                Text(
                  '${strings.monthNames[_displayedMonth.month - 1]} ${_displayedMonth.year}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _nextMonth,
                ),
              ],
            ),
          ),

          // Заголовки дней недели
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: strings.weekDaysShort
                  .map((day) => SizedBox(
                        width: 36,
                        child: Text(
                          day,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),

          // Сетка дней
          Expanded(
            child: _buildCalendarGrid(
              context: context,
              selectedDate: selectedDate,
              today: today,
              daysWithEvents: daysWithEvents,
              scheduleProvider: scheduleProvider,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid({
    required BuildContext context,
    required DateTime selectedDate,
    required DateTime today,
    required Set<DateTime> daysWithEvents,
    required ScheduleProvider scheduleProvider,
  }) {
    // Первый день месяца
    final firstDay = DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    // Сколько пустых ячеек перед первым днём (weekday: 1=Пн, 7=Вс)
    final startOffset = firstDay.weekday - 1;
    // Последний день месяца
    final daysInMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0).day;

    final totalCells = startOffset + daysInMonth;
    // Количество строк (каждая строка = 7 дней)
    final rowCount = (totalCells / 7).ceil();

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,   // 7 колонок = 7 дней недели
        childAspectRatio: 1, // квадратные ячейки
      ),
      itemCount: rowCount * 7,
      itemBuilder: (context, index) {
        final dayNumber = index - startOffset + 1;

        // Пустые ячейки до начала месяца
        if (dayNumber < 1 || dayNumber > daysInMonth) {
          return const SizedBox.shrink();
        }

        final cellDate = DateTime(
          _displayedMonth.year,
          _displayedMonth.month,
          dayNumber,
        );

        final isToday = _isSameDay(cellDate, today);
        final isSelected = _isSameDay(cellDate, selectedDate);
        final hasEvent = daysWithEvents.any((d) => _isSameDay(d, cellDate));

        return GestureDetector(
          onTap: () {
            scheduleProvider.selectDate(cellDate);
            Navigator.of(context).pop(); // вернуться на главный экран
          },
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              // Выбранный день — синий фон
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : isToday
                      ? Theme.of(context).colorScheme.primaryContainer
                      : null,
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  '$dayNumber',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isToday || isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected ? Colors.white : null,
                  ),
                ),
                // Точка — если есть события в этот день
                if (hasEvent && !isSelected)
                  Positioned(
                    bottom: 4,
                    child: Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
