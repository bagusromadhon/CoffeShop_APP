class MenuItemModel {
  final String id;
  final String name;
  final String? description;
  final int price;
  final String? imageUrl;
  final String? category;

  MenuItemModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    this.category,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: json['price'] as int,
      imageUrl: json['image_url'] as String?,
      category: json['category'] as String?,
    );
  }
}
