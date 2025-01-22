import 'package:flutter/material.dart';
import 'package:himcops/layout/formlayout.dart';

class DhvReqViewPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const DhvReqViewPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final searchandviewdetails =
        data['searchandviewdetails'] as Map<String, dynamic>? ?? {};
    final Map<String, String> labels = {
      'applicationsubmissionDate': 'Application Date',
      'firstName': 'Full Name',
      'languageSpokenDesc': 'Language',
      'genderDesc': 'Gender',
      'nationalityDesc': 'Nationality',
      'relative1FirstName': 'Relative Name',
      'relative1Village':'Relative Address',
      'relative1CountryDesc':'Relative Country',
      'relative1StateDesc': 'Relative State',
      'relative1DistrictDesc': 'Relative District',
      'relative1PoliceStationDesc':'Relative Police Station',
    };

    final Map<String, dynamic> nestedData =
        searchandviewdetails['emplVerificationEmployee'] as Map<String, dynamic>? ??
            {};
    if (nestedData.containsKey('commonPanelAgeYear')) {
      searchandviewdetails['commonPanelAgeYear'] =
          nestedData['commonPanelAgeYear'];
      labels['commonPanelAgeYear'] = 'Age';
    }

    final searchviewAddressDetails =
        data['searchandviewdetails'] as Map<String, dynamic>? ?? {};
    final Map<String, String> addressLabels = {
      'permanentVillage': 'Address',
      'permanentCountryDesc': 'Country',
      'permanentStateDesc': 'State',
      'permanentDistrictDesc': 'District',
      'permanentPoliceStationDesc': 'Police Station',
      'presentVillage': 'Present Address',
      'presentCountryDesc': 'Present Country',
      'presentStateDesc': 'Present State',
      'presentDistrictDesc': 'Present District',
      'presentPoliceStationDesc': 'Present Police Station',
      
    };
    //    final searchviewCurrentEmployerDetails =
    //     data['searchandviewdetails'] as Map<String, dynamic>? ?? {};
    // final Map<String, String> currentEmployerLabels = {
    //   'nameofEmployer': 'Full Name',
    //   'employerVillage': 'Address',
    //   'employerCountryDesc': 'Country',
    //   'employerStateDesc': 'State',
    //   'employerDistrictDesc': 'District',
    //   'employerPoliceStationDesc': 'Police Station',
    // };
 final searchviewMasterEmployerDetails =
        data['searchandviewdetails'] as Map<String, dynamic>? ?? {};
    final Map<String, String> masterLabels = {
      'masterFirstName': 'Full Name',
      'masterEmailId': 'Email',
      'masterVillage': 'Address',
      'masterCountryDesc': 'Country',
      'masterStateDesc': 'State',
      'masterDistrictDesc': 'District',
      'masterPoliceStationDesc': 'Police Station',
    };

    final searchviewStatusDetails = searchandviewdetails;
    final Map<String, String> statusLabels = {
      'delayedStatus': 'Status',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Helper Verification Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration: myBoxDecoration(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Helper Personal Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ...labels.entries.map((entry) {
                final value =
                    searchandviewdetails[entry.key]?.toString() ?? 'N/A';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    initialValue: value,
                    decoration: InputDecoration(
                      labelText: entry.value,
                      labelStyle: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                          fillColor: Colors.white,
                          filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2.0),
                      ),
                    ),
                    enabled: false,
                  ),
                );
              }).toList(),
              const SizedBox(height: 16.0),
              const Text(
                'Helper Address Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ...addressLabels.entries.map((entry) {
                final value =
                    searchviewAddressDetails[entry.key]?.toString() ??
                        'N/A';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    initialValue: value,
                    decoration: InputDecoration(
                      labelText: entry.value,
                      labelStyle: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                           fillColor: Colors.white,
                          filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2.0),
                      ),
                    ),
                    enabled: false,
                  ),
                );
              }).toList(),
              const SizedBox(height: 16.0),
              const Text(
                'Master Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ...masterLabels.entries.map((entry) {
                final value =
                    searchviewMasterEmployerDetails[entry.key]?.toString() ??
                        'N/A';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    initialValue: value,
                    decoration: InputDecoration(
                      labelText: entry.value,
                      labelStyle: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                           fillColor: Colors.white,
                          filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2.0),
                      ),
                    ),
                    enabled: false,
                  ),
                );
              }).toList(),
              const SizedBox(height: 16.0),
              const Text(
                'Request Status',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ...statusLabels.entries.map((entry) {
                final value =
                    searchviewStatusDetails[entry.key]?.toString() ??
                        'N/A';
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    initialValue: value,
                    decoration: InputDecoration(
                      labelText: entry.value,
                      labelStyle: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                           fillColor: Colors.white,
                          filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: Colors.black, width: 2.0),
                      ),
                    ),
                    enabled: false,
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
