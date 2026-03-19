// lib/widgets/burger_menu.dart
// бургер меню

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../l10n/app_strings.dart';
import '../screens/upload_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/calendar_screen.dart';
import 'save_dialog.dart';

class BurgerMenu extends StatelessWidget {
  const BurgerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final strings = AppStrings(settings.language);

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Заголовок меню
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                strings.appName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Divider(),

            // Пункты меню
            _MenuItem(
              icon: Icons.upload_file,
              label: strings.upload,
              onTap: () {
                Navigator.of(context).pop(); // закрыть меню
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const UploadScreen()),
                );
              },
            ),

            _MenuItem(
              icon: Icons.save_alt,
              label: strings.saveSchedule,
              onTap: () {
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (_) => const SaveDialog(),
                );
              },
            ),

            _MenuItem(
              icon: Icons.calendar_month,
              label: strings.calendar,
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const CalendarScreen()),
                );
              },
            ),

            const Spacer(), // растягивает пустое пространство, прижимая Settings вниз

            const Divider(),

            _MenuItem(
              icon: Icons.settings,
              label: strings.settings,
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Вспомогательный виджет для пункта меню (избегаем дублирования кода)
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label, style: const TextStyle(fontSize: 16)),
      onTap: onTap,
    );
  }
}
