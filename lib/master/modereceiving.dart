import 'package:flutter/material.dart';

class ModeReceivingPage extends StatefulWidget {
  final TextEditingController controller;

  const ModeReceivingPage({super.key, required this.controller,required bool enabled});

  @override
  State<ModeReceivingPage> createState() => _ModeReceivingPageState();
}

class _ModeReceivingPageState extends State<ModeReceivingPage> {
  String selectedModeReceiving = 'In-Person';

  @override
  void initState() {
    super.initState();

    if (widget.controller.text.isEmpty) {
      widget.controller.text = selectedModeReceiving;
    } else {
      selectedModeReceiving = widget.controller.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedModeReceiving.isNotEmpty ? selectedModeReceiving : null,
      decoration: InputDecoration(
        labelText: 'Mode Receiving',
        prefixIcon: const Icon(Icons.mode),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: <String>[
        'By Post',
        'In-Person',
        'By mail'
      ] // Api call here for master country
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedModeReceiving = newValue!;
          widget.controller.text = newValue;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a Mode Receiving';
        }
        return null;
      },
    );
  }
}
