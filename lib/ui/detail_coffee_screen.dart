import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:kafe/custom_theme.dart';
import 'package:kafe/data/models/coffee_shop_model.dart';
import 'package:kafe/data/models/user_model.dart';
import 'package:kafe/service/firestore_service.dart';
import 'package:kafe/service/ui_service.dart';
import 'package:kafe/widgets/custom_category_row.dart';
import 'package:kafe/widgets/custom_form_field.dart';
import 'package:kafe/widgets/custom_icon_info_row.dart';
import 'package:kafe/widgets/custom_primary_button.dart';
import 'package:kafe/widgets/custom_rating_star.dart';
import 'package:kafe/widgets/custom_rating_widget.dart';

class DetailCoffeeScreen extends StatefulWidget {
  final CoffeeShopModel coffeeShop;
  final UserModel user;
  const DetailCoffeeScreen({super.key, required this.coffeeShop, required this.user});

  @override
  State<DetailCoffeeScreen> createState() => _DetailCoffeeScreenState();
}

class _DetailCoffeeScreenState extends State<DetailCoffeeScreen> {
  TextEditingController reviewController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final UIService _ui = UIService();
  final FirestoreService _firestore = FirestoreService();
  int _currentImageIndex = 0;
  double _currentRating = 5.0;
  double screenWidth = 0;
  double screenHeight = 0;

  void _handleShowRoute() {
    Navigator.pop(context, widget.coffeeShop);
  }

  Widget horizontalDivider() {
    return Container(
      width: screenWidth,
      height: 1,
      color: Colors.black26,
      margin: const EdgeInsets.symmetric(
        vertical: 6,
      ),
    );
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    if(MediaQuery.of(context).viewInsets.bottom > 0) {
      _scrollToBottom();
    }

    return Scaffold(
      backgroundColor: backgroundMain,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(widget.coffeeShop.images.length > 1)
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      SizedBox(
                        child: CarouselSlider(
                          options: CarouselOptions(
                            enlargeCenterPage: false,
                            autoPlay: true,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enableInfiniteScroll: true,
                            autoPlayAnimationDuration: const Duration(milliseconds: 800),
                            viewportFraction: 1,
                            aspectRatio: 4/3,
                            onPageChanged: (i, reason) {
                              setState(() {
                                _currentImageIndex = i;
                              });
                            }
                          ),
                          items: widget.coffeeShop.images.map((item) => Center(
                            child: CachedNetworkImage(
                              imageUrl: item,
                              fit: BoxFit.cover,
                              width: screenWidth,
                              height: screenHeight / 2,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                "assets/images/user-profile-placeholder.jpg",
                                fit: BoxFit.cover,
                              ),
                              cacheManager: CacheManager(
                                Config(
                                  'imageDetailsCache',
                                  stalePeriod: const Duration(days: 7),
                                  maxNrOfCacheObjects: 100,
                                ),
                              ),
                            ),
                          )).toList(),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: widget.coffeeShop.images.map((url) {
                          int index = widget.coffeeShop.images.indexOf(url);
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 2.5,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentImageIndex == index
                                  ? Colors.white
                                  : Colors.white54,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  )
                else
                  CachedNetworkImage(
                    imageUrl: widget.coffeeShop.imageURL,
                    fit: BoxFit.cover,
                    width: screenWidth,
                    height: screenHeight / 2,
                    placeholder: (context, url) => const Center(
                      child: SafeArea(
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      "assets/images/user-profile-placeholder.jpg",
                      fit: BoxFit.cover,
                    ),
                    cacheManager: CacheManager(
                      Config(
                        'imageDetailsCache',
                        stalePeriod: const Duration(days: 7),
                        maxNrOfCacheObjects: 100,
                      ),
                    ),
                  ),
                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.coffeeShop.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        widget.coffeeShop.type,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                      Text(
                        widget.coffeeShop.addressShort.toString(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  "Rating Kafë",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: ratingColor,
                                    ),
                                    Text(
                                      widget.coffeeShop.kafeRating.toString(),
                                      style: Theme.of(context).textTheme.headlineSmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.black26,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  "Rating Lain",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      color: ratingColor,
                                    ),
                                    Text(
                                      widget.coffeeShop.otherRating.toString(),
                                      style: Theme.of(context).textTheme.headlineSmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20,),
                      GestureDetector(
                        onTap: () {
                          if(widget.coffeeShop.website != "-" && widget.coffeeShop.website!.isNotEmpty) {
                            Feedback.forTap(context);
                            _ui.launchURL(widget.coffeeShop.website.toString());
                          }
                        },
                        child: CustomIconInfoRow(
                          icon: Icons.language,
                          text: widget.coffeeShop.website ?? "-",
                        ),
                      ),
                      const SizedBox(height: 6,),
                      GestureDetector(
                        onTap: () {
                          if(widget.coffeeShop.website != "-" && widget.coffeeShop.website!.isNotEmpty) {
                            Feedback.forTap(context);
                            _ui.makePhoneCall(widget.coffeeShop.phone.toString());
                          }
                        },
                        child: CustomIconInfoRow(
                          icon: Icons.phone,
                          text: widget.coffeeShop.phone ?? "-",
                        ),
                      ),
                      const SizedBox(height: 6,),
                      CustomIconInfoRow(
                        icon: Icons.location_pin,
                        text: widget.coffeeShop.addressRoad,
                      ),
                      const SizedBox(height: 20,),
                      CustomCategoryRow(
                        category: "Fasilitas",
                        detail: widget.coffeeShop.category!.preferFacilities.join(", "),
                      ),
                      horizontalDivider(),
                      CustomCategoryRow(
                        category: "Lokasi",
                        detail: widget.coffeeShop.category!.preferLocation.join(", "),
                      ),
                      horizontalDivider(),
                      CustomCategoryRow(
                        category: "Suasana",
                        detail: widget.coffeeShop.category!.preferAtmosphere.join(", "),
                      ),
                      horizontalDivider(),
                      const SizedBox(height: 16,),
                      CustomPrimaryButton(
                        buttonText: "Tampilkan Rute",
                        onTap: () {
                          Feedback.forTap(context);
                          _handleShowRoute();
                        },
                      ),
                      const SizedBox(height: 20,),
                      Text(
                        "Ulasan Kafë  · (${widget.coffeeShop.reviews!.length})",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      widget.coffeeShop.reviews!.isNotEmpty ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12,),
                          for(int i = 0; i < widget.coffeeShop.reviews!.length; i++)...<Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 40,
                                      height: 40,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(1000),
                                        child: CachedNetworkImage(
                                          imageUrl: widget.user.photoURL,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => const Center(
                                            child: CircularProgressIndicator(
                                              color: primaryColor,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) => Image.asset(
                                            "assets/images/user-profile-placeholder.jpg",
                                            fit: BoxFit.cover,
                                          ),
                                          cacheManager: CacheManager(
                                            Config(
                                              'imageDetailsCache',
                                              stalePeriod: const Duration(days: 7),
                                              maxNrOfCacheObjects: 100,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6,),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            widget.coffeeShop.reviews![i].username,
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              RatingStar(
                                                rating: widget.coffeeShop.reviews![i].rating,
                                                size: 20,
                                              ),
                                              Text(
                                                "  (${widget.coffeeShop.reviews![i].rating})",
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  color: secondaryText,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      _ui.timeAgo(DateFormat("dd-MM-yyyy HH:mm:ss").parse(widget.coffeeShop.reviews![i].created)),
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: secondaryText,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6,),
                                Text(
                                  widget.coffeeShop.reviews![i].review,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 12,),
                              ],
                            ),
                          ],
                        ],
                      ) : Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                        ),
                        child: Center(
                          child: Text(
                            "Belum ada ulasan",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12,),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(1000),
                            child: CachedNetworkImage(
                              imageUrl: widget.user.photoURL,
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                "assets/images/user-profile-placeholder.jpg",
                                fit: BoxFit.cover,
                              ),
                              cacheManager: CacheManager(
                                Config(
                                  'imageDetailsCache',
                                  stalePeriod: const Duration(days: 7),
                                  maxNrOfCacheObjects: 100,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6,),
                          Expanded(
                            child: CustomFormField(
                              controller: reviewController,
                              hint: "Berikan ulasan",
                              maxLines: 5,
                            ),
                          ),
                          const SizedBox(width: 8,),
                          GestureDetector(
                            onTap: () {
                              String review = reviewController.text;
                              if(review.isNotEmpty) {
                                _ui.showSimpleConfirmationDialog(context,
                                  "Kirim Ulasan",
                                  "Apakah kamu sudah mengkonfirmasi ulasan kamu? Mohon berikan ulasan dengan sejujur-jujurnya.",
                                  "Kirim",
                                  "Batal",
                                  () async {
                                    reviewController.clear();
                                    FocusScope.of(context).unfocus();
                                    Feedback.forTap(context);
                                    await _firestore.sendReviewUser(
                                      widget.coffeeShop,
                                      widget.user,
                                      review,
                                      _currentRating,
                                    ).then((_) {
                                      Navigator.pop(context);
                                    });
                                  },
                                  () {
                                    Navigator.pop(context);
                                  },
                                );
                              } else {
                                _handleError("Silahkan berikan ulasan terlebih dahulu");
                              }
                            },
                            child: const Icon(
                              Icons.send,
                              color: primaryColor,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Rating",
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.black54,
                            ),
                          ),
                          CustomRatingWidget(
                            onChanged: (rating) {
                              setState(() {
                                _currentRating = rating;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 30,),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.only(
                  top: 12,
                  left: 20,
                ),
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleError(String message) {
    _ui.showSimpleSnackBar(context, message);
  }
}
