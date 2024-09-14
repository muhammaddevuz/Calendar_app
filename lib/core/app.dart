import 'package:calendar_app/injections.dart';
import 'package:calendar_app/presentation/blocs/events_bloc/todo_events_bloc.dart';
import 'package:calendar_app/presentation/screens/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<TodoEventsBloc>(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
