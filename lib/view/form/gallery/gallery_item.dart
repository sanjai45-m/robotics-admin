class GalleryItem {
  String id;
  String imageUrl;
  String title;
  String category;

  GalleryItem({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.category,
  });

  factory GalleryItem.fromJson(Map<String, dynamic> json) {
    return GalleryItem(
      id: json['id'],
      imageUrl: json['image'],
      title: json['title'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': imageUrl,
      'title': title,
      'category': category,
    };
  }
}
