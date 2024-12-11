import 'package:flutter/material.dart';
import '../../../model/galleryService.dart';
import 'add_gallery_item.dart';
import 'gallery_item.dart';
import 'gallerydetailsscreen.dart';

class GalleryListScreen extends StatefulWidget {
  @override
  _GalleryListScreenState createState() => _GalleryListScreenState();
}

class _GalleryListScreenState extends State<GalleryListScreen> {
  late Future<List<GalleryItem>> _galleryItems;

  @override
  void initState() {
    super.initState();
    _galleryItems = GalleryService.fetchGalleryItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gallery',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 4.0,
      ),
      body: FutureBuilder<List<GalleryItem>>(
        future: _galleryItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'No Gallery Items',
                style: TextStyle(fontSize: 16, color: Colors.redAccent),
              ),
            );
          } else {
            final items = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: 0.8,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GalleryDetailScreen(item: item),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 6.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16.0),
                          ),
                          child: Image.network(
                            item.imageUrl,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                item.category,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddGalleryItemScreen()),
          );
        },
        backgroundColor: Colors.deepPurpleAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
