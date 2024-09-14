import 'package:calendar_app/data/models/event_model.dart';
import 'package:calendar_app/domain/entities/event.dart';
import 'package:calendar_app/presentation/blocs/events_bloc/todo_events_bloc.dart';
import 'package:calendar_app/presentation/screens/map_screen/map_screen.dart';
import 'package:calendar_app/presentation/widgets/add_event_widgets/color_picker.dart';
import 'package:calendar_app/presentation/widgets/add_event_widgets/cusotm_color_picker.dart';
import 'package:calendar_app/presentation/widgets/add_event_widgets/cutom_textfild.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEventScreen extends StatefulWidget {
  final Event? event;
  final DateTime eventDateTimeInfo;
  const AddEventScreen(
      {super.key, this.event, required this.eventDateTimeInfo});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();

  Color _selectedColor = Colors.red;

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      _populateFields(widget.event!);
    }
  }
    
  void _populateFields(Event event) {
    _nameController.text = event.eventName;
    _descriptionController.text = event.eventDescription;
    _locationController.text = event.eventLocation;
    _startTimeController.text = event.eventDateTime;
    _endTimeController.text = event.eventEndTime;
    _selectedColor = Color(event.eventColor);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (_) => CustomColorPicker(
        initialColor: _selectedColor,
        onColorSelected: (color) {
          setState(() {
            _selectedColor = color;
          });
        },
      ),
    );
  }

  bool _validateFields() {
    return _nameController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _locationController.text.isNotEmpty &&
        _startTimeController.text.isNotEmpty &&
        _endTimeController.text.isNotEmpty;
  }

  void _addOrUpdateEvent() {
    if (_validateFields()) {
      final event = EventModel(
          id: widget.event?.id,
          eventName: _nameController.text,
          eventDescription: _descriptionController.text,
          eventLocation: _locationController.text,
          eventColor: _selectedColor.value,
          eventDateTime: _startTimeController.text,
          eventEndTime: _endTimeController.text,
          eventDateTimeInfo: widget.eventDateTimeInfo);

      if (widget.event == null) {
        context.read<TodoEventsBloc>().add(AddTodoEvent(event: event));
      } else {
        context.read<TodoEventsBloc>().add(EditTodoEvent(newEvent: event));
      }

      Navigator.of(context).pop(event);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all the fields"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 80,
        color: Colors.transparent,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _addOrUpdateEvent,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              widget.event == null ? 'Add' : 'Update',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextfield(label: 'Event name', controller: _nameController),
              const SizedBox(height: 16),
              CustomTextfield(
                label: 'Event description',
                controller: _descriptionController,
                maxLines: 4,
              ),
              const SizedBox(height: 16),
              CustomTextfield(
                label: 'Event location',
                controller: _locationController,
              ),
              Center(
                child: TextButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (_) => const MapScreen(),
                      ),
                    );
                    _locationController.text = result['street'];
                  },
                  child: const Text("Open Maps"),
                ),
              ),
              const SizedBox(height: 16),
              ColorPicker(
                selectedColor: _selectedColor,
                onTap: _showColorPicker,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => _showTimePicker(_startTimeController),
                child: CustomTextfield(
                  ignorePointers: true,
                  label: 'Start time',
                  controller: _startTimeController,
                  suffixIcon: Icons.access_time,
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => _showTimePicker(_endTimeController),
                child: CustomTextfield(
                  ignorePointers: true,
                  label: 'End time',
                  controller: _endTimeController,
                  suffixIcon: Icons.access_time,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showTimePicker(TextEditingController controller) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        DateTime dateTime = DateTime.now();
        return CupertinoAlertDialog(
          title: const Text('Vaqtni tanlang'),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                initialDateTime: DateTime.now(),
                mode: CupertinoDatePickerMode.time,
                onDateTimeChanged: (DateTime newDateTime) {
                  dateTime = newDateTime;
                },
              ),
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('Bekor qilish'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: const Text('Tanlash'),
              onPressed: () {
                setState(() {
                  controller.text =
                      "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
