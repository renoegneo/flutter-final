// lib/l10n/app_strings.dart
//
// Строки интерфейса на двух языках.
// l10n — сокращение от "localization" (локализация = перевод на разные языки)

class AppStrings {
  final String language;

  const AppStrings(this.language);

  bool get _isRu => language == 'ru';

  // --- Общие ---
  String get appName => 'Schedule';
  String get cancel => _isRu ? 'Отмена' : 'Cancel';
  String get save => _isRu ? 'Сохранить' : 'Save';
  String get delete => _isRu ? 'Удалить' : 'Delete';
  String get add => _isRu ? 'Добавить' : 'Add';
  String get close => _isRu ? 'Закрыть' : 'Close';
  String get yes => _isRu ? 'Да' : 'Yes';
  String get no => _isRu ? 'Нет' : 'No';
  String get ok => 'OK';

  // --- Главный экран ---
  String get today => _isRu ? 'Сегодня' : 'Today';
  String get noEvents => _isRu ? 'Нет событий' : 'No events';
  String get addEvent => _isRu ? 'Добавить событие' : 'Add Event';

  // --- Меню ---
  String get upload => _isRu ? 'Загрузить' : 'Upload';
  String get saveSchedule => _isRu ? 'Сохранить расписание' : 'Save Schedule';
  String get calendar => _isRu ? 'Календарь' : 'Calendar';
  String get settings => _isRu ? 'Настройки' : 'Settings';

  // --- Диалог добавления ---
  String get time => _isRu ? 'Время' : 'Time';
  String get eventName => _isRu ? 'Название события' : 'Event name';
  String get enterEventName =>
      _isRu ? 'Введите название...' : 'Enter event name...';
  String get repeatsWeekly =>
      _isRu ? 'Повторять каждую неделю' : 'Repeat weekly';

  // --- Диалог удаления ---
  String get deleteEventTitle =>
      _isRu ? 'Удалить событие?' : 'Delete this event?';
  String get deleteEventMessage =>
      _isRu ? 'Это действие нельзя отменить.' : 'This action cannot be undone.';

  // --- Загрузка файла ---
  String get uploadSchedule =>
      _isRu ? 'Загрузить расписание' : 'Upload Schedule';
  String get clickToSelect =>
      _isRu ? 'Нажмите для выбора файла' : 'Click to select file or drag here';
  String get supported => _isRu ? 'Поддерживаются' : 'Supported';
  String get preview => _isRu ? 'Предпросмотр' : 'Preview';
  String get importBtn => _isRu ? 'Импортировать' : 'Import';
  String get importSuccess =>
      _isRu ? 'Расписание импортировано!' : 'Schedule imported!';

  // --- Сохранение ---
  String get saveTitle =>
      _isRu ? 'Сохранить расписание?' : 'Save this schedule?';
  String get saveMessage =>
      _isRu ? 'Файл будет сохранён в загрузки.' : 'File will be saved to downloads folder.';
  String get savedSuccess =>
      _isRu ? 'Расписание успешно сохранено!' : 'Schedule was successfully saved to downloads folder!';
  String get goToFile => _isRu ? 'Открыть файл' : 'Go to file';

  // --- Настройки ---
  String get notifications => _isRu ? 'Уведомления' : 'Notifications';
  String get darkMode => _isRu ? 'Тёмная тема' : 'Dark Mode';
  String get timeFormat => _isRu ? 'Формат времени' : 'Time Format';
  String get hour24 => _isRu ? '24-часовой' : '24-hour';
  String get hour12 => _isRu ? '12-часовой' : '12-hour';
  String get languageLabel => _isRu ? 'Язык' : 'Language';
  String get reminder => _isRu ? 'Напоминание' : 'Reminder';
  String get weekStart => _isRu ? 'Начало недели' : 'Week Start';
  String get monday => _isRu ? 'Понедельник' : 'Monday';
  String get sunday => _isRu ? 'Воскресенье' : 'Sunday';
  String minutesBefore(int n) =>
      _isRu ? 'За $n мин' : '$n min before';

  // --- Редактирование ---
  String get edit => _isRu ? 'Изменить' : 'Edit';
  String get editEvent => _isRu ? 'Изменить событие' : 'Edit Event';

  // --- Режим выделения ---
  String get selected => _isRu ? 'выбрано' : 'selected';
  String get selectAll => _isRu ? 'Выбрать все' : 'Select all';
  String deleteSelectedMessage(int count) =>
      _isRu ? 'Удалить $count событий?' : 'Delete $count events?';

  // --- Дни недели ---
  List<String> get weekDaysShort =>
      _isRu ? ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс']
             : ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  List<String> get monthNames => _isRu
      ? ['Январь','Февраль','Март','Апрель','Май','Июнь',
         'Июль','Август','Сентябрь','Октябрь','Ноябрь','Декабрь']
      : ['January','February','March','April','May','June',
         'July','August','September','October','November','December'];
}