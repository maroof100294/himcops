import 'package:flutter/material.dart';

class OfficeNamePage extends StatefulWidget {
  final TextEditingController controller;

  const OfficeNamePage({super.key, required this.controller, required bool enabled});

  @override
  State<OfficeNamePage> createState() => _OfficeNamePageState();
}

class _OfficeNamePageState extends State<OfficeNamePage> {
  String selectedOffice = '';

  @override
  void initState() {
    super.initState();
    
    if (widget.controller.text.isNotEmpty) {
      selectedOffice = widget.controller.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedOffice.isNotEmpty ? selectedOffice : null,
      decoration: InputDecoration(
        labelText: 'Office Name',
        prefixIcon: const Icon(Icons.location_city_sharp),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: <String>['Office1', 'Office2', 'Office3', 'Office4'] // Api call here for master country
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedOffice = newValue!;
          widget.controller.text = newValue; 
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a Office';
        }
        return null;
      },
    );
  }
}
