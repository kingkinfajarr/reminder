import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entity/reminder_entity.dart';
import '../../../domain/usecase/reminder_use_case.dart';

part 'reminder_event.dart';
part 'reminder_state.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  final ReminderUseCase useCase;

  ReminderBloc(this.useCase) : super(ReminderInitial()) {
    on<LoadRemindersEvent>((event, emit) async {
      emit(ReminderLoading());
      try {
        final reminders = await useCase.getAllReminders();
        emit(ReminderLoaded(reminders));
      } catch (_) {
        emit(const ReminderError("Failed to load reminders"));
      }
    });

    on<AddReminderEvent>((event, emit) async {
      await useCase.addReminder(event.reminder);
      add(LoadRemindersEvent());
    });

    on<UpdateReminderEvent>((event, emit) async {
      await useCase.updateReminder(event.reminder);
      add(LoadRemindersEvent());
    });

    on<DeleteReminderEvent>((event, emit) async {
      await useCase.deleteReminder(event.id);
      add(LoadRemindersEvent());
    });
  }
}
