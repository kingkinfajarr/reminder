import '../entity/reminder_entity.dart';
import '../repositories/reminder_repository.dart';

class ReminderUseCase {
  final ReminderRepository repository;

  ReminderUseCase(this.repository);

  Future<void> addReminder(ReminderEntity reminder) {
    return repository.addReminder(reminder);
  }

  Future<void> deleteReminder(int id) {
    return repository.deleteReminder(id);
  }

  Future<List<ReminderEntity>> getAllReminders() {
    return repository.getAllReminders();
  }

  Future<void> updateReminder(ReminderEntity reminder) {
    return repository.updateReminder(reminder);
  }
}
