import 'package:flutter/material.dart';
import 'package:jkv/view/form/event_form.dart';
import 'package:jkv/controller/workshop_data.dart';
import 'package:provider/provider.dart';
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
    workshopDataProvider = Provider.of<WorkshopDataProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WorkShops"),
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
        child: const Icon(Icons.add, size: 30),
      ),
      body: Consumer<WorkshopDataProvider>(
        builder: (BuildContext context, WorkshopDataProvider provider, Widget? child) {
          return RefreshIndicator(
            onRefresh: _loadWorkshops, // Pull-to-refresh function
            child: provider.workshopModel.isEmpty
                ? const Center(
              child: Text(
                "No Workshops Available",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: provider.workshopModel.length,
              itemBuilder: (context, index) {
                final workshop = provider.workshopModel[index];
                return Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: workshop.imageUrl != null && workshop.imageUrl!.isNotEmpty
                                ? Image.network(
                              workshop.imageUrl!,
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            )
                                : const Icon(
                              Icons.image_not_supported,
                              size: 60,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  workshop.workshopName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurpleAccent,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  workshop.collegeName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  workshop.dateTime,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),
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
