import 'package:flutter/material.dart';
import 'package:himcops/master/gender.dart';
import 'package:himcops/master/occupation.dart';
import 'package:himcops/master/purposetenancy.dart';
import 'package:himcops/master/relationtype.dart';
import 'package:intl/intl.dart';

class TenantDetailsFormPage extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController tOccupationController;
  final TextEditingController genderController;
  final TextEditingController dateDobController;
  final TextEditingController relationController;
  final TextEditingController relativeNameController;
  final TextEditingController tenancyController;
  final TextEditingController ageController;

  const TenantDetailsFormPage({
    super.key,
    required this.nameController,
    required this.tOccupationController,
    required this.ageController,
    required this.dateDobController,
    required this.genderController,
    required this.relationController,
    required this.relativeNameController,
    required this.tenancyController,
  });

  @override
  _TenantDetailsFormPageState createState() => _TenantDetailsFormPageState();
}

class _TenantDetailsFormPageState extends State<TenantDetailsFormPage> {
  Future<void> _selectDob(BuildContext context) async {
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
      widget.dateDobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);

      final DateTime now = DateTime.now();
      int years = now.year - pickedDate.year;
      int months = now.month - pickedDate.month;

      // If the current month is before the birth month or it's the same month but before the birth date
      if (months < 0 || (months == 0 && now.day < pickedDate.day)) {
        years--;
        months += 12; // Add 12 months when reducing 1 year
      }

      // Display age in the format "X years, Y months"
      widget.ageController.text = '$years years, $months months';
    });
  }
}
  

  String? ValidateFullName(String value) {
    if (!RegExp(r"^[a-zA-Z\s]{1,50}$").hasMatch(value)) {
      return "Full name should only contain alphabets\nand not exceed 50 characters";
    }
    return null;
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
        OccupationPage(
          controller: widget.tOccupationController,
          enabled: true,
        ),
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
          labelText: 'Age (Years, Months)',
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
        RelationTypePage(controller: widget.relationController),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.relativeNameController,
          decoration: InputDecoration(
            labelText: 'Relative Full Name',
            prefixIcon: const Icon(Icons.person),
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
            return ValidateFullName(value);
          },
        ),
        const SizedBox(height: 10),
        TenancyPage(controller: widget.tenancyController, enabled: true),
      ],
    );
  }
}
