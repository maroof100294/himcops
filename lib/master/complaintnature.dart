import 'package:flutter/material.dart';

class NatureComplaintPage extends StatefulWidget {
  final TextEditingController controller;

  const NatureComplaintPage({super.key, required this.controller, required bool enabled});

  @override
  State<NatureComplaintPage> createState() => _NatureComplaintPageState();
}

class _NatureComplaintPageState extends State<NatureComplaintPage> {
  String selectedNatureComplaint = '';

  @override
  void initState() {
    super.initState();
    
    if (widget.controller.text.isNotEmpty) {
      selectedNatureComplaint = widget.controller.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedNatureComplaint.isNotEmpty ? selectedNatureComplaint : null,
      decoration: InputDecoration(
        labelText: 'Nature of Complaint',
        prefixIcon: const Icon(Icons.nature),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: <String>['Complaint1','Complaint2'] // Api call here for master country
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedNatureComplaint = newValue!;
          widget.controller.text = newValue; 
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a nature of Complaint';
        }
        return null;
      },
    );
  }
}
