import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:himcops/drawer/pdrawer.dart';
import 'package:intl/intl.dart';

class DSIMobileHomePage extends StatefulWidget {
  const DSIMobileHomePage({super.key});

  @override
  State<DSIMobileHomePage> createState() => _DSIMobileHomePageState();
}

class _DSIMobileHomePageState extends State<DSIMobileHomePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController firNumController = TextEditingController();
  final TextEditingController _dateFromController = TextEditingController();
  final TextEditingController _dateToController = TextEditingController();
  final TextEditingController _dateFirFromController = TextEditingController();
  final TextEditingController _dateFirToController = TextEditingController();

  int totalFIR = 0;
  int specialCases = 0;
  DateTime? fromDate;
  DateTime? toDate;
  String? dsiDistrictCode;
  String? dsiPoliceStationCode;
  DateTime? firFromDate;
  DateTime? firToDate;
  String? dsiFirDistrictCode;
  String? dsiFirPoliceStationCode;
  int? selectedIndex;
  late TabController _tabController;
  bool isFirDetailsVisible = false;
  int currentPage = 0;
  final int itemsPerPage = 2;

  @override
  void initState() {
    super.initState();
    _dateFromController.text = DateFormat('yyyy-MM-dd')
        .format(DateTime.now().subtract(Duration(days: 1)));
    _dateToController.text = DateTime.now().toString().split(' ')[0];
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showListDialog(context);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showListDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) => Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Please Select Anyone to View',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setDialogState(() => selectedIndex = 0);
                            setState(() {}); // Update UI in main screen
                            Navigator.pop(context);
                            _showGraphDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedIndex == 0
                                ? Colors.blue[900]
                                : Colors.grey[300],
                            foregroundColor: selectedIndex == 0
                                ? Colors.white
                                : Colors.black,
                          ),
                          child: const Text('Graphical View'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setDialogState(() => selectedIndex = 1);
                            setState(() {});
                            Navigator.pop(context);
                            _showFirDialog(context); // Update UI in main screen
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedIndex == 1
                                ? Colors.blue[900]
                                : Colors.grey[300],
                            foregroundColor: selectedIndex == 1
                                ? Colors.white
                                : Colors.black,
                          ),
                          child: const Text('FIR Details View'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setDialogState(() => selectedIndex = 2);
                            setState(() {}); // Update UI in main screen
                            // Navigator.pop(context);
                            // _showHeadDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: selectedIndex == 2
                                ? Colors.blue[900]
                                : Colors.grey[300],
                            foregroundColor: selectedIndex == 2
                                ? Colors.white
                                : Colors.black,
                          ),
                          child: const Text('Local Head Count View'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showGraphDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Filter Options',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dateFromController,
                      decoration: InputDecoration(
                        labelText: 'Date Range From',
                        prefixIcon: const Icon(Icons.calendar_month),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      readOnly: true,
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _selectfromDate(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _dateToController,
                      decoration: InputDecoration(
                        labelText: 'Date Range To',
                        prefixIcon: const Icon(Icons.calendar_month),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      readOnly: true,
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _selecttoDate(context);
                      },
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 8),
              // DpPage(
              //   onDistrictSelected: (districtCode) {
              //     setState(() {
              //       dsiDistrictCode = districtCode;
              //     });
              //   },
              //   onPoliceStationSelected: (policeStationCode) {
              //     setState(() {
              //       dsiPoliceStationCode = policeStationCode;
              //     });
              //   },
              // ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isFirDetailsVisible = false; // Show FIR details
                      });
                      Navigator.pop(context);
                      _search();
                    },
                    child: const Text('Search'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFirDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Filter Options',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: firNumController,
                      decoration: InputDecoration(
                        labelText: 'FIR Number',
                        prefixIcon: const Icon(Icons.note),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dateFirFromController,
                      decoration: InputDecoration(
                        labelText: 'Date Range From',
                        prefixIcon: const Icon(Icons.calendar_month),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      readOnly: true,
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _selectfirfromDate(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      controller: _dateFirToController,
                      decoration: InputDecoration(
                        labelText: 'Date Range To',
                        prefixIcon: const Icon(Icons.calendar_month),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      readOnly: true,
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        _selectfirtoDate(context);
                      },
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 8),
              // DpPage(
              //   onDistrictSelected: (districtCode) {
              //     setState(() {
              //       dsiFirDistrictCode = districtCode;
              //     });
              //   },
              //   onPoliceStationSelected: (policeStationCode) {
              //     setState(() {
              //       dsiFirPoliceStationCode = policeStationCode;
              //     });
              //   },
              // ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isFirDetailsVisible = true; // Show FIR details
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Search'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _search() {
    setState(() {
      totalFIR = 42;
      specialCases = 10;
    });
  }

  Widget _buildGraph(String title, List<Map<String, dynamic>> data) {
    int touchedIndex = -1;
    return Scaffold(
      body: Card(
        margin: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 300,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback:
                              (FlTouchEvent event, pieTouchResponse) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -10;
                                return;
                              }
                              touchedIndex = pieTouchResponse
                                  .touchedSection!.touchedSectionIndex;
                            });
                          },
                        ),
                        sectionsSpace: 1,
                        centerSpaceRadius: 0,
                        startDegreeOffset: 180,
                        borderData: FlBorderData(show: false),
                        sections: List.generate(
                          data.length,
                          (i) {
                            final isTouched = i == touchedIndex;
                            final double radius = isTouched ? 150 : 140;
                            final sectionData = data[i];
                            return PieChartSectionData(
                              value: sectionData['value'].toDouble(),
                              title: '${sectionData['value']}',
                              radius: radius,
                              color: sectionData['color'],
                              titleStyle: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(color: Colors.black, blurRadius: 2)
                                ],
                              ),
                              borderSide: isTouched
                                  ? const BorderSide(
                                      color: Colors.white, width: 6)
                                  : BorderSide(color: Colors.transparent),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Header',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('Total Count',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Divider(),
                      ...data.map((section) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: section['color'],
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(
                                      width: 8), // Space between color and text
                                  TextButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(section['label']),
                                            content: Text(
                                                'Details of ${section['label']}'),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text('Close'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text('${section['label']}'),
                                  ),
                                ],
                              ),
                              Text('${section['value']}'),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'DSI Dashboard',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 12, 100, 233),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_sharp, color: Colors.white, size: 30),
            onPressed: () => _showListDialog(context),
          ),
        ],
      ),
      drawer: PolAppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Conditional visibility
            if (isFirDetailsVisible) ...[
              _buildFirDetails(),
              _buildFirList(),
            ] else ...[
              _buildDateRangeSelector(),
            ],
          ],
        ),
      ),
    );
  }

  List<Map<String, String>> firDetailsList = [
    {
      "firNo": "12345",
      "firDate": "2023-01-01",
      "gdNo": "12345110",
      "district": "District A",
      "policeStation": "Police A",
      "ioName": "IO A",
    },
    {
      "firNo": "12346",
      "firDate": "2023-01-02",
      "gdNo": "12346111",
      "district": "District B",
      "policeStation": "Police B",
      "ioName": "IO B",
    },
    {
      "firNo": "12347",
      "firDate": "2023-01-03",
      "gdNo": "12347112",
      "district": "District A",
      "policeStation": "Police A",
      "ioName": "IO A",
    },
    {
      "firNo": "12348",
      "firDate": "2023-01-04",
      "gdNo": "12348113",
      "district": "District A",
      "policeStation": "Police A",
      "ioName": "IO A",
    },
    {
      "firNo": "12349",
      "firDate": "2023-01-05",
      "gdNo": "12349114",
      "district": "District A",
      "policeStation": "Police A",
      "ioName": "IO A",
    },
  ];

  Widget _buildFirDetails() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: firNumController,
                decoration: InputDecoration(
                  labelText: 'FIR Number',
                  prefixIcon: const Icon(Icons.note),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _dateFirFromController,
                decoration: InputDecoration(
                  labelText: 'Date Range From',
                  prefixIcon: const Icon(Icons.calendar_month),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                readOnly: true,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _selectfirfromDate(context);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: _dateFirToController,
                decoration: InputDecoration(
                  labelText: 'Date Range To',
                  prefixIcon: const Icon(Icons.calendar_month),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                readOnly: true,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _selectfirtoDate(context);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isFirDetailsVisible = true;
                  currentPage = 0; // Show FIR details
                });
                Navigator.pop(context);
              },
              child: const Text('Search'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFirList() {
    int startIndex = currentPage * itemsPerPage;
    int endIndex = (startIndex + itemsPerPage).clamp(0, firDetailsList.length);
    List<Map<String, String>> paginatedList =
        firDetailsList.sublist(startIndex, endIndex);

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics:
              NeverScrollableScrollPhysics(), // Prevents internal scrolling
          itemCount: paginatedList.length,
          itemBuilder: (context, index) {
            return buildDsiFirCard(paginatedList[index]);
          },
        ),
        const SizedBox(height: 10),
        _buildPaginationControls(),
      ],
    );
  }

  Widget _buildPaginationControls() {
    int totalPages = (firDetailsList.length / itemsPerPage).ceil();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: currentPage > 0
              ? () {
                  setState(() {
                    currentPage--;
                  });
                }
              : null,
        ),
        Text('Page ${currentPage + 1} of $totalPages'),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: currentPage < totalPages - 1
              ? () {
                  setState(() {
                    currentPage++;
                  });
                }
              : null,
        ),
      ],
    );
  }

  Widget buildDsiFirCard(Map<String, String> dsiFirItem) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Table(
              border: TableBorder.all(color: Colors.black),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(3),
              },
              children: [
                _buildTableRow('FIR No.', dsiFirItem['firNo'] ?? '', 'FIR Date',
                    dsiFirItem['firDate'] ?? ''),
                _buildTableRow('GD No.', dsiFirItem['gdNo'] ?? '', 'GD Date',
                    dsiFirItem['gdDate'] ?? ''),
                _buildTableRow('District', dsiFirItem['district'] ?? '',
                    'Police Station', dsiFirItem['policeStation'] ?? ''),
                _buildTableRow('IO Name', dsiFirItem['ioName'] ?? '',
                    'IO Mobile', dsiFirItem['ioMobile'] ?? ''),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      showComplaintDetailsDialog(context);
                    },
                    child: Text('Complaint Details')),
                const SizedBox(width: 16),
                ElevatedButton(
                    onPressed: () {
                      showActSectionDetailsDialog(context);
                    },
                    child: Text('Fir Act and Section'))
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      showFirContentDetailsDialog(context);
                    },
                    child: Text('Fir Content')),
              ],
            ),
          ],
        ),
      ),
    );
  }


  void showFirContentDetailsDialog(BuildContext context) {
  final Map<String, dynamic> dsiFirItem = {
    'FIR Content': ' GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTestGDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTestGDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTestGDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTestGDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTestGDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTestGDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTestGDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTestGDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTestGDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTestGDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest GDTest',
  };

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'FIR Content:-',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Flexible(
                    child: SingleChildScrollView(
                      child: _buildFirContentTable(dsiFirItem),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildFirContentTable(Map<String, dynamic> dsiFirItem) {
  String content = dsiFirItem['FIR Content']?.toString() ?? 'No Data Available';

  Widget table = Table(
    border: TableBorder.all(color: Colors.black),
    columnWidths: const {0: FlexColumnWidth(1)},
    children: [
      _buildFirContentRow('Content', content),
    ],
  );

  return LayoutBuilder(
    builder: (context, constraints) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: constraints.maxHeight > 600 ? 600 : double.infinity,
        ),
        child: SingleChildScrollView(
          physics: constraints.maxHeight > 600 ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
          child: IntrinsicHeight(
            child: table,
          ),
        ),
      );
    },
  );
}


TableRow _buildFirContentRow(String title, String content) {
  return TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          content,
          textAlign: TextAlign.left,
          softWrap: true,
        ),
      ),
    ],
  );
}

// i need scrollable when table height exceed 800  and if the height is less than 800 it should same height as table and not scrallable

  void showComplaintDetailsDialog(BuildContext context) {
    final Map<String, dynamic> dsiFirItem = {
      'srNo': '001',
      'name': 'John Doe',
      'age': '30',
      'gen': 'Male',
      'rel': 'Father: David Doe',
      'add': '123 Main St, City, Country',
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Complainant Details:-',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    Table(
                      border: TableBorder.all(color: Colors.black),
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(3),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(3),
                      },
                      children: [
                        _buildHeaderRow('Sr.No.', dsiFirItem['srNo'] ?? '',
                            'Name', dsiFirItem['name'] ?? ''),
                        _buildHeaderRow('Age', dsiFirItem['age'] ?? '',
                            'Gender', dsiFirItem['gen'] ?? ''),
                        _buildHeaderRow(
                            'Relative Name',
                            dsiFirItem['rel'] ?? '',
                            'Address',
                            dsiFirItem['add'] ?? ''),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showActSectionDetailsDialog(BuildContext context) {
    final List<Map<String, dynamic>> dsiFirItems = List.generate(
      3, // Change this number to test different row counts
      (index) => {
        'srNo': '${index + 1}',
        'act': 'THE BHARATIYA NYAYA SANHITA (BNS), 2023',
        'section': '${200 + index}',
      },
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // ignore: unused_local_variable
                    double maxHeight = constraints.maxHeight * 0.7;
                    double tableHeight = dsiFirItems.length * 50;
                    bool isScrollable = tableHeight > 500;

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'FIR Act and Section:-',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        isScrollable
                            ? SizedBox(
                                height: 500, // Restrict max height
                                child: SingleChildScrollView(
                                  child: _buildActSectionTable(dsiFirItems),
                                ),
                              )
                            : _buildActSectionTable(
                                dsiFirItems), // Show table without scrolling
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActSectionTable(List<Map<String, dynamic>> dsiFirItems) {
    return Table(
      border: TableBorder.all(color: Colors.black),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(2),
      },
      children: [
        _buildActSectionRow('Sr.No.', 'Act', 'Section'), // Header Row
        for (var item in dsiFirItems)
          _buildActSectionRow(item['srNo'], item['act'], item['section']),
      ],
    );
  }

  TableRow _buildActSectionRow(String srNo, String act, String section) {
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(srNo, textAlign: TextAlign.center),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(act, textAlign: TextAlign.center),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(section, textAlign: TextAlign.center),
      ),
    ]);
  }

  TableRow _buildHeaderRow(
      String key1, String value1, String key2, String value2) {
    return TableRow(
      children: [
        _buildTableCells(key1, isHeader: true),
        _buildTableCells(value1),
        _buildTableCells(key2, isHeader: true),
        _buildTableCells(value2),
      ],
    );
  }

  Widget _buildTableCells(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  TableRow _buildTableRow(
      String label1, String value1, String label2, String value2) {
    return TableRow(children: [
      _buildTableCell(label1, isBold: true),
      _buildTableCell(value1),
      _buildTableCell(label2, isBold: true),
      _buildTableCell(value2),
    ]);
  }

  Widget _buildTableCell(String text, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style:
            TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }

  Widget _buildDateRangeSelector() {
    final graphs = [
      _buildGraph(
        'Total FIR $totalFIR\n(${_dateFromController.text} to ${_dateToController.text})',
        [
          {'label': 'Abetment to Suicide', 'value': 20, 'color': Colors.blue},
          {'label': 'Attempt to Murder', 'value': 30, 'color': Colors.red},
          {'label': 'Murder', 'value': 40, 'color': Colors.green},
          {'label': 'Accident', 'value': 10, 'color': Colors.orange},
          {
            'label': 'Abetment to Suicide',
            'value': 20,
            'color': const Color.fromARGB(255, 240, 243, 33)
          },
          {
            'label': 'Attempt to Murder',
            'value': 30,
            'color': const Color.fromARGB(255, 190, 54, 244)
          },
          {
            'label': 'Murder',
            'value': 40,
            'color': const Color.fromARGB(255, 78, 67, 2)
          },
          {
            'label': 'Accident',
            'value': 10,
            'color': const Color.fromARGB(255, 255, 0, 98)
          },
        ],
      ),
      _buildGraph(
        'Special Cases $specialCases\n(${_dateFromController.text} to ${_dateToController.text})',
        [
          {'label': 'Abetment to Suicide', 'value': 25, 'color': Colors.blue},
          {'label': 'Attempt to Murder', 'value': 35, 'color': Colors.red},
          {'label': 'Murder', 'value': 30, 'color': Colors.green},
          {'label': 'Accident', 'value': 10, 'color': Colors.orange},
        ],
      ),
      _buildGraph(
        'Total FIR\n(Current Year)',
        [
          {'label': 'Abetment to Suicide', 'value': 20, 'color': Colors.blue},
          {'label': 'Attempt to Murder', 'value': 25, 'color': Colors.red},
          {'label': 'Murder', 'value': 45, 'color': Colors.green},
          {'label': 'Accident', 'value': 10, 'color': Colors.orange},
        ],
      ),
      _buildGraph(
        'Special Cases\n(Current Year)',
        [
          {'label': 'Abetment to Suicide', 'value': 15, 'color': Colors.blue},
          {'label': 'Attempt to Murder', 'value': 35, 'color': Colors.red},
          {'label': 'Murder', 'value': 40, 'color': Colors.green},
          {'label': 'Accident', 'value': 10, 'color': Colors.orange},
        ],
      ),
    ];
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: TextFormField(
                controller: _dateFromController,
                decoration: InputDecoration(
                  labelText: 'Date Range From',
                  prefixIcon: const Icon(Icons.calendar_month),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                readOnly: true,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _selectfromDate(context);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: _dateToController,
                decoration: InputDecoration(
                  labelText: 'Date Range To',
                  prefixIcon: const Icon(Icons.calendar_month),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                readOnly: true,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  _selecttoDate(context);
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _search();
              },
              child: const Text('Search'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'Total FIR'),
            Tab(text: 'Special Cases'),
            Tab(text: 'Total FIR'),
            Tab(text: 'Special Cases'),
          ],
        ),
        SizedBox(
          height: 650,
          child: TabBarView(
            controller: _tabController,
            children: graphs,
          ),
        ),
      ],
    );
  }

// i want here this design which i shared in screenshot in tabular form
  Future<void> _selectfromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        fromDate = picked;
        _dateFromController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selecttoDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        toDate = picked;
        _dateToController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectfirfromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        firFromDate = picked;
        _dateFirFromController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectfirtoDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        firToDate = picked;
        _dateFirToController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  DateTime tryParseDate(String dateStr) {
    DateTime? parsedDate;

    try {
      parsedDate = DateFormat('yyyy-MM-dd').parseStrict(dateStr);
    } catch (e) {
      try {
        parsedDate = DateFormat('dd/MM/yyyy').parseStrict(dateStr);
      } catch (e) {
        parsedDate = DateTime(1900, 1, 1);
      }
    }

    return parsedDate;
  }
}
