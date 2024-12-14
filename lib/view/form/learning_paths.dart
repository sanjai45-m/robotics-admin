import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jkv/model/drawers.dart';

import 'edit_training_content.dart';

class TrainingPrograms extends StatefulWidget {
  const TrainingPrograms({super.key});

  @override
  State<TrainingPrograms> createState() => _TrainingProgramsState();
}

class _TrainingProgramsState extends State<TrainingPrograms> {
  // Data placeholders
  String partnerColleges = "Loading...";
  String studentsTrained = "Loading...";
  String workshopsConducted = "Loading...";
  String industryPartners = "Loading...";

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Fetch data from Firebase
  Future<void> _fetchData() async {
    const url =
        "https://snews-8ed67-default-rtdb.asia-southeast1.firebasedatabase.app/numbers.json";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          partnerColleges = data['partnerColleges'] ?? "N/A";
          studentsTrained = data['studentsTrained'] ?? "N/A";
          workshopsConducted = data['workshopsConducted'] ?? "N/A";
          industryPartners = data['industryPartners'] ?? "N/A";
        });
      } else {
        _showError("Failed to load data.");
      }
    } catch (error) {
      _showError("An error occurred: $error");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawers(activePage: "Learning Paths"),
      appBar: AppBar(
        title: const Text(
          "Industry-Leading Training Programs",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCard(
              icon: Icons.school,
              title: "Partner Colleges",
              subtitle: "$partnerColleges+",
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 15),
            _buildCard(
              icon: Icons.group,
              title: "Students Trained",
              subtitle:"$studentsTrained+",
              color: Colors.greenAccent,
            ),
            const SizedBox(height: 15),
            _buildCard(
              icon: Icons.work,
              title: "Workshops Conducted",
              subtitle: "$workshopsConducted+",
              color: Colors.orangeAccent,
            ),
            const SizedBox(height: 15),
            _buildCard(
              icon: Icons.business,
              title: "Industry Partners",
              subtitle: "$industryPartners+",
              color: Colors.pinkAccent,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit_outlined),
        onPressed: () async {
          final bool? updated = await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditTrainingContent(
                partnerColleges: partnerColleges,
                studentsTrained: studentsTrained,
                workshopsConducted: workshopsConducted,
                industryPartners: industryPartners,
              ),
            ),
          );

          if (updated == true) {
            _fetchData(); // Reload data after successful update
          }
        },
      ),

    );
  }

  Widget _buildCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              radius: 25,
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
