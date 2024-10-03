import 'package:flutter/material.dart';
import 'package:kafe/custom_theme.dart';

class CustomSearchListTile extends StatelessWidget {
  final String name;
  final String address;
  const CustomSearchListTile({super.key, required this.name, required this.address});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(
        top: 6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      address,
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.north_west,
                color: primaryColor,
              ),
            ],
          ),
          Container(
            width: screenWidth,
            height: 1,
            color: Colors.black26,
            margin: const EdgeInsets.only(
              left: 12,
              right: 12,
              top: 6,
            ),
          ),
        ],
      ),
    );
  }
}
