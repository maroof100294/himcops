import 'package:flutter/material.dart';
import 'package:himcops/drawer/drawer.dart';
import 'package:himcops/layout/backgroundlayout.dart';
import 'package:himcops/layout/formlayout.dart';
import 'package:himcops/master/sdp.dart';
import 'package:himcops/pages/cgridhome.dart';

class ViewFIRPage extends StatefulWidget {
  const ViewFIRPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ViewFIRPageState createState() => _ViewFIRPageState();
}

class _ViewFIRPageState extends State<ViewFIRPage> {
  final TextEditingController firNumberController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  String? viewFirDistrictCode;
  String? viewFirPoliceStationCode;
  
  @override
  void initState() {
    super.initState();
  }

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
            'View FIR',
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
        body: Stack(
          children: [
            const BackgroundPage(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                decoration: myBoxDecoration(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: firNumberController,
                      decoration: InputDecoration(
                        labelText: 'FIR Number',
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.numbers),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: yearController,
                      decoration: InputDecoration(
                        labelText: 'Select Year',
                        prefixIcon: const Icon(Icons.calendar_month),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onTap: () {
                        // year function
                      },
                    ),
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF133371),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            'Search',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Reset',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// when i click back button its exit the app if i open this from CitizenGridPage, it should go to the same page