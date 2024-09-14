import 'package:calendar_app/data/datasources/event_local_database.dart';
import 'package:calendar_app/data/models/event_model.dart';
import 'package:calendar_app/domain/entities/event.dart';
import 'package:calendar_app/domain/repositories/eventRepository.dart';

class EventRepositoryPerf implements EventRepository {
  final EventLocalDataSource localDataSource;

  EventRepositoryPerf(this.localDataSource);

  @override
  Future<void> addEvent(Event event) async {
    final eventModel = EventModel(
      eventName: event.eventName,
      eventDescription: event.eventDescription,
      eventLocation: event.eventLocation,
      eventColor: event.eventColor,
      eventDateTime: event.eventDateTime,
      eventEndTime: event.eventEndTime,
      eventDateTimeInfo: event.eventDateTimeInfo,
    );
    return await localDataSource.insertEvent(eventModel);
  }

  @override
  Future<List<Event>> getAllEvents() async {
    return await localDataSource.getEvents();
  }

  @override
  Future<void> deleteEvent(int id) async {
    return await localDataSource.deleteEvent(id);
  }

  @override
  Future<void> editEvent(EventModel event) async {
    final eventsModel = EventModel(
      id: event.id,
      eventName: event.eventName,
      eventDescription: event.eventDescription,
      eventLocation: event.eventLocation,
      eventColor: event.eventColor,
      eventDateTime: event.eventDateTime,
      eventEndTime: event.eventEndTime,
      eventDateTimeInfo: event.eventDateTimeInfo,
    );
    return await localDataSource.editEvent(eventsModel);
  }
}
