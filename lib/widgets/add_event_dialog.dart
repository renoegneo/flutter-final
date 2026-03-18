// lib/widgets/add_event_dialog.dart
//
// Диалог добавления нового события.
// StatefulWidget — виджет, у которого есть своё изменяемое состояние
// (в отличие от StatelessWidget, который всегда одинаков).

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../providers/settings_provider.dart';
import '../l10n/app_strings.dart';

class AddEventDialog extends StatefulWidget {
  final DateTime initialDate;

  const AddEventDialog({super.key, required this.initialDate});

  @override
  State<AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  // TextEditingController — управляет текстовым полем ввода
  final _titleController = TextEditingController();

  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isRecurring = false;

  @override
  void initState() {
    super.initState();
    // Инициализируем время текущим
    _selectedTime = TimeOfDay(
      hour: widget.initialDate.hour,
      minute: widget.initialDate.minute,
    );
  }

  @override
  void dispose() {
    // Важно освобождать контроллеры! Иначе утечка памяти.
    _titleController.dispose();
    super.dispose();
  }

  // Открыть системный выбор времени
  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  void _submit() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return; // не создаём пустые события

    // Собираем полную дату из выбранного дня + выбранного времени
    final dt = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
      widget.initialDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final event = Event(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      dateTime: dt,
      isRecurring: _isRecurring,
    );

    // Navigator.pop закрывает диалог и возвращает данные
    Navigator.of(context).pop(event);
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final strings = AppStrings(settings.language);

    return AlertDialog(
      title: Text(strings.addEvent),
      content: Column(
        mainAxisSize: MainAxisSize.min, // диалог подстраивается по высоте
        children: [
          // Выбор времени
          ListTile(
            leading: const Icon(Icons.access_time),
            title: Text(strings.time),
            trailing: GestureDetector(
              onTap: _pickTime,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  settings.formatTime(DateTime(
                    2000, 1, 1,
                    _selectedTime.hour,
                    _selectedTime.minute,
                  )),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            contentPadding: EdgeInsets.zero,
          ),

          const SizedBox(height: 8),

          // Поле для названия события
          TextField(
            controller: _titleController,
            autofocus: true, // сразу открывает клавиатуру
            decoration: InputDecoration(
              hintText: strings.enterEventName,
              labelText: strings.eventName,
              border: const OutlineInputBorder(),
            ),
            // Нажатие Enter = подтвердить
            onSubmitted: (_) => _submit(),
          ),

          const SizedBox(height: 8),

          // Переключатель "повторять каждую неделю"
          SwitchListTile(
            title: Text(strings.repeatsWeekly),
            value: _isRecurring,
            onChanged: (val) => setState(() => _isRecurring = val),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(), // закрыть без результата
          child: Text(strings.cancel),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(strings.add),
        ),
      ],
    );
  }
}
