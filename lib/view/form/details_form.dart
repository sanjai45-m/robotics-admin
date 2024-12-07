import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../controller/workshop_data.dart';
import '../../model/workshop_template.dart'; // Add this package

class DetailsForm extends StatefulWidget {
  final DateTime id;
  final AboutWorkshopDetails? existingDetails;

  const DetailsForm({super.key, required this.id, this.existingDetails});

  @override
  State<DetailsForm> createState() => _DetailsFormState();
}

class _DetailsFormState extends State<DetailsForm> {
  late TextEditingController _descriptionController;
  late TextEditingController _objectiveController;
  late TextEditingController _impactStudentsController;
  late TextEditingController _impactIndustryController;
  late TextEditingController _impactResearchController;

  final List<String> _outcomes = [];
  final List<String> _futureScope = [];
  final TextEditingController _outcomeController = TextEditingController();
  final TextEditingController _futureScopeController = TextEditingController();
  final List<String> _technologiesUsed = [];
  final TextEditingController _technologiesUsedCOntroller = TextEditingController();
  List<File> _selectedImages = []; // Store File objects

  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.existingDetails?.description ?? '');
    _objectiveController =
        TextEditingController(text: widget.existingDetails?.objective ?? '');
    _impactStudentsController = TextEditingController(
        text: widget.existingDetails?.impact.students ?? '');
    _impactIndustryController = TextEditingController(
        text: widget.existingDetails?.impact.industry ?? '');
    _impactResearchController = TextEditingController(
        text: widget.existingDetails?.impact.research ?? '');
    if (widget.existingDetails != null) {
      _outcomes.addAll(widget.existingDetails!.outcomes);
      _futureScope.addAll(widget.existingDetails!.futureScope);

    }
  }

  Future<void> _selectImages() async {
    final ImagePicker picker = ImagePicker();
    List<XFile>? pickedImages = await picker.pickMultiImage(); // Native multi-image selection in image_picker

    if (pickedImages.isNotEmpty) {
      setState(() {
        // Convert XFile to File
        _selectedImages = pickedImages.map((image) => File(image.path)).toList();
      });
    }
  }

  Future<String> uploadImageToFirebase(File image) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('workshop_images/${DateTime.now().toIso8601String()}.jpg');

      final uploadTask = storageRef.putFile(image);
      final snapshot = await uploadTask.whenComplete(() {});

      // Get the download URL of the uploaded image
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (error) {
      throw Exception("Image upload failed: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingDetails == null
            ? "Add Workshop Details"
            : "Edit Workshop Details"),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCard(
              title: "Description",
              icon: Icons.description,
              child: TextField(
                maxLines: 10,
                controller: _descriptionController,
                decoration: _inputDecoration("Enter workshop description"),
              ),
            ),
            _buildCard(
              title: "Objective",
              icon: Icons.flag,
              child: TextField(
                maxLines: 10,
                controller: _objectiveController,
                decoration: _inputDecoration("Enter workshop objective"),
              ),
            ),
            _buildCard(
              title: "Impact",
              icon: Icons.deck_rounded,
              child: Column(
                children: [
                  TextField(
                    maxLines: 10,
                    controller: _impactStudentsController,
                    decoration: _inputDecoration("Impact on Students"),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    maxLines: 10,
                    controller: _impactIndustryController,
                    decoration: _inputDecoration("Impact on Industry"),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    maxLines: 10,
                    controller: _impactResearchController,
                    decoration: _inputDecoration("Impact on Research"),
                  ),
                ],
              ),
            ),
            _buildCard(
              title: "Images",
              icon: Icons.image,
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _selectImages,
                    child: const Text("Select Images"),
                  ),
                  const SizedBox(height: 10),
                  _selectedImages.isEmpty
                      ? const Text("No images selected")
                      : Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _selectedImages.asMap().entries.map((entry) {
                      final index = entry.key;
                      final image = entry.value;

                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                image,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: -8,
                            right: -8,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedImages.removeAt(index);
                                });
                              },
                              child: const CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.red,
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            _buildListAdder(
              "Technologies Used",
              _technologiesUsed,
              _technologiesUsedCOntroller,
              Icons.lightbulb,
            ),
            _buildListAdder(
              "Outcomes",
              _outcomes,
              _outcomeController,
              Icons.check_circle,
            ),
            _buildListAdder(
              "Future Scope",
              _futureScope,
              _futureScopeController,
              Icons.lightbulb,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _saveDetails,
              child: Text(
                widget.existingDetails == null ? "Add Details" : "Save Changes",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  Widget _buildListAdder(
      String label,
      List<String> list,
      TextEditingController controller,
      IconData icon,
      ) {
    return _buildCard(
      title: label,
      icon: icon,
      child: Column(
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "Add $label",
              hintStyle: const TextStyle(color: Colors.grey),
              contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              filled: true,
              fillColor: Colors.teal.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.add, color: Colors.teal),
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    setState(() {
                      list.add(controller.text);
                      controller.clear();
                    });
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 10,
            children: list
                .asMap()
                .entries
                .map((entry) {
              int index = entry.key;
              String item = entry.value;
              return Chip(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                label: Text(
                  item,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.teal.shade200,
                deleteIcon: const Icon(Icons.delete, color: Colors.red),
                onDeleted: () {
                  setState(() {
                    list.removeAt(index);
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            })
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.teal),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }

  Future<void> _saveDetails() async {
    if (_descriptionController.text.isEmpty ||
        _objectiveController.text.isEmpty ||
        _impactStudentsController.text.isEmpty ||
        _impactIndustryController.text.isEmpty ||
        _impactResearchController.text.isEmpty) {
      return;
    }

    final List<String> imageUrls = [];

    // Upload all images
    for (File image in _selectedImages) {
      try {
        String url = await uploadImageToFirebase(image);
        imageUrls.add(url);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Image upload failed: $error")),
        );
        return;
      }
    }

    final workshopDetails = AboutWorkshopDetails(
      description: _descriptionController.text,
      objective: _objectiveController.text,
      impact: Impact(
        students: _impactStudentsController.text,
        industry: _impactIndustryController.text,
        research: _impactResearchController.text,
      ),
      outcomes: _outcomes,
      futureScope: _futureScope,
      technologiesUsed: _technologiesUsed,
      images: imageUrls,
    );

    // Access the data provider
    final workshopDataProvider = Provider.of<WorkshopDataProvider>(context, listen: false);

    // Check if it's an existing workshop or new workshop
    if (widget.existingDetails != null) {
      // Edit existing workshop
      workshopDataProvider.updateWorkshopDetailsInFirebase(widget.id, workshopDetails);
    } else {
      // Add new workshop
      workshopDataProvider.addWorkshopDetails(widget.id, workshopDetails);
    }

    // Send the updated data to Firebase
    final workshop = workshopDataProvider.workshopModel.firstWhere((w) => w.id == widget.id);
    await workshopDataProvider.sendWorkshopToFirebase(workshop);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Details saved successfully")),
    );

    Navigator.pop(context);
  }




}
