import 'package:equatable/equatable.dart';

class RestaurantModel extends Equatable {
  final String id;
  final String name;
  final String logoUrl;
  final String coverImageUrl;
  final double rating;
  final int reviewCount;
  final String deliveryTime;
  final double deliveryFee;
  final double distanceKm;
  final String description;
  final List<String> tags;
  final bool isPopular;
  final bool isFavorite;
  final String address;

  const RestaurantModel({
    required this.id,
    required this.name,
    required this.logoUrl,
    required this.coverImageUrl,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.distanceKm,
    required this.description,
    required this.tags,
    this.isPopular = false,
    this.isFavorite = false,
    required this.address,
  });

  RestaurantModel copyWith({
    String? id,
    String? name,
    String? logoUrl,
    String? coverImageUrl,
    double? rating,
    int? reviewCount,
    String? deliveryTime,
    double? deliveryFee,
    double? distanceKm,
    String? description,
    List<String>? tags,
    bool? isPopular,
    bool? isFavorite,
    String? address,
  }) {
    return RestaurantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      distanceKm: distanceKm ?? this.distanceKm,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      isPopular: isPopular ?? this.isPopular,
      isFavorite: isFavorite ?? this.isFavorite,
      address: address ?? this.address,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        logoUrl,
        coverImageUrl,
        rating,
        reviewCount,
        deliveryTime,
        deliveryFee,
        distanceKm,
        description,
        tags,
        isPopular,
        isFavorite,
        address,
      ];
}
