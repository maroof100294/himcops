import 'package:flutter/material.dart';
import 'package:himcops/layout/formlayout.dart';

class ProcessionReqViewPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const ProcessionReqViewPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final viewProtestVerificationDetails =
        data['applicant'] as Map<String, dynamic>? ?? {};
    final Map<String, String> labels = {
      'firstName': 'Full Name',
      'applicantGenderCdDesc': 'Gender', //this is needed
      'mRelationTypeDesc': 'Relation', //this is needed
      'relativeName': 'Relative Name',
      'mobile2': 'Mobile Number'
    };

    final Map<String, dynamic> nestedData =
        viewProtestVerificationDetails['processionRequestRegApplicant']
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
      'orgPsCdDesc':'Police Station'//its needed
      
    };
    final viewProtestlocationDetails = data.isNotEmpty ? data : {};
    final Map<String, String> locationlabels = {
      'procesionTypeDesc': 'ProcessionType', // need event type
      'processionStartDtStr': 'Start Date of Procession',
      'processionEndDtStr': 'End Date of Procession',
      'expectedCrowd': 'Expected Crowd'
    };
    
       final viewProStartinglocationDetails =
        data['startPointAddr'] as Map<String, dynamic>? ?? {};
    final Map<String, String> startingAddLabels = {
      'village': 'Starting Address',
      'countryValue': 'Country', //this is needed
      'stateValue': 'State', //this is needed
      'districtValue': 'District'
    };

final viewProEndinglocationDetails =
        data['endPointAddr'] as Map<String, dynamic>? ?? {};
    final Map<String, String> endingAddLabels = {
      'village': 'End route Address',
      'countryValue': 'Country', //this is needed
      'stateValue': 'State', //this is needed
      'districtValue': 'District'
    };


    final viewProtestStatusDetails = data.isNotEmpty ? data : {};
    final Map<String, String> statusLabels = {
      'serviceRequestStatus': 'Status',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Procession Request Details'),
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
              ...presentlabels.entries.map((entry) {
                final value =
                    viewProtestPresentDetails[entry.key]?.toString() ?? 'N/A';
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
                    viewProtestOrgDetails[entry.key]?.toString() ?? 'N/A';
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
                    viewProtestOrgAddDetails[entry.key]?.toString() ?? 'N/A';
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
                'Procession Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ...locationlabels.entries.map((entry) {
                final value =
                    viewProtestlocationDetails[entry.key]?.toString() ?? 'N/A';
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
                      "${viewProtestlocationDetails['protestStartTimeHH'] ?? 'N/A'} : ${viewProtestlocationDetails['protestStartTimeMM'] ?? 'N/A'}",
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
                      "${viewProtestlocationDetails['processionStartTimeStrHH'] ?? ' '} : ${viewProtestlocationDetails['processionStartTimeStrMM'] ?? ' '}",
                  decoration: InputDecoration( 
                    labelText: 'Procession Start/End Time',
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
                      "${viewProtestlocationDetails['briefSynopsis'] ?? 'N/A'}",
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
              ...startingAddLabels.entries.map((entry) {
                final value =
                    viewProStartinglocationDetails[entry.key]?.toString() ?? 'N/A';
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
              ...endingAddLabels.entries.map((entry) {
                final value =
                    viewProEndinglocationDetails[entry.key]?.toString() ?? 'N/A';
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
                    viewProtestStatusDetails[entry.key]?.toString() ?? 'N/A';
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
