import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:himcops/master/sdp.dart';
import 'package:intl/intl.dart';

class DSIMobileHomePage extends StatefulWidget {
  const DSIMobileHomePage({super.key});

  @override
  State<DSIMobileHomePage> createState() => _DSIMobileHomePageState();
}

class _DSIMobileHomePageState extends State<DSIMobileHomePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _dateFromController = TextEditingController();
  final TextEditingController _dateToController = TextEditingController();
  final String district = "Sample District";
  final String policeStation = "Sample PS";
  int totalFIR = 0;
  int specialCases = 0;
  DateTime? fromDate;
  DateTime? toDate;
  String? dsiDistrictCode;
  String? dsiPoliceStationCode;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _dateFromController.text = DateTime.now().toString().split(' ')[0];
    _dateToController.text = DateTime.now().toString().split(' ')[0];
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showFilterDialog(context);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showFilterDialog(BuildContext context) {
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
              const SizedBox(height: 8),
              DpPage(
                onDistrictSelected: (districtCode) {
                  setState(() {
                    dsiDistrictCode = districtCode;
                  });
                },
                onPoliceStationSelected: (policeStationCode) {
                  setState(() {
                    dsiPoliceStationCode = policeStationCode;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
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

  void _search() {
    setState(() {
      totalFIR = 42;
      specialCases = 10;
    });
  }

  Widget _buildViewportCard(String title, String subtitle, int count) {
    return InkWell(
      onTap: () {
        _showDetailsDialog(context);
      },
      child: Container(
        width: 150,
        height: 150,
        child: Card(
          elevation: 5,
          margin: const EdgeInsets.all(5),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(subtitle,
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center),
                const SizedBox(height: 10),
                Text(
                  '$count',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
                              title: '${sectionData['value']}%',
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: data.map((section) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                    child: Text(
                      '${section['label']}: ${section['value']}%',
                      style: TextStyle(
                          fontSize: 14,
                          color: section['color'],
                          fontWeight: FontWeight.bold),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement your download logic here
        },
        backgroundColor: Colors.indigo[300],
        child: const Icon(Icons.download, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }

  @override
  Widget build(BuildContext context) {
    final graphs = [
      _buildGraph(
        'Total FIR\n(${_dateFromController.text} to ${_dateToController.text})',
        [
          {'label': 'Abetment to Suicide', 'value': 20, 'color': Colors.blue},
          {'label': 'Attempt to Murder', 'value': 30, 'color': Colors.red},
          {'label': 'Murder', 'value': 40, 'color': Colors.green},
          {'label': 'Accident', 'value': 10, 'color': Colors.orange},
        ],
      ),
      _buildGraph(
        'Special Cases\n(${_dateFromController.text} to ${_dateToController.text})',
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
            icon: const Icon(Icons.filter_alt, color: Colors.white),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: _buildViewportCard(
                    'Total FIR',
                    '(${_dateFromController.text} to\n${_dateToController.text})',
                    totalFIR,
                  ),
                ),
                Expanded(
                  child: _buildViewportCard(
                    'Special Cases',
                    '(${_dateFromController.text} to\n${_dateToController.text})',
                    specialCases,
                  ),
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
        ),
      ),
    );
  }

  void _showDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Details View',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailText('FIR No:', '12345'),
                      const SizedBox(height: 8),
                      _buildDetailText('Act/Section:', 'IPC 123'),
                      const SizedBox(height: 8),
                      _buildDetailText('Name of Complainant:', 'John wick'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close current dialog
                          _showBriefFactDialog(
                              context); // Show brief fact dialog
                        },
                        child: const Text('View More Details'),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailText('FIR No:', '12346'),
                      const SizedBox(height: 8),
                      _buildDetailText('Act/Section:', 'IPC 123'),
                      const SizedBox(height: 8),
                      _buildDetailText(
                          'Name of Complainant:', 'merry christmas'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close current dialog
                          _showBriefFactDialog(
                              context); // Show brief fact dialog
                        },
                        child: const Text('View More Details'),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailText('FIR No:', '12347'),
                      const SizedBox(height: 8),
                      _buildDetailText('Act/Section:', 'IPC 123'),
                      const SizedBox(height: 8),
                      _buildDetailText('Name of Complainant:', 'Piyush Sharma'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close current dialog
                          _showBriefFactDialog(
                              context); // Show brief fact dialog
                        },
                        child: const Text('View More Details'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DSIMobileHomePage(),
                    ),
                  );
                },
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailText(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(color: Colors.black87),
          ),
        ),
      ],
    );
  }

  void _showBriefFactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Brief Fact Details'),
        content: const Text('Full details of the brief fact.'),
        actions: [
          Row(
            children: [
              TextButton(
                onPressed: () => _showDetailsDialog(context),
                child: const Text('Ok'),
              ),
              SizedBox(width: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
