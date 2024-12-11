import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditTrainingContent extends StatefulWidget {
  final String partnerColleges;
  final String studentsTrained;
  final String workshopsConducted;
  final String industryPartners;

  const EditTrainingContent({
    super.key,
    required this.partnerColleges,
    required this.studentsTrained,
    required this.workshopsConducted,
    required this.industryPartners,
  });

  @override
  State<EditTrainingContent> createState() => _EditTrainingContentState();
}

class _EditTrainingContentState extends State<EditTrainingContent> {
  late TextEditingController _partnerCollegesController;
  late TextEditingController _studentsTrainedController;
  late TextEditingController _workshopsConductedController;
  late TextEditingController _industryPartnersController;

  @override
  void initState() {
    super.initState();
    _partnerCollegesController =
        TextEditingController(text: widget.partnerColleges);
    _studentsTrainedController =
        TextEditingController(text: widget.studentsTrained);
    _workshopsConductedController =
        TextEditingController(text: widget.workshopsConducted);
    _industryPartnersController =
        TextEditingController(text: widget.industryPartners);
  }

  Future<void> _updateData() async {
    const url =
        "https://snews-8ed67-default-rtdb.asia-southeast1.firebasedatabase.app/numbers.json";

    final Map<String, String> data = {
      "partnerColleges": _partnerCollegesController.text,
      "studentsTrained": _studentsTrainedController.text,
      "workshopsConducted": _workshopsConductedController.text,
      "industryPartners": _industryPartnersController.text,
    };

    try {
      final response = await http.patch(
        Uri.parse(url),
        body: json.encode(data),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data updated successfully!")),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update data.")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Training Content",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildInputField(
              title: "Partner Colleges",
              controller: _partnerCollegesController,
              icon: Icons.school_rounded,
              color: Colors.deepPurple,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              title: "Students Trained",
              controller: _studentsTrainedController,
              icon: Icons.group_rounded,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              title: "Workshops Conducted",
              controller: _workshopsConductedController,
              icon: Icons.event,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              title: "Industry Partners",
              controller: _industryPartnersController,
              icon: Icons.business,
              color: Colors.orange,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _updateData,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                backgroundColor: Colors.pinkAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                elevation: 10,
              ),
              child: const Text(
                "Submit",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String title,
    required TextEditingController controller,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.2), Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: color.withOpacity(0.2),
                  child: Icon(icon, color: color, size: 30),
                ),
                const SizedBox(width: 15),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Enter $title",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              textInputAction: TextInputAction.next,
            ),
          ],
        ),
      ),
    );
  }
}
