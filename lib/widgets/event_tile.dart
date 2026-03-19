// lib/widgets/event_tile.dart
// виджет для отображения одного события в списке
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/event.dart';
import '../providers/settings_provider.dart';

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
    final settingsProvider = context.watch<SettingsProvider>();
    final timeStr = settingsProvider.formatTime(event.dateTime);
    final isDark = settingsProvider.isDarkMode;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Text(
          timeStr,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[500],
            fontWeight: FontWeight.w500,
          ),
        ),
        title: Text(
          event.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
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
        onLongPress: onDelete,
        trailing: IconButton(
          icon: Icon(Icons.close, size: 18, color: Colors.grey[400]),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
