import 'package:flutter/material.dart';
import 'package:jkv/model/drawers.dart';
import 'package:jkv/view/form/event_form.dart';
import 'package:jkv/controller/workshop_data.dart';
import 'package:provider/provider.dart';
import '../../controller/category_service.dart';
import 'details_page.dart';

class WorkShops extends StatefulWidget {
  const WorkShops({super.key});

  @override
  State<WorkShops> createState() => _WorkShopsState();
}

class _WorkShopsState extends State<WorkShops> {
  late WorkshopDataProvider workshopDataProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWorkshops();
    });
  }

  Future<void> _loadWorkshops() async {
    await workshopDataProvider.fetchWorkshopsFromFirebase();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    workshopDataProvider =
        Provider.of<WorkshopDataProvider>(context, listen: false);
  }

  Future<void> _deleteWorkshop(String id) async {
    try {
      workshopDataProvider.deleteEvent(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Workshop deleted successfully")),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete workshop: $error")),
      );
    }
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Deletion"),
        content: const Text("Are you sure you want to delete this workshop?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteWorkshop(id);
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadowColor: Colors.redAccent,
              elevation: 8,
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.delete, size: 18),
                SizedBox(width: 8),
                Text("Delete", style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawers(activePage: "Home",),
      appBar: AppBar(
        title: const Text("WorkShops",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.deepPurpleAccent,
        centerTitle: true,
        elevation: 4,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const AddWorkShop(),
          ));
        },
        backgroundColor: Colors.deepPurpleAccent,
        child: const Icon(Icons.add, size: 30,color: Colors.white,),
      ),
      body: Consumer<WorkshopDataProvider>(
        builder: (BuildContext context, WorkshopDataProvider provider,
            Widget? child) {
          return RefreshIndicator(
            onRefresh: _loadWorkshops,
            child: provider.workshopModel.isEmpty
                ? const Center(
              child: Text(
                "No Workshops Available",
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: provider.workshopModel.length,
              itemBuilder: (context, index) {
                final workshop = provider.workshopModel[index];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DetailPage(
                              id: workshop.id,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Hero(
                                tag: workshop.id,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                  child: workshop.imageUrl != null &&
                                      workshop.imageUrl!.isNotEmpty
                                      ? Image.network(
                                    workshop.imageUrl!,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                      : Container(
                                    height: 200,
                                    width: double.infinity,
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      size: 100,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Colors.deepPurple,
                                        Colors.purpleAccent
                                      ],
                                    ),
                                    borderRadius:
                                    BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    workshop.dateTime,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  workshop.workshopName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        workshop.collegeName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        _confirmDelete(workshop.id.toIso8601String()),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12), backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(20),
                                      ),
                                      elevation: 10,
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.delete, size: 18,color: Colors.white,),
                                        SizedBox(width: 8),
                                        Text("Delete", style: TextStyle(fontSize: 16,color: Colors.white)),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
