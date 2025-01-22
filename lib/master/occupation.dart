import 'package:flutter/material.dart';

class OccupationPage extends StatefulWidget {
  final TextEditingController controller;

  const OccupationPage({super.key, required this.controller, required bool enabled});

  @override
  State<OccupationPage> createState() => _OccupationPageState();
}

class _OccupationPageState extends State<OccupationPage> {
  String selectedOccupation = '';

  @override
  void initState() {
    super.initState();
    
    if (widget.controller.text.isNotEmpty) {
      selectedOccupation = widget.controller.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedOccupation.isNotEmpty ? selectedOccupation : null,
      decoration: InputDecoration(
        labelText: 'Occupation',
        prefixIcon: const Icon(Icons.work),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: <String>['occupation1','occupation2','occupation3'] // Api call here for master country
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedOccupation = newValue!;
          widget.controller.text = newValue; 
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a Occupation';
        }
        return null;
      },
    );
  }
}
