import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reminder/features/reminder/presentation/widgets/card_reminder_widget.dart';

import '../../domain/entity/reminder_entity.dart';
import '../bloc/reminder/reminder_bloc.dart';
import '../widgets/reminder_form_widget.dart';

class ReminderPage extends StatelessWidget {
  const ReminderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reminders")),
      body: BlocBuilder<ReminderBloc, ReminderState>(
        builder: (context, state) {
          if (state is ReminderLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ReminderLoaded) {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.reminders.length,
              itemBuilder: (context, index) {
                final reminder = state.reminders[index];
                return CardReminderWidget(
                  title: reminder.title,
                  description: reminder.description,
                  time: "${reminder.hour}:${reminder.minute}",
                  onEdit: () {
                    _showFormDialog(context, reminder: reminder);
                  },
                  onDelete: () {
                    _showDialog(context, reminder);
                  },
                );
              },
            );
          }
          if (state is ReminderError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showFormDialog(BuildContext context, {ReminderEntity? reminder}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(reminder == null ? 'Add Reminder' : 'Edit Reminder'),
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ReminderForm(reminder: reminder),
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, ReminderEntity reminder) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Confirmation'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                context.read<ReminderBloc>().add(
                      DeleteReminderEvent(reminder.id!),
                    );
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
