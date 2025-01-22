import 'package:flutter/material.dart';

class ProtestPage extends StatefulWidget {
  final TextEditingController controller;

  const ProtestPage({super.key, required this.controller, required bool enabled});

  @override
  State<ProtestPage> createState() => _ProtestPageState();
}

class _ProtestPageState extends State<ProtestPage> {
  String selectedProtest = '';

  @override
  void initState() {
    super.initState();
    
    if (widget.controller.text.isNotEmpty) {
      selectedProtest = widget.controller.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedProtest.isNotEmpty ? selectedProtest : null,
      decoration: InputDecoration(
        labelText: 'Type of Protest',
        prefixIcon: const Icon(Icons.block),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: <String>['Protest1','Protest2','Protest3'] // Api call here for master 
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedProtest = newValue!;
          widget.controller.text = newValue; 
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a Protest';
        }
        return null;
      },
    );
  }
}
