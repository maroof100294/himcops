import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:himcops/citizen/searchstaus/complaintstatus.dart';
import 'package:himcops/citizen/searchstaus/viewfir.dart';
import 'package:himcops/police/dsi.dart';
import 'package:himcops/police/phome.dart';

class PolAppDrawer extends StatefulWidget {
  const PolAppDrawer({super.key});

  @override
  _PolAppDrawerState createState() => _PolAppDrawerState();
}

class _PolAppDrawerState extends State<PolAppDrawer> {
  // int? _expandedTileIndex;

  // void _onExpansionChanged(int index, bool isExpanded) {
  //   setState(() {
  //     _expandedTileIndex = isExpanded ? index : null;
  //   });
  // }

  // String loginId = '';
  // String firstName = '';
  // int? mobile2;
  // String email = '';
  // final FlutterSecureStorage storage = const FlutterSecureStorage();

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchLoginId();
  // }

  // Future<void> _fetchLoginId() async {
  //   // Retrieve the values stored in secure storage
  //   final String? storedLoginId = await storage.read(key: 'loginId');
  //   final String? storedfirstName = await storage.read(key: 'firstName');
  //   final String? storedMobile2 = await storage.read(key: 'mobile2');
  //   final String? storedemail = await storage.read(key: 'email');
  //   print(
  //       'loginId:$storedLoginId,firstname:$storedfirstName,mobile:$storedMobile2,email:$storedemail');

  //   setState(() {
  //     loginId = storedLoginId ?? 'Unknown';
  //     firstName = storedfirstName ?? 'Unknown';
  //     mobile2 = storedMobile2 != null ? int.tryParse(storedMobile2) : null;
  //     email = storedemail ?? 'Unknown';
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 12, 100, 233),
                  Color.fromARGB(255, 139, 197, 230)
                ],
                stops: [0.23, 0.76],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              // color:Color.fromARGB(255, 9, 70, 35),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'asset/images/hp_logo.png',
                  width: 70,
                  height: 70,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'wc' .tr,
                      style: TextStyle(fontSize: 12, color: Colors.white,
                        fontWeight: FontWeight.bold,),
                    ),
                    Text(
                      // ignore: unnecessary_string_interpolations
                      'Police User Name',
                      style: TextStyle(
                        fontSize: 14,//MediaQuery.of(context).size.width * 0.033,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(214, 252, 225, 185),
                      ),
                      // textScaleFactor: MediaQuery.of(context)
                      //     .textScaleFactor
                      //     .clamp(1.0, 2.0),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'cn'.tr,
                        style: TextStyle(
                          fontSize: 14, //MediaQuery.of(context).size.width * 0.030,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Police Office Name',
                            style: TextStyle(
                              fontSize:
                                  14, //MediaQuery.of(context).size.width * 0.030,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(214, 252, 225, 185),
                            ),
                          ),
                        ],
                      ),
                      // textScaleFactor: MediaQuery.of(context)
                      //     .textScaleFactor
                      //     .clamp(1.0, 2.0),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text(
              'Home',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const PoliceHomePage()),
              );
            },
          ),
         ListTile(
            leading: const Icon(Icons.home),
            title:  Text(
              'dsi'.tr,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const DSIMobileHomePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title:  Text(
              'v_fir'.tr,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const ViewFIRPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title:  Text(
              'v_complaint'.tr,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const ComplaintStatusPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title:  Text(
              'c_diary'.tr,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => const ComplaintStatusPage()),
              // );
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title:  Text(
              'v_search'.tr,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => const ComplaintStatusPage()),
              // );
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title:  Text(
              'a_search'.tr,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => const ComplaintStatusPage()),
              // );
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title:  Text(
              'cis'.tr,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => const ComplaintStatusPage()),
              // );
            },
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title:  Text(
              'hcs'.tr,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => const ComplaintStatusPage()),
              // );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title:  Text(
              'logout'.tr,
              style: const TextStyle(
                // fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
          SizedBox(height: 10),
           ElevatedButton(
                      onPressed: () {
                        var locale = Get.locale!.languageCode == 'en'
                            ? const Locale('hi',
                                'IN') // Switch to Hindi if currently in English
                            : const Locale('en',
                                'US'); // Switch to English if currently in Hindi

                        // Update locale dynamically
                        Get.updateLocale(locale);
                      },
                      child: Text('change_language'
                          .tr), // Translated text for the button
                    ),
          
        ],
      ),
    );
  }
}
