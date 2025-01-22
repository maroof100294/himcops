import 'package:flutter/material.dart';

class ProcessionPage extends StatefulWidget {
  final TextEditingController controller;

  const ProcessionPage({super.key, required this.controller, required bool enabled});

  @override
  State<ProcessionPage> createState() => _ProcessionPageState();
}

class _ProcessionPageState extends State<ProcessionPage> {
  String selectedProcession = '';

  @override
  void initState() {
    super.initState();
    
    if (widget.controller.text.isNotEmpty) {
      selectedProcession = widget.controller.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedProcession.isNotEmpty ? selectedProcession : null,
      decoration: InputDecoration(
        labelText: 'Type of Procession',
        prefixIcon: const Icon(Icons.block),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: <String>['Procession1','Procession2','Procesion3'] // Api call here for master 
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedProcession = newValue!;
          widget.controller.text = newValue; 
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a Procession';
        }
        return null;
      },
    );
  }
}
