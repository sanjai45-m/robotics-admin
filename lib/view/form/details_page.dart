import 'package:flutter/material.dart';
import 'package:jkv/model/reuse_widgets.dart';
import 'package:provider/provider.dart';

import '../../controller/workshop_data.dart';
import '../../model/workshop_template.dart';
import 'details_form.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.id});
  final DateTime id;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  void initState() {
    super.initState();
    final workshopDataProvider = Provider.of<WorkshopDataProvider>(context, listen: false);
    if (workshopDataProvider.workshopModel.isEmpty) {
      workshopDataProvider.fetchWorkshopsFromFirebase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final workshopDataProvider = Provider.of<WorkshopDataProvider>(context);
    final workshop = workshopDataProvider.workshopModel.firstWhere(
          (w) => w.id == widget.id,
      // Assuming you have a static empty factory constructor
    );


    if (workshop == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Workshop Details')),
        body: const Center(child: Text('Workshop not found')),
      );
    }

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
            ReuseWidgets().buildDetailCard("Description", details.description),
            ReuseWidgets().buildListCard("Technology Used", details.technologiesUsed),
            ReuseWidgets().buildListCard("Outcomes", details.outcomes),
            ReuseWidgets().buildDetailCard("Objective", details.objective),
            ReuseWidgets().buildListCard("Future Scope", details.futureScope),
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
      floatingActionButton: details == null
          ? FloatingActionButton.extended(
        label: const Text("Add"),
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
      )
          : null, // Do not show the FAB if details are not null
    );

  }
}
