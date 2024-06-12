import '../entity/reminder_entity.dart';

abstract class ReminderRepository {
  Future<void> addReminder(ReminderEntity reminder);
  Future<void> deleteReminder(int id);
  Future<List<ReminderEntity>> getAllReminders();
  Future<void> updateReminder(ReminderEntity reminder);
}
