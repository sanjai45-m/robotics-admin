import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/gallery_item.dart';

class GalleryService {
  static const String databaseUrl = 'https://snews-8ed67-default-rtdb.asia-southeast1.firebasedatabase.app/gallery';

  /// Fetch gallery items from the Firebase Realtime Database.
  static Stream<List<GalleryItem>> getGalleryItemsStream() {
    final controller = StreamController<List<GalleryItem>>();

    Timer.periodic(const Duration(seconds: 5), (_) async {
      try {
        final response = await http.get(Uri.parse('$databaseUrl.json'));
        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          final items = data.entries
              .map((entry) => GalleryItem.fromJson({...entry.value, 'id': entry.key}))
              .toList();
          controller.add(items);
        } else {
          controller.addError('Failed to fetch gallery items');
        }
      } catch (error) {
        controller.addError('Error fetching data');
      }
    });

    return controller.stream;
  }

  /// Add a new gallery item to the Firebase Realtime Database.
  static Future<void> addGalleryItem(GalleryItem item) async {
    final response = await http.post(
      Uri.parse('$databaseUrl.json'),
      body: json.encode(item.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add gallery item.');
    }
  }

  /// Upload an image to Firebase Storage and return the download URL.
  static Future<String> uploadImage(String filePath) async {
    final fileName = DateTime.now().toIso8601String();
    final ref = FirebaseStorage.instance.ref().child('gallery/$fileName');
    final uploadTask = await ref.putFile(File(filePath));
    return await uploadTask.ref.getDownloadURL();
  }

  /// Delete a gallery item from the Firebase Realtime Database by its ID.
  static Future<void> deleteGalleryItem(String id) async {
    final response = await http.delete(Uri.parse('$databaseUrl/$id.json'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete gallery item.');
    }
  }

  /// Update an existing gallery item in the Firebase Realtime Database.
  static Future<void> updateGalleryItem(GalleryItem updatedItem) async {
    final response = await http.patch(
      Uri.parse('$databaseUrl/${updatedItem.id}.json'),
      body: json.encode(updatedItem.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update gallery item.');
    }
  }
}
