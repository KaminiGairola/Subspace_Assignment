class Blog {
  final String id;
  final String title;
  final String? imageUrl;
  final String category;
  bool isFavorite;

  Blog({
    required this.id,
    required this.title,
    this.imageUrl,
    required this.category,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'category': category,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory Blog.fromMap(Map<String, dynamic> map) {
    return Blog(
      id: map['id'],
      title: map['title'],
      imageUrl: map['imageUrl'],
      category: map['category'],
      isFavorite: map['isFavorite'] == 1,
    );
  }

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'],
      title: json['title'],
      imageUrl: json['image_url'],
      category: json['category'] ?? 'Uncategorized',
    );
  }
}
