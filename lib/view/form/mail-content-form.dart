import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MailForm extends StatefulWidget {
  final String serviceId;
  final String templateId;
  final String apiKey;

  const MailForm(
      {super.key,
      required this.serviceId,
      required this.templateId,
      required this.apiKey});

  @override
  State<MailForm> createState() => _MailFormState();
}

class _MailFormState extends State<MailForm> {



  final _formKey = GlobalKey<FormState>(); // Form key for validation
  late  TextEditingController _serviceIdController = TextEditingController();
  late TextEditingController _emailTemplateController =
      TextEditingController();
  late TextEditingController _apiController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _serviceIdController =TextEditingController(text: widget.serviceId);
    _emailTemplateController = TextEditingController(text: widget.templateId);
    _apiController = TextEditingController(text: widget.apiKey);
  }
  Future<void> _updateData() async {
    const url =
        "https://snews-8ed67-default-rtdb.asia-southeast1.firebasedatabase.app/mails.json";

    final Map<String, String> data = {
      "serviceId": _serviceIdController.text,
      "emailTemplate": _emailTemplateController.text,
      "api-key": _apiController.text,
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
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Mail Configuration",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A8CAF), Color(0xFFD8E3E7)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Form Content
          SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 70.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      elevation: 6.0,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _formFieldLabel("Service ID"),
                            _textFormField(
                              hintText: "Enter Service ID",
                              controller: _serviceIdController,
                              icon: Icons.design_services,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Service ID is required";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            _formFieldLabel("Template ID"),
                            _textFormField(
                              hintText: "Enter Template ID",
                              controller: _emailTemplateController,
                              icon: Icons.sd_card_alert,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Template ID is required";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            _formFieldLabel("API Key"),
                            _textFormField(
                              hintText: "Enter API Key",
                              controller: _apiController,
                              icon: Icons.key,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "API Key is required";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // Floating Save Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            // If form is valid, proceed with saving
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Form is valid! Saving...")),
            );
            _updateData();
          }
        },
        icon: const Icon(Icons.save),
        label: const Text("Save"),
        backgroundColor: const Color(0xFF6A8CAF),
      ),
    );
  }

  Widget _formFieldLabel(String labelText) {
    return Text(
      labelText,
      style: const TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _textFormField({
    required String hintText,
    required TextEditingController controller,
    required IconData icon,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon,color: Colors.black87,),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: const BorderSide( width: 1.5),
        ),
      ),
      style: const TextStyle(fontSize: 14.0,color: Colors.black),
    );
  }
}
