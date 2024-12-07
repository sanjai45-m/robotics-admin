import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:jkv/controller/workshop_data.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class AddWorkShop extends StatefulWidget {
  const AddWorkShop({super.key});

  @override
  State<AddWorkShop> createState() => _AddWorkShopState();
}

class _AddWorkShopState extends State<AddWorkShop> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final dataController = TextEditingController();
  final workShopController = TextEditingController();
  final collegeNameController = TextEditingController();
  File? _image;


  @override
  void dispose() {
    dataController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickDate != null) {
      final formattedTime = "${pickDate.year}-${pickDate.month.toString().padLeft(2, '0')}-${pickDate.day.toString().padLeft(2, '0')}";
      setState(() {
        dataController.text = formattedTime; // Correctly formatted date
      });
    }
  }
  Future<void> _pickImage() async {
    ImagePicker imagePicker =  ImagePicker();
    final pickImage = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickImage != null) {
      setState(() {
        _image = File(pickImage.path);
      });
    }
  }

  void onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<WorkshopDataProvider>(context, listen: false);

      // Parse the date string to DateTime
      final parsedDate = DateTime.tryParse(dataController.text);
      if (parsedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid date format. Please choose a valid date.")),
        );
        return;
      }

      // Check if an image is selected
      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select an image.")),
        );
        return;
      }

      try {
        // Upload image to Firebase Storage and get URL
        final imageUrl = await uploadImageToFirebase(_image!);

        // Add workshop data with the image URL
        provider.sendWorkshopDataToFirebase(
          parsedDate,
          workShopController.text,
          collegeNameController.text,
          dataController.text,
          imageUrl,
        );

        // Reload workshops data to ensure it is updated
        await provider.fetchWorkshopsFromFirebase();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Workshop created successfully")),
        );

        _resetForm();
        Navigator.of(context).pop(); // Go back to the previous page
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to create workshop: $error")),
        );
      }
    }
  }



  _resetForm() {
    dataController.clear();
    workShopController.clear();
    collegeNameController.clear();
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
          title: const Text("Create a Workshop"),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Add padding around the form
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Workshop Name",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(
                    height: 8), // Add space between text and input field
                TextFormField(
                  controller: workShopController,
                  decoration: InputDecoration(
                    hintText: 'Enter the workshop name',
                    filled: true,
                    fillColor:
                        Colors.grey[200], // Light background for the input
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter the Workshop Name";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16), // Add spacing between fields
                const Text(
                  "College Name",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: collegeNameController,
                  decoration: InputDecoration(
                    hintText: 'Enter the college name',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter the College Name";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  "Date",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: dataController,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.date_range),
                    hintText: 'Enter the date',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Choose Date";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  "Upload Image",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                // Button to pick image
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text("Pick Image"),
                ),
                const SizedBox(height: 8),
                // Display image preview if selected
                if (_image != null)
                  Image.file(
                    _image!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(height: 24), // Add spacing before the button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      onSubmit();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text(
                      "Add Workshop",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
