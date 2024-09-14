// ignore_for_file: file_names

import 'package:calendar_app/data/models/event_model.dart';
import 'package:calendar_app/domain/entities/event.dart';

abstract class EventRepository {
  Future<void> addEvent(Event event);
  Future<List<Event>> getAllEvents();
  Future<void> deleteEvent(int id);
  Future<void> editEvent(EventModel event);
}
