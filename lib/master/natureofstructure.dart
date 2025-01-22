import 'package:flutter/material.dart';

class NatureStructurePage extends StatefulWidget {
  final TextEditingController controller;

  const NatureStructurePage({super.key, required this.controller, required bool enabled});

  @override
  State<NatureStructurePage> createState() => _NatureStructurePageState();
}

class _NatureStructurePageState extends State<NatureStructurePage> {
  String selectedNature = '';

  @override
  void initState() {
    super.initState();
    
    if (widget.controller.text.isNotEmpty) {
      selectedNature = widget.controller.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedNature.isNotEmpty ? selectedNature : null,
      decoration: InputDecoration(
        labelText: 'Nature of Structure',
        prefixIcon: const Icon(Icons.nature),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: <String>['Temporary','Permanent'] // Api call here for master country
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedNature = newValue!;
          widget.controller.text = newValue; 
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a nature of structure';
        }
        return null;
      },
    );
  }
}
