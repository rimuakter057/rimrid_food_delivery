import 'package:equatable/equatable.dart';

class AddOnModel extends Equatable {
  final String id;
  final String name;
  final double price;
  final bool isSelected;

  const AddOnModel({
    required this.id,
    required this.name,
    required this.price,
    this.isSelected = false,
  });

  AddOnModel copyWith({
    String? id,
    String? name,
    double? price,
    bool? isSelected,
  }) {
    return AddOnModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [id, name, price, isSelected];
}

class FoodModel extends Equatable {
  final String id;
  final String restaurantId;
  final String restaurantName;
  final String categoryId;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final int prepTimeMinutes;
  final int calories;
  final List<AddOnModel> addOns;
  final bool isPopular;
  final bool isRecommended;
  final bool isFavorite;

  const FoodModel({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.prepTimeMinutes,
    required this.calories,
    this.addOns = const [],
    this.isPopular = false,
    this.isRecommended = false,
    this.isFavorite = false,
  });

  FoodModel copyWith({
    String? id,
    String? restaurantId,
    String? restaurantName,
    String? categoryId,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    double? rating,
    int? reviewCount,
    String? imageUrl,
    int? prepTimeMinutes,
    int? calories,
    List<AddOnModel>? addOns,
    bool? isPopular,
    bool? isRecommended,
    bool? isFavorite,
  }) {
    return FoodModel(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      imageUrl: imageUrl ?? this.imageUrl,
      prepTimeMinutes: prepTimeMinutes ?? this.prepTimeMinutes,
      calories: calories ?? this.calories,
      addOns: addOns ?? this.addOns,
      isPopular: isPopular ?? this.isPopular,
      isRecommended: isRecommended ?? this.isRecommended,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  List<Object?> get props => [
        id,
        restaurantId,
        restaurantName,
        categoryId,
        name,
        description,
        price,
        originalPrice,
        rating,
        reviewCount,
        imageUrl,
        prepTimeMinutes,
        calories,
        addOns,
        isPopular,
        isRecommended,
        isFavorite,
      ];
}
