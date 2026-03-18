# Schedule App

Мобильное приложение для управления расписанием на Flutter.

## Что умеет

- Просмотр событий на выбранный день
- Добавление и удаление событий
- Повторяющиеся события (каждую неделю)
- Импорт расписания из файлов: `.csv`, `.xlsx`, `.ics`
- Сохранение расписания в `.csv`
- Календарь с выбором дня
- Тёмная и светлая тема
- Русский и английский язык
- Формат времени 12/24 часа

## Как запустить

### 1. Установи Flutter

Скачай с https://flutter.dev/docs/get-started/install  
Проверь установку: `flutter doctor`

### 2. Установи зависимости

```bash
cd schedule_app
flutter pub get
```

Эта команда скачает все пакеты из pubspec.yaml.

### 3. Запусти приложение

```bash
# Посмотреть доступные устройства (эмулятор или реальный телефон)
flutter devices

# Запустить
flutter run
```

## Структура проекта

```
lib/
  main.dart                  # Точка входа
  theme.dart                 # Цвета и стили
  models/
    event.dart               # Модель события
    settings.dart            # Модель настроек
  services/
    storage_service.dart     # Чтение/запись на телефон
    file_import_service.dart # Парсинг CSV / XLSX / ICS
  providers/
    schedule_provider.dart   # Состояние расписания
    settings_provider.dart   # Состояние настроек
  screens/
    home_screen.dart         # Главный экран
    calendar_screen.dart     # Календарь
    upload_screen.dart       # Загрузка файла
    settings_screen.dart     # Настройки
  widgets/
    event_tile.dart          # Карточка события
    add_event_dialog.dart    # Диалог добавления
    delete_event_dialog.dart # Диалог удаления
    save_dialog.dart         # Диалог сохранения
    burger_menu.dart         # Боковое меню
  l10n/
    app_strings.dart         # Переводы (EN / RU)
```

## Форматы файлов для импорта

### CSV
```
Time,Event,Date
09:00,Math Class,2024-02-12
10:30,History Lecture,2024-02-12
```

### ICS (iCalendar)
Стандартный формат экспорта из Google Calendar, Outlook, Apple Calendar.

### XLSX
Таблица Excel с колонками: Time | Event | Date (опционально)

## Частые вопросы

**`flutter pub get` падает с ошибкой?**  
Проверь версию Flutter: `flutter --version`. Нужна версия 3.10+.

**На Android не сохраняется файл?**  
На Android 11+ нужно выдать разрешение на файлы вручную в Настройках телефона → Приложения → Schedule → Разрешения.
