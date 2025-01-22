import 'package:flutter/material.dart';
import 'package:himcops/master/addressverification.dart';
import 'package:himcops/master/gender.dart';
import 'package:intl/intl.dart';

class EmployeeBasicDetailsForm extends StatefulWidget {
  final TextEditingController departmentController;
  final TextEditingController dateController;
  final TextEditingController nameController;
  final TextEditingController genderController;
  final TextEditingController dateDobController;
  final TextEditingController ageController;
  final TextEditingController placeBirthController;
  final TextEditingController employeeAddressVerificationController;
  final TextEditingController docController;

  const EmployeeBasicDetailsForm({
    super.key,
    required this.departmentController,
    required this.dateController,
    required this.nameController,
    required this.genderController,
    required this.dateDobController,
    required this.ageController,
    required this.placeBirthController,
    required this.employeeAddressVerificationController,
    required this.docController,
  });

  @override
  // ignore: library_private_types_in_public_api
  _EmployeeBasicDetailsFormState createState() =>
      _EmployeeBasicDetailsFormState();
}

class _EmployeeBasicDetailsFormState extends State<EmployeeBasicDetailsForm> {
  @override
  void initState() {
    super.initState();
    // Set the current date as the initial value
    widget.dateController.text =
        DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  Future<void> _selectDob(BuildContext context) async {
    // Calculate the last eligible date (18 years before today)
    final DateTime today = DateTime.now();
    final DateTime lastEligibleDate =
        DateTime(today.year - 18, today.month, today.day);

    final DateTime firstDate = DateTime(1924); // Arbitrary earliest date
    final DateTime initialDate =
        lastEligibleDate; // Default to the last eligible date

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastEligibleDate,
    );

    if (pickedDate != null) {
      setState(() {
        widget.dateDobController.text =
            DateFormat('yyyy-MM-dd').format(pickedDate);

        final int age = today.year - pickedDate.year;
        if (today
            .isBefore(DateTime(today.year, pickedDate.month, pickedDate.day))) {
          widget.ageController.text = (age - 1).toString();
        } else {
          widget.ageController.text = age.toString();
        }
      });
    }
  }

  String? ValidateFullName(String value) {
    if (!RegExp(r"^[a-zA-Z\s]{1,50}$").hasMatch(value)) {
      return "Full name should only contain alphabets\nand not exceed 50 words";
    }
    return null;
  }

  String? ValidatePlaceBirth(String value) {
    if (!RegExp(r"^[a-zA-Z\s]{1,50}$").hasMatch(value)) {
      return "Place Birth should only contain alphabets\nand not exceed 50 words";
    }
    return null;
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

  String? ValidateDepartment(String value) {
    if (!RegExp(r"^[a-zA-Z\s]{1,50}$").hasMatch(value)) {
      return "Department name should only contain alphabets\nand not exceed 50 words";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: widget.departmentController,
          decoration: InputDecoration(
            labelText: 'Name of Department',
            prefixIcon: const Icon(Icons.work),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your department name';
            }
            return ValidateDepartment(value);
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.dateController,
          enabled: false, // Disables the field completely
          decoration: InputDecoration(
            labelText: 'Application Date',
            prefixIcon: const Icon(Icons.calendar_month),
            filled: true,
            fillColor: Colors
                .grey[200], // Change background color to indicate it's disabled
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onTap: () {
            // You might need to ensure the onTap handler remains functional when the field is "read-only"
            _selectDate(context);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your application date';
            }
            return null;
          },
        ),
        const SizedBox(height: 8),
        const Text(
          'Employee Personal Information',
          style: const TextStyle(
            color: Color(0xFF133371),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.nameController,
          decoration: InputDecoration(
            labelText: 'Full Name',
            prefixIcon: const Icon(Icons.person),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your name';
            }
            return ValidateFullName(value);
          },
        ),
        const SizedBox(height: 10),
        GenderPage(controller: widget.genderController),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.dateDobController,
          decoration: InputDecoration(
            labelText: 'Date of Birth',
            prefixIcon: const Icon(Icons.calendar_month),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onTap: () {
            _selectDob(context);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your date of birth';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.ageController,
          decoration: InputDecoration(
            labelText: 'Age',
            prefixIcon: const Icon(Icons.numbers),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          readOnly: true, // Make it read-only
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your age';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.placeBirthController,
          decoration: InputDecoration(
            labelText: 'Place of Birth',
            prefixIcon: const Icon(Icons.pin_drop_sharp),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your birth place';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        AddressVerificationPage(
          controller: widget.employeeAddressVerificationController,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.docController,
          decoration: InputDecoration(
            labelText: 'Document Number',
            prefixIcon: const Icon(Icons.edit_document),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your document number';
            }
            return null;
          },
        ),
      ],
    );
  }
}
