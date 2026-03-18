// lib/widgets/save_dialog.dart
//
// Диалог сохранения расписания в файл.
// Показывает: подтверждение → успех с кнопками "Закрыть" и "Открыть файл".

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import '../providers/schedule_provider.dart';
import '../providers/settings_provider.dart';
import '../l10n/app_strings.dart';

class SaveDialog extends StatefulWidget {
  const SaveDialog({super.key});

  @override
  State<SaveDialog> createState() => _SaveDialogState();
}

class _SaveDialogState extends State<SaveDialog> {
  // Три возможных состояния диалога
  bool _isSaving = false;
  bool _isSaved = false;
  String? _savedPath;

  Future<void> _save() async {
    setState(() => _isSaving = true);

    try {
      final scheduleProvider = context.read<ScheduleProvider>();
      final events = scheduleProvider.eventsForSelectedDay;

      // Собираем CSV-содержимое
      final buffer = StringBuffer();
      buffer.writeln('Time,Event,Date,Recurring');

      for (final event in events) {
        final time =
            '${event.dateTime.hour.toString().padLeft(2, '0')}:${event.dateTime.minute.toString().padLeft(2, '0')}';
        final date =
            '${event.dateTime.year}-${event.dateTime.month.toString().padLeft(2, '0')}-${event.dateTime.day.toString().padLeft(2, '0')}';
        buffer.writeln('$time,${event.title},$date,${event.isRecurring}');
      }

      // Получаем папку загрузок (или Documents на iOS)
      final Directory dir;
      if (Platform.isAndroid) {
        dir = Directory('/storage/emulated/0/Download');
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      final fileName =
          'schedule_${DateTime.now().millisecondsSinceEpoch}.csv';
      final file = File('${dir.path}/$fileName');
      await file.writeAsString(buffer.toString());

      setState(() {
        _isSaving = false;
        _isSaved = true;
        _savedPath = file.path;
      });
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final strings = AppStrings(settings.language);

    // Экран успеха
    if (_isSaved) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 48),
            const SizedBox(height: 16),
            Text(
              strings.savedSuccess,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(strings.close),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Открыть файловый менеджер (упрощённо — просто показываем путь)
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(_savedPath ?? '')),
              );
            },
            child: Text(strings.goToFile),
          ),
        ],
      );
    }

    // Экран подтверждения
    return AlertDialog(
      title: Text(strings.saveTitle),
      content: Text(strings.saveMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(strings.cancel),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _save, // null = кнопка неактивна
          child: _isSaving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(strings.save),
        ),
      ],
    );
  }
}
