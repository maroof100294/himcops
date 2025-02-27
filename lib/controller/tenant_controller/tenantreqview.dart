import 'package:flutter/material.dart';
import 'package:himcops/layout/formlayout.dart';

class TenantReqViewPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const TenantReqViewPage({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final viewTenentVerificationDetails =
        data['viewTenentVerificationDetails'] as Map<String, dynamic>? ?? {};
    final Map<String, String> labels = {
      'tenantFirstName': 'Full Name',
      'tenantGenderDesc': 'Gender',
      'tenantOccupationDesc':'Occupation',
      'tenantRelationTypeDesc': 'Relation',
      'tenantRelativeName': 'Relative Name',
      'tenantPurposeDesc':'Purpose of Tenancy',
      'commercialDetails': 'Commercial Detail'
    };

    final Map<String, dynamic> nestedData =
        viewTenentVerificationDetails['tenantVerificationTenant'] as Map<String, dynamic>? ??
            {};
    if (nestedData.containsKey('commonPanelAgeYear')) {
      viewTenentVerificationDetails['commonPanelAgeYear'] =
          nestedData['commonPanelAgeYear'];
      labels['commonPanelAgeYear'] = 'Age';
    }

    final viewTenentOwnerDetails =
        data['viewTenentVerificationDetails'] as Map<String, dynamic>? ?? {};
    final Map<String, String> ownerLabels = {
      'ownerFirstName': 'Full Name',
      'ownerOccupationDesc': 'Occupation',
      'ownerEmailId': 'Email',
      'ownerVillage':'Address',
      'ownerCountryDesc': 'Country',
      'ownerStateDesc': 'State',
      'ownerDistrictDesc': 'District',
      'ownerPoliceStationDesc': 'PoliceStation'
    };

    final viewTenentPresentAddressDetails =
        data['viewTenentVerificationDetails'] as Map<String, dynamic>? ?? {};
    final Map<String, String> presentAddressLabels = {
      'tenantPresentVillage': 'Address',
      'tenantPresentCountryDesc': 'Country',
      'tenantPresentStateDesc': 'State',
      'tenantPresentDistrictDesc':'District',
      'tenantPresentPoliceStationDesc': 'PoliceStation'
    };

    final viewTenentPermanentAddressDetails =
        data['viewTenentVerificationDetails'] as Map<String, dynamic>? ?? {};
    final Map<String, String> permanentAddressLabels = {
      'tenantPermanentVillage': 'Address',
      'tenantPermanentCountryDesc': 'Country',
      'tenantPermanentStateDesc': 'State',
      'tenantPermanentDistrictDesc':'District',
      'tenantPermanentPoliceStationDesc': 'PoliceStation'
    };

    final viewTenentStatusDetails = viewTenentVerificationDetails;
    final Map<String, String> statusLabels = {
      'serviceRequestStatus': 'Status',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tenant Verification Details'),
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
                'Owner Personal Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ...ownerLabels.entries.map((entry) {
                final value =
                    viewTenentOwnerDetails[entry.key]?.toString() ??
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
                'Tenant Personal Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ...labels.entries.map((entry) {
                final value =
                    viewTenentVerificationDetails[entry.key]?.toString() ?? 'N/A';
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
                'Tenant Present Address Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ...presentAddressLabels.entries.map((entry) {
                final value =
                    viewTenentPresentAddressDetails[entry.key]?.toString() ??
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
                'Tenant Permanent Address Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              ...permanentAddressLabels.entries.map((entry) {
                final value =
                    viewTenentPermanentAddressDetails[entry.key]?.toString() ??
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
                    viewTenentStatusDetails[entry.key]?.toString() ??
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
