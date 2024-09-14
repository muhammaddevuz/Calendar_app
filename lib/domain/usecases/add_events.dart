import 'package:calendar_app/domain/entities/event.dart';
import 'package:calendar_app/domain/repositories/eventRepository.dart';

class AddEvents {
  final EventRepository repository;

  AddEvents(this.repository);

  Future<void> call(Event event) async {
    return await repository.addEvent(event);
  }
}
