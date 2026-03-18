// lib/widgets/delete_event_dialog.dart
//
// Простой диалог подтверждения удаления.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../l10n/app_strings.dart';

class DeleteEventDialog extends StatelessWidget {
  final String eventTitle;

  const DeleteEventDialog({super.key, required this.eventTitle});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final strings = AppStrings(settings.language);

    return AlertDialog(
      title: Text(strings.deleteEventTitle),
      content: Text(strings.deleteEventMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false), // false = отмена
          child: Text(strings.cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () => Navigator.of(context).pop(true), // true = подтверждено
          child: Text(strings.delete),
        ),
      ],
    );
  }
}
