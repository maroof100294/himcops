import 'package:flutter/material.dart';
//import 'package:hppolice/payment/payment.dart';

class EmpAffidavitForm extends StatefulWidget {
  final TextEditingController employeeAffidavitController;
  final ValueChanged<bool> onCriminalStatusChanged;

  const EmpAffidavitForm({
    super.key,
    required this.employeeAffidavitController,
    required this.onCriminalStatusChanged,
  });

  @override
  _EmpAffidavitFormState createState() => _EmpAffidavitFormState();
}

class _EmpAffidavitFormState extends State<EmpAffidavitForm> {
  bool isCriminal = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          const Text(
            'Do you have any criminal record or any criminal proceedings against you or your family in any part of the country?',
          ),
          Row(
            children: [
              Expanded(
                child: RadioListTile<bool>(
                  value: true,
                  groupValue: isCriminal,
                  onChanged: (val) {
                    setState(() {
                      isCriminal = val!;
                      widget.onCriminalStatusChanged(isCriminal);
                    });
                  },
                  title: const Text('Yes'),
                ),
              ),
              Expanded(
                child: RadioListTile<bool>(
                  value: false,
                  groupValue: isCriminal,
                  onChanged: (val) {
                    setState(() {
                      isCriminal = val!;
                      widget.onCriminalStatusChanged(isCriminal);
                    });
                  },
                  title: const Text("No"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: widget.employeeAffidavitController,
            enabled: isCriminal,
            decoration: InputDecoration(
              labelText: 'If yes, Provide details',
              prefixIcon: const Icon(Icons.description),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            maxLines: 3,
            maxLength: 1000,
            validator: (value) {
              if (isCriminal && (value == null || value.isEmpty)) {
                return 'Please enter your details';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
