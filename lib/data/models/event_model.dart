import 'package:calendar_app/domain/entities/event.dart';

class EventModel extends Event {
  EventModel({
    super.id,
    required super.eventName,
    required super.eventDescription,
    required super.eventLocation,
    required super.eventColor,
    required super.eventDateTime,
    required super.eventEndTime,
    required super.eventDateTimeInfo,
  });

  factory EventModel.fromMap(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] as int?,
      eventName: json['event_name'] as String,
      eventDescription: json['event_description'] as String,
      eventLocation: json['event_location'] as String,
      eventColor: json['event_color'] as int,
      eventDateTime: json['event_date_time'] as String,
      eventEndTime: json['event_end_time'] as String,
      eventDateTimeInfo: DateTime.parse(json['event_date_time_info'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'event_name': eventName,
      'event_description': eventDescription,
      'event_location': eventLocation,
      'event_color': eventColor,
      'event_date_time': eventDateTime,
      'event_end_time': eventEndTime,
      'event_date_time_info': eventDateTimeInfo.toIso8601String(),
    };
  }
}