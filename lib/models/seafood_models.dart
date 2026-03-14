import 'dart:convert';

class SeafoodProduct {
  final String id;
  final String name;
  final String description;
  final double price;
  final String categoryId;
  final List<String> images;
  final double rating;
  final int reviewsCount;
  final String origin;
  final String freshnessInfo;
  final List<String> weightOptions; // e.g. ["500g", "1kg", "2kg"]
  final Map<String, double> weightMultipliers; // e.g. {"500g": 1.0, "1kg": 1.9, "2kg": 3.6}
  final bool isFeatured;
  final bool isDailyDeal;
  final double? discountPrice;

  SeafoodProduct({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.images,
    required this.rating,
    required this.reviewsCount,
    required this.origin,
    required this.freshnessInfo,
    required this.weightOptions,
    required this.weightMultipliers,
    this.isFeatured = false,
    this.isDailyDeal = false,
    this.discountPrice,
  });

  factory SeafoodProduct.fromJson(Map<String, dynamic> json) {
    return SeafoodProduct(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      categoryId: json['categoryId'],
      images: List<String>.from(json['images']),
      rating: json['rating'].toDouble(),
      reviewsCount: json['reviewsCount'],
      origin: json['origin'],
      freshnessInfo: json['freshnessInfo'],
      weightOptions: List<String>.from(json['weightOptions']),
      weightMultipliers: Map<String, double>.from(json['weightMultipliers']),
      isFeatured: json['isFeatured'] ?? false,
      isDailyDeal: json['isDailyDeal'] ?? false,
      discountPrice: json['discountPrice']?.toDouble(),
    );
  }
}

class Category {
  final String id;
  final String name;
  final String iconPath;

  Category({required this.id, required this.name, required this.iconPath});
}
