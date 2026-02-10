class FoodMenuModel {
  final String id;
  final String hotelId;
  final String category;
  final String itemName;
  final String? description;
  final double price;
  final bool isVegetarian;
  final bool isVegan;
  final bool isGlutenFree;
  final String? spiceLevel; // 'mild', 'medium', 'hot', 'extra_hot'
  final String? imagePath;
  final bool isAvailable;
  final List<String> availableTimes; // ['breakfast', 'lunch', 'dinner']
  final DateTime createdAt;
  final DateTime updatedAt;

  FoodMenuModel({
    required this.id,
    required this.hotelId,
    required this.category,
    required this.itemName,
    this.description,
    required this.price,
    required this.isVegetarian,
    required this.isVegan,
    required this.isGlutenFree,
    this.spiceLevel,
    this.imagePath,
    required this.isAvailable,
    required this.availableTimes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FoodMenuModel.fromJson(Map<String, dynamic> json) {
    return FoodMenuModel(
      id: json['id'] as String,
      hotelId: json['hotel_id'] as String,
      category: json['category'] as String,
      itemName: json['item_name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      isVegetarian: json['is_vegetarian'] as bool? ?? false,
      isVegan: json['is_vegan'] as bool? ?? false,
      isGlutenFree: json['is_gluten_free'] as bool? ?? false,
      spiceLevel: json['spice_level'] as String?,
      imagePath: json['image_path'] as String?,
      isAvailable: json['is_available'] as bool? ?? true,
      availableTimes: (json['available_times'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotel_id': hotelId,
      'category': category,
      'item_name': itemName,
      'description': description,
      'price': price,
      'is_vegetarian': isVegetarian,
      'is_vegan': isVegan,
      'is_gluten_free': isGlutenFree,
      'spice_level': spiceLevel,
      'image_path': imagePath,
      'is_available': isAvailable,
      'available_times': availableTimes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}