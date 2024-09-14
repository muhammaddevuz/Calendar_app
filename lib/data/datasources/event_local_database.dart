// event_local_database.dart
import 'package:calendar_app/data/models/event_model.dart';

abstract class EventLocalDataSource {
  Future<void> insertEvent(EventModel event);
  Future<List<EventModel>> getEvents();
  Future<void> deleteEvent(int id);
  Future<void> editEvent(EventModel event);
}
