class WorkshopModel {
  final DateTime id;
  final String workshopName;
  final String collegeName;
  final String dateTime;
  final String? imageUrl; // Changed to String for image URL
  AboutWorkshopDetails? aboutWorkshopDetails;

  WorkshopModel(
      this.id, {
        required this.workshopName,
        required this.collegeName,
        required this.dateTime,
        this.imageUrl, // Optional, this is the URL of the image
        this.aboutWorkshopDetails,
      });
}

class AboutWorkshopDetails {
  final String description;
  final List<String> outcomes;
  final List<String> technologiesUsed;
  final String objective;
  final List<String> futureScope;
  final Impact impact;
  final List<String>? images; // List of image URLs

  AboutWorkshopDetails({
    required this.description,
    required this.outcomes,
    required this.technologiesUsed,
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
