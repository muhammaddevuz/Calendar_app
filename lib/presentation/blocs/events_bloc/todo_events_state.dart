part of "todo_events_bloc.dart";

sealed class TodoEventsState {}

final class InitialTodoEventState extends TodoEventsState {}

final class LoadingTodoEventState extends TodoEventsState {}

final class LoadedTodoEventState extends TodoEventsState {
  final List<Event> events;
  LoadedTodoEventState({required this.events});
}

final class ErrorTodoEventState extends TodoEventsState {
  final String errorMessage;
  ErrorTodoEventState({required this.errorMessage});
}
