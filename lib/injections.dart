import 'package:calendar_app/data/datasources/event_local_database.dart';
import 'package:calendar_app/data/datasources/event_local_perf.dart';
import 'package:calendar_app/data/repositories/event_repository_perf.dart';
import 'package:calendar_app/domain/repositories/eventRepository.dart';
import 'package:calendar_app/domain/usecases/add_events.dart';
import 'package:calendar_app/domain/usecases/delete_events.dart';
import 'package:calendar_app/domain/usecases/edit_events.dart';
import 'package:calendar_app/domain/usecases/get_events.dart';
import 'package:calendar_app/presentation/blocs/events_bloc/todo_events_bloc.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;
Future<void> init() async {
  getIt.registerSingleton<EventLocalDataSource>(EventLocalDataSourcePerf());

  getIt.registerSingleton<EventRepository>(
    EventRepositoryPerf(getIt.get<EventLocalDataSource>()),
  );

  getIt.registerSingleton<AddEvents>(
    AddEvents(getIt.get<EventRepository>()),
  );

  getIt.registerSingleton<GetEvents>(
    GetEvents(getIt.get<EventRepository>()),
  );

  getIt.registerSingleton<DeleteEvents>(
    DeleteEvents(getIt.get<EventRepository>()),
  );

  getIt.registerSingleton<EditEvents>(
    EditEvents(getIt.get<EventRepository>()),
  );

  getIt.registerSingleton<TodoEventsBloc>(
    TodoEventsBloc(
      getEventsUseCase: getIt.get<GetEvents>(),
      addEventsUseCase: getIt.get<AddEvents>(),
      editEventsUseCase: getIt.get<EditEvents>(),
      deleteEventsUseCase: getIt.get<DeleteEvents>(),
    ),
  );
}
