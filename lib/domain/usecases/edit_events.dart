import 'package:calendar_app/data/models/event_model.dart';
import 'package:calendar_app/domain/repositories/eventRepository.dart';

class EditEvents {
  final EventRepository repository;

  EditEvents(this.repository);

  Future<void> call(EventModel event) async {
    return await repository.editEvent(event);
  }
}
