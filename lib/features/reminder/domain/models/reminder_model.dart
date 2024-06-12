import '../entity/reminder_entity.dart';

class Reminder extends ReminderEntity {
  Reminder({
    int? id,
    required String title,
    required String description,
    required int hour,
    required int minute,
  }) : super(
          id: id,
          title: title,
          description: description,
          hour: hour,
          minute: minute,
        );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'hour': hour,
      'minute': minute,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      hour: map['hour'],
      minute: map['minute'],
    );
  }
}
