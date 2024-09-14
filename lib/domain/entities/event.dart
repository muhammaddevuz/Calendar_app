import 'dart:ui';

class Event {
  final int? id;
  final String eventName;
  final String eventDescription;
  final String eventLocation;
  final int eventColor;
  final String eventDateTime;
  final String eventEndTime;
  final DateTime eventDateTimeInfo;

  Event({
    this.id,
    required this.eventName,
    required this.eventDescription,
    required this.eventLocation,
    required this.eventColor,
    required this.eventDateTime,
    required this.eventEndTime,
    required this.eventDateTimeInfo,
  });

  Color get eventColorAs => Color(eventColor);
}
