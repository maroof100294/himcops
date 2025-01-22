import 'package:flutter/material.dart';
import 'package:himcops/master/country.dart';
import 'package:himcops/master/district.dart';
import 'package:himcops/master/officename.dart';
import 'package:himcops/master/policestation.dart';
import 'package:intl/intl.dart';

class CompComplaintDetailsForm extends StatefulWidget {

  final TextEditingController dateController;
  final TextEditingController complaintDescriptionController;
  final TextEditingController accusedNameController;
  final TextEditingController accusedAddressController;
  final TextEditingController accusedCountryController;
  final TextEditingController accusedStateController;
  final TextEditingController accusedDistrictController;
  final TextEditingController accusedPoliceStationController;
  final TextEditingController submissionPoliceController;
  final TextEditingController submissionDistrictController;
  final TextEditingController submissionOfficeController;
  const CompComplaintDetailsForm({
    super.key,

    required this.dateController,
    required this.complaintDescriptionController,
    required this.accusedNameController,
    required this.accusedAddressController,
    required this.accusedCountryController,
    required this.accusedStateController,
    required this.accusedDistrictController,
    required this.accusedPoliceStationController,
    required this.submissionPoliceController,
    required this.submissionDistrictController,
    required this.submissionOfficeController,
  });

  @override
  _CompComplaintDetailsFormState createState() =>
      _CompComplaintDetailsFormState();
}

class _CompComplaintDetailsFormState
    extends State<CompComplaintDetailsForm> {
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
        widget.dateController.text =
            DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  
  int? selectedStateId;
  bool isAccused = false;
  bool isPoliceKnown=true;
  bool isDistrictKnown = true;
  String? complaintDistrictCode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: widget.dateController,
          decoration: InputDecoration(
            labelText: 'Date of Complaint',
            prefixIcon: const Icon(Icons.calendar_month),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onTap: () {
            _selectDate(context);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your complaint date';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.complaintDescriptionController,
          decoration: InputDecoration(
            labelText: 'Complaint Description',
            prefixIcon: const Icon(Icons.place),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your complaint';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Do You have Accused Details?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                value: true,
                groupValue: isAccused,
                onChanged: (val) {
                  setState(() {
                    isAccused = val!;
                  });
                },
                title: const Text('Yes'),
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                value: false,
                groupValue: isAccused,
                onChanged: (val) {
                  setState(() {
                    isAccused = val!;
                  });
                },
                title: const Text("No"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (isAccused) ...[
          TextFormField(
          controller: widget.accusedAddressController,
          decoration: InputDecoration(
            labelText: 'Address',
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
          controller: widget.accusedCountryController,
          enabled: true,
        ),
        const SizedBox(height: 10),
        //statedynamic
        ],
        const SizedBox(height: 10),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Do you know your police station?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                value: true,
                groupValue: isPoliceKnown,
                onChanged: (val) {
                  setState(() {
                    isPoliceKnown = val!;
                  });
                },
                title: const Text('Yes'),
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                value: false,
                groupValue: isPoliceKnown,
                onChanged: (val) {
                  setState(() {
                    isPoliceKnown = val!;
                  });
                },
                title: const Text("No"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
         if (isPoliceKnown) ...[
        DistrictPage(
          controller: (districtCode) {
                        setState(() {
                          complaintDistrictCode = districtCode;
                        });
                      },
          enabled: true
        ),
        const SizedBox(height: 10),
        PoliceStationPage(
          controller: widget.submissionPoliceController,
          enabled: true,
        ),
        ] else ...[
          const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                'Do you know your district ?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                value: true,
                groupValue: isDistrictKnown,
                onChanged: (val) {
                  setState(() {
                    isDistrictKnown = val!;
                  });
                },
                title: const Text('Yes'),
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                value: false,
                groupValue: isDistrictKnown,
                onChanged: (val) {
                  setState(() {
                    isDistrictKnown = val!;
                  });
                },
                title: const Text("No"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (isDistrictKnown) ...[
        DistrictPage(
          controller: (districtCode) {
                        setState(() {
                          complaintDistrictCode = districtCode;
                        });
                      },
          enabled: true
        ),
        const SizedBox(height: 10),
        OfficeNamePage(controller: widget.submissionOfficeController, enabled: true),
        ] else ...[
          OfficeNamePage(controller:widget.submissionOfficeController, enabled: true),
        ]
        ]
      ],
    );
  }
}
