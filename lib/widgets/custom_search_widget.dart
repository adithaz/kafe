import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kafe/custom_theme.dart';
import 'package:kafe/data/models/coffee_shop_model.dart';
import 'package:kafe/widgets/custom_search_list_tile.dart';

class CustomSearchWidget extends StatefulWidget {
  const CustomSearchWidget({super.key});

  @override
  State<CustomSearchWidget> createState() => _CustomSearchWidgetState();
}

class _CustomSearchWidgetState extends State<CustomSearchWidget> {
  TextEditingController searchController = TextEditingController();
  double screenWidth = 0;
  double screenHeight = 0;
  List<DocumentSnapshot> _results = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundMain,
      body: SafeArea(
        child: Column(
          children: [
            Hero(
              tag: "searchBar",
              child: Container(
                margin: const EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(2, 2),
                      blurRadius: 5,
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 4,
                ),
                child: Material(
                  child: Container(
                    color: Colors.white,
                    child: TextFormField(
                      autofocus: true,
                      controller: searchController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Cari sesuatu...",
                        hintStyle: Theme.of(context).textTheme.bodySmall,
                        suffixIcon: const Icon(
                          Icons.search,
                          color: primaryColor,
                        ),
                      ),
                      onChanged: (v) {
                        _search();
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20,),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: _results.isNotEmpty ? ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    var place = CoffeeShopModel.fromJson(_results[index].data() as Map<String, dynamic>);

                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context, place);
                      },
                      child: CustomSearchListTile(
                        name: place.name,
                        address: place.addressRoad,
                      ),
                    );
                  },
                ) : const Center(
                  child: Text("Tidak ada hasil yang cocok"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _search() async {
    String searchQuery = searchController.text.trim();
    searchQuery = "${searchQuery[0].toUpperCase()}${searchQuery.substring(1).toLowerCase()}";
    if (searchQuery.isNotEmpty) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('shops')
          .where('name', isGreaterThanOrEqualTo: searchQuery)
          .where('name', isLessThanOrEqualTo: '$searchQuery\uf8ff')
          .get();

      setState(() {
        _results = snapshot.docs;
      });
    }
  }
}
