import 'package:flutter/material.dart';
import 'package:himcops/master/country.dart';
import 'package:himcops/master/gender.dart';
import 'package:himcops/master/languagespoken.dart';
import 'package:himcops/master/relationtype.dart';
import 'package:intl/intl.dart';

class PersonalDetailsForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController genderController;
  final TextEditingController dateDobController;
  final TextEditingController ageController;
  final TextEditingController placeBirthController;
  final TextEditingController dateController;
  final TextEditingController languageSpokenController;
  final TextEditingController countryController;
  final TextEditingController relationTypeController;
  final TextEditingController relativeController;

  const PersonalDetailsForm({
    super.key,
    required this.nameController,
    required this.genderController,
    required this.dateDobController,
    required this.ageController,
    required this.placeBirthController,
    required this.dateController,
    required this.languageSpokenController,
    required this.countryController,
    required this.relationTypeController,
    required this.relativeController,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PersonalDetailsFormState createState() => _PersonalDetailsFormState();
}

class _PersonalDetailsFormState extends State<PersonalDetailsForm> {
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

  String? ValidateRelative(String value) {
    if (!RegExp(r"^[a-zA-Z\s]{1,50}$").hasMatch(value)) {
      return "Relative name should only contain alphabets\nand not exceed 50 words";
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    // Set the current date as the initial value
    widget.dateController.text =
        DateFormat('yyyy-MM-dd').format(DateTime.now());
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
        widget.dateController.text = DateFormat('yyyy-MM-dd').format(lastDate);
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
            return ValidatePlaceBirth(value);
          },
        ),
        const SizedBox(height: 10),
        LanguagesSpokenPage(controller: widget.languageSpokenController),
        const SizedBox(height: 10),
        CountryPage(
          controller: widget.countryController,
          enabled: true,
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
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.relativeController,
          decoration: InputDecoration(
            labelText: 'Relative Name',
            prefixIcon: const Icon(Icons.family_restroom),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your relative name';
            }
            return ValidateRelative(value);
          },
        ),
        const SizedBox(height: 10),
        RelationTypePage(controller: widget.relationTypeController),
      ],
    );
  }
}
