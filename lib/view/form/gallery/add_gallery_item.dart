import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../controller/category_service.dart';
import '../../../controller/galleryService.dart';
import '../../../model/gallery_item.dart';

class AddGalleryItemScreen extends StatefulWidget {
  final GalleryItem? editItem;

  const AddGalleryItemScreen({this.editItem});

  @override
  _AddGalleryItemScreenState createState() => _AddGalleryItemScreenState();
}

class _AddGalleryItemScreenState extends State<AddGalleryItemScreen> {
  final _titleController = TextEditingController();
  String? _selectedCategory;
  String? _imagePath;
  bool loading = false; // New variable to track loading state

  Map<String, String> categories = {}; // Initialize as a map instead of a list

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    if (widget.editItem != null) {
      _titleController.text = widget.editItem!.title;
      _selectedCategory = widget.editItem!.category;
      _imagePath = widget.editItem!.imageUrl;
    }
  }

  // Fetch categories from Firebase
  Future<void> _fetchCategories() async {
    try {
      final fetchedCategories = await CategoryService.fetchCategories();
      setState(() {
        categories = fetchedCategories; // Ensure this is a Map<String, String>
        // Ensure _selectedCategory is valid
        if (widget.editItem != null && widget.editItem!.category.isNotEmpty) {
          if (!categories.containsValue(widget.editItem!.category)) {
            _selectedCategory = categories.keys.first; // Fallback to first category
          } else {
            _selectedCategory = categories.entries
                .firstWhere((entry) => entry.value == widget.editItem!.category)
                .key; // Match category name to key
          }
        } else {
          _selectedCategory = categories.keys.isNotEmpty ? categories.keys.first : null; // Fallback to first category key
        }
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load categories')),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  Future<void> _saveItem() async {
    if (_titleController.text.isNotEmpty &&
        _selectedCategory != null &&
        _imagePath != null) {
      setState(() {
        loading = true; // Start loading
      });

      try {
        final imageUrl = await GalleryService.uploadImage(_imagePath!);
        final selectedCategoryName = categories[_selectedCategory!];

        if (selectedCategoryName == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid category selected.')),
          );
          setState(() {
            loading = false; // Stop loading
          });
          return;
        }

        if (widget.editItem != null) {
          final updatedItem = GalleryItem(
            id: widget.editItem!.id,
            imageUrl: imageUrl,
            title: _titleController.text,
            category: selectedCategoryName,
          );
          await GalleryService.updateGalleryItem(updatedItem);
        } else {
          final newItem = GalleryItem(
            id: DateTime.now().toString(),
            imageUrl: imageUrl,
            title: _titleController.text,
            category: selectedCategoryName,
          );
          await GalleryService.addGalleryItem(newItem);
        }

        setState(() {
          loading = false; // Stop loading
        });

        Navigator.pop(context, true); // Pass true to indicate refresh
      } catch (error) {
        setState(() {
          loading = false; // Stop loading
        });
        print(error);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save item.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Gallery Item'),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 4.0,
      ),
      body:  Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add New Item',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: 'Title',
                              labelStyle: const TextStyle(color: Colors.deepPurple),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          if (categories.isNotEmpty)
                            DropdownButtonFormField<String>(
                              value: _selectedCategory,
                              items: categories.entries.map((entry) {
                                return DropdownMenuItem<String>(
                                  value: entry.key,
                                  child: Text(entry.value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategory = value;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'Category',
                                labelStyle: const TextStyle(color: Colors.deepPurple),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _pickImage,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Colors.deepPurpleAccent,
                              elevation: 4.0,
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.camera_alt, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  'Pick an Image',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          if (_imagePath != null) ...[
                            const SizedBox(height: 16),
                            _imagePath!.startsWith('http')
                                ? Image.network(_imagePath!)
                                : Image.file(File(_imagePath!)),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: _saveItem,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        widget.editItem != null ? 'Update Item' : 'Add Item',
                        style: const TextStyle(fontSize: 18,color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (loading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
