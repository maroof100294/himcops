import 'package:flutter/material.dart';

class ComplextionPage extends StatefulWidget {
  final TextEditingController controller;

  const ComplextionPage({super.key, required this.controller});

  @override
  State<ComplextionPage> createState() => _ComplextionPageState();
}

class _ComplextionPageState extends State<ComplextionPage> {
  String selectedComplextion = '';

  @override
  void initState() {
    super.initState();
    
    if (widget.controller.text.isNotEmpty) {
      selectedComplextion = widget.controller.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedComplextion.isNotEmpty ? selectedComplextion : null,
      decoration: InputDecoration(
        labelText: 'Complextion',
        prefixIcon: const Icon(Icons.bloodtype),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: <String>['complextion1', 'complextion2', 'complextion3', 'complextion4'] // Api call here for master country
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedComplextion = newValue!;
          widget.controller.text = newValue; 
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a complextion';
        }
        return null;
      },
    );
  }
}
