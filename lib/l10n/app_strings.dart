class AppStrings {
  final String language;

  const AppStrings(this.language);

  bool get _isRu => language == 'ru';

  String get appName => 'Schedule';
  String get cancel => _isRu ? 'Отмена' : 'Cancel';
  String get save => _isRu ? 'Сохранить' : 'Save';
  String get delete => _isRu ? 'Удалить' : 'Delete';
  String get add => _isRu ? 'Добавить' : 'Add';
  String get close => _isRu ? 'Закрыть' : 'Close';
  String get yes => _isRu ? 'Да' : 'Yes';
  String get no => _isRu ? 'Нет' : 'No';
  String get ok => 'OK';

  String get today => _isRu ? 'Сегодня' : 'Today';
  String get noEvents => _isRu ? 'Нет событий' : 'No events';
  String get addEvent => _isRu ? 'Добавить событие' : 'Add Event';

  String get upload => _isRu ? 'Загрузить' : 'Upload';
  String get saveSchedule => _isRu ? 'Сохранить расписание' : 'Save Schedule';
  String get calendar => _isRu ? 'Календарь' : 'Calendar';
  String get settings => _isRu ? 'Настройки' : 'Settings';
  String get cloudAccount => _isRu ? 'Облако и аккаунт' : 'Cloud Account';

  String get time => _isRu ? 'Время' : 'Time';
  String get eventName => _isRu ? 'Название события' : 'Event name';
  String get enterEventName =>
      _isRu ? 'Введите название...' : 'Enter event name...';
  String get repeatsWeekly =>
      _isRu ? 'Повторять каждую неделю' : 'Repeat weekly';

  String get deleteEventTitle =>
      _isRu ? 'Удалить событие?' : 'Delete this event?';
  String get deleteEventMessage =>
      _isRu ? 'Это действие нельзя отменить.' : 'This action cannot be undone.';

  String get uploadSchedule =>
      _isRu ? 'Загрузить расписание' : 'Upload Schedule';
  String get clickToSelect =>
      _isRu ? 'Нажмите для выбора файла' : 'Click to select file';
  String get supported => _isRu ? 'Поддерживаются' : 'Supported';
  String get preview => _isRu ? 'Предпросмотр' : 'Preview';
  String get importBtn => _isRu ? 'Импортировать' : 'Import';
  String get importSuccess =>
      _isRu ? 'Расписание импортировано!' : 'Schedule imported!';

  String get saveTitle =>
      _isRu ? 'Сохранить расписание?' : 'Save this schedule?';
  String get saveMessage => _isRu
      ? 'Файл будет сохранен в загрузки.'
      : 'File will be saved to downloads folder.';
  String get savedSuccess => _isRu
      ? 'Расписание успешно сохранено!'
      : 'Schedule was successfully saved!';
  String get goToFile => _isRu ? 'Показать путь' : 'Show path';

  String get notifications => _isRu ? 'Уведомления' : 'Notifications';
  String get darkMode => _isRu ? 'Темная тема' : 'Dark Mode';
  String get timeFormat => _isRu ? 'Формат времени' : 'Time Format';
  String get hour24 => _isRu ? '24-часовой' : '24-hour';
  String get hour12 => _isRu ? '12-часовой' : '12-hour';
  String get languageLabel => _isRu ? 'Язык' : 'Language';
  String get reminder => _isRu ? 'Напоминание' : 'Reminder';
  String get weekStart => _isRu ? 'Начало недели' : 'Week Start';
  String get monday => _isRu ? 'Понедельник' : 'Monday';
  String get sunday => _isRu ? 'Воскресенье' : 'Sunday';
  String minutesBefore(int n) => _isRu ? 'За $n мин' : '$n min before';

  String get edit => _isRu ? 'Изменить' : 'Edit';
  String get editEvent => _isRu ? 'Изменить событие' : 'Edit Event';

  String get selected => _isRu ? 'выбрано' : 'selected';
  String get selectAll => _isRu ? 'Выбрать все' : 'Select all';
  String deleteSelectedMessage(int count) =>
      _isRu ? 'Удалить $count событий?' : 'Delete $count events?';

  String get serverUrl => _isRu ? 'URL сервера' : 'Server URL';
  String get username => _isRu ? 'Логин' : 'Username';
  String get password => _isRu ? 'Пароль' : 'Password';
  String get login => _isRu ? 'Войти' : 'Login';
  String get register => _isRu ? 'Регистрация' : 'Register';
  String get logout => _isRu ? 'Выйти' : 'Logout';
  String get cloudLoginHint => _isRu
      ? 'Введите адрес backend и данные аккаунта.'
      : 'Enter backend URL and account credentials.';
  String cloudConnectedAs(String username) =>
      _isRu ? 'Вы вошли как: $username' : 'Signed in as: $username';
  String get cloudSyncUpload =>
      _isRu ? 'Выгрузить расписание в облако' : 'Upload schedule to cloud';
  String get cloudSyncDownload =>
      _isRu ? 'Загрузить расписание из облака' : 'Download schedule from cloud';
  String get loginSuccess =>
      _isRu ? 'Вход выполнен успешно.' : 'Signed in successfully.';
  String get registerSuccess =>
      _isRu ? 'Аккаунт создан успешно.' : 'Account created successfully.';
  String cloudUploadSuccess(int count) =>
      _isRu ? 'В облако отправлено событий: $count' : 'Uploaded events: $count';
  String cloudDownloadSuccess(int count) => _isRu
      ? 'Из облака загружено событий: $count'
      : 'Downloaded events: $count';

  List<String> get weekDaysShort => _isRu
      ? ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс']
      : ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  List<String> get monthNames => _isRu
      ? [
          'Январь',
          'Февраль',
          'Март',
          'Апрель',
          'Май',
          'Июнь',
          'Июль',
          'Август',
          'Сентябрь',
          'Октябрь',
          'Ноябрь',
          'Декабрь',
        ]
      : [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December',
        ];
}
