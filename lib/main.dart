import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cores/helper/notification_service.dart';
import 'features/reminder/data/data_sources/local/reminder_local_data_source.dart';
import 'features/reminder/data/repositories/reminder_repository_impl.dart';
import 'features/reminder/domain/usecase/reminder_use_case.dart';
import 'features/reminder/presentation/bloc/reminder/reminder_bloc.dart';
import 'features/reminder/presentation/pages/reminder_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterLocalNotificationService.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final reminderDataSource = ReminderLocalDataSource();
            final reminderRepository =
                ReminderRepositoryImpl(reminderDataSource);
            final reminderUseCase = ReminderUseCase(reminderRepository);
            return ReminderBloc(reminderUseCase)..add(LoadRemindersEvent());
          },
        ),
      ],
      child: MaterialApp(
        title: 'Reminder App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ReminderPage(),
      ),
    );
  }
}
