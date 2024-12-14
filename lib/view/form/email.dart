import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jkv/model/drawers.dart';
import 'package:jkv/view/form/mail-content-form.dart';
import 'package:http/http.dart' as http;

class EmailData extends StatefulWidget {
  const EmailData({super.key});

  @override
  State<EmailData> createState() => _EmailDataState();
}

class _EmailDataState extends State<EmailData> {
  String serviceId = "Loading...";
  String templateId = "Loading...";
  String api_key = "Loading...";

  Future<void> _fetchData() async {
    const url =
        "https://snews-8ed67-default-rtdb.asia-southeast1.firebasedatabase.app/mails.json";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          serviceId = data['serviceId'] ?? "N/A";
          templateId = data['emailTemplate'] ?? "N/A";
          api_key = data['api-key'] ?? "N/A";
        });
      } else {
        _showError("Failed to load data.");
      }
    } catch (error) {
      _showError("An error occurred: $error");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawers(activePage: "Email"),
      appBar: AppBar(
        title: const Text("Email"),
      ),
      body: Column(
        children: [
          _buildCard(
              icon: Icons.design_services,
              title: "Service Id",
              subtitle: serviceId,
              color: Colors.redAccent),
          _buildCard(
              icon: Icons.sd_card_alert,
              title: "Templete Id",
              subtitle: templateId,
              color: Colors.blue),
          _buildCard(
              icon: Icons.key_outlined,
              title: "Api-Key",
              subtitle: api_key,
              color: Colors.green),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MailForm(
                serviceId: serviceId, templateId: templateId, apiKey: api_key),
          ));
        },
        icon: const Icon(Icons.edit_outlined),
        label: const Text("Edit Data"),
      ),
    );
  }
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
