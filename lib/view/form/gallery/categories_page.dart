import 'package:flutter/material.dart';
import '../../../controller/category_service.dart';
import '../../../model/drawers.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _categoryController = TextEditingController();
  Map<String, String> categories = {}; // Initialize as a map instead of a list
  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  // Fetch categories from Firebase
  void _fetchCategories() async {
    try {
      final fetchedCategories = await CategoryService.fetchCategories();
      setState(() {
        categories = fetchedCategories;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load categories')),
      );
    }
  }

  // Add new category
  void _addCategory() async {
    final newCategory = _categoryController.text.trim();
    if (newCategory.isNotEmpty) {
      try {
        await CategoryService.addCategory(newCategory);
        _fetchCategories(); // Reload categories
        _categoryController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Category Added Successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 1),
          ),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to add category')),
        );
      }
    }
  }

  // Delete category
  void _deleteCategory(String id) async {
    try {
      await CategoryService.deleteCategory(id);
      _fetchCategories(); // Reload categories after deletion
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Category Deleted Successfully'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 1),
        ),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete category')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawers(activePage: "Categories page",),
      appBar: AppBar(
        title: const Text('Manage Categories'),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Animated Input Field with transition
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: TextField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  labelStyle: const TextStyle(color: Colors.deepPurpleAccent),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
            ),

            // Add Category Button with transition animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _addCategory,
                child: const Text(
                  'Add Category',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Display categories with slide transition
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  String id = categories.keys.elementAt(index);
                  String name = categories.values.elementAt(index);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: Colors.deepPurple[50],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Text(
                          name,
                          style: const TextStyle(fontSize: 18, color: Colors.deepPurple),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteCategory(id),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _addCategory,
      //   backgroundColor: Colors.deepPurpleAccent,
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
