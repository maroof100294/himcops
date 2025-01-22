import 'package:flutter/material.dart';

class TenancyPage extends StatefulWidget {
  final TextEditingController controller;

  const TenancyPage({super.key, required this.controller, required bool enabled});

  @override
  State<TenancyPage> createState() => _TenancyPageState();
}

class _TenancyPageState extends State<TenancyPage> {
  String selectedTenancy = '';

  @override
  void initState() {
    super.initState();
    
    if (widget.controller.text.isNotEmpty) {
      selectedTenancy = widget.controller.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedTenancy.isNotEmpty ? selectedTenancy : null,
      decoration: InputDecoration(
        labelText: 'Purpose of Tenancy',
        prefixIcon: const Icon(Icons.home_outlined),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: <String>['Commercial','Residential'] // Api call here for master country
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedTenancy = newValue!;
          widget.controller.text = newValue; 
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a Purpose of Tenancy';
        }
        return null;
      },
    );
  }
}
