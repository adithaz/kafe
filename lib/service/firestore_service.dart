import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:kafe/data/models/coffee_shop_model.dart';
import 'package:kafe/data/models/review_model.dart';
import 'package:kafe/data/models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toJson());
  }

  Future<bool> checkUsernameAvailability(String username) async {
    QuerySnapshot snapshot = await _firestore.collection('users').where('username', isEqualTo: username).get();
    if(snapshot.docs.isNotEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<UserModel> getUserProfile(String uid) async {
    DocumentSnapshot snapshot = await _firestore.collection('users').doc(uid).get();
    return UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
  }

  Future<void> updateUserProfile(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).update(user.toJson());
  }

  Future<void> createCoffeeShop(CoffeeShopModel coffeeShop) async {
    await _firestore.collection('shops').add(coffeeShop.toJson()).then((doc) async {
      await _firestore.collection('shops').doc(doc.id).update({
        'id': doc.id,
      });
    });
  }

  Future<List<CoffeeShopModel>> getAllCoffeeShop() async {
    List<CoffeeShopModel> buffer = [];
    QuerySnapshot result = await _firestore.collection('shops').get();
    for(int i = 0; i < result.docs.length; i++) {
      buffer.add(CoffeeShopModel.fromJson(result.docs[i].data() as Map<String, dynamic>));
    }
    return buffer;
  }

  Future<void> addCoffeeShopClicks(CoffeeShopModel coffeeShop) async {
    await _firestore.collection('shops').doc(coffeeShop.id).update({
      'clicks': coffeeShop.clicks + 1,
    });
  }

  Future<void> sendReviewUser(CoffeeShopModel coffeeShop, UserModel user, String review, double rating) async {
    List<int> kafeRatingsCount = coffeeShop.ratings;
    List<ReviewModel> allReviews = coffeeShop.reviews ?? [];
    coffeeShop.ratings[rating.toInt() - 1]++;
    ReviewModel newReview = ReviewModel(
      id: _generateCustomID("REVIEW", user.username),
      uid: user.uid,
      idCoffeeShop: coffeeShop.id,
      username: user.username,
      photoURL: user.photoURL,
      review: review,
      created: DateFormat("dd-MM-yyyy HH:mm:ss").format(DateTime.now()),
      rating: rating,
    );
    allReviews.add(newReview);

    double newKafeRating = 0;
    for(int i = 0; i < allReviews.length; i++) {
      newKafeRating += allReviews[i].rating;
    }
    newKafeRating = double.parse((newKafeRating / allReviews.length).toStringAsFixed(1));

    int newKafeReviews = allReviews.length;

    CoffeeShopModel updatedCoffeeShop = CoffeeShopModel(
      id: coffeeShop.id,
      name: coffeeShop.name,
      imageURL: coffeeShop.imageURL,
      addressShort: coffeeShop.addressShort,
      addressRoad: coffeeShop.addressRoad,
      addressFull: coffeeShop.addressFull,
      type: coffeeShop.type,
      created: coffeeShop.created,
      category: coffeeShop.category,
      images: coffeeShop.images,
      phone: coffeeShop.phone,
      website: coffeeShop.website,
      latitude: coffeeShop.latitude,
      longitude: coffeeShop.longitude,
      kafeRating: newKafeRating,
      otherRating: coffeeShop.otherRating,
      ratings: kafeRatingsCount,
      kafeReviews: newKafeReviews,
      otherReviews: coffeeShop.otherReviews,
      clicks: coffeeShop.clicks,
      reviews: allReviews,
    );

    await _firestore.collection('shops').doc(coffeeShop.id).update(updatedCoffeeShop.toJson());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getRecommendationShopStream() {
    return _firestore.collection('shops').snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getNearestShopStream() {
    return _firestore.collection('shops').snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getPopularShopStream() {
    return _firestore.collection('shops').orderBy('clicks', descending: true).snapshots();
  }

  String _generateCustomID(String method, String username) {
    String timestamp = Timestamp.now().toString();
    String rawString = '$method-$username-$timestamp';
    var bytes = utf8.encode(rawString);
    var digest = md5.convert(bytes);
    return digest.toString();
  }
}