import 'package:flutter/material.dart';
import 'package:himcops/layout/formlayout.dart';

class ProtestReqViewPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const ProtestReqViewPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final viewProtestVerificationDetails =
        data['applicant'] as Map<String, dynamic>? ?? {};
    final Map<String, String> labels = {
      'firstName': 'Full Name'
    };
    final viewPProtestVerificationDetails = data.isNotEmpty ? data : {};
    final Map<String, String> applicantlabels = {
      'applicantGenderCdDesc': 'Gender', //this is needed
      'mRelationTypeDesc': 'Relation' //this is needed //ps code needed
    };
final viewPPProtestVerificationDetails =
        data['applicant'] as Map<String, dynamic>? ?? {};
    final Map<String, String> applabels = {
      'relativeName': 'Relative Name',
      'email': 'Email ID',
      'mobile2': 'Mobile Number'
    };
    final Map<String, dynamic> nestedData =
        viewProtestVerificationDetails['protestStrikeApplicant']
                as Map<String, dynamic>? ??
            {};
    if (nestedData.containsKey('commonPanelAgeYear')) {
      viewProtestVerificationDetails['commonPanelAgeYear'] =
          nestedData['commonPanelAgeYear'];
      labels['commonPanelAgeYear'] = 'Age';
    }

    // final Map<String, dynamic> perAddressData =
    //     viewProtestVerificationDetails['permanentAddressFormBean']
    //             as Map<String, dynamic>? ??
    //         {};
    // if (perAddressData.containsKey('village')) {
    //   viewProtestVerificationDetails['village'] = perAddressData['village'];
    //   labels['village'] = 'Permanent Address';
    // }

    // final viewProtestPermanentDetails = data.isNotEmpty ? data : {};
    // final Map<String, String> permanentlabels = {
    //   'applicantPerAddCountryCdDesc': 'Country',
    //   'applicantPerAddStateCdDesc': 'State',
    //   'applicantPerAddDistCdDesc': 'District', // District needed
    //   'applicantPerAddPSCdDesc': 'Police Station'//police station
    // };

    final Map<String, dynamic> preAddressData =
        viewProtestVerificationDetails['presentAddressFormBean']
                as Map<String, dynamic>? ??
            {};
    if (preAddressData.containsKey('village')) {
      viewProtestVerificationDetails['village'] = preAddressData['village'];
      labels['village'] = 'Present Address';
    }

    final viewProtestPresentDetails = data.isNotEmpty ? data : {};
    final Map<String, String> presentlabels = {
      'applicantPreAddCountryCdDesc': 'Country',
      'applicantPreAddStateCdDesc': 'State',
      'applicantPreAddDistCdDesc': 'District',
      'applicantPreAddPSCdDesc': 'Police Station' //ps code needed
    };

    

    final viewProtestOrgDetails =data.isNotEmpty ? data : {};
    final Map<String, String> orglabels = {
      'targetInstituteOrPersonName': 'Target Institute/Person Name',
      'orgName': 'Organization Name',
      
    };
    final Map<String, dynamic> orgAddressData = viewProtestOrgDetails['organization'] as Map<String ,dynamic>? ??
    {};
     if (orgAddressData.containsKey('village')) {
      viewProtestOrgDetails['village'] = orgAddressData['village'];
      orglabels['village'] = 'Organization Address';
    }
    final viewProtestOrgAddDetails =data.isNotEmpty ? data : {};
    final Map<String, String> orgAddlabels = {
      'orgCountryCdDesc': 'Country',
      'orgStateCdDesc': 'State',
      'orgDistCdDesc':'District',
      'orgPSCdDesc':'Police Station'//its needed
      
    };
    final viewProtestlocationDetails = data.isNotEmpty ? data : {};
    final Map<String, String> locationlabels = {
      'locationProtestStrikeName': 'Protest Location Name',
      'typeOfProtestStrikeDesc': 'Protest/Strike Type', // need event type
      'startDateProtestStrikeStr': 'Start Date of Protest',
      'endDateProtestStrikeStr': 'End Date of Protest',
    };
    

    final Map<String, dynamic> locationAddressData =
        viewProtestlocationDetails['protestStrikeLocationAddress'] as Map<String, dynamic>? ??
            {};
    if (locationAddressData.containsKey('village')) {
      viewProtestlocationDetails['village'] = locationAddressData['village'];
      locationlabels['village'] = 'Protest Location Address';
    }

    final viewProtestLocAddressDetails = data.isNotEmpty ? data : {};
    final Map<String, String> locationAddlabels = {
      'locAddCountryCdDesc': 'Country',
      'locAddStateCdDesc': 'State',
      'locAddDistCdDesc': 'District',
      'locAddPSCdDesc': 'Police Station'
    };

    final viewProtestStatusDetails = data.isNotEmpty ? data : {};
    final Map<String, String> statusLabels = {
      'serviceRequestStatus': 'Status',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Protest/Strike Details'),
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
                'Applicant Personal Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ...labels.entries.map((entry) {
                final value =
                    viewProtestVerificationDetails[entry.key]?.toString() ??
                        ' ';
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
              // ...permanentlabels.entries.map((entry) {
              //   final value =
              //       viewProtestPermanentDetails[entry.key]?.toString() ?? ' ';
              //   return Padding(
              //     padding: const EdgeInsets.only(bottom: 16.0),
              //     child: TextFormField(
              //       initialValue: value,
              //       decoration: InputDecoration(
              //         labelText: entry.value,
              //         labelStyle: const TextStyle(
              //             color: Colors.black, fontWeight: FontWeight.bold),
              //         fillColor: Colors.white,
              //         filled: true,
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
              ...presentlabels.entries.map((entry) {
                final value =
                    viewProtestPresentDetails[entry.key]?.toString() ?? ' ';
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
              ...applicantlabels.entries.map((entry) {
                final value =
                    viewPProtestVerificationDetails[entry.key]?.toString() ?? ' ';
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
              ...applabels.entries.map((entry) {
                final value =
                    viewPPProtestVerificationDetails[entry.key]?.toString() ?? ' ';
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
                'Applicant Organization Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ...orglabels.entries.map((entry) {
                final value =
                    viewProtestOrgDetails[entry.key]?.toString() ?? ' ';
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
              ...orgAddlabels.entries.map((entry) {
                final value =
                    viewProtestOrgAddDetails[entry.key]?.toString() ?? ' ';
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
                'Event Location Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ...locationlabels.entries.map((entry) {
                final value =
                    viewProtestlocationDetails[entry.key]?.toString() ?? ' ';
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
              ...locationAddlabels.entries.map((entry) {
                final value =
                    viewProtestLocAddressDetails[entry.key]?.toString() ?? ' ';
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
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextFormField(
                  initialValue:
                      "${viewProtestlocationDetails['locationAreaDetails'] ?? ' '} :  Sq.Mts.",
                  decoration: InputDecoration(
                    labelText: 'Location Area',
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
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextFormField(
                  initialValue:
                      "${viewProtestlocationDetails['protestStartTimeStrHH'] ?? ' '} : ${viewProtestlocationDetails['protestStartTimeStrMM'] ?? ' '}",
                  decoration: InputDecoration(
                    labelText: 'Proposed Time',
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
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextFormField(
                  initialValue:
                      "${viewProtestlocationDetails['protestStartTimeHH'] ?? ' '} : ${viewProtestlocationDetails['protestStartTimeMM'] ?? ' '}",
                  decoration: InputDecoration(
                    labelText: 'Event Start Time',
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
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextFormField(
                  initialValue:
                      "${viewProtestlocationDetails['protestStrikeDesc'] ?? ' '}",
                  decoration: InputDecoration(
                    labelText: 'Brief Description',
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
                  maxLines: 3,
                ),
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Request Status',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ...statusLabels.entries.map((entry) {
                final value =
                    viewProtestStatusDetails[entry.key]?.toString() ?? ' ';
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
