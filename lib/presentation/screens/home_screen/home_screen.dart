import 'package:calendar_app/presentation/blocs/events_bloc/todo_events_bloc.dart';
import 'package:calendar_app/presentation/screens/event_screen/add_events_screen.dart';
import 'package:calendar_app/presentation/widgets/calendar_screen_widgets/event_list_widget.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();

  void _previousMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedDate.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    String dayName = DateFormat('EEEE').format(_selectedDate);
    String day = DateFormat('d').format(_selectedDate);
    String monthName = DateFormat('MMMM').format(_selectedDate);
    String year = DateFormat('y').format(_selectedDate);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              dayName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '$day $monthName $year',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, size: 35),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 35),
                    onPressed: _previousMonth,
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, size: 35),
                    onPressed: _nextMonth,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                  .map((day) => Expanded(
                        child: Center(
                          child: Text(day),
                        ),
                      ))
                  .toList(),
            ),
            _buildCalendar(),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ZoomTapAnimation(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return AddEventScreen(
                            eventDateTimeInfo: _selectedDate,
                          );
                        },
                      ));
                    },
                    child: Container(
                      height: 35,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(11),
                        color: Colors.blue,
                      ),
                      child: const Center(
                        child: Text(
                          "Add Event",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<TodoEventsBloc, TodoEventsState>(
                bloc: context.read<TodoEventsBloc>()..add(GetTodoEvent()),
                builder: (context, state) {
                  if (state is LoadingTodoEventState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is ErrorTodoEventState) {
                    return Center(
                      child: Text("Error: ${state.errorMessage}"),
                    );
                  }
                  if (state is LoadedTodoEventState) {
                    final filteredEvents = state.events.where((event) {
                      return DateFormat('yyyy-MM-dd')
                              .format(event.eventDateTimeInfo) ==
                          DateFormat('yyyy-MM-dd').format(_selectedDate);
                    }).toList();

                    if (filteredEvents.isEmpty) {
                      return const Center(
                        child: Text("No events for this date"),
                      );
                    }
                    return EventList(
                        events: filteredEvents,
                        eventDateTimeInfo: _selectedDate);
                  }

                  return const SizedBox();
                },
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    int daysInMonth =
        DateTime(_selectedDate.year, _selectedDate.month + 1, 0).day;
    int firstWeekday =
        DateTime(_selectedDate.year, _selectedDate.month, 1).weekday;

    // Agar firstWeekday 7 bo'lsa, uni 0 deb hisoblaymiz, shunda kalendar to'g'ri boshlangan bo'ladi
    if (firstWeekday == 7) {
      firstWeekday = 0;
    }

    return Expanded(
      // Expanded qo'shdik
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: daysInMonth + firstWeekday,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
        ),
        itemBuilder: (context, index) {
          if (index < firstWeekday) {
            return Container(); // Birinchi haftaning bo'sh joylarini yaratish
          }
          int day = index - firstWeekday + 1;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate =
                    DateTime(_selectedDate.year, _selectedDate.month, day);
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: _selectedDate.day == day
                        ? Colors.blue
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Text(
                      '$day',
                      style: TextStyle(
                        color: _selectedDate.day == day
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 25,
                  child: BlocBuilder<TodoEventsBloc, TodoEventsState>(
                    builder: (context, state) {
                      if (state is LoadedTodoEventState) {
                        final eventsForDay = state.events.where((event) {
                          return DateFormat('yyyy-MM-dd')
                                  .format(event.eventDateTimeInfo) ==
                              DateFormat('yyyy-MM-dd').format(
                                DateTime(_selectedDate.year,
                                    _selectedDate.month, day),
                              );
                        }).toList();

                        return SizedBox(
                          height: 23,
                          child: ListView.builder(
                            itemCount: eventsForDay.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final event = eventsForDay[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 1, vertical: 2),
                                child: Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: Color(event.eventColor),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
