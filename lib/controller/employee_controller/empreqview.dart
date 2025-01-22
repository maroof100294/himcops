import 'package:flutter/material.dart';
import 'package:himcops/layout/formlayout.dart';

class EmpReqViewPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const EmpReqViewPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final searchviewemployeedetails =
        data['searchviewemployeedetails'] as Map<String, dynamic>? ?? {};
    final Map<String, String> labels = {
      'basicOrganization': 'Organization Name',
      'basicApplicationDate': 'Application Date',
      'employeeFirstName': 'Full Name',
      'employeePlaceofBirth': 'Place of Birth',
      'employeeGenderDesc': 'Gender',
      'addressVerificationDocumentDesc': 'Verification Document',
      'documentNo':'Document Number',
    };

    final Map<String, dynamic> nestedData =
        searchviewemployeedetails['emplVerificationEmployee'] as Map<String, dynamic>? ??
            {};
    if (nestedData.containsKey('commonPanelAgeYear')) {
      searchviewemployeedetails['commonPanelAgeYear'] =
          nestedData['commonPanelAgeYear'];
      labels['commonPanelAgeYear'] = 'Age';
    }

    final searchviewAddressDetails =
        data['searchviewemployeedetails'] as Map<String, dynamic>? ?? {};
    final Map<String, String> addressLabels = {
      'presentVillageTownCity': 'Present Address',
      'presentCountryDesc': 'Present Country',
      'presentStateDesc': 'Present State',
      'presentDistrictDesc': 'Present District',
      'presentPoliceStationDesc': 'Present Police Station',
      
    };
       final searchviewCurrentEmployerDetails =
        data['searchviewemployeedetails'] as Map<String, dynamic>? ?? {};
    final Map<String, String> currentEmployerLabels = {
      'currentEmployerName': 'Full Name',
      'currentEmployerRoleOfEmployee': 'Role of the Employer',
      'currentEmployerVillageTownCity': 'Address',
      'currentEmployerCountryDesc': 'Country',
      'currentEmployerStateDesc': 'State',
      'currentEmployerDistrictDesc': 'District',
      'currentEmployerPoliceStationDesc': 'Police Station',
    };
    // final employeeRelativesList =
    //     data[0]['emplyeeRelativesList'] as Map<String, dynamic>? ?? {};
    // final Map<String, String> employeeRelativeLabels = {
    //   'RELATIVE_NAME': 'Full Name',
    //   'RELATIVE_TYPE': 'Relation',
    //   'PresentAddress': 'Address',
    // };

    final searchviewStatusDetails = searchviewemployeedetails;
    final Map<String, String> statusLabels = {
      'serviceRequestStatus': 'Status',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Verification Details'),
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
                'Employee Personal Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ...labels.entries.map((entry) {
                final value =
                    searchviewemployeedetails[entry.key]?.toString() ?? 'N/A';
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
                'Employee Address Details',
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
              // const SizedBox(height: 16.0),
              // const Text(
              //   'Employee Relatives Details',
              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(height: 8.0),
              // ...employeeRelativeLabels.entries.map((entry) {
              //   final value =
              //       employeeRelativesList[entry.key]?.toString() ??
              //           'N/A';
              //   return Padding(
              //     padding: const EdgeInsets.only(bottom: 16.0),
              //     child: TextFormField(
              //       initialValue: value,
              //       decoration: InputDecoration(
              //         labelText: entry.value,
              //         labelStyle: const TextStyle(
              //             color: Colors.black, fontWeight: FontWeight.bold),
              //              fillColor: Colors.white,
              //             filled: true,
              //         border: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(10),
              //           borderSide:
              //               const BorderSide(color: Colors.black, width: 2.0),
              //         ),
              //       ),
              //       enabled: false,
              //     ),
              //   );
              // }).toList(),
              const SizedBox(height: 16.0),
              const Text(
                'Current Employer Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ...currentEmployerLabels.entries.map((entry) {
                final value =
                    searchviewCurrentEmployerDetails[entry.key]?.toString() ??
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
