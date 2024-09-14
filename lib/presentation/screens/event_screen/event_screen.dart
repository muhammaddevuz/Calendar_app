import 'dart:async';
import 'package:calendar_app/domain/entities/event.dart';
import 'package:calendar_app/presentation/blocs/events_bloc/todo_events_bloc.dart';
import 'package:calendar_app/presentation/screens/event_screen/add_events_screen.dart';
import 'package:calendar_app/presentation/widgets/event_screen_widgets/event_contents.dart';
import 'package:calendar_app/presentation/widgets/event_screen_widgets/event_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventScreen extends StatefulWidget {
  final Event event;

  const EventScreen({super.key, required this.event});

  @override
  State<EventScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventScreen> {
  late Event _event;

  Future<void> _onEditEvent() async {
    final updatedEvent = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEventScreen(
          eventDateTimeInfo: _event.eventDateTimeInfo,
          event: _event,
        ),
      ),
    ) as Event?;

    if (updatedEvent != null) {
      setState(() {
        _event = updatedEvent;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _event = widget.event;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              context
                  .read<TodoEventsBloc>()
                  .add(DeleteTodoEvent(id: widget.event.id!));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.red[50],
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/icons/delete.png"),
                const SizedBox(width: 8),
                const Text(
                  'Delete Event',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          EventHeader(event: _event, onEdit: _onEditEvent),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: EventContent(
              event: _event,
            ),
          ),
        ],
      ),
    );
  }
}
