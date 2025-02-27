import 'package:flutter/material.dart';

class LocationAreaPage extends StatefulWidget {
  final TextEditingController controller;

  const LocationAreaPage({super.key, required this.controller, required bool enabled});

  @override
  State<LocationAreaPage> createState() => _LocationAreaPageState();
}

class _LocationAreaPageState extends State<LocationAreaPage> {
  String selectedLocation = '';

  @override
  void initState() {
    super.initState();
    
    if (widget.controller.text.isNotEmpty) {
      selectedLocation = widget.controller.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedLocation.isNotEmpty ? selectedLocation : null,
      decoration: InputDecoration(
        labelText: 'Location Area',
        prefixIcon: const Icon(Icons.location_city),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: <String>['Sq.Mts.','Sq.Feet'] // Api call here for master country
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedLocation = newValue!;
          widget.controller.text = newValue; 
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a location area';
        }
        return null;
      },
    );
  }
}
