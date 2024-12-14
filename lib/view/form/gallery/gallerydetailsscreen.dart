import 'package:flutter/material.dart';
import '../../../controller/galleryService.dart';
import 'add_gallery_item.dart';
import '../../../model/gallery_item.dart';

class GalleryDetailScreen extends StatelessWidget {
  final GalleryItem item;

  const GalleryDetailScreen({required this.item});

  void _deleteItem(BuildContext context) async {
    try {
      await GalleryService.deleteGalleryItem(item.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item deleted successfully')),
      );
      Navigator.pop(context, true); // Return true to refresh the list.
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting item')),
      );
    }
  }

  void _editItem(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddGalleryItemScreen(editItem: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          item.title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(

            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.network(
                      item.imageUrl,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                // Title
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(1, 1),
                        blurRadius: 2,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10.0),
                // Category
                Text(
                  item.category,
                  style: const TextStyle(
                    fontSize: 16.0,
                    // color: Colors.white70,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const Spacer(),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _editItem(context),
                      icon: const Icon(Icons.edit, color: Colors.white),
                      label: const Text("Edit"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        elevation: 5,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _deleteItem(context),
                      icon: const Icon(Icons.delete, color: Colors.white),
                      label: const Text("Delete"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        elevation: 5,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
