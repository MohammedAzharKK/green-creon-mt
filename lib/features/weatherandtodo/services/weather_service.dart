import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class WeatherService {
  static const String apiKey = 'f20fa5985132d733d7d14453e79466eb';
  static const String baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';
  static const String geoUrl = 'https://api.openweathermap.org/geo/1.0/direct';

  static Future<Map<String, dynamic>> getWeather(String city) async {
    try {
      // First, get coordinates for the city
      final geoResponse = await http.get(
        Uri.parse('$geoUrl?q=$city&limit=1&appid=$apiKey'),
      );

      log('Geo Response Status: ${geoResponse.statusCode}');
      log('Geo Response Body: ${geoResponse.body}');

      if (geoResponse.statusCode != 200) {
        throw 'Failed to get city coordinates. Status: ${geoResponse.statusCode}';
      }

      final List geoData = json.decode(geoResponse.body);
      if (geoData.isEmpty) {
        throw 'City not found. Please check the city name.';
      }

      final double lat = geoData.first['lat'];
      final double lon = geoData.first['lon'];

      print('Coordinates - Lat: $lat, Lon: $lon');

      // Now get weather using coordinates
      final weatherResponse = await http.get(
        Uri.parse('$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric'),
      );

      print('Weather Response Status: ${weatherResponse.statusCode}');
      print('Weather Response Body: ${weatherResponse.body}');

      if (weatherResponse.statusCode == 200) {
        final data = json.decode(weatherResponse.body);
        return data;
      } else {
        throw 'Failed to get weather data. Status: ${weatherResponse.statusCode}';
      }
    } catch (e) {
      print('Error in getWeather: $e');
      if (e.toString().contains('SocketException')) {
        throw 'No internet connection. Please check your connection.';
      }
      throw e.toString();
    }
  }
}
