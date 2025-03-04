import 'package:flutter/material.dart';
import 'package:himcops/master/complaintnature.dart';
import 'package:himcops/master/identification.dart';
import 'package:intl/intl.dart';

class ComplaintPersonalDetailsForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController dateDobController;
  final TextEditingController ageController;
  final TextEditingController mobileController;
  final TextEditingController emailController;
  final TextEditingController complaintNatureController;
  final TextEditingController identifyController;
  final TextEditingController idNumberController;

  const ComplaintPersonalDetailsForm({
    super.key,
    required this.nameController,
    required this.dateDobController,
    required this.ageController,
    required this.mobileController,
    required this.emailController,
    required this.complaintNatureController,
    required this.identifyController,
    required this.idNumberController,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ComplaintPersonalDetailsFormState createState() =>
      _ComplaintPersonalDetailsFormState();
}

class _ComplaintPersonalDetailsFormState
    extends State<ComplaintPersonalDetailsForm> {
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
      return "Full name should only contain alphabets and spaces\nand not exceed 50 words";
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
          controller: widget.mobileController,
          decoration: InputDecoration(
            labelText: 'Mobile Number',
            prefixIcon: const Icon(Icons.person),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          keyboardType: TextInputType.number,
          maxLength: 10,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your mobile';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.emailController,
          decoration: InputDecoration(
            labelText: 'Email',
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
            return null;
          },
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
        NatureComplaintPage(
            controller: widget.complaintNatureController, enabled: true),
        const SizedBox(height: 10),
        IdentificationTypePage(controller: widget.identifyController),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.idNumberController,
          decoration: InputDecoration(
            labelText: 'Identification Number',
            prefixIcon: const Icon(Icons.person),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your ID number';
            }
            return null;
          },
        ),
      ],
    );
  }
}
