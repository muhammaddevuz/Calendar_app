import 'package:calendar_app/presentation/widgets/calendar_screen_widgets/event_cart_widget.dart';
import 'package:flutter/material.dart';
import '../../../../domain/entities/event.dart';

class EventList extends StatelessWidget {
  final List<Event> events;
  final DateTime eventDateTimeInfo;

  const EventList({
    required this.events,
    super.key,
    required this.eventDateTimeInfo,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: EventCard(
            event: event,
            eventDatetimeInfo: eventDateTimeInfo,
          ),
        );
      },
    );
  }
}
