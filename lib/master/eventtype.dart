import 'package:flutter/material.dart';

class EventPerformanceTyePage extends StatefulWidget {
  final TextEditingController controller;

  const EventPerformanceTyePage({super.key, required this.controller, required bool enabled});

  @override
  State<EventPerformanceTyePage> createState() => _EventPerformanceTyePageState();
}

class _EventPerformanceTyePageState extends State<EventPerformanceTyePage> {
  String selectedEventPerformance = '';

  @override
  void initState() {
    super.initState();
    
    if (widget.controller.text.isNotEmpty) {
      selectedEventPerformance = widget.controller.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedEventPerformance.isNotEmpty ? selectedEventPerformance : null,
      decoration: InputDecoration(
        labelText: 'Event Performance',
        prefixIcon: const Icon(Icons.event),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: <String>['Event1','Event2','Event3'] // Api call here for master country
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedEventPerformance = newValue!;
          widget.controller.text = newValue; 
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a Event Performance';
        }
        return null;
      },
    );
  }
}
