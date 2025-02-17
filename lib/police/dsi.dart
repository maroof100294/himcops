import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:himcops/drawer/pdrawer.dart';
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
  int totalFIR = 0;
  int specialCases = 0;
  DateTime? fromDate;
  DateTime? toDate;
  String? dsiDistrictCode;
  String? dsiPoliceStationCode;
  int? selectedIndex;
  late TabController _tabController;

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
                            _showFilterDialog(context);
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
                            setState(() {}); // Update UI in main screen
                            // Navigator.pop(context);
                            // _showFirDialog(context);
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
              // Wrap this in a scrollable widget
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
                      }).toList(),
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
        ),
      ),
    );
  }

// when user click on button in _showListDialog it is getting blue but when user click on icon button in appbar it is opening the _showListDialog but the active button is not showing dark blue button
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
