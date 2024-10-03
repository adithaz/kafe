class ReviewModel {
  final String id;
  final String uid;
  final String idCoffeeShop;
  final String username;
  final String photoURL;
  final String review;
  final String created;
  final double rating;

  ReviewModel({
    this.id = '',
    this.uid = '',
    this.idCoffeeShop = '',
    this.username = '',
    this.photoURL = '',
    this.review = '',
    this.created = '',
    this.rating = 0.0,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      uid: json['uid'],
      idCoffeeShop: json['idCoffeeShop'],
      username: json['username'],
      photoURL: json['photoURL'],
      review: json['review'],
      created: json['created'],
      rating: json['rating'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'idCoffeeShop': idCoffeeShop,
      'username': username,
      'photoURL': photoURL,
      'review': review,
      'created': created,
      'rating': rating,
    };
  }
}