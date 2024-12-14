import 'package:flutter/material.dart';
import '../controller/category_service.dart';
class CategoryDropdown extends StatefulWidget {
  final String? selectedCategory;
  final ValueChanged<String?> onChanged;

  CategoryDropdown({required this.selectedCategory, required this.onChanged});

  @override
  _CategoryDropdownState createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  late Future<Map<String, String>> categoriesFuture;

  @override
  void initState() {
    super.initState();
    categoriesFuture = CategoryService.fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('Error loading categories');
        }
        final categories = snapshot.data ?? {};
        return DropdownButtonFormField<String>(
          value: widget.selectedCategory,
          items: categories.values.map((category) {
            return DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            labelText: 'Category',
            labelStyle: TextStyle(color: Colors.deepPurple),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }
}
