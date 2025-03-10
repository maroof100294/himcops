import 'package:flutter/material.dart';
import 'package:himcops/master/natureofstructure.dart';
import 'package:himcops/master/protest.dart';
import 'package:intl/intl.dart';

class ProtestDetailsForm extends StatefulWidget {
  final TextEditingController instituteNameController;
  final TextEditingController protestTypeController;
  final TextEditingController briefDescriptionController;
  final TextEditingController startDateController;
  final TextEditingController endDateController;
  final TextEditingController startHoursController;
  final TextEditingController startMinutesController;
  final TextEditingController expectedHoursController;
  final TextEditingController expectedMinutesController;
  final TextEditingController locationAreaController;
  final TextEditingController locationNumberController;
  final TextEditingController structureNatureController;

  const ProtestDetailsForm({
    super.key,
    required this.instituteNameController,
    required this.protestTypeController,
    required this.briefDescriptionController,
    required this.startDateController,
    required this.endDateController,
    required this.startHoursController,
    required this.startMinutesController,
    required this.expectedHoursController,
    required this.expectedMinutesController,
    required this.locationAreaController,
    required this.locationNumberController,
    required this.structureNatureController,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ProtestDetailsFormState createState() => _ProtestDetailsFormState();
}

class _ProtestDetailsFormState extends State<ProtestDetailsForm> {
  int? selectedStateId;

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
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Name of Target Institution/Person\n(Against which Protest/Strike is planned)',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: widget.instituteNameController,
          decoration: InputDecoration(
            labelText: 'Name of Target',
            prefixIcon: const Icon(Icons.location_city),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter name of target institute';
            }
            return ValidateFullName(value);
          },
        ),
        const SizedBox(height: 8),
        const Divider(),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Expected time limit\nfor the Protest/Strike (per day)',
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
                    widget.expectedHoursController.text = newValue?.toString().padLeft(2, '0') ?? '';
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
                    widget.expectedMinutesController.text = newValue?.toString().padLeft(2, '0') ?? '';
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
            labelText: 'Description of Protest/Strike*',
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
        ProtestPage(controller: widget.protestTypeController, enabled: true),
        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 14),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Location area size details in Sq.Mts.',
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
                controller: widget.locationNumberController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter loction area';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        NatureStructurePage(
            controller: widget.structureNatureController, enabled: true),
        const SizedBox(height: 10),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Start and End Date of the Protest/Strike',
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
                    return 'Please enter your start date of the Protest/Strike';
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
                    return 'Please enter your end date of the Protest/Strike';
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
                'Start Time of the Protest/Strike',
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
                    child: Text(
                        value.toString().padLeft(2, '0')), // Ensures two digits
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
                    child: Text(
                        value.toString().padLeft(2, '0')), // Ensures two digits
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
