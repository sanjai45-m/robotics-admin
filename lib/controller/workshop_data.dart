import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:jkv/model/workshop_template.dart';

class WorkshopDataProvider with ChangeNotifier {
  List<WorkshopModel> _workshopModel = [];
  List<WorkshopModel> get workshopModel => _workshopModel;
  final String firebaseUrl =
      "https://snews-8ed67-default-rtdb.asia-southeast1.firebasedatabase.app/workshop.json";
  void addWorkshopModelData(DateTime id, String workshopName, String collegeName, String dateTime, String image) {
    final workshop = WorkshopModel(
      id,
      workshopName: workshopName,
      collegeName: collegeName,
      dateTime: dateTime,
      imageUrl: image,
    );
    _workshopModel.add(workshop);
    notifyListeners();

    sendWorkshopToFirebase(workshop);
  }

  void addWorkshopDetails(DateTime id, AboutWorkshopDetails details) {
    final workshop = _workshopModel.firstWhere((w) => w.id == id);
    workshop.aboutWorkshopDetails = details;
    notifyListeners();

    // Send the updated workshop data to Firebase
    sendWorkshopToFirebase(workshop);
  }
  Future<void> sendWorkshopDataToFirebase(
      DateTime id,
      String workshopName,
      String collegeName,
      String dateTime,
      String imageUrl,
      ) async {
    final workshop = {
      "id": id.toIso8601String(),
      "workshopName": workshopName,
      "collegeName": collegeName,
      "dateTime": dateTime,
      "imageUrl": imageUrl,
    };

    try {
      final response = await http.post(
        Uri.parse(firebaseUrl  ),
        body: json.encode(workshop),
      );

      if (response.statusCode == 200) {
        print("Workshop data sent to Firebase");
      } else {
        throw Exception("Failed to send workshop data: ${response.statusCode}");
      }
    } catch (error) {
      throw Exception("Error sending workshop data: $error");
    }
  }

  Future<void> sendWorkshopToFirebase(WorkshopModel workshop) async {
    try {
      // Fetch existing data
      final response = await http.get(Uri.parse(firebaseUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>?;
        String? existingKey;

        // Check if the workshop exists
        data?.forEach((key, value) {
          if (value['id'] == workshop.id.toIso8601String()) {
            existingKey = key; // Store Firebase's key
          }
        });

        if (existingKey != null) {
          // Update existing workshop
          final updateUrl =
              "https://snews-8ed67-default-rtdb.asia-southeast1.firebasedatabase.app/workshop/$existingKey.json";
          final updateResponse = await http.patch(
            Uri.parse(updateUrl),
            body: json.encode({
              "workshopName": workshop.workshopName,
              "collegeName": workshop.collegeName,
              "dateTime": workshop.dateTime,
              "imageUrl": workshop.imageUrl,
              "aboutWorkshopDetails": {
                "description": workshop.aboutWorkshopDetails?.description,
                "outcomes": workshop.aboutWorkshopDetails?.outcomes,
                "technologiesUsed": workshop.aboutWorkshopDetails?.technologiesUsed,
                "objective": workshop.aboutWorkshopDetails?.objective,
                "futureScope": workshop.aboutWorkshopDetails?.futureScope,
                "impact": {
                  "students": workshop.aboutWorkshopDetails?.impact.students,
                  "industry": workshop.aboutWorkshopDetails?.impact.industry,
                  "research": workshop.aboutWorkshopDetails?.impact.research,
                },
                "images": workshop.aboutWorkshopDetails?.images,
              },
            }),
          );

          if (updateResponse.statusCode == 200) {
            print("Workshop updated successfully");
          } else {
            throw Exception("Failed to update workshop: ${updateResponse.statusCode}");
          }
        } else {
          // Create new workshop
          final createResponse = await http.post(
            Uri.parse(firebaseUrl),
            body: json.encode({
              "id": workshop.id.toIso8601String(),
              "workshopName": workshop.workshopName,
              "collegeName": workshop.collegeName,
              "dateTime": workshop.dateTime,
              "imageUrl": workshop.imageUrl,
              "aboutWorkshopDetails": {
                "description": workshop.aboutWorkshopDetails?.description,
                "outcomes": workshop.aboutWorkshopDetails?.outcomes,
                "technologiesUsed": workshop.aboutWorkshopDetails?.technologiesUsed,
                "objective": workshop.aboutWorkshopDetails?.objective,
                "futureScope": workshop.aboutWorkshopDetails?.futureScope,
                "impact": {
                  "students": workshop.aboutWorkshopDetails?.impact.students,
                  "industry": workshop.aboutWorkshopDetails?.impact.industry,
                  "research": workshop.aboutWorkshopDetails?.impact.research,
                },
                "images": workshop.aboutWorkshopDetails?.images,
              },
            }),
          );

          if (createResponse.statusCode == 200) {
            print("Workshop created successfully");
          } else {
            throw Exception("Failed to create workshop: ${createResponse.statusCode}");
          }
        }
      } else {
        throw Exception("Failed to fetch workshops for validation");
      }
    } catch (error) {
      print("Error updating/creating workshop: $error");
    }
  }

  // Fetch workshops from Firebase
  Future<void> fetchWorkshopsFromFirebase() async {
    try {
      final response = await http.get(Uri.parse(firebaseUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic>? data = json.decode(response.body);
        if (data != null) {
          final List<WorkshopModel> loadedWorkshops = [];
          data.forEach((key, workshopData) {
            // Ensure 'aboutWorkshopDetails' is not null before accessing its properties
            final aboutWorkshopDetails = workshopData['aboutWorkshopDetails'];

            List<String> imageUrls = [];
            if (aboutWorkshopDetails != null && aboutWorkshopDetails['images'] != null) {
              imageUrls = List<String>.from(aboutWorkshopDetails['images'] ?? []);
            }

            loadedWorkshops.add(
              WorkshopModel(
                DateTime.parse(workshopData['id']),
                workshopName: workshopData['workshopName'],
                collegeName: workshopData['collegeName'],
                dateTime: workshopData['dateTime'],
                imageUrl: workshopData['imageUrl'],
                aboutWorkshopDetails: aboutWorkshopDetails != null
                    ? AboutWorkshopDetails(
                  description: aboutWorkshopDetails['description'] ?? '',
                  outcomes: List<String>.from(aboutWorkshopDetails['outcomes'] ?? []),
                  technologiesUsed: List<String>.from(aboutWorkshopDetails['technologiesUsed'] ?? []),
                  objective: aboutWorkshopDetails['objective'] ?? '',
                  futureScope: List<String>.from(aboutWorkshopDetails['futureScope'] ?? []),
                  impact: Impact(
                    students: aboutWorkshopDetails['impact']?['students'] ?? '',
                    industry: aboutWorkshopDetails['impact']?['industry'] ?? '',
                    research: aboutWorkshopDetails['impact']?['research'] ?? '',
                  ),
                  images: imageUrls,
                )
                    : null, // If aboutWorkshopDetails is null, we assign null to this field
              ),
            );
          });
          _workshopModel = loadedWorkshops;
          notifyListeners();
        }
      } else {
        throw Exception('Failed to fetch workshops: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching workshops: $error');
      throw error;
    }
  }

  Future<void> deleteEvent(String id) async {
    try {
      // Fetch all existing workshops to find the key
      final response = await http.get(Uri.parse(firebaseUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        String? workshopKey;

        // Find the workshop key by matching the id
        data.forEach((key, value) {
          if (value['id'] == id) {
            workshopKey = key;
          }
        });

        if (workshopKey != null) {
          // Delete the workshop with the specific key
          final deleteUrl = "https://snews-8ed67-default-rtdb.asia-southeast1.firebasedatabase.app/workshop/$workshopKey.json";
          final deleteResponse = await http.delete(Uri.parse(deleteUrl));

          if (deleteResponse.statusCode == 200) {
            // Remove locally from the provider list
            _workshopModel.removeWhere((workshop) => workshop.id.toIso8601String() == id);
            notifyListeners();
          } else {
            throw Exception('Failed to delete workshop from Firebase.');
          }
        } else {
          throw Exception('Workshop not found.');
        }
      } else {
        throw Exception('Failed to fetch workshops.');
      }
    } catch (error) {
      print('Error deleting workshop: $error');
      throw error;
    }
  }

  Future<void> updateWorkshopDetailsInFirebase(DateTime id, AboutWorkshopDetails updatedDetails) async {
    // Find the workshop by ID
    final workshopKey = _workshopModel.firstWhere((workshop) => workshop.id == id);

    if (workshopKey != null) {
      final url =
          "https://snews-8ed67-default-rtdb.asia-southeast1.firebasedatabase.app/workshop/$workshopKey.json";

      try {
        final response = await http.patch(
          Uri.parse(url),
          body: json.encode({
            "aboutWorkshopDetails": {
              "description": updatedDetails.description,
              "outcomes": updatedDetails.outcomes,
              "technologiesUsed": updatedDetails.technologiesUsed,
              "objective": updatedDetails.objective,
              "futureScope": updatedDetails.futureScope,
              "impact": {
                "students": updatedDetails.impact.students,
                "industry": updatedDetails.impact.industry,
                "research": updatedDetails.impact.research,
              },
              "images": updatedDetails.images,
            },
          }),
        );

        if (response.statusCode == 200) {
          print("Workshop details updated successfully");
        } else {
          print("Failed to update workshop details: ${response.statusCode}");
        }
      } catch (error) {
        print("Error updating workshop details: $error");
      }
    } else {
      print("Workshop with ID $id not found");
    }
  }



}
