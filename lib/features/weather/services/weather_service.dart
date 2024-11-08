import 'dart:convert';

import 'package:http/http.dart' as http;

class WeatherService {
  static const String apiKey = '9b6b38bb9f52778a5fd8b9a9d4f22e7f';
  static const String baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';
  static const String geoUrl = 'http://api.openweathermap.org/geo/1.0/direct';

  static Future<Map<String, dynamic>> getWeather(String city) async {
    try {
      // First, get coordinates for the city
      final geoResponse = await http.get(
        Uri.parse('$geoUrl?q=$city&limit=1&appid=$apiKey'),
      );

      if (geoResponse.statusCode != 200) {
        throw 'City not found. Please check the city name.';
      }

      final List geoData = json.decode(geoResponse.body);
      if (geoData.isEmpty) {
        throw 'City not found. Please check the city name.';
      }

      // Extract coordinates
      final double latit = geoData[0]['lat'];
      final double longit = geoData[0]['lon'];

      // Now get weather using coordinates
      final weatherResponse = await http.get(
        Uri.parse('$baseUrl?lat=$latit&lon=$longit&appid=$apiKey&units=metric'),
      );

      if (weatherResponse.statusCode == 200) {
        final data = json.decode(weatherResponse.body);
        return data;
      } else {
        throw 'Failed to get weather data. Please try again.';
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        throw 'No internet connection. Please check your connection and try again.';
      }
      throw e.toString();
    }
  }
}
