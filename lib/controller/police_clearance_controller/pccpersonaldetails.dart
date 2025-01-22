import 'package:flutter/material.dart';
import 'package:himcops/master/gender.dart';
import 'package:himcops/master/modereceiving.dart';
import 'package:himcops/master/relationtype.dart';
import 'package:intl/intl.dart';

class PccPersonalDetailsForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController pccRelationTypeController;
  final TextEditingController pccRelativeNameController;
  final TextEditingController pccDescriptionServiceController;
  final TextEditingController pccModeReceivingController;
  final TextEditingController genderController;
  final TextEditingController dateDobController;
  final TextEditingController ageController;

  const PccPersonalDetailsForm({
    super.key,
    required this.nameController,
    required this.pccRelationTypeController,
    required this.pccRelativeNameController,
    required this.pccDescriptionServiceController,
    required this.pccModeReceivingController,
    required this.genderController,
    required this.dateDobController,
    required this.ageController,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PccPersonalDetailsFormState createState() => _PccPersonalDetailsFormState();
}

class _PccPersonalDetailsFormState extends State<PccPersonalDetailsForm> {


  Future<void> _selectDob(BuildContext context) async {
  // Calculate the last eligible date (18 years before today)
  final DateTime today = DateTime.now();
  final DateTime lastEligibleDate = DateTime(today.year - 18, today.month, today.day);

  final DateTime firstDate = DateTime(1924); // Arbitrary earliest date
  final DateTime initialDate = lastEligibleDate; // Default to the last eligible date

  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastEligibleDate,
  );

  if (pickedDate != null) {
    setState(() {
      widget.dateDobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);

      final int age = today.year - pickedDate.year;
      if (today.isBefore(DateTime(today.year, pickedDate.month, pickedDate.day))) {
        widget.ageController.text = (age - 1).toString();
      } else {
        widget.ageController.text = age.toString();
      }
    });
  }
}


  @override
  void setState(fn) {
    super.setState(fn);
  }

  String? ValidateFullName(String value) {
    if (!RegExp(r"^[a-zA-Z\s]{1,50}$").hasMatch(value)) {
      return "Full name should only contain alphabets and spaces\nand not exceed 50 words";
    }
    return null;
  }

  String? ValidateDescription(String value) {
    if (!RegExp(r"^[a-zA-Z0-9._%&$!@*#+-\s]{1,500}$").hasMatch(value)) {
      return "Description shouldn't contain space\nnot more that 500 words";
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
        TextFormField(
          controller: widget.pccDescriptionServiceController,
          decoration: InputDecoration(
            labelText: 'Purpose of Applying this Service',
            prefixIcon: const Icon(Icons.description),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a description';
            }
            return ValidateDescription(value);
          },
        ),
        const SizedBox(height: 10),
        ModeReceivingPage(controller: widget.pccModeReceivingController, enabled: false,),
        const SizedBox(height: 10),
        GenderPage(controller: widget.genderController),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.pccRelativeNameController,
          decoration: InputDecoration(
            labelText: 'Relative Name',
            prefixIcon: const Icon(Icons.family_restroom_sharp),
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
        RelationTypePage(controller: widget.pccRelationTypeController),
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
      ],
    );
  }
}
