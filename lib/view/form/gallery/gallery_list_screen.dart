import 'package:flutter/material.dart';
import '../../../controller/galleryService.dart';
import '../../../model/drawers.dart';
import 'add_gallery_item.dart';
import '../../../model/gallery_item.dart';
import 'gallerydetailsscreen.dart';

class GalleryListScreen extends StatefulWidget {
  @override
  _GalleryListScreenState createState() => _GalleryListScreenState();
}

class _GalleryListScreenState extends State<GalleryListScreen> {
  late Stream<List<GalleryItem>> _galleryItemsStream;

  @override
  void initState() {
    super.initState();
    _galleryItemsStream = GalleryService.getGalleryItemsStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawers(activePage: "Gallery"),
      appBar: AppBar(
        title: const Text(
          'Gallery',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 4.0,
      ),
      body: StreamBuilder<List<GalleryItem>>(
        stream: _galleryItemsStream,
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
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
        onPressed: () async {
          final refresh = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddGalleryItemScreen()),
          );
          if (refresh == true) {
            setState(() {
              // Simply reload the stream to update the gallery
              _galleryItemsStream = GalleryService.getGalleryItemsStream();
            });
          }
        },
        backgroundColor: Colors.deepPurpleAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
