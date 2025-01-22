import 'package:flutter/material.dart';
import 'package:himcops/master/country.dart';
import 'package:himcops/master/procession.dart';
import 'package:intl/intl.dart';

class ProcessionDetailsForm extends StatefulWidget {
  final TextEditingController processionTypeController;
  final TextEditingController briefDescriptionController;
  final TextEditingController majorParticipantNameController;
  final TextEditingController majorAddressController;
  final TextEditingController majorCountryController;
  final TextEditingController majorStateController;
  final TextEditingController majorDistrictController;
  final TextEditingController majorPoliceStationController;
  final TextEditingController startAddressController;
  final TextEditingController startCountryController;
  final TextEditingController startStateController;
  final TextEditingController startDistrictController;
  final TextEditingController startPoliceStationController;
  final TextEditingController endAddressController;
  final TextEditingController endCountryController;
  final TextEditingController endStateController;
  final TextEditingController endDistrictController;
  final TextEditingController endPoliceStationController;
  final TextEditingController otherAddressController;
  final TextEditingController otherCountryController;
  final TextEditingController otherStateController;
  final TextEditingController otherDistrictController;
  final TextEditingController otherPoliceStationController;
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
    required this.majorParticipantNameController,
    required this.majorAddressController,
    required this.majorCountryController,
    required this.majorStateController,
    required this.majorDistrictController,
    required this.majorPoliceStationController,
    required this.startAddressController,
    required this.startCountryController,
    required this.startStateController,
    required this.startDistrictController,
    required this.startPoliceStationController,
    required this.endAddressController,
    required this.endCountryController,
    required this.endStateController,
    required this.endDistrictController,
    required this.endPoliceStationController,
    required this.otherAddressController,
    required this.otherCountryController,
    required this.otherStateController,
    required this.otherDistrictController,
    required this.otherPoliceStationController,
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
                value: 0, // Default value
                decoration: InputDecoration(
                  labelText: "Expected Hours",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: List.generate(101, (index) => index).map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    widget.expectedHoursController.text = newValue.toString();
                  });
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<int>(
                value: 0, // Default value
                decoration: InputDecoration(
                  labelText: "Expected Minutes",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: List.generate(101, (index) => index).map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    widget.expectedMinutesController.text = newValue.toString();
                  });
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
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Address of the Starting Point',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: widget.startAddressController,
          decoration: InputDecoration(
            labelText: 'Address',
            prefixIcon: const Icon(Icons.pin_drop),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          keyboardType: TextInputType.streetAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your details';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: CountryPage(
                  controller: widget.startCountryController, enabled: true),
            ),
          ],
        ),
        const SizedBox(height: 10),
        //statedyanmic
        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 8),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Major Head Participant Details',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: widget.majorParticipantNameController,
          decoration: InputDecoration(
            labelText: 'Name of Major Participant',
            prefixIcon: const Icon(Icons.pin_drop),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your details';
            }
            return ValidateFullName(value);
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.majorAddressController,
          decoration: InputDecoration(
            labelText: 'Address',
            prefixIcon: const Icon(Icons.pin_drop),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          keyboardType: TextInputType.streetAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your details';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: CountryPage(
                  controller: widget.majorCountryController, enabled: true),
            ),
          ],
        ),
        const SizedBox(height: 10),
        //statedynamic
        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 8),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Address of the other point in route',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: widget.otherAddressController,
          decoration: InputDecoration(
            labelText: 'Address',
            prefixIcon: const Icon(Icons.pin_drop),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          keyboardType: TextInputType.streetAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your details';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: CountryPage(
                  controller: widget.otherCountryController, enabled: true),
            ),
          ],
        ),
        const SizedBox(height: 10),
        //statedynamic
        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 8),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Address of the Ending Point',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: widget.endAddressController,
          decoration: InputDecoration(
            labelText: 'Address',
            prefixIcon: const Icon(Icons.pin_drop),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          keyboardType: TextInputType.streetAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your details';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: CountryPage(
                  controller: widget.endCountryController, enabled: true),
            ),
          ],
        ),
        const SizedBox(height: 10),
        //state dynamic
        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 8),
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
                value: 0, // Default value
                decoration: InputDecoration(
                  labelText: "Expected Hours",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: List.generate(101, (index) => index).map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    widget.startHoursController.text = newValue.toString();
                  });
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DropdownButtonFormField<int>(
                value: 0, // Default value
                decoration: InputDecoration(
                  labelText: "Expected Minutes",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: List.generate(101, (index) => index).map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    widget.startMinutesController.text = newValue.toString();
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
