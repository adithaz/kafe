import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class HttpService {
  Future<List<LatLng>> fetchRoute(LatLng start, LatLng end) async {
    final apiKey = dotenv.env['OPENROUTESERVICE_API_KEY'] ?? '';
    final url = 'https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List coordinates = data['features'][0]['geometry']['coordinates'];
      return coordinates.map((coordinate) => LatLng(coordinate[1], coordinate[0])).toList();
    } else {
      throw Exception('Failed to load route');
    }
  }
}