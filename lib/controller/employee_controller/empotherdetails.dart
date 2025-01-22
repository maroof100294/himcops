import 'package:flutter/material.dart';
import 'package:himcops/master/addressverification.dart';

class EmployeeOtherDetailsForm extends StatefulWidget {
  final TextEditingController employeeAddressVerificationController;
  final TextEditingController employeePoliceStationController;
  final TextEditingController docController;

  const EmployeeOtherDetailsForm({
    super.key,
    required this.employeeAddressVerificationController,
    required this.employeePoliceStationController,
    required this.docController,
  });

  @override

  // ignore: library_private_types_in_public_api
  _EmployeeOtherDetailsFormState createState() =>
      _EmployeeOtherDetailsFormState();
}

class _EmployeeOtherDetailsFormState extends State<EmployeeOtherDetailsForm> {
  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        AddressVerificationPage(
          controller: widget.employeeAddressVerificationController,
        ),
        const SizedBox(height: 20),
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
