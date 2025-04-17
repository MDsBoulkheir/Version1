import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  // 🔑 Remplace ces clés par les tiennes :
  static const _owmApiKey = '7dc855f27081307161a8c72dc14869e8';
  static const _tmrApiKey = 'aI80azYk74Q4d01oYv9MIwgEP2OT2ij4';

  /// 📦 Récupère les données météo actuelles depuis OpenWeatherMap
  static Future<Map<String, dynamic>> getOpenWeatherData(String city) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&lang=fr&appid=$_owmApiKey';

    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      throw Exception("Erreur de récupération OpenWeatherMap (${res.statusCode})");
    }
  }

  /// 🌱 Récupère l'humidité du sol depuis Tomorrow.io
  static Future<double?> getSoilMoisture(double lat, double lon) async {
    final url =
        'https://api.tomorrow.io/v4/weather/realtime?location=$lat,$lon&apikey=$_tmrApiKey';

    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return data["data"]["values"]["soilMoisture10cm"];
    } else {
      throw Exception("Erreur de récupération Tomorrow.io (${res.statusCode})");
    }
  }

  static Future<List<dynamic>> getForecastFromForecastApi(String city) async {
  final url =
      'https://api.openweathermap.org/data/2.5/forecast?q=$city&units=metric&lang=fr&appid=7dc855f27081307161a8c72dc14869e8';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    return jsonData["list"];
  } else {
    throw Exception("Impossible de récupérer les prévisions météo");
  }
}

}
