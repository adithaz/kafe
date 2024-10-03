import 'package:flutter/material.dart';
import 'package:kafe/custom_theme.dart';
import 'package:kafe/data/models/coffee_shop_model.dart';
import 'package:kafe/ui/home/home.dart';
import 'package:kafe/ui/home/profile.dart';
import 'package:kafe/ui/home/search.dart';
import 'package:kafe/widgets/custom_floating_navigation_circle.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  double screenWidth = 0;
  double screenHeight = 0;
  final PageController _pageController = PageController();
  CoffeeShopModel? coffeeShop;

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showCoffeeShopRouteInSearch(CoffeeShopModel shop) {
    setState(() {
      coffeeShop = shop;
    });
    _onItemTapped(1);
  }

  void _clearCoffeeShopRoute() {
    setState(() {
      coffeeShop = null;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundMain,
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              Home(showCoffeeRoute: _showCoffeeShopRouteInSearch,),
              Search(coffeeShop: coffeeShop, clearCoffeeShopFromHome: _clearCoffeeShopRoute,),
              const Profile(),
            ],
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomFloatingNavigationCircle(
                  icon: Icons.home_filled,
                  onTap: () {
                    _onItemTapped(0);
                  },
                ),
                CustomFloatingNavigationCircle(
                  icon: Icons.public,
                  onTap: () {
                    _onItemTapped(1);
                  },
                ),
                CustomFloatingNavigationCircle(
                  icon: Icons.account_circle_rounded,
                  onTap: () {
                    _onItemTapped(2);
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
