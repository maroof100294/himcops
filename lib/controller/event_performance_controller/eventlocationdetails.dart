import 'package:flutter/material.dart';
import 'package:himcops/master/country.dart';
import 'package:himcops/master/locationarea.dart';
import 'package:himcops/master/natureofstructure.dart';
import 'package:himcops/master/typeofstructure.dart';

class EventLocationDetailsForm extends StatefulWidget {
  final TextEditingController locationNameController;
  final TextEditingController structureTypeController;
  final TextEditingController structureNatureController;
  final TextEditingController locationAreaController;
  final TextEditingController locationNumberController;
  final TextEditingController locationAddressController;
  final TextEditingController locationCountryController;
  final TextEditingController locationStateController;
  final TextEditingController locationDistrictController;
  final TextEditingController locationPoliceStationController;

  const EventLocationDetailsForm({
    super.key,
    required this.locationNameController,
    required this.structureTypeController,
    required this.structureNatureController,
    required this.locationAreaController,
    required this.locationNumberController,
    required this.locationAddressController,
    required this.locationCountryController,
    required this.locationStateController,
    required this.locationDistrictController,
    required this.locationPoliceStationController,
  });

  @override
  // ignore: library_private_types_in_public_api
  _EventLocationDetailsFormState createState() =>
      _EventLocationDetailsFormState();
}

class _EventLocationDetailsFormState extends State<EventLocationDetailsForm> {
  int? selectedStateId;

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
          controller: widget.locationNameController,
          decoration: InputDecoration(
            labelText: 'Location Name',
            prefixIcon: const Icon(Icons.location_city),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your location name';
            }
            return ValidateFullName(value);
          },
        ),
        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 8),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Address of the Location',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        TextFormField(
          controller: widget.locationAddressController,
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
                  controller: widget.locationCountryController, enabled: true),
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
                'Location Area',
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter loction area';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
                child: LocationAreaPage(
                    controller: widget.locationAreaController, enabled: true)),
          ],
        ),
        const SizedBox(height: 10),
        NatureStructurePage(controller: widget.structureNatureController, enabled: true),
        const SizedBox(height: 10),
        StructureTypePage(controller: widget.structureTypeController, enabled: true),
      ],
    );
  }
}
