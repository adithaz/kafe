import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kafe/custom_strings.dart';
import 'package:kafe/custom_theme.dart';
import 'package:kafe/data/models/coffee_shop_model.dart';
import 'package:kafe/data/models/user_model.dart';
import 'package:kafe/service/firestore_service.dart';
import 'package:kafe/service/http_service.dart';
import 'package:kafe/service/shared_preferences_service.dart';
import 'package:kafe/service/ui_service.dart';
import 'package:kafe/ui/detail_coffee_screen.dart';
import 'package:kafe/widgets/custom_floating_navigation_circle.dart';
import 'package:kafe/widgets/custom_search_widget.dart';
import 'package:kafe/widgets/custom_user_location_dot.dart';
import 'package:latlong2/latlong.dart';
import 'package:page_transition/page_transition.dart';

class Search extends StatefulWidget {
  final CoffeeShopModel? coffeeShop;
  final VoidCallback? clearCoffeeShopFromHome;
  const Search({super.key, this.coffeeShop, this.clearCoffeeShopFromHome});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> with TickerProviderStateMixin {
  final UIService _ui = UIService();
  final FirestoreService _firestore = FirestoreService();
  final HttpService _http = HttpService();
  final SharedPreferencesService _prefs = SharedPreferencesService();
  UserModel currentUser = UserModel();
  late AnimatedMapController _mapController;
  double screenWidth = 0;
  double screenHeight = 0;
  List<CoffeeShopModel> coffeeShopMarkers = [];
  LatLng? _userCurrentPosition;
  String _shopDestinationName = "";
  List<LatLng> _shopDestinationRoutePoints = [];
  bool _isMapReady = false;
  bool _showSearchBar = true;
  bool _showRoute = false;

  static const double _initialZoom = 13.0;
  static const double _focusZoom = 15.0;
  static const int _animationSpeed = 500;

  @override
  void initState() {
    super.initState();
    _getAllCoffeeShop();

    _mapController = AnimatedMapController(
      vsync: this,
      duration: const Duration(milliseconds: _animationSpeed),
      curve: Curves.easeInOut,
    );

    _getCurrentLocation();
    getUser();
  }

  void getUser() async {
    UserModel? user = await _prefs.getUser();
    setState(() {
      currentUser = user!;
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();
    if(mounted) {
      setState(() {
        _userCurrentPosition = LatLng(position.latitude, position.longitude);
        _isMapReady = true;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkCoffeeShopRouteSearch();
        if(widget.clearCoffeeShopFromHome != null) {
          widget.clearCoffeeShopFromHome!();
        }
      });
    }
  }

  void _getAllCoffeeShop() async {
    List<CoffeeShopModel> buffer = [];
    final result = await _firestore.getAllCoffeeShop();
    for(int i = 0; i < result.length; i++) {
      buffer.add(result[i]);
    }
    if(mounted) {
      setState(() {
        coffeeShopMarkers = buffer;
      });
    }
  }

  void _focusOnMarker(LatLng location) {
    _mapController.animateTo(
      dest: location,
      zoom: _focusZoom,
      curve: Curves.easeInOut,
      rotation: 0,
    );
  }

  void _unFocus() {
    if(mounted) {
      _mapController.animateTo(
        dest: _userCurrentPosition,
        zoom: _initialZoom,
        curve: Curves.easeInOut,
        rotation: 0,
      );
    }
  }

  Future<void> _loadRoute(LatLng dest) async {
    _handleLoading(true);
    LatLng start = _userCurrentPosition!;
    LatLng end = dest;

    try {
      List<LatLng> points = await _http.fetchRoute(start, end);
      setState(() {
        _shopDestinationRoutePoints = points;
        _showRoute = true;
      });
      _zoomToBounds(points);
    } catch (e) {
      _unFocus();
    }
    _handleLoading(false);
  }

  void _clearRoutePoints() {
    setState(() {
      _shopDestinationRoutePoints.clear();
    });
  }

  void _zoomToBounds(List<LatLng> points) {
    if (points.isEmpty) return;

    LatLngBounds bounds = LatLngBounds.fromPoints(points);
    _mapController.animatedFitCamera(
      cameraFit: CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(100),
      ),
    );
  }

  void _handleDetailScreen(CoffeeShopModel coffeeShop) async {
    final result = await Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: DetailCoffeeScreen(coffeeShop: coffeeShop, user: currentUser,),
        curve: Curves.ease,
      ),
    );

    await _firestore.addCoffeeShopClicks(coffeeShop);

    if (result != null && result is CoffeeShopModel) {
      _unFocus();
      _loadRoute(LatLng(result.latitude, result.longitude));
      setState(() {
        _showSearchBar = false;
        _shopDestinationName = result.name;
        coffeeShopMarkers = [result];
      });
    } else {
      _unFocus();
    }
  }

  void _checkCoffeeShopRouteSearch() {
    if(widget.coffeeShop != null) {
      CoffeeShopModel coffeeShop = widget.coffeeShop!;
      _loadRoute(LatLng(coffeeShop.latitude, coffeeShop.longitude));
      setState(() {
        _showSearchBar = false;
        _shopDestinationName = coffeeShop.name;
      });
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        _isMapReady ? FlutterMap(
          mapController: _mapController.mapController,
          options: MapOptions(
            initialCenter: _userCurrentPosition!,
            initialZoom: _initialZoom,
          ),
          children: [
            GestureDetector(
              onTap: () {
                _unFocus();
              },
              child: TileLayer(
                urlTemplate: "https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c', 'd'],
                retinaMode: RetinaMode.isHighDensity(context),
              ),
            ),
            if (_userCurrentPosition != null && _showRoute)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _shopDestinationRoutePoints,
                    strokeWidth: 4.0,
                    color: Colors.blue,
                  ),
                ],
              ),
            AnimatedMarkerLayer(
              markers: coffeeShopMarkers.map((shop) {
                final point = LatLng(shop.latitude, shop.longitude);
                return AnimatedMarker(
                  width: 80.0,
                  height: 80.0,
                  point: point,
                  builder: (_, animation) {
                    final size = 50.0 * animation.value;
                    return GestureDetector(
                      onTap: () {
                        _focusOnMarker(point);
                        Future.delayed(const Duration(milliseconds: _animationSpeed + 200), () {
                          _handleDetailScreen(shop);
                        });
                      },
                      child: Icon(
                        Icons.location_on,
                        color: primaryColor,
                        size: size,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            MarkerLayer(
              markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: _userCurrentPosition!,
                  child: const CustomUserLocationDot(size: 40,),
                ),
              ],
            ),
          ],
        ) : const Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: Text(
                CustomStrings.appTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
          ),
        ),
        _showSearchBar ? Align(
          alignment: Alignment.bottomCenter,
          child: Hero(
            tag: "searchBar",
            child: Container(
              margin: const EdgeInsets.only(
                bottom: 96,
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
                  child: GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: const CustomSearchWidget(),
                          curve: Curves.ease,
                          duration: const Duration(milliseconds: 500),
                        ),
                      );

                      if(result != null) {
                        _focusOnMarker(LatLng(result.latitude, result.longitude));
                        Future.delayed(const Duration(milliseconds: _animationSpeed + 200), () {
                          _handleDetailScreen(result);
                        });
                      }
                    },
                    child: TextFormField(
                      enabled: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Cari tempat kopi...",
                        hintStyle: Theme.of(context).textTheme.bodySmall,
                        suffixIcon: const Icon(
                          Icons.search,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ) : const SizedBox(),
        _showSearchBar ? const SizedBox() :
        Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(
                    bottom: 96,
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.more_vert,
                        size: 20,
                        color: Colors.black26,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const CustomUserLocationDot(size: 20,),
                              const SizedBox(width: 6,),
                              Text(
                                "Lokasi kamu",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.location_pin,
                                color: primaryColor,
                                size: 20,
                              ),
                              const SizedBox(width: 6,),
                              Text(
                                _shopDestinationName,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(
                  bottom: 96,
                  right: 20,
                ),
                child: CustomFloatingNavigationCircle(
                  icon: Icons.close,
                  onTap: _closeRouteMode,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _closeRouteMode() {
    _clearRoutePoints();
    _unFocus();
    _getAllCoffeeShop();
    setState(() {
      _showSearchBar = true;
    });
  }

  void _handleLoading(bool show) {
    if(show) {
      _ui.showSimpleLoadingDialog(context);
    } else {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
