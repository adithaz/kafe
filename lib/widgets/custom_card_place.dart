import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:kafe/custom_theme.dart';

class CustomCardPlace extends StatefulWidget {
  final String imageURL;
  final String title;
  final String subTitle;
  const CustomCardPlace({super.key, required this.imageURL, required this.title, required this.subTitle});

  @override
  State<CustomCardPlace> createState() => _CustomCardPlaceState();
}

class _CustomCardPlaceState extends State<CustomCardPlace> {
  double screenWidth = 0;
  double screenHeight = 0;

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth / 2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              imageUrl: widget.imageURL,
              fit: BoxFit.cover,
              width: screenWidth / 2,
              height: screenWidth / 2,
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
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  widget.subTitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.black54,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
