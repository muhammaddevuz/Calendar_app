// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:calendar_app/data/models/event_model.dart';
import 'package:calendar_app/domain/entities/event.dart';
import 'package:calendar_app/domain/usecases/add_events.dart';
import 'package:calendar_app/domain/usecases/delete_events.dart';
import 'package:calendar_app/domain/usecases/edit_events.dart';
import 'package:calendar_app/domain/usecases/get_events.dart';

part 'todo_events_event.dart';
part 'todo_events_state.dart';

class TodoEventsBloc extends Bloc<TodoEvent, TodoEventsState> {
  final GetEvents _getEventsUseCase;
  final AddEvents _addEventsUseCase;
  final EditEvents _editEventsUseCase;
  final DeleteEvents _deleteEventsUseCase;

  TodoEventsBloc({
    required GetEvents getEventsUseCase,
    required AddEvents addEventsUseCase,
    required EditEvents editEventsUseCase,
    required DeleteEvents deleteEventsUseCase,
  })  : _getEventsUseCase = getEventsUseCase,
        _addEventsUseCase = addEventsUseCase,
        _editEventsUseCase = editEventsUseCase,
        _deleteEventsUseCase = deleteEventsUseCase,
        super(InitialTodoEventState()) {
    on<GetTodoEvent>(_onGetTodoEvent);
    on<AddTodoEvent>(_onAddTodoEvent);
    on<EditTodoEvent>(_onEditTodoEvent);
    on<DeleteTodoEvent>(_onDeleteTodoEvent);
  }

  Future<void> _onGetTodoEvent(
      GetTodoEvent event, Emitter<TodoEventsState> emit) async {
    emit(LoadingTodoEventState());
    try {
      // final events = await _eventRepository.getEvents(event.start, event.end);
      final events = await _getEventsUseCase.call();
      emit(LoadedTodoEventState(events: events));
    } catch (e) {
      print("Error Get qlishda: $e");
      emit(ErrorTodoEventState(errorMessage: 'Failed to load events: $e'));
    }
  }

  Future<void> _onAddTodoEvent(
      AddTodoEvent event, Emitter<TodoEventsState> emit) async {
    emit(LoadingTodoEventState());
    try {
      await _addEventsUseCase(event.event);
      add(GetTodoEvent());
    } catch (e) {
      print("Eventni Add qlishda error: $e");
      emit(ErrorTodoEventState(errorMessage: e.toString()));
    }
  }

  Future<void> _onEditTodoEvent(EditTodoEvent event, Emitter emit) async {
    emit(LoadingTodoEventState());
    try {
      await _editEventsUseCase.call(event.newEvent);
      print(event);
      add(GetTodoEvent());
    } catch (e) {
      print("Eventni Edit qlishda error: $e");
      emit(ErrorTodoEventState(errorMessage: e.toString()));
    }
  }

  Future<void> _onDeleteTodoEvent(DeleteTodoEvent event, Emitter emit) async {
    emit(LoadingTodoEventState());
    try {
      await _deleteEventsUseCase(event.id);
      add(GetTodoEvent());
    } catch (e) {
      print("Eventlarni Delete qlishda error: $e");
      emit(ErrorTodoEventState(errorMessage: e.toString()));
    }
  }
}
