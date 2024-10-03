import 'package:kafe/data/models/preference_model.dart';
import 'package:kafe/data/models/review_model.dart';

class CoffeeShopModel {
  final String id;
  final String name;
  final String imageURL;
  final String addressShort;
  final String addressRoad;
  final String addressFull;
  final String type;
  final String created;
  final PreferenceModel? category;
  final List<String> images;
  final String? phone;
  final String? website;
  final double latitude;
  final double longitude;
  final double kafeRating;
  final double otherRating;
  final List<int> ratings;
  final int kafeReviews;
  final int otherReviews;
  final int clicks;
  final List<ReviewModel>? reviews;

  CoffeeShopModel({
    this.id = '',
    this.name = '',
    this.imageURL = '',
    this.addressShort = '',
    this.addressRoad = '',
    this.addressFull = '',
    this.type = '',
    this.created = '',
    this.category,
    this.images = const [],
    this.phone = '',
    this.website = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.kafeRating = 0.0,
    this.otherRating = 0.0,
    this.ratings = const [],
    this.kafeReviews = 0,
    this.otherReviews = 0,
    this.clicks = 0,
    this.reviews = const [],
  });

  factory CoffeeShopModel.fromJson(Map<String, dynamic> json) {
    return CoffeeShopModel(
      id: json['id'],
      name: json['name'],
      imageURL: json['imageURL'],
      addressShort: json['addressShort'],
      addressRoad: json['addressRoad'],
      addressFull: json['addressFull'],
      type: json['type'],
      created: json['created'],
      category: json['category'] != null
          ? PreferenceModel.fromJson(json['category'])
          : PreferenceModel(),
      images: List<String>.from(json['images']),
      phone: json['phone'],
      website: json['website'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      kafeRating: json['kafeRating'],
      otherRating: json['otherRating'],
      ratings: List<int>.from(json['ratings']),
      kafeReviews: json['kafeReviews'],
      otherReviews: json['otherReviews'],
      clicks: json['clicks'],
      reviews: json['reviews'] != null
          ? List<ReviewModel>.from(json['reviews'].map((review) => ReviewModel.fromJson(review)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageURL': imageURL,
      'addressShort': addressShort,
      'addressRoad': addressRoad,
      'addressFull': addressFull,
      'type': type,
      'created': created,
      'category': category!.toJson(),
      'images': images,
      'phone': phone,
      'website': website,
      'latitude': latitude,
      'longitude': longitude,
      'kafeRating': kafeRating,
      'otherRating': otherRating,
      'ratings': ratings,
      'kafeReviews': kafeReviews,
      'otherReviews': otherReviews,
      'clicks': clicks,
      'reviews': reviews != null
          ? reviews!.map((review) => review.toJson()).toList()
          : [],
    };
  }
}