// lib/widgets/event_tile.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../providers/schedule_provider.dart';
import '../providers/settings_provider.dart';
import '../l10n/app_strings.dart';
import 'add_event_dialog.dart';

class EventTile extends StatelessWidget {
  final Event event;
  final VoidCallback onDelete;

  const EventTile({
    super.key,
    required this.event,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final schedule = context.watch<ScheduleProvider>();
    final timeStr = settings.formatTime(event.dateTime);
    final isDark = settings.isDarkMode;
    final strings = AppStrings(settings.language);

    final isSelectionMode = schedule.isSelectionMode;
    final isSelected = schedule.selectedIds.contains(event.id);

    // Цвет фона: подсвечиваем если выделено
    final bgColor = isSelected
        ? Theme.of(context).colorScheme.primaryContainer
        : isDark
            ? const Color(0xFF2C2C2E)
            : Colors.white;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        // В режиме выделения — слева чекбокс, иначе — время
        leading: isSelectionMode
            ? Checkbox(
                value: isSelected,
                onChanged: (_) => schedule.toggleSelection(event.id),
              )
            : Text(
                timeStr,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),

        title: Text(
          event.title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),

        subtitle: event.isRecurring
            ? Row(
                children: [
                  Icon(Icons.repeat, size: 12, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    'Weekly',
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
                ],
              )
            : null,

        // Долгое нажатие — входим в режим выделения
        onLongPress: isSelectionMode
            ? null
            : () => schedule.enterSelectionMode(event.id),

        // В режиме выделения — тап переключает чекбокс
        onTap: isSelectionMode
            ? () => schedule.toggleSelection(event.id)
            : null,

        // Справа: в режиме выделения ничего, иначе — троеточие
        trailing: isSelectionMode
            ? null
            : _ThreeDotMenu(
                event: event,
                onDelete: onDelete,
                strings: strings,
              ),
      ),
    );
  }
}

// Меню с тремя точками (⋮) — вынесено в отдельный виджет для чистоты
class _ThreeDotMenu extends StatelessWidget {
  final Event event;
  final VoidCallback onDelete;
  final AppStrings strings;

  const _ThreeDotMenu({
    required this.event,
    required this.onDelete,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    // PopupMenuButton — стандартный Flutter-виджет для выпадающего меню
    return PopupMenuButton<_MenuAction>(
      icon: Icon(Icons.more_vert, color: Colors.grey[400]),
      onSelected: (action) {
        switch (action) {
          case _MenuAction.edit:
            _showEditDialog(context);
          case _MenuAction.delete:
            onDelete();
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: _MenuAction.edit,
          child: Row(
            children: [
              const Icon(Icons.edit_outlined, size: 18),
              const SizedBox(width: 8),
              Text(strings.edit),
            ],
          ),
        ),
        PopupMenuItem(
          value: _MenuAction.delete,
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 18, color: Colors.red[400]),
              const SizedBox(width: 8),
              Text(strings.delete, style: TextStyle(color: Colors.red[400])),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showEditDialog(BuildContext context) async {
    // Переиспользуем AddEventDialog — передаём существующее событие
    final Event? updated = await showDialog<Event>(
      context: context,
      builder: (_) => AddEventDialog(
        initialDate: event.dateTime,
        existingEvent: event, // новый параметр — редактирование
      ),
    );

    if (updated != null && context.mounted) {
      await context.read<ScheduleProvider>().updateEvent(updated);
    }
  }
}

// Enum для пунктов меню. Enum — перечисление фиксированных вариантов.
// Лучше чем строки типа 'edit'/'delete' — компилятор поймает опечатку
enum _MenuAction { edit, delete }