import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/gallery_item.dart';

class CategoryService {
  static const String url = 'https://snews-8ed67-default-rtdb.asia-southeast1.firebasedatabase.app/categories.json';

  // Fetch categories from Firebase
  // In CategoryService:
  // Modify the fetchCategories method in CategoryService to return a Map<String, String>
  static Future<Map<String, String>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        Map<String, String> categories = {};
        data.forEach((key, value) {
          categories[key] = value['category']; // Store ID as key
        });
        return categories;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (error) {
      throw Exception('Failed to load categories: $error');
    }
  }


  // Add category to Firebase
  static Future<void> addCategory(String category) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'category': category,
        }),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to add category');
      }
    } catch (error) {
      throw Exception('Failed to add category: $error');
    }
  }
  static Future<void> updateGalleryItem(GalleryItem item) async {
    try {
      final response = await http.put(
        Uri.parse('$url/${item.id}.json'), // Use the specific item ID
        body: json.encode({
          'title': item.title,
          'category': item.category,
          'imageUrl': item.imageUrl,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update gallery item');
      }
    } catch (error) {
      throw Exception('Failed to update gallery item: $error');
    }
  }

  // Delete category from Firebase
  static Future<void> deleteCategory(String id) async {
    try {
      final deleteUrl = 'https://snews-8ed67-default-rtdb.asia-southeast1.firebasedatabase.app/categories/$id.json';
      final response = await http.delete(Uri.parse(deleteUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to delete category');
      }
    } catch (error) {
      throw Exception('Failed to delete category: $error');
    }
  }
}
