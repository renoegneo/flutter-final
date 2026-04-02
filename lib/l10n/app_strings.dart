class AppStrings {
  final String language;

  const AppStrings(this.language);

  bool get _isRu => language == 'ru';

  String get appName => 'Schedule';
  String get cancel => _isRu ? 'РћС‚РјРµРЅР°' : 'Cancel';
  String get save => _isRu ? 'РЎРѕС…СЂР°РЅРёС‚СЊ' : 'Save';
  String get delete => _isRu ? 'РЈРґР°Р»РёС‚СЊ' : 'Delete';
  String get add => _isRu ? 'Р”РѕР±Р°РІРёС‚СЊ' : 'Add';
  String get close => _isRu ? 'Р—Р°РєСЂС‹С‚СЊ' : 'Close';
  String get yes => _isRu ? 'Р”Р°' : 'Yes';
  String get no => _isRu ? 'РќРµС‚' : 'No';
  String get ok => 'OK';

  String get today => _isRu ? 'РЎРµРіРѕРґРЅСЏ' : 'Today';
  String get noEvents => _isRu ? 'РќРµС‚ СЃРѕР±С‹С‚РёР№' : 'No events';
  String get addEvent =>
      _isRu ? 'Р”РѕР±Р°РІРёС‚СЊ СЃРѕР±С‹С‚РёРµ' : 'Add Event';

  String get upload => _isRu ? 'Р—Р°РіСЂСѓР·РёС‚СЊ' : 'Upload';
  String get saveSchedule =>
      _isRu ? 'РЎРѕС…СЂР°РЅРёС‚СЊ СЂР°СЃРїРёСЃР°РЅРёРµ' : 'Save Schedule';
  String get calendar => _isRu ? 'РљР°Р»РµРЅРґР°СЂСЊ' : 'Calendar';
  String get settings => _isRu ? 'РќР°СЃС‚СЂРѕР№РєРё' : 'Settings';
  String get cloudAccount =>
      _isRu ? 'РћР±Р»Р°РєРѕ Рё Р°РєРєР°СѓРЅС‚' : 'Cloud Account';

  String get time => _isRu ? 'Р’СЂРµРјСЏ' : 'Time';
  String get eventName =>
      _isRu ? 'РќР°Р·РІР°РЅРёРµ СЃРѕР±С‹С‚РёСЏ' : 'Event name';
  String get enterEventName =>
      _isRu ? 'Р’РІРµРґРёС‚Рµ РЅР°Р·РІР°РЅРёРµ...' : 'Enter event name...';
  String get repeatsWeekly =>
      _isRu ? 'РџРѕРІС‚РѕСЂСЏС‚СЊ РєР°Р¶РґСѓСЋ РЅРµРґРµР»СЋ' : 'Repeat weekly';

  String get deleteEventTitle =>
      _isRu ? 'РЈРґР°Р»РёС‚СЊ СЃРѕР±С‹С‚РёРµ?' : 'Delete this event?';
  String get deleteEventMessage => _isRu
      ? 'Р­С‚Рѕ РґРµР№СЃС‚РІРёРµ РЅРµР»СЊР·СЏ РѕС‚РјРµРЅРёС‚СЊ.'
      : 'This action cannot be undone.';

  String get uploadSchedule =>
      _isRu ? 'Р—Р°РіСЂСѓР·РёС‚СЊ СЂР°СЃРїРёСЃР°РЅРёРµ' : 'Upload Schedule';
  String get clickToSelect => _isRu
      ? 'РќР°Р¶РјРёС‚Рµ РґР»СЏ РІС‹Р±РѕСЂР° С„Р°Р№Р»Р°'
      : 'Click to select file';
  String get supported => _isRu ? 'РџРѕРґРґРµСЂР¶РёРІР°СЋС‚СЃСЏ' : 'Supported';
  String get preview => _isRu ? 'РџСЂРµРґРїСЂРѕСЃРјРѕС‚СЂ' : 'Preview';
  String get importBtn => _isRu ? 'РРјРїРѕСЂС‚РёСЂРѕРІР°С‚СЊ' : 'Import';
  String get importSuccess => _isRu
      ? 'Р Р°СЃРїРёСЃР°РЅРёРµ РёРјРїРѕСЂС‚РёСЂРѕРІР°РЅРѕ!'
      : 'Schedule imported!';

  String get saveTitle => _isRu
      ? 'РЎРѕС…СЂР°РЅРёС‚СЊ СЂР°СЃРїРёСЃР°РЅРёРµ?'
      : 'Save this schedule?';
  String get saveMessage => _isRu
      ? 'Р¤Р°Р№Р» Р±СѓРґРµС‚ СЃРѕС…СЂР°РЅРµРЅ РІ Р·Р°РіСЂСѓР·РєРё.'
      : 'File will be saved to downloads folder.';
  String get savedSuccess => _isRu
      ? 'Р Р°СЃРїРёСЃР°РЅРёРµ СѓСЃРїРµС€РЅРѕ СЃРѕС…СЂР°РЅРµРЅРѕ!'
      : 'Schedule was successfully saved!';
  String get goToFile => _isRu ? 'РџРѕРєР°Р·Р°С‚СЊ РїСѓС‚СЊ' : 'Show path';

  String get notifications =>
      _isRu ? 'РЈРІРµРґРѕРјР»РµРЅРёСЏ' : 'Notifications';
  String get darkMode => _isRu ? 'РўРµРјРЅР°СЏ С‚РµРјР°' : 'Dark Mode';
  String get timeFormat =>
      _isRu ? 'Р¤РѕСЂРјР°С‚ РІСЂРµРјРµРЅРё' : 'Time Format';
  String get hour24 => _isRu ? '24-С‡Р°СЃРѕРІРѕР№' : '24-hour';
  String get hour12 => _isRu ? '12-С‡Р°СЃРѕРІРѕР№' : '12-hour';
  String get languageLabel => _isRu ? 'РЇР·С‹Рє' : 'Language';
  String get reminder => _isRu ? 'РќР°РїРѕРјРёРЅР°РЅРёРµ' : 'Reminder';
  String get weekStart => _isRu ? 'РќР°С‡Р°Р»Рѕ РЅРµРґРµР»Рё' : 'Week Start';
  String get monday => _isRu ? 'РџРѕРЅРµРґРµР»СЊРЅРёРє' : 'Monday';
  String get sunday => _isRu ? 'Р’РѕСЃРєСЂРµСЃРµРЅСЊРµ' : 'Sunday';
  String minutesBefore(int n) => _isRu ? 'Р—Р° $n РјРёРЅ' : '$n min before';

  String get edit => _isRu ? 'РР·РјРµРЅРёС‚СЊ' : 'Edit';
  String get editEvent =>
      _isRu ? 'РР·РјРµРЅРёС‚СЊ СЃРѕР±С‹С‚РёРµ' : 'Edit Event';

  String get selected => _isRu ? 'РІС‹Р±СЂР°РЅРѕ' : 'selected';
  String get selectAll => _isRu ? 'Р’С‹Р±СЂР°С‚СЊ РІСЃРµ' : 'Select all';
  String deleteSelectedMessage(int count) =>
      _isRu ? 'РЈРґР°Р»РёС‚СЊ $count СЃРѕР±С‹С‚РёР№?' : 'Delete $count events?';

  String get serverUrl => _isRu ? 'URL СЃРµСЂРІРµСЂР°' : 'Server URL';
  String get username => _isRu ? 'Р›РѕРіРёРЅ' : 'Username';
  String get password => _isRu ? 'РџР°СЂРѕР»СЊ' : 'Password';
  String get login => _isRu ? 'Р’РѕР№С‚Рё' : 'Login';
  String get register => _isRu ? 'Р РµРіРёСЃС‚СЂР°С†РёСЏ' : 'Register';
  String get logout => _isRu ? 'Р’С‹Р№С‚Рё' : 'Logout';
  String get cloudLoginHint => _isRu
      ? 'Р’РІРµРґРёС‚Рµ Р°РґСЂРµСЃ backend Рё РґР°РЅРЅС‹Рµ Р°РєРєР°СѓРЅС‚Р°.'
      : 'Enter username and password. Backend URL is configured in code.';
  String cloudConnectedAs(String username) =>
      _isRu ? 'Р’С‹ РІРѕС€Р»Рё РєР°Рє: $username' : 'Signed in as: $username';
  String get cloudSyncUpload => _isRu
      ? 'Р’С‹РіСЂСѓР·РёС‚СЊ СЂР°СЃРїРёСЃР°РЅРёРµ РІ РѕР±Р»Р°РєРѕ'
      : 'Upload schedule to cloud';
  String get cloudSyncDownload => _isRu
      ? 'Р—Р°РіСЂСѓР·РёС‚СЊ СЂР°СЃРїРёСЃР°РЅРёРµ РёР· РѕР±Р»Р°РєР°'
      : 'Download schedule from cloud';
  String get loginSuccess => _isRu
      ? 'Р’С…РѕРґ РІС‹РїРѕР»РЅРµРЅ СѓСЃРїРµС€РЅРѕ.'
      : 'Signed in successfully.';
  String get registerSuccess => _isRu
      ? 'РђРєРєР°СѓРЅС‚ СЃРѕР·РґР°РЅ СѓСЃРїРµС€РЅРѕ.'
      : 'Account created successfully.';
  String cloudUploadSuccess(int count) => _isRu
      ? 'Р’ РѕР±Р»Р°РєРѕ РѕС‚РїСЂР°РІР»РµРЅРѕ СЃРѕР±С‹С‚РёР№: $count'
      : 'Uploaded events: $count';
  String cloudDownloadSuccess(int count) => _isRu
      ? 'РР· РѕР±Р»Р°РєР° Р·Р°РіСЂСѓР¶РµРЅРѕ СЃРѕР±С‹С‚РёР№: $count'
      : 'Downloaded events: $count';

  List<String> get weekDaysShort => _isRu
      ? ['РџРЅ', 'Р’С‚', 'РЎСЂ', 'Р§С‚', 'РџС‚', 'РЎР±', 'Р’СЃ']
      : ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];

  List<String> get monthNames => _isRu
      ? [
          'РЇРЅРІР°СЂСЊ',
          'Р¤РµРІСЂР°Р»СЊ',
          'РњР°СЂС‚',
          'РђРїСЂРµР»СЊ',
          'РњР°Р№',
          'РСЋРЅСЊ',
          'РСЋР»СЊ',
          'РђРІРіСѓСЃС‚',
          'РЎРµРЅС‚СЏР±СЂСЊ',
          'РћРєС‚СЏР±СЂСЊ',
          'РќРѕСЏР±СЂСЊ',
          'Р”РµРєР°Р±СЂСЊ',
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
