import 'package:flutter/material.dart';
import 'package:himcops/drawer/drawer.dart';
import 'package:himcops/master/district.dart';
import 'package:himcops/master/officename.dart';
import 'package:himcops/master/sdp.dart';
import 'package:himcops/pages/cgridhome.dart';

class CitizenTipForm extends StatefulWidget {
  const CitizenTipForm({
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CitizenTipFormState createState() => _CitizenTipFormState();
}

class _CitizenTipFormState extends State<CitizenTipForm> {
  final TextEditingController citizenTipController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController policeController = TextEditingController();
  final TextEditingController dDistrictController = TextEditingController();
  final TextEditingController officeController = TextEditingController();
  final TextEditingController oOfficeController = TextEditingController();

  int? selectedStateId;
  bool isPoliceKnown = true;
  bool isDistrictKnown = true;
  String? viewFirDistrictCode;
  String? viewFirPoliceStationCode;
  String? tipDistrictCode;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldLogout = await Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CitizenGridPage()));
        return shouldLogout;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Citizen Tip',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 255, 255, 255)),
          ),
          backgroundColor: Color.fromARGB(255, 12, 100, 233),
          iconTheme: const IconThemeData(
            color: Colors.white, // Set the menu icon color to white
          ),
        ),
        drawer: const AppDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                TextFormField(
                  controller: citizenTipController,
                  decoration: InputDecoration(
                    labelText: 'Information/Tip',
                    prefixIcon: const Icon(Icons.feedback),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 10),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Do you know your police station?',
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
                        groupValue: isPoliceKnown,
                        onChanged: (val) {
                          setState(() {
                            isPoliceKnown = val!;
                          });
                        },
                        title: const Text('Yes'),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        value: false,
                        groupValue: isPoliceKnown,
                        onChanged: (val) {
                          setState(() {
                            isPoliceKnown = val!;
                          });
                        },
                        title: const Text("No"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (isPoliceKnown) ...[
                  DpPage(
                    onDistrictSelected: (districtCode) {
                      setState(() {
                        viewFirDistrictCode = districtCode;
                      });
                    },
                    onPoliceStationSelected: (policeStationCode) {
                      setState(() {
                        viewFirPoliceStationCode = policeStationCode;
                      });
                    },
                  ),
                ] else ...[
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'Do you know your district?',
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
                          groupValue: isDistrictKnown,
                          onChanged: (val) {
                            setState(() {
                              isDistrictKnown = val!;
                            });
                          },
                          title: const Text('Yes'),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<bool>(
                          value: false,
                          groupValue: isDistrictKnown,
                          onChanged: (val) {
                            setState(() {
                              isDistrictKnown = val!;
                            });
                          },
                          title: const Text("No"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (isDistrictKnown) ...[
                    DistrictPage(
                      controller: (districtCode) {
                        setState(() {
                          tipDistrictCode = districtCode;
                        });
                      },
                      enabled: true,
                    ),
                    const SizedBox(height: 10),
                    OfficeNamePage(controller: officeController, enabled: true),
                  ] else ...[
                    OfficeNamePage(
                        controller: oOfficeController, enabled: true),
                  ]
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
