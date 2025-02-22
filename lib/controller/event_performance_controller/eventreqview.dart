import 'package:flutter/material.dart';
import 'package:himcops/layout/formlayout.dart';

class EventReqViewPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const EventReqViewPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final viewEventVerificationDetails =
        data['applicant'] as Map<String, dynamic>? ?? {};
    final Map<String, String> labels = {
      'firstName': 'Full Name',
      'relativeName': 'Relative Name',
      'email': 'Email ID',
      'mobile2': 'Mobile Number'
    };
final viewEEventVerificationDetails = data.isNotEmpty ? data : {};
    final Map<String, String> applicantlabels = {
      
      'applicantGenderCdDesc': 'Gender',
      'mRelationTypeDesc': 'Relation'
    };
    final Map<String, dynamic> nestedData =
        viewEventVerificationDetails['eventPerformanceRegApplicant']
                as Map<String, dynamic>? ??
            {};
    if (nestedData.containsKey('commonPanelAgeYear')) {
      viewEventVerificationDetails['commonPanelAgeYear'] =
          nestedData['commonPanelAgeYear'];
      labels['commonPanelAgeYear'] = 'Age';
    }

    final Map<String, dynamic> perAddressData =
        viewEventVerificationDetails['permanentAddressFormBean']
                as Map<String, dynamic>? ??
            {};
    if (perAddressData.containsKey('village')) {
      viewEventVerificationDetails['village'] = perAddressData['village'];
      labels['village'] = 'Permanent Address';
    }

    final viewEventPermanentDetails = data.isNotEmpty ? data : {};
    final Map<String, String> permanentlabels = {
      'applicantPerAddCountryCdDesc': 'Country',
      'applicantPerAddStateCdDesc': 'State',
      'applicantPerAddDistCdDesc': 'District', // District needed
      'applicantPerAddPSCdDesc': 'Police Station'
    };

    final Map<String, dynamic> preAddressData =
        viewEventVerificationDetails['presentAddressFormBean']
                as Map<String, dynamic>? ??
            {};
    if (preAddressData.containsKey('village')) {
      viewEventVerificationDetails['village'] = preAddressData['village'];
      labels['village'] = 'Present Address';
    }

    final viewEventPresentDetails = data.isNotEmpty ? data : {};
    final Map<String, String> presentlabels = {
      'applicantPreAddCountryCdDesc': 'Country',
      'applicantPreAddStateCdDesc': 'State',
      'applicantPreAddDistCdDesc': 'District', // District needed
      'applicantPreAddPSCdDesc': 'Police Station'
    };

    

    final viewEventOrgDetails =data.isNotEmpty ? data : {};
    final Map<String, String> orglabels = {
      'orgnizationName': 'Organization Name',
    };

    final viewEventlocationDetails = data.isNotEmpty ? data : {};
    final Map<String, String> locationlabels = {
      'locationName': 'Event Location Name',
      'eventTypeCdDesc': 'Event Performance Type', // need event type
      'eventStartDtStr': 'Start Date of Event',
      'eventEndDtStr': 'End Date of Event',
    };

    final Map<String, dynamic> locationAddressData =
        viewEventlocationDetails['locationAddress'] as Map<String, dynamic>? ??
            {};
    if (locationAddressData.containsKey('village')) {
      viewEventlocationDetails['village'] = locationAddressData['village'];
      locationlabels['village'] = 'Event Location Address';
    }

    final viewEventLocAddressDetails = data.isNotEmpty ? data : {};
    final Map<String, String> locationAddlabels = {
      'locAddCountryCdDesc': 'Country',
      'locAddStateCdDesc': 'State',
      'locAddDistCdDesc': 'District',
      'locAddPSCdDesc': 'Police Station'
    };

    final viewEventStatusDetails = data.isNotEmpty ? data : {};
    final Map<String, String> statusLabels = {
      'requestStatus': 'Status',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Performance Details'),
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
                    viewEventVerificationDetails[entry.key]?.toString() ??
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
              ...applicantlabels.entries.map((entry) {
                final value =
                    viewEEventVerificationDetails[entry.key]?.toString() ?? 'N/A';
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
              ...permanentlabels.entries.map((entry) {
                final value =
                    viewEventPermanentDetails[entry.key]?.toString() ?? 'N/A';
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
                    viewEventPresentDetails[entry.key]?.toString() ?? 'N/A';
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
              ...orglabels.entries.map((entry) {
                final value =
                    viewEventOrgDetails[entry.key]?.toString() ?? 'N/A';
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
                    viewEventlocationDetails[entry.key]?.toString() ?? 'N/A';
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
                    viewEventLocAddressDetails[entry.key]?.toString() ?? 'N/A';
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
                      "${viewEventlocationDetails['locationArea'] ?? 'N/A'}  ${viewEventlocationDetails['locationAreaCd'] ?? ' '}",
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
                      "${viewEventlocationDetails['proposedTimeLmtHH'] ?? 'N/A'} : ${viewEventlocationDetails['proposedTimeLmtMM'] ?? 'N/A'}",
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
                      "${viewEventlocationDetails['eventStartTimeStrHH'] ?? 'N/A'} : ${viewEventlocationDetails['eventStartTimeStrMM'] ?? 'N/A'}",
                  decoration: InputDecoration(
                    labelText: 'Event Start/End Time',
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
                      "${viewEventlocationDetails['briefSynopsis'] ?? 'N/A'}",
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
                    viewEventStatusDetails[entry.key]?.toString() ?? 'N/A';
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
