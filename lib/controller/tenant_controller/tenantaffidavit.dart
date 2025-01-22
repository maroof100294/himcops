import 'package:flutter/material.dart';
//import 'package:hppolice/payment/payment.dart';

class TenantAffidavitForm extends StatefulWidget {
  final TextEditingController affidavitController;

  const TenantAffidavitForm({
    super.key,
    required this.affidavitController,
  });

  @override
  // ignore: library_private_types_in_public_api
  _TenantAffidavitFormState createState() => _TenantAffidavitFormState();
}

class _TenantAffidavitFormState extends State<TenantAffidavitForm> {
  bool isCriminal = true;

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
                    });
                  },
                  title: const Text("No"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: widget.affidavitController,
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
