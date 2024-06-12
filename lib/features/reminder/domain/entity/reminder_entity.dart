class ReminderEntity {
  final int? id;
  final String title;
  final String description;
  final int hour;
  final int minute;

  ReminderEntity({
    this.id,
    required this.title,
    required this.description,
    required this.hour,
    required this.minute,
  });
}
