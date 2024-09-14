import 'package:calendar_app/domain/repositories/eventRepository.dart';

class DeleteEvents {
  final EventRepository repository;
  DeleteEvents(this.repository);

  Future<void> call(int id) async {
    return await repository.deleteEvent(id);
  }
}
