// lib/widgets/add_event_dialog.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../providers/settings_provider.dart';
import '../l10n/app_strings.dart';

class AddEventDialog extends StatefulWidget {
  final DateTime initialDate;
  // Если передан existingEvent — режим редактирования, иначе — добавление
  final Event? existingEvent;

  const AddEventDialog({
    super.key,
    required this.initialDate,
    this.existingEvent,
  });

  @override
  State<AddEventDialog> createState() => _AddEventDialogState();
}

class _AddEventDialogState extends State<AddEventDialog> {
  late final TextEditingController _titleController;
  late TimeOfDay _selectedTime;
  late bool _isRecurring;

  // Режим редактирования если передан existingEvent
  bool get _isEditing => widget.existingEvent != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingEvent;
    // Если редактируем — заполняем поля из существующего события
    _titleController = TextEditingController(text: existing?.title ?? '');
    _selectedTime = existing != null
        ? TimeOfDay(hour: existing.dateTime.hour, minute: existing.dateTime.minute)
        : TimeOfDay(hour: widget.initialDate.hour, minute: widget.initialDate.minute);
    _isRecurring = existing?.isRecurring ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

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
    if (title.isEmpty) return;

    final dt = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
      widget.initialDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final event = Event(
      // При редактировании сохраняем тот же ID — иначе создастся новое событие
      id: widget.existingEvent?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      dateTime: dt,
      isRecurring: _isRecurring,
    );

    Navigator.of(context).pop(event);
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final strings = AppStrings(settings.language);

    return AlertDialog(
      // Заголовок меняется в зависимости от режима
      title: Text(_isEditing ? strings.editEvent : strings.addEvent),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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

          TextField(
            controller: _titleController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: strings.enterEventName,
              labelText: strings.eventName,
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) => _submit(),
          ),

          const SizedBox(height: 8),

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
          onPressed: () => Navigator.of(context).pop(),
          child: Text(strings.cancel),
        ),
        FilledButton(
          onPressed: _submit,
          // Кнопка "Сохранить" при редактировании, "Добавить" при создании
          child: Text(_isEditing ? strings.save : strings.add),
        ),
      ],
    );
  }
}