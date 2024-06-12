import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:date_time_picker/date_time_picker.dart';

import '../../../../cores/helper/notification_service.dart';
import '../../domain/entity/reminder_entity.dart';
import '../bloc/reminder/reminder_bloc.dart';

class ReminderForm extends StatefulWidget {
  final ReminderEntity? reminder;

  const ReminderForm({super.key, this.reminder});

  @override
  _ReminderFormState createState() => _ReminderFormState();
}

class _ReminderFormState extends State<ReminderForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late TimeOfDay _time;

  @override
  void initState() {
    super.initState();
    if (widget.reminder != null) {
      _title = widget.reminder!.title;
      _description = widget.reminder!.description;
      _time = TimeOfDay(
          hour: widget.reminder!.hour, minute: widget.reminder!.minute);
    } else {
      _title = '';
      _description = '';
      _time = const TimeOfDay(hour: 0, minute: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final initialValue =
        '${_time.hour.toString().padLeft(2, '0')}:${_time.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _title = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _description = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              DateTimePicker(
                type: DateTimePickerType.time,
                initialValue: initialValue,
                timeHintText: 'Select Time',
                decoration: InputDecoration(
                  labelText: 'Time',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (value) {
                  final parts = value.split(":");
                  setState(() {
                    _time = TimeOfDay(
                      hour: int.parse(parts[0]),
                      minute: int.parse(parts[1]),
                    );
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a time';
                  }
                  final parts = value.split(":");
                  if (parts.length != 2) {
                    return 'Please enter a valid time';
                  }
                  final hour = int.tryParse(parts[0]);
                  final minute = int.tryParse(parts[1]);
                  if (hour == null || hour < 0 || hour > 23) {
                    return 'Please enter a valid hour (0-23)';
                  }
                  if (minute == null || minute < 0 || minute > 59) {
                    return 'Please enter a valid minute (0-59)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16.0),
                    backgroundColor: Colors.deepPurple[400],
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final reminder = ReminderEntity(
                        id: widget.reminder?.id,
                        title: _title,
                        description: _description,
                        hour: _time.hour,
                        minute: _time.minute,
                      );

                      if (widget.reminder == null) {
                        context
                            .read<ReminderBloc>()
                            .add(AddReminderEvent(reminder));
                      } else {
                        context
                            .read<ReminderBloc>()
                            .add(UpdateReminderEvent(reminder));
                      }

                      FlutterLocalNotificationService.scheduleNotification(
                          reminder);

                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(
                    widget.reminder == null
                        ? 'Add Reminder'
                        : 'Update Reminder',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
