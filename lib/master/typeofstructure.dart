import 'package:flutter/material.dart';

class StructureTypePage extends StatefulWidget {
  final TextEditingController controller;

  const StructureTypePage({super.key, required this.controller, required bool enabled});

  @override
  State<StructureTypePage> createState() => _StructureTypePageState();
}

class _StructureTypePageState extends State<StructureTypePage> {
  String selectedTypeStructure = '';

  @override
  void initState() {
    super.initState();
    
    if (widget.controller.text.isNotEmpty) {
      selectedTypeStructure = widget.controller.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedTypeStructure.isNotEmpty ? selectedTypeStructure : null,
      decoration: InputDecoration(
        labelText: 'Type of Structure',
        prefixIcon: const Icon(Icons.nature),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: <String>['Close','Open'] // Api call here for master country
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedTypeStructure = newValue!;
          widget.controller.text = newValue; 
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a Type of structure';
        }
        return null;
      },
    );
  }
}
