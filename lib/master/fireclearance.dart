import 'package:flutter/material.dart';

class FireClearancePage extends StatefulWidget {
  final TextEditingController controller;

  const FireClearancePage({super.key, required this.controller, required bool enabled});

  @override
  State<FireClearancePage> createState() => _FireClearancePageState();
}

class _FireClearancePageState extends State<FireClearancePage> {
  String selectedFireClearance = 'No';

  @override
  void initState() {
    super.initState();
    
    if (widget.controller.text.isNotEmpty) {
      selectedFireClearance = widget.controller.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedFireClearance.isNotEmpty ? selectedFireClearance : null,
      decoration: InputDecoration(
        labelText: 'Fire Clearance',
        prefixIcon: const Icon(Icons.fire_hydrant),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: <String>['Yes','No'] // Api call here for master country
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedFireClearance = newValue!;
          widget.controller.text = newValue; 
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a Fire Clearance area';
        }
        return null;
      },
    );
  }
}
