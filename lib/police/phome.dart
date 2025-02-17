import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:himcops/citizen/searchstaus/complaintstatus.dart';
import 'package:himcops/citizen/searchstaus/viewfir.dart';
import 'package:himcops/drawer/pdrawer.dart';
import 'package:himcops/police/dsi.dart';

class PoliceHomePage extends StatefulWidget {
  const PoliceHomePage({super.key});
  @override
  _PoliceHomePageState createState() => _PoliceHomePageState();
}

class _PoliceHomePageState extends State<PoliceHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
 

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
        label: 'dsi'.tr, iconPath: 'asset/images/cservice.jpeg'),
    Service(label: 'v_fir'.tr, iconPath: 'asset/images/vfir.jpeg'),
    Service(label: 'v_complaint'.tr, iconPath: 'asset/images/complaint.jpeg'),
    Service(label: 'c_diary'.tr, iconPath: 'asset/images/echallan.jpeg'),
    // Service(label: 'v_search'.tr, iconPath: 'asset/images/ctip.jpeg'),
    // Service(label: 'a_search'.tr, iconPath: 'asset/images/contact.jpeg'),
    // Service(label: 'cis'.tr, iconPath: 'asset/images/ctip.jpeg'),
    // Service(label: 'hcs'.tr, iconPath: 'asset/images/contact.jpeg'),
  ];


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldLogout = await _showLogoutDialog(context);
        return shouldLogout;
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: PolAppDrawer(),
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
                        text: 'Police User Name', //Police User Full Name with district and Police station
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(211, 11, 72, 151),
                        ),
                      ),
                      TextSpan(
                        text: 'Police User District', //Police User Full Name with district and Police station
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.035,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(211, 11, 72, 151),
                        ),
                      ),
                      TextSpan(
                        text: 'Police User PoliceStation', //Police User Full Name with district and Police station
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const DSIMobileHomePage()));
                                break;
                              case 1:
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ViewFIRPage()));
                                break;
                              case 2:
                                 Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ComplaintStatusPage()));
                                break;
                              case 3:
                              // showComplaintDialog(context);
                              //   _launchURL(
                              //       'https://echallan.parivahan.gov.in/index/accused-challan');
                                // break;
                              // case 4:
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) =>
                              //               const CitizenTipForm()));
                              //   break;
                              // case 5:
                              //   showContactDetail();
                              // break;
                              // case 6:
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) =>
                              //               const CitizenTipForm()));
                              //   break;
                              // case 7:
                              //   showContactDetail();
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
          ],
        ),
      ),
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

// void _launchURL(String url) async {
//   if (await canLaunch(url)) {
//     await launch(url);
//   } else {
//     throw 'Could not launch $url';
//   }
// }

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
