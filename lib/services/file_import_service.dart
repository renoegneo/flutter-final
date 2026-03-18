// lib/services/file_import_service.dart
//
// Сервис для чтения расписаний из файлов разных форматов.
// Парсинг (parsing) — это разбор файла и извлечение данных из него.

import 'dart:io'; // работа с файловой системой
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import '../models/event.dart';

class FileImportService {
  // Главный метод — определяет формат файла и вызывает нужный парсер
  Future<List<Event>> importFile(String filePath) async {
    final extension = filePath.split('.').last.toLowerCase();

    switch (extension) {
      case 'csv':
        return _parseCsv(filePath);
      case 'xlsx':
      case 'xls':
        return _parseExcel(filePath);
      case 'ics':
        return _parseIcs(filePath);
      default:
        throw UnsupportedError('Unsupported file format: $extension');
    }
  }

  // --- CSV парсер ---
  // CSV (Comma-Separated Values) — файл где значения разделены запятыми
  Future<List<Event>> _parseCsv(String filePath) async {
    final file = File(filePath);
    final content = await file.readAsString();

    final rows = const CsvToListConverter().convert(content);

    final events = <Event>[];

    // Пропускаем первую строку — это обычно заголовки ("Time", "Event" и т.д.)
    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.length < 2) continue; // пропускаем неполные строки

      final event = _parseRowToEvent(
        timeStr: row[0].toString(),
        title: row[1].toString(),
        dateStr: row.length > 2 ? row[2].toString() : null,
      );

      if (event != null) events.add(event);
    }

    return events;
  }

  // --- Excel парсер ---
  Future<List<Event>> _parseExcel(String filePath) async {
    final file = File(filePath);
    final bytes = file.readAsBytesSync(); // excel ^3 принимает Uint8List напрямую
    final excel = Excel.decodeBytes(bytes);

    final events = <Event>[];

    // Берём первый лист (sheet) из файла
    final sheetName = excel.tables.keys.first;
    final sheet = excel.tables[sheetName];
    if (sheet == null) return events;

    final rows = sheet.rows;

    // Пропускаем заголовок (первую строку)
    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.isEmpty) continue;

      // getCellValue — получаем текст из ячейки, защищаясь от null
      final timeStr = row[0]?.value?.toString() ?? '';
      final title = row.length > 1 ? (row[1]?.value?.toString() ?? '') : '';
      final dateStr = row.length > 2 ? row[2]?.value?.toString() : null;

      if (title.isEmpty) continue;

      final event = _parseRowToEvent(
        timeStr: timeStr,
        title: title,
        dateStr: dateStr,
      );

      if (event != null) events.add(event);
    }

    return events;
  }

  // --- ICS парсер ---
  // ICS — формат iCalendar, используется в Google Calendar, Outlook и т.д.
  Future<List<Event>> _parseIcs(String filePath) async {
    final file = File(filePath);
    final content = await file.readAsString();

    final events = <Event>[];
    final lines = content.split('\n');

    String? summary; // название события
    DateTime? dtStart; // дата и время начала

    for (final rawLine in lines) {
      final line = rawLine.trim();

      if (line.startsWith('SUMMARY:')) {
        summary = line.substring('SUMMARY:'.length).trim();
      } else if (line.startsWith('DTSTART')) {
        // DTSTART может быть в разных форматах
        final value = line.contains(':') ? line.split(':').last.trim() : null;
        if (value != null) {
          dtStart = _parseIcsDate(value);
        }
      } else if (line == 'END:VEVENT') {
        // Конец блока события — создаём объект если данные есть
        if (summary != null && dtStart != null) {
          events.add(Event(
            id: DateTime.now().millisecondsSinceEpoch.toString() +
                events.length.toString(),
            title: summary,
            dateTime: dtStart,
          ));
        }
        summary = null;
        dtStart = null;
      }
    }

    return events;
  }

  // Вспомогательный метод: парсит время и создаёт Event
  Event? _parseRowToEvent({
    required String timeStr,
    required String title,
    String? dateStr,
  }) {
    if (title.isEmpty) return null;

    // Пробуем разобрать время в формате "HH:MM" или "H:MM"
    DateTime dateTime;
    try {
      final now = DateTime.now();
      final timeParts = timeStr.replaceAll('.', ':').split(':');

      if (timeParts.length >= 2) {
        final hour = int.parse(timeParts[0].trim());
        final minute = int.parse(timeParts[1].trim());

        // Если есть дата в отдельной колонке — парсим её
        if (dateStr != null && dateStr.isNotEmpty) {
          dateTime = _parseDate(dateStr, hour, minute) ??
              DateTime(now.year, now.month, now.day, hour, minute);
        } else {
          dateTime = DateTime(now.year, now.month, now.day, hour, minute);
        }
      } else {
        // Не удалось разобрать время — используем полночь
        dateTime = DateTime(now.year, now.month, now.day, 0, 0);
      }
    } catch (_) {
      return null; // если время вообще не разобрать — пропускаем строку
    }

    return Event(
      // Уникальный ID: миллисекунды + случайный суффикс
      id: '${DateTime.now().millisecondsSinceEpoch}_${title.hashCode}',
      title: title,
      dateTime: dateTime,
    );
  }

  // Парсит дату из строки (поддерживает несколько форматов)
  DateTime? _parseDate(String dateStr, int hour, int minute) {
    // Форматы: "2024-02-12", "12.02.2024", "02/12/2024"
    try {
      if (dateStr.contains('-')) {
        final parts = dateStr.split('-');
        return DateTime(
            int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]),
            hour, minute);
      } else if (dateStr.contains('.')) {
        final parts = dateStr.split('.');
        // Формат dd.MM.yyyy
        return DateTime(
            int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]),
            hour, minute);
      } else if (dateStr.contains('/')) {
        final parts = dateStr.split('/');
        // Формат MM/dd/yyyy
        return DateTime(
            int.parse(parts[2]), int.parse(parts[0]), int.parse(parts[1]),
            hour, minute);
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  // Парсит дату из формата ICS: "20240212T090000Z"
  DateTime? _parseIcsDate(String value) {
    try {
      // Убираем 'Z' (означает UTC — всемирное время)
      final clean = value.replaceAll('Z', '');
      if (clean.length >= 15) {
        return DateTime(
          int.parse(clean.substring(0, 4)),   // год
          int.parse(clean.substring(4, 6)),   // месяц
          int.parse(clean.substring(6, 8)),   // день
          int.parse(clean.substring(9, 11)),  // час
          int.parse(clean.substring(11, 13)), // минута
        );
      } else if (clean.length == 8) {
        // Только дата без времени
        return DateTime(
          int.parse(clean.substring(0, 4)),
          int.parse(clean.substring(4, 6)),
          int.parse(clean.substring(6, 8)),
        );
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}
