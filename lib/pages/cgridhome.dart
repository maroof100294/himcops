import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:himcops/citizen/citizentip.dart';
import 'package:himcops/citizen/domestichelpverification.dart';
import 'package:himcops/citizen/employeeverification.dart';
import 'package:himcops/citizen/eventperformancerequest.dart';
import 'package:himcops/citizen/policeclearance.dart';
import 'package:himcops/citizen/processionrequest.dart';
import 'package:himcops/citizen/proteststrikerequest.dart';
import 'package:himcops/citizen/searchstaus/Tenantverifystatus.dart';
import 'package:himcops/citizen/searchstaus/characterstatus.dart';
import 'package:himcops/citizen/searchstaus/dmvviewpage.dart';
import 'package:himcops/citizen/searchstaus/empviewpage.dart';
import 'package:himcops/citizen/searchstaus/eventperformance.dart';
import 'package:himcops/citizen/searchstaus/pccviewpage.dart';
import 'package:himcops/citizen/searchstaus/processionstatus.dart';
import 'package:himcops/citizen/searchstaus/proteststrikestatus.dart';
import 'package:himcops/citizen/searchstaus/viewfir.dart';
import 'package:himcops/citizen/tenantverification.dart';
import 'package:himcops/drawer/drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class CitizenGridPage extends StatefulWidget {
  const CitizenGridPage({super.key});
  @override
  _CitizenGridPageState createState() => _CitizenGridPageState();
}

class _CitizenGridPageState extends State<CitizenGridPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String loginId = '';
  String firstName = '';
  int? mobile2;
  String email = '';
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _fetchLoginId();
  }

  Future<void> _fetchLoginId() async {
    final String? storedLoginId = await storage.read(key: 'loginId');
    final String? storedFirstName = await storage.read(key: 'firstName');
    final String? storedMobile2 = await storage.read(key: 'mobile2');
    final String? storedEmail = await storage.read(key: 'email');

    setState(() {
      loginId = storedLoginId ?? 'Unknown';
      firstName = storedFirstName ?? 'Unknown';
      mobile2 = storedMobile2 != null ? int.tryParse(storedMobile2) : null;
      email = storedEmail ?? 'Unknown';
    });
  }

  final List<String> imagePaths = [
    'asset/images/pic_a.jpg',
    'asset/images/pic_b.jpg',
    'asset/images/pic_c.jpg',
    'asset/images/pic_d.jpg',
    'asset/images/pic_e.jpg',
  ];

  final List<String> imageEmgPaths = [
    'asset/images/pem.png',
    'asset/images/amb.png',
    'asset/images/fire.png',
    'asset/images/child.png',
    'asset/images/gudiya.png',
  ];

  final List<Service> services = [
    Service(
        label: 'citizen_service'.tr, iconPath: 'asset/images/cservice.jpeg'),
    Service(label: 'v_fir'.tr, iconPath: 'asset/images/vfir.jpeg'),
    Service(label: 'add_complaint'.tr, iconPath: 'asset/images/complaint.jpeg'),
    Service(label: 'echallan'.tr, iconPath: 'asset/images/echallan.jpeg'),
    Service(label: 'citizen_tip'.tr, iconPath: 'asset/images/ctip.jpeg'),
    Service(label: 'contact_us'.tr, iconPath: 'asset/images/contact.jpeg'),
  ];
//  final RxList<Service> services = <Service>[
//     Service(label: 'citizen_service'.tr, iconPath: 'asset/images/cservice.jpeg'),
//     Service(label: 'v_fir'.tr, iconPath: 'asset/images/vfir.jpeg'),
//     Service(label: 'add_complaint'.tr, iconPath: 'asset/images/complaint.jpeg'),
//     Service(label: 'echallan'.tr, iconPath: 'asset/images/echallan.jpeg'),
//     Service(label: 'citizen_tip'.tr, iconPath: 'asset/images/ctip.jpeg'),
//     Service(label: 'contact_us'.tr, iconPath: 'asset/images/contact.jpeg'),
//   ].obs;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldLogout = await _showLogoutDialog(context);
        return shouldLogout;
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: AppDrawer(),
        body: Column(
          children: [
            Container(
              height: 35, // Adjust the height as needed
              color: const Color.fromARGB(207, 43, 73, 119),
            ),
            Container(
              height: 60, // Total height of the top section
              color:
                  Color.fromARGB(255, 113, 150, 207), // AppBar background color
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 10.0), // Adjust horizontal padding
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.menu, color: Colors.white),
                      onPressed: () {
                        _scaffoldKey.currentState?.openDrawer();
                      },
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Himachal Pradesh Police',
                            style: TextStyle(
                              fontSize: 14, // Adjust font size as needed
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'हिमाचल प्रदेश पुलिस',
                            style: TextStyle(
                              fontSize: 14, // Match the font size
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 40, // Match the logo size
                      height: 40, // Match the logo size
                      child: Image.asset(
                        'asset/images/hp_logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(
                    text: 'wc'.tr,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '$firstName',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(211, 11, 72, 151),
                        ),
                      ),
                    ],
                  ),
                  textScaleFactor:
                      MediaQuery.of(context).textScaleFactor.clamp(1.0, 2.0),
                ),
              ),
            ),
            SizedBox(height: 10),
            CarouselSlider(
              items: imagePaths
                  .map((path) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          path,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ))
                  .toList(),
              options: CarouselOptions(
                height: 200,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                viewportFraction: 0.9,
                enlargeCenterPage: true,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.0,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      padding: const EdgeInsets.all(8),
                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        return ServiceCard(
                          service: services[index],
                          onTap: () {
                            switch (index) {
                              case 0:
                                showCitizenHomeDialog(context);
                                break;
                              case 1:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ViewFIRPage()));
                                break;
                              case 2:
                                // showComplaintDialog(context);
                                break;
                              case 3:
                                _launchURL(
                                    'https://echallan.parivahan.gov.in/index/accused-challan');
                                break;
                              case 4:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CitizenTipForm()));
                                break;
                              case 5:
                                showContactDetail();
                                break;
                              default:
                                break;
                            }
                          },
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    CarouselSlider(
                      items: imageEmgPaths
                          .map((path) => ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset(
                                  path,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ))
                          .toList(),
                      options: CarouselOptions(
                        height: 100,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 5),
                        viewportFraction: 0.9,
                        enlargeCenterPage: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          backgroundColor: const Color.fromARGB(255, 147, 176, 235),
          tooltip: 'Please click to view the options',
          children: [
            SpeedDialChild(
              backgroundColor: Colors.red,
              labelBackgroundColor: Colors.grey,
              labelStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              child: const Icon(Icons.logout, color: Colors.white),
              label: 'logout'.tr,
              onTap: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
            // SpeedDialChild(
            //   backgroundColor: const Color.fromARGB(255, 244, 155, 54),
            //   labelBackgroundColor: Colors.grey,
            //   labelStyle: const TextStyle(
            //       color: Colors.white, fontWeight: FontWeight.bold),
            //   child: const Icon(Icons.language, color: Colors.white),
            //   label: 'change_language'.tr,
            //   onTap: () {
            //     var locale = Get.locale!.languageCode == 'en'
            //         ? const Locale(
            //             'hi', 'IN') // Switch to Hindi if currently in English
            //         : const Locale(
            //             'en', 'US'); // Switch to English if currently in Hindi

            //     // Update locale dynamically
            //     Get.updateLocale(locale);

            //     // Manually update the labels
            //     services.forEach((service) {
            //       service.label.value =
            //           service.label.value.tr; // Re-translate the label
            //     });
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  void showCitizenHomeDialog(BuildContext context) {
    bool isServicesExpanded = true;
    bool isStatusExpanded = false;

    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      barrierDismissible: true,
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                  child: Container(
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
              ),
              SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-1.0, 0.0),
                  end: const Offset(-0.1, 0.0),
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                )),
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    void toggleDropdown(String type) {
                      setState(() {
                        if (type == 'Apply For Service') {
                          isServicesExpanded = !isServicesExpanded;
                          isStatusExpanded = false;
                        } else if (type == 'Track Request Status') {
                          isStatusExpanded = !isStatusExpanded;
                          isServicesExpanded = false;
                        }
                      });
                    }

                    return Align(
                      alignment: Alignment.center,
                      child: FractionallySizedBox(
                        widthFactor: 1.10,
                        child: Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 30),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'asset/images/hp_logo.png',
                                  height: 50,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'citizen_service'.tr,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 243, 140, 5),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                _buildDropdownCard(
                                  'apply_service'.tr,
                                  isServicesExpanded,
                                  () => toggleDropdown('Apply For Service'),
                                  [
                                    'pcc'.tr,
                                    'emp'.tr,
                                    'dhv'.tr,
                                    'tv'.tr,
                                    'epr'.tr,
                                    'psr'.tr,
                                    'pr'.tr,
                                  ],
                                ),
                                const SizedBox(height: 10),
                                _buildDropdownCard(
                                  'track_service'.tr,
                                  isStatusExpanded,
                                  () => toggleDropdown('Track Request Status'),
                                  [
                                    'crs'.tr,
                                    'pccs'.tr,
                                    'emps'.tr,
                                    'dhvs'.tr,
                                    'tvs'.tr,
                                    'eprs'.tr,
                                    'psrs'.tr,
                                    'prs'.tr,
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      transitionDuration: const Duration(seconds: 2),
    ));
  }

  Widget _buildDropdownCard(
      String title, bool isExpanded, VoidCallback onTap, List<String> options) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            color: const Color.fromARGB(207, 43, 73, 119),
            child: ListTile(
              title: Text(
                title,
                style:
                    const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
              leading: const Icon(
                Icons.assignment,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              trailing: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
              ),
              onTap: onTap,
            ),
          ),
          if (isExpanded)
            Container(
              color: const Color.fromARGB(255, 197, 218, 241),
              child: Column(
                children: options
                    .map((option) => Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                _navigateToService(option);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6.0,
                                    horizontal: 12.0), // Adjust spacing here
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    option,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const Divider(
                              color: Colors.white, // White divider
                              thickness: 1, // Thickness of the divider
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  void _navigateToService(String service) {
    if (service == 'Domestic Helper Verification') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const DomesticHelpVerificationPage()));
    } else if (service == 'Employee Verification') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const EmployeeVerificationPage()));
    } else if (service == 'Police Clearance Certificate') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const PoliceClearanceCertificatePage()));
    } else if (service == 'Character Certificate Status') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const CharacterRequestStatusPage()));
    } else if (service == 'Domestic Helper Status') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const DomesticHelpVerificationViewPage()));
    } else if (service == 'Employee Status') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const EmployeeVerificationViewPage()));
    } else if (service == 'Police Clearance Status') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const PoliceClearanceCertificateViewPage()));
    } else if (service == 'Tenant Verification') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const TenantVerificationPage()));
    } else if (service == 'Event Performance Request') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const EventPerformanceRequestPage()));
    } else if (service == 'Protest/Strike Request') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const ProtestStrikeRequestPage()));
    } else if (service == 'Procession Request') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const ProcessionRequestPage()));
    } else if (service == 'Procession Status') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const ProcessionStatusPage()));
    } else if (service == 'Protest/Strike Status') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const ProtestStrikeStatusPage()));
    }  else if (service == 'Event Performance Status') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const EventPerformanceStatusPage()));
    } else if (service == 'Tenant Verification Status') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const TenantVerificaitonStatusPage()));
    } else if (service == 'किरायेदार सत्यापन') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const TenantVerificationPage()));
    } else if (service == 'घरेलू सहायक सत्यापन') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const DomesticHelpVerificationPage()));
    } else if (service == 'कर्मचारी सत्यापन') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const EmployeeVerificationPage()));
    } else if (service == 'पुलिस क्लियरेंस प्रमाणपत्र') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const PoliceClearanceCertificatePage()));
    } else if (service == 'चरित्र प्रमाणपत्र स्थिति') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const CharacterRequestStatusPage()));
    } else if (service == 'घरेलू सहायक स्थिति') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const DomesticHelpVerificationViewPage()));
    } else if (service == 'कर्मचारी स्थिति') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const EmployeeVerificationViewPage()));
    } else if (service == 'पुलिस क्लियरेंस स्थिति') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const PoliceClearanceCertificateViewPage()));
    }
  }

  void showContactDetail() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Column(
            children: [
              Image.asset(
                'asset/images/hp_logo.png',
                height: 50,
              ),
              const SizedBox(height: 10),
              Text(
                'police'.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'citizen_service'.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Director General of Police, Himachal Pradesh\nTelephone Number: 2628216\nEmail ID: scrb-hp@nic.in',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFFF3AC00),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showLogoutDialog(BuildContext context) async {
    bool shouldLogout = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('log'.tr),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                shouldLogout = false;
              },
              child: Text('cancel'.tr),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                shouldLogout = true;
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text('logout'.tr),
            ),
          ],
        );
      },
    );
    return shouldLogout;
  }
}

void _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class Service {
  final String label;
  final String iconPath;

  Service({required this.label, required this.iconPath});
}

class ServiceCard extends StatelessWidget {
  final Service service;
  final VoidCallback onTap;

  const ServiceCard({required this.service, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.asset(
                service.iconPath,
                height: 60,
                width: 60,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              service.label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
