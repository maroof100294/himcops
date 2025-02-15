import 'package:flutter/material.dart';
import 'package:himcops/master/occupation.dart';

class TenantOwnerDetailsFormPage extends StatefulWidget {
  final TextEditingController oNameController;
  final TextEditingController emailController;
  final TextEditingController mobileController;
  final TextEditingController occupationController;
  final TextEditingController oAddressController;
  final TextEditingController oCountryController;
  final TextEditingController oStateController;
  final TextEditingController oDistrictController;
  final TextEditingController oPoliceStationController;

  const TenantOwnerDetailsFormPage({
    super.key,
    required this.oNameController,
    required this.emailController,
    required this.mobileController,
    required this.occupationController,
    required this.oAddressController,
    required this.oCountryController,
    required this.oStateController,
    required this.oDistrictController,
    required this.oPoliceStationController,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TenantOwnerDetailsFormPageState createState() =>
      _TenantOwnerDetailsFormPageState();
}

class _TenantOwnerDetailsFormPageState
    extends State<TenantOwnerDetailsFormPage> {
  int? selectedStateId;

  String? ValidateFullName(String value) {
    if (!RegExp(r"^[a-zA-Z\s]{1,50}$").hasMatch(value)) {
      return "Full name should only contain alphabets\nand not exceed 50 words";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: widget.oNameController,
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
        OccupationPage(
          controller: widget.occupationController,
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
      ],
    );
  }
}
