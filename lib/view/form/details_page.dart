import 'package:flutter/material.dart';
import 'package:jkv/model/reuse_widgets.dart';
import 'package:provider/provider.dart';

import '../../controller/workshop_data.dart';
import 'details_form.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.id});
  final DateTime id;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    final workshop = Provider.of<WorkshopDataProvider>(context)
        .workshopModel
        .firstWhere((w) => w.id == widget.id);

    final details = workshop.aboutWorkshopDetails;

    return Scaffold(
      appBar: AppBar(
        title: Text(workshop.workshopName),
        backgroundColor: Colors.teal,
      ),
      body: details == null
          ? const Center(
        child: Text(
          'No details available',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              "Workshop Details",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            ),
            const SizedBox(height: 10),
            ReuseWidgets()
                .buildDetailCard("Description", details.description),
            ReuseWidgets().buildListCard("Outcomes", details.outcomes),
            ReuseWidgets()
                .buildDetailCard("Objective", details.objective),
            ReuseWidgets()
                .buildListCard("Future Scope", details.futureScope),
            const SizedBox(height: 20),
            const Text(
              "Impact",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            ),
            const SizedBox(height: 10),
            ReuseWidgets().buildImpactDetails(details.impact),
            const SizedBox(height: 20),
            const Text(
              "Images",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal),
            ),
            const SizedBox(height: 10),
            ReuseWidgets().buildImageList(details.images),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text(details == null ? "Add" : "Edit"),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DetailsForm(
                id: widget.id,
                existingDetails: details, // Pass existing details for editing
              ),
            ),
          );
        },
      ),
    );
  }
}
