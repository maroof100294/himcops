import 'package:flutter/material.dart';

class EventPerformanceOtherDetailsForm extends StatefulWidget {
  final TextEditingController criminalController;
  final TextEditingController convictedController;
  final TextEditingController preceedingController;
  final TextEditingController blacklistedController;

  const EventPerformanceOtherDetailsForm({
    super.key,
    required this.criminalController,
    required this.convictedController,
    required this.preceedingController,
    required this.blacklistedController,
  });

  @override
  _EventPerformanceOtherDetailsFormState createState() =>
      _EventPerformanceOtherDetailsFormState();
}

class _EventPerformanceOtherDetailsFormState
    extends State<EventPerformanceOtherDetailsForm> {
  bool isCriminal = false;
  bool isConvicted = false;
  bool isBlacklisted = false;
  bool isPreceeding = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Whether Applicant is Involved in any Criminal Case',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
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
          //const SizedBox(height: 10),
          TextFormField(
            controller: widget.criminalController,
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
            maxLines: 2,
            maxLength: 1000,
            validator: (value) {
              if (isCriminal && (value == null || value.isEmpty)) {
                return 'Please enter your details';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Whether Applicant is convicted',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          
          Row(
            children: [
              Expanded(
                child: RadioListTile<bool>(
                  value: true,
                  groupValue: isConvicted,
                  onChanged: (val) {
                    setState(() {
                      isConvicted = val!;
                    });
                  },
                  title: const Text('Yes'),
                ),
              ),
              Expanded(
                child: RadioListTile<bool>(
                  value: false,
                  groupValue: isConvicted,
                  onChanged: (val) {
                    setState(() {
                      isConvicted = val!;
                    });
                  },
                  title: const Text("No"),
                ),
              ),
            ],
          ),
          //const SizedBox(height: 10),
          TextFormField(
            controller: widget.convictedController,
            enabled: isConvicted,
            decoration: InputDecoration(
              labelText: 'If yes, Provide details',
              prefixIcon: const Icon(Icons.description),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            maxLines: 2,
            maxLength: 1000,
            validator: (value) {
              if (isConvicted && (value == null || value.isEmpty)) {
                return 'Please enter your details';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Whether Preventive proceedings initiated against the Applicant',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          
          Row(
            children: [
              Expanded(
                child: RadioListTile<bool>(
                  value: true,
                  groupValue: isPreceeding,
                  onChanged: (val) {
                    setState(() {
                      isPreceeding = val!;
                    });
                  },
                  title: const Text('Yes'),
                ),
              ),
              Expanded(
                child: RadioListTile<bool>(
                  value: false,
                  groupValue: isPreceeding,
                  onChanged: (val) {
                    setState(() {
                      isPreceeding = val!;
                    });
                  },
                  title: const Text("No"),
                ),
              ),
            ],
          ),
          //const SizedBox(height: 10),
          TextFormField(
            controller: widget.preceedingController,
            enabled: isPreceeding,
            decoration: InputDecoration(
              labelText: 'If yes, Provide details',
              prefixIcon: const Icon(Icons.description),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            maxLines: 2,
            maxLength: 1000,
            validator: (value) {
              if (isPreceeding && (value == null || value.isEmpty)) {
                return 'Please enter your details';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Whether Applicant is blacklisted ever',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          
          Row(
            children: [
              Expanded(
                child: RadioListTile<bool>(
                  value: true,
                  groupValue: isBlacklisted,
                  onChanged: (val) {
                    setState(() {
                      isBlacklisted = val!;
                    });
                  },
                  title: const Text('Yes'),
                ),
              ),
              Expanded(
                child: RadioListTile<bool>(
                  value: false,
                  groupValue: isBlacklisted,
                  onChanged: (val) {
                    setState(() {
                      isBlacklisted = val!;
                    });
                  },
                  title: const Text("No"),
                ),
              ),
            ],
          ),
          //const SizedBox(height: 10),
          TextFormField(
            controller: widget.blacklistedController,
            enabled: isBlacklisted,
            decoration: InputDecoration(
              labelText: 'If yes, Provide details',
              prefixIcon: const Icon(Icons.description),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            maxLines: 2,
            maxLength: 1000,
            validator: (value) {
              if (isBlacklisted && (value == null || value.isEmpty)) {
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
