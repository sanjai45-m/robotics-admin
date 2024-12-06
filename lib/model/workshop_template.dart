import 'dart:io';

class WorkshopModel {
  final DateTime id;
  final String workshopName;
  final String collegeName;
  final String dateTime;
  final File? image;
  AboutWorkshopDetails? aboutWorkshopDetails; // Optional field

  WorkshopModel(
      this.id, {
        required this.workshopName,
        required this.collegeName,
        required this.dateTime,
        required this.image,
        this.aboutWorkshopDetails, // Remove "required"
      });
}


class AboutWorkshopDetails {
  final String description;
  final List<String> outcomes;
  final String objective;
  final List<String> futureScope;
  final Impact impact;
  final List<File>? images; // List of images

  AboutWorkshopDetails({
    required this.description,
    required this.outcomes,
    required this.objective,
    required this.futureScope,
    required this.impact,
    this.images, // Optional, default null
  });
}


class Impact {
  final String students;
  final String industry;
  final String research;

  Impact(
      {required this.students, required this.industry, required this.research});
}
