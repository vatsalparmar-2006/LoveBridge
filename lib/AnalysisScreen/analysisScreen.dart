import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../API/apiServices.dart';
import '../utils/constant.dart';

class AnalysisChartScreen extends StatefulWidget {
  const AnalysisChartScreen({super.key});

  @override
  State<AnalysisChartScreen> createState() => _AnalysisChartScreenState();
}

class _AnalysisChartScreenState extends State<AnalysisChartScreen> {
  List<Map<String, dynamic>> _users = [];
  int totalMembers = 0;

  final List<Color> _chartColors = [
    Colors.pinkAccent,
    Colors.purpleAccent,
    Colors.blueAccent,
    Colors.tealAccent,
    Colors.orangeAccent,
    Colors.greenAccent,
    Colors.redAccent,
  ];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    ApiService apiService = ApiService();
    List<dynamic> apiUsers = await apiService.getUsers();
    List<Map<String, dynamic>> users =
    apiUsers.map((user) => Map<String, dynamic>.from(user)).toList();

    setState(() {
      _users = users;
      totalMembers = users.length;
    });
  }

  Map<String, int> _getCityDistribution() {
    Map<String, int> cityCounts = {
      'Rajkot': 0,
      'Ahmedabad': 0,
      'Mumbai': 0,
      'Delhi': 0,
      'Kolkata': 0,
    };

    for (var user in _users) {
      String city = user[CITY] ?? 'Other';
      if (cityCounts.containsKey(city)) {
        cityCounts[city] = cityCounts[city]! + 1;
      }
    }
    return cityCounts;
  }

  Map<String, int> _getReligionDistribution() {
    Map<String, int> religionCounts = {};
    for (var user in _users) {
      String religion = user[RELIGION] ?? 'Other';
      religionCounts.update(religion, (value) => value + 1, ifAbsent: () => 1);
    }
    return religionCounts;
  }

  Widget _buildCityPieChart() {
    final cityData = _getCityDistribution();
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('City Distribution',
                style: TextStyle(fontSize: 18, color: Colors.pinkAccent, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: cityData.entries.map((entry) {
                    return PieChartSectionData(
                      color: _chartColors[cityData.keys.toList().indexOf(entry.key) % _chartColors.length],
                      value: entry.value.toDouble(),
                      title: '${entry.key}\n${entry.value}',
                      radius: 60,
                      titleStyle: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                    );
                  }).toList(),
                  centerSpaceRadius: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReligionPieChart() {
    final religionData = _getReligionDistribution();
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Religion Distribution',
                style: TextStyle(fontSize: 18, color: Colors.pinkAccent, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: religionData.entries.map((entry) {
                    return PieChartSectionData(
                      color: _chartColors[religionData.keys.toList().indexOf(entry.key) % _chartColors.length],
                      value: entry.value.toDouble(),
                      title: '${entry.key}\n${entry.value}',
                      radius: 60,
                      titleStyle: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                    );
                  }).toList(),
                  centerSpaceRadius: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Analytics',
            style: TextStyle(fontSize: 24, color: Colors.pink.shade800, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.pink.shade100, Colors.purple.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: _users.isEmpty
            ? Center(child: CircularProgressIndicator(color: Colors.pinkAccent))
            : ListView(
          padding: EdgeInsets.all(16),
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Total Members',
                        style: TextStyle(fontSize: 18, color: Colors.pinkAccent, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text('$totalMembers',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.purple)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildCityPieChart(),
            SizedBox(height: 20),
            _buildReligionPieChart(),
          ],
        ),
      ),
    );
  }
}
