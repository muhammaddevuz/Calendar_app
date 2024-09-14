part of "todo_events_bloc.dart";


sealed class TodoEvent {}

final class GetTodoEvent extends TodoEvent {
  final DateTime? date;

  GetTodoEvent({this.date});
}

final class AddTodoEvent extends TodoEvent {
  final Event event;
  AddTodoEvent({required this.event});
}

final class EditTodoEvent extends TodoEvent {
  final EventModel newEvent;
  EditTodoEvent({
    required this.newEvent,
  });
}

final class DeleteTodoEvent extends TodoEvent {
  final int id;
  DeleteTodoEvent({required this.id});
}
