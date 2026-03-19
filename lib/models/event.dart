// модели событий

class Event {
  final String id;         // айди
  final String title;      // название ивента
  final DateTime dateTime; // дата и время начала
  final bool isRecurring;  // повторение каждую неделю
  final String? note;      // необязательная заметка

  Event({
    required this.id,
    required this.title,
    required this.dateTime,
    this.isRecurring = false,
    this.note,
  });

  // Конвертация в Map для сохранения в SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'dateTime': dateTime.toIso8601String(), // стандартный формат даты-времени
      'isRecurring': isRecurring,
      'note': note,
    };
  }

  // Создание Event из Map (когда загружаем из хранилища)
  factory Event.fromMap(Map<String, dynamic> map) {
    return Event(
      id: map['id'] as String,
      title: map['title'] as String,
      dateTime: DateTime.parse(map['dateTime'] as String),
      isRecurring: map['isRecurring'] as bool? ?? false,
      note: map['note'] as String?,
    );
  }

  // Создание копии события с изменёнными полями
  Event copyWith({
    String? id,
    String? title,
    DateTime? dateTime,
    bool? isRecurring,
    String? note,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      dateTime: dateTime ?? this.dateTime,
      isRecurring: isRecurring ?? this.isRecurring,
      note: note ?? this.note,
    );
  }
}
