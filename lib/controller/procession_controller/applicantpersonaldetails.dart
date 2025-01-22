import 'package:flutter/material.dart';
import 'package:himcops/master/gender.dart';
import 'package:himcops/master/relationtype.dart';
import 'package:intl/intl.dart';

class ApplicantPersonalDetailsForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController mobileController;
  final TextEditingController emailController;
  final TextEditingController relationController;
  final TextEditingController relativeNameController;
  final TextEditingController genderController;
  final TextEditingController dateDobController;
  final TextEditingController ageController;

  const ApplicantPersonalDetailsForm({
    super.key,
    required this.nameController,
    required this.relationController,
    required this.relativeNameController,
    required this.genderController,
    required this.dateDobController,
    required this.ageController,
    required this.emailController,
    required this.mobileController,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ApplicantPersonalDetailsFormState createState() =>
      _ApplicantPersonalDetailsFormState();
}

class _ApplicantPersonalDetailsFormState
    extends State<ApplicantPersonalDetailsForm> {
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
        widget.dateDobController.text =
            DateFormat('yyyy-MM-dd').format(pickedDate);

        final int age = DateTime.now().year - pickedDate.year;
        if (DateTime.now().isBefore(
            DateTime(DateTime.now().year, pickedDate.month, pickedDate.day))) {
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
            prefixIcon: const Icon(Icons.phone),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          keyboardType: TextInputType.number,
          maxLength: 10,
          onTap: () {
            //to be fetch when user is login
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your Mobile number';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: const Icon(Icons.email),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          onTap: () {
            //to be fetch when user is login
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        GenderPage(controller: widget.genderController),
        const SizedBox(height: 10),
        RelationTypePage(controller: widget.relationController),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.relativeNameController,
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
            return ValidateFullName(value);
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
      ],
    );
  }
}
