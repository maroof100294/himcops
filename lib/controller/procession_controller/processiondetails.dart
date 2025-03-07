import 'package:flutter/material.dart';
import 'package:himcops/master/procession.dart';
import 'package:intl/intl.dart';

class ProcessionDetailsForm extends StatefulWidget {
  final TextEditingController processionTypeController;
  final TextEditingController briefDescriptionController;
  final TextEditingController startDateController;
  final TextEditingController endDateController;
  final TextEditingController processionNumberController;
  final TextEditingController startHoursController;
  final TextEditingController startMinutesController;
  final TextEditingController expectedHoursController;
  final TextEditingController expectedMinutesController;

  const ProcessionDetailsForm({
    super.key,
    required this.processionTypeController,
    required this.briefDescriptionController,
    required this.startDateController,
    required this.endDateController,
    required this.processionNumberController,
    required this.startHoursController,
    required this.startMinutesController,
    required this.expectedHoursController,
    required this.expectedMinutesController,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ProcessionDetailsFormState createState() => _ProcessionDetailsFormState();
}

class _ProcessionDetailsFormState extends State<ProcessionDetailsForm> {
  String? ValidateFullName(String value) {
    if (!RegExp(r"^[a-zA-Z\s]{1,50}$").hasMatch(value)) {
      return "Full name should only contain alphabets and spaces\nand not exceed 50 words";
    }
    return null;
  }

  Future<void> _selectStartDate(BuildContext context) async {
    //final DateTime currentDate = DateTime.now();
    final DateTime initialDate = DateTime.now(); // Default initial date
    final DateTime firstDate = DateTime.now(); // Minimum date is year 1924
    final DateTime lastDate = DateTime(2100);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      setState(() {
        widget.startDateController.text =
            DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    //final DateTime currentDate = DateTime.now();
    final DateTime initialDate = DateTime.now(); // Default initial date
    final DateTime firstDate = DateTime.now(); // Minimum date is year 1924
    final DateTime lastDate = DateTime(2100);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (pickedDate != null) {
      setState(() {
        widget.endDateController.text =
            DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProcessionPage(
            controller: widget.processionTypeController, enabled: true),
        const SizedBox(height: 10),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Expected Time of Procession',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: "Expected Hours",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: List.generate(24, (index) => index).map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString().padLeft(2, '0')),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    widget.expectedHoursController.text =
                        newValue?.toString().padLeft(2, '0')  ?? '';
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select expected hours';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: "Expected Minutes",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: List.generate(60, (index) => index).map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString().padLeft(2, '0')),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    widget.expectedMinutesController.text =
                        newValue?.toString().padLeft(2, '0') ?? '';
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select expected minutes';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.briefDescriptionController,
          enabled: true,
          decoration: InputDecoration(
            labelText: 'Brief Description',
            prefixIcon: const Icon(Icons.description),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          maxLines: 3,
          maxLength: 1000,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your details';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.processionNumberController,
          decoration: InputDecoration(
            labelText: 'Expected crowd to be gathered',
            prefixIcon: const Icon(Icons.numbers),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your details';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Start and End Date of Procession',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextFormField(
                controller: widget.startDateController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'Start Date',
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                readOnly: true,
                onTap: () {
                  _selectStartDate(context); // Open date picker
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your start date of procession';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: widget.endDateController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  labelText: 'End Date',
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                readOnly: true,
                onTap: () {
                  _selectEndDate(context); // Open date picker
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your end date of procession';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Start Time of Procession',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: "Expected Hours",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: List.generate(24, (index) => index).map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString().padLeft(2, '0')),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    widget.startHoursController.text =
                        newValue?.toString().padLeft(2, '0') ?? '';
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select expected minutes';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: "Expected Minutes",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: List.generate(60, (index) => index).map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString().padLeft(2, '0')),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    widget.startMinutesController.text =
                        newValue?.toString().padLeft(2, '0') ?? '';
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select expected minutes';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
