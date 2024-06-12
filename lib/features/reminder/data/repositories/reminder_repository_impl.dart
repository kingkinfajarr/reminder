import '../../domain/entity/reminder_entity.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../../domain/models/reminder_model.dart';
import '../data_sources/local/reminder_local_data_source.dart';

class ReminderRepositoryImpl implements ReminderRepository {
  final ReminderLocalDataSource _dataSource;

  ReminderRepositoryImpl(this._dataSource);

  @override
  Future<void> addReminder(ReminderEntity reminderEntity) {
    final reminder = Reminder(
      id: reminderEntity.id,
      title: reminderEntity.title,
      description: reminderEntity.description,
      hour: reminderEntity.hour,
      minute: reminderEntity.minute,
    );
    return _dataSource.insertReminder(reminder);
  }

  @override
  Future<void> deleteReminder(int id) {
    return _dataSource.deleteReminder(id);
  }

  @override
  Future<List<ReminderEntity>> getAllReminders() async {
    final reminders = await _dataSource.fetchAllReminders();
    return reminders
        .map((reminder) => ReminderEntity(
              id: reminder.id,
              title: reminder.title,
              description: reminder.description,
              hour: reminder.hour,
              minute: reminder.minute,
            ))
        .toList();
  }

  @override
  Future<void> updateReminder(ReminderEntity reminderEntity) {
    final reminder = Reminder(
      id: reminderEntity.id,
      title: reminderEntity.title,
      description: reminderEntity.description,
      hour: reminderEntity.hour,
      minute: reminderEntity.minute,
    );
    return _dataSource.updateReminder(reminder);
  }
}
