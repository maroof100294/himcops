import 'package:flutter/material.dart';
import 'package:himcops/master/country.dart';

class ApplicantAddressDetailsForm extends StatefulWidget {
  final TextEditingController addressController;
  final TextEditingController aCountryController;
  final TextEditingController aStateController;
  final TextEditingController aDistrictController;
  final TextEditingController aPoliceStationController;
  final TextEditingController paddressController;
  final TextEditingController pcountryController;
  final TextEditingController pdistrictController;
  final TextEditingController pstateController;
  final TextEditingController ppoliceStationController;

  const ApplicantAddressDetailsForm({
    super.key,
    required this.addressController,
    required this.aCountryController,
    required this.aStateController,
    required this.aDistrictController,
    required this.aPoliceStationController,
    required this.paddressController,
    required this.pcountryController,
    required this.pstateController,
    required this.pdistrictController,
    required this.ppoliceStationController,
  });

  @override

  // ignore: library_private_types_in_public_api
  _ApplicantAddressDetailsFormState createState() =>
      _ApplicantAddressDetailsFormState();
}

class _ApplicantAddressDetailsFormState
    extends State<ApplicantAddressDetailsForm> {
  bool isChecked = false;
  
  int? selectedStateId;

  String? ValidateYear(String value) {
    if (!RegExp(r"^[0-9]{1,2}$").hasMatch(value)) {
      return "Year should only contain number";
    }
    return null;
  }

  String? ValidateMonth(String value) {
    if (!RegExp(r"^[0-9]{1,2}$").hasMatch(value)) {
      return "Month should only contain number";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: widget.paddressController,
          decoration: InputDecoration(
            labelText: 'Present Address',
            prefixIcon: const Icon(Icons.home),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your address';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        CountryPage(
          controller: widget.pcountryController,
          enabled: true,
        ),
        const SizedBox(height: 10),
        //statedynamic
        Row(
          children: [
            Checkbox(
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value ?? false;
                  if (isChecked) {
                    widget.addressController.text =
                        widget.paddressController.text;
                    widget.aCountryController.text =
                        widget.pcountryController.text;
                    widget.aStateController.text = widget.pstateController.text;
                    widget.aDistrictController.text =
                        widget.pdistrictController.text;
                    widget.aPoliceStationController.text =
                        widget.ppoliceStationController.text;
                  } else {
                    // Clear the present address fields if unchecked
                    widget.addressController.clear();
                    widget.aCountryController.clear();
                    widget.aStateController.clear();
                    widget.aDistrictController.clear();
                    widget.aPoliceStationController.clear();
                  }
                });
              },
            ),
            const Text('Permanent address is same as present address'),
          ],
        ),
        if (!isChecked)
          Column(
            children: [
              TextFormField(
                controller: widget.addressController,
                enabled: true,
                decoration: InputDecoration(
                  labelText: 'Permanent Address',
                  prefixIcon: const Icon(Icons.home),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              CountryPage(controller: widget.aCountryController, enabled: true),
              const SizedBox(height: 10),
              //statedynamic
            ],
          ),
      ],
    );
  }
}
