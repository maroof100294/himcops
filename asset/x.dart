import 'package:flutter/material.dart';
import 'package:himcops/master/majcountry.dart';
import 'package:himcops/master/statedistrictdynamic.dart'; // Import the StateDistrictDynamicPage

class ProcessionDetailsForm extends StatefulWidget {
  const ProcessionDetailsForm({super.key});

  @override
  _ProcessionDetailsFormState createState() => _ProcessionDetailsFormState();
}

class _ProcessionDetailsFormState extends State<ProcessionDetailsForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  String? selectedCountry = 'INDIA';
  String? selectedStateName;
  String? selectedDistrictName;
  String? selectedPoliceName;

  List<Map<String, String>> majorParticipants = [];

  void _addParticipant() {
    if (nameController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        selectedCountry != null) {
      setState(() {
        majorParticipants.add({
          'name': nameController.text,
          'address': '${addressController.text},$selectedStateName,$selectedDistrictName,$selectedPoliceName,$selectedCountry',
        });

        // Clear fields
        nameController.clear();
        addressController.clear();
        countryController.clear();
        selectedCountry = 'INDIA';
      });
    }
  }

  void _updateCountry(String country) {
    setState(() {
      selectedCountry = country;
    });
  }

  void _updateState(String? stateName) {
    setState(() {
      selectedStateName = stateName;
    });
  }

  void _updateDistrict(String? districtName) {
    setState(() {
      selectedDistrictName = districtName;
    });
  }

  void _updatePolice(String? policeStationName) {
    setState(() {
      selectedPoliceName = policeStationName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Major Head Participant Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Name of Major Participant',
            prefixIcon: const Icon(Icons.person),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: addressController,
          decoration: InputDecoration(
            labelText: 'Address',
            prefixIcon: const Icon(Icons.home),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          keyboardType: TextInputType.streetAddress,
          maxLines: 3,
        ),
        const SizedBox(height: 10),

        // Country Selection
        MajCountryPage(
          controller: countryController,
          enabled: true,
          onCountrySelected: _updateCountry,
        ),

        if (selectedCountry != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Selected Country: $selectedCountry',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

        const SizedBox(height: 10),

        // Integrate the StateDistrictDynamicPage below the country selection
        StateDistrictDynamicPage(
          onStateSelected: _updateState,
          onDistrictSelected: _updateDistrict,
          onPoliceStationSelected: _updatePolice,
        ),

        if (selectedStateName != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Selected State: $selectedStateName',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        if (selectedDistrictName != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Selected District: $selectedDistrictName',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        if (selectedPoliceName != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Selected Police Station: $selectedPoliceName',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _addParticipant,
          child: const Text('Add Participant'),
        ),
        const SizedBox(height: 20),

        if (majorParticipants.isNotEmpty)
          Table(
            border: TableBorder.all(),
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(4),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.grey[300]),
                children: const [
                  Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Name',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('Address',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
              ...majorParticipants.map(
                (participant) => TableRow(
                  children: [
                    Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(participant['name']!)),
                    Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(participant['address']!)),
                  ],
                ),
              ),
            ],
          ),
      ],
    );
  }
}
