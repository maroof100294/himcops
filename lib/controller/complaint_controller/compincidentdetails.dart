import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ComplaintIncidentDetailsForm extends StatefulWidget {
  final TextEditingController incidentDateTimeFromController;
  final TextEditingController incidentDateTimeToController;
  final TextEditingController incidentPlaceController;
  final TextEditingController dateController;
  final TextEditingController complaintDescriptionController;

  const ComplaintIncidentDetailsForm({
    super.key,
    required this.incidentDateTimeFromController,
    required this.incidentDateTimeToController,
    required this.incidentPlaceController,
    required this.dateController,
    required this.complaintDescriptionController,
  });

  @override
  _ComplaintIncidentDetailsFormState createState() =>
      _ComplaintIncidentDetailsFormState();
}

class _ComplaintIncidentDetailsFormState
    extends State<ComplaintIncidentDetailsForm> {
  Future<void> _selectDateTime(TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1924),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        controller.text = DateFormat('yyyy-MM-dd HH:mm').format(finalDateTime);
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime initialDate = DateTime.now();
    final DateTime firstDate = DateTime(1924);
    final DateTime lastDate = DateTime.now();

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      setState(() {
        widget.dateController.text =
            DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Set the current date as the initial value
    widget.dateController.text =
        DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  bool isIncident = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Is Date / Time of Incident Known?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                value: true,
                groupValue: isIncident,
                onChanged: (val) {
                  setState(() {
                    isIncident = val!;
                  });
                },
                title: const Text('Yes'),
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                value: false,
                groupValue: isIncident,
                onChanged: (val) {
                  setState(() {
                    isIncident = val!;
                  });
                },
                title: const Text("No"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (isIncident) ...[
          GestureDetector(
            onTap: () => _selectDateTime(widget.incidentDateTimeFromController),
            child: AbsorbPointer(
              child: TextFormField(
                controller: widget.incidentDateTimeFromController,
                decoration: InputDecoration(
                  labelText: 'Date & Time of Incident From',
                  prefixIcon: const Icon(Icons.calendar_month),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Date & Time of Incident';
                  }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => _selectDateTime(widget.incidentDateTimeToController),
            child: AbsorbPointer(
              child: TextFormField(
                controller: widget.incidentDateTimeToController,
                decoration: InputDecoration(
                  labelText: 'Date & Time of Incident To',
                  prefixIcon: const Icon(Icons.calendar_month),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Date & Time of Incident';
                  }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
        TextFormField(
          controller: widget.incidentPlaceController,
          decoration: InputDecoration(
            labelText: 'Place of Incident',
            prefixIcon: const Icon(Icons.place),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your incident place';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        Divider(),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.dateController,
          decoration: InputDecoration(
            labelText: 'Date of Complaint',
            prefixIcon: const Icon(Icons.calendar_month),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onTap: () {
            _selectDate(context);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your complaint date';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.complaintDescriptionController,
          decoration: InputDecoration(
            labelText: 'Complaint Description',
            prefixIcon: const Icon(Icons.place),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          maxLength: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your complaint';
            }
            return null;
          },
        ),
      ],
    );
  }
}
