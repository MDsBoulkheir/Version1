import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class MeteoPage extends StatefulWidget {
  const MeteoPage({super.key});

  @override
  State<MeteoPage> createState() => _MeteoPageState();
}

class _MeteoPageState extends State<MeteoPage> {
  Map<String, dynamic>? weatherData;
  Map<String, dynamic>? forecastData;
  Map<String, dynamic>? tomorrowData;

  List<dynamic>? forecastList;


  double? soilMoisture;

  @override
  void initState() {
    super.initState();
    loadWeather();
  }


  Map<String, dynamic>? oneCallData;
  
  Future<void> loadWeather() async {
  try {
    final data = await WeatherService.getOpenWeatherData("Nouakchott");
    final lat = data["coord"]["lat"];
    final lon = data["coord"]["lon"];
    final soil = await WeatherService.getSoilMoisture(lat, lon);
    final forecast = await WeatherService.getForecastFromForecastApi("Nouakchott");
    final tomorrow = await WeatherService.getTomorrowData(lat, lon);

    setState(() {
      weatherData = data;
      soilMoisture = soil;
      forecastList = forecast;
      tomorrowData = tomorrow;
    });
  } catch (e) {
    print("Erreur de récupération météo : $e");
  }
}


  @override
  Widget build(BuildContext context) {
    final main = weatherData?["main"];
    final wind = weatherData?["wind"];
    final weather = weatherData?["weather"]?[0];
    final rain = weatherData?["rain"]?["1h"] ?? 0.0;
    final snow = weatherData?["snow"]?["1h"] ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Météo"),
        centerTitle: true,
      ),
      body: weatherData == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _currentWeather(main, weather),
                const SizedBox(height: 16),
                _sectionTitle("Conditions actuelles"),
                _infoGrid([
                  _infoCard("Ressenti", "${main["feels_like"]}°C", Icons.thermostat),
                  _infoCard("Humidité", "${main["humidity"]}%", Icons.water_drop),
                  _infoCard("Vent", "${wind["speed"]} km/h", Icons.air),
                  _infoCard("Pression", "${main["pressure"]} hPa", Icons.speed),
                ]),
                const SizedBox(height: 16),
                _sectionTitle("Précipitations"),
                _infoGrid([
                  _infoCard("Pluie (1h)", "$rain mm", Icons.water),
                  _infoCard("Neige (1h)", "$snow mm", Icons.ac_unit),
                  _infoCard("Risques de pluie", "${_getRainChance()}%", Icons.grain),
                  _infoCard("Accum. 24h", "-- mm", Icons.house),
                ]),
                const SizedBox(height: 16),
                _sectionTitle("Indicateurs agricoles"),
                _infoGrid([
  _infoCard("Indice UV", "${tomorrowData?["uvIndex"]?.toStringAsFixed(1) ?? "--"}", Icons.wb_sunny),
  _infoCard("Humidité du sol", "${soilMoisture?.toStringAsFixed(1) ?? "--"}%", Icons.eco),
  _infoCard("Point de rosée", "${tomorrowData?["dewPoint"]?.toStringAsFixed(1) ?? "--"}°C", Icons.opacity),
  _infoCard("Humidité", "${tomorrowData?["humidity"]?.toStringAsFixed(0) ?? "--"}%", Icons.grass),
]),
                const SizedBox(height: 16),
                _sectionTitle("Conditions de culture"),
                _infoGrid([
                  _infoCard("GDD", "--", Icons.device_thermostat),
                  _infoCard("Évapotranspiration", "${tomorrowData?["evapotranspiration"]?.toStringAsFixed(1) ?? "--"} mm", Icons.invert_colors),

                  _infoCard("Phase lunaire", "Pleine lune", Icons.nightlight),
                  _infoCard("Visibilité", "${weatherData?["visibility"] / 1000 ?? "--"} km", Icons.visibility),
                ]),
                const SizedBox(height: 16),
                _sectionTitle("Prévisions horaires"),
                _hourlyForecast(),
                const SizedBox(height: 16),
                _sectionTitle("Prévisions sur 5 jours"),
                _dailyForecast(),
              ],
            ),
    );
  }

  String _getRainChance() {
    return (weatherData?["clouds"]?["all"] ?? 0).toString();
  }

  Widget _sectionTitle(String title) {
    return Text(title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }

  Widget _infoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.lightBlue, size: 30),
          const SizedBox(height: 8),
          Text(value,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(title,
              style: const TextStyle(fontSize: 14, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _infoGrid(List<Widget> children) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: children,
    );
  }

  Widget _currentWeather(dynamic main, dynamic weather) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text("Météo actuelle à Nouakchott",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          const Icon(Icons.cloud, color: Colors.blue, size: 48),
          Text("${main["temp"]}°C",
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
          Text("${weather["description"]}",
              style: const TextStyle(fontSize: 16, color: Colors.black54)),
        ],
      ),
    );
  }

  // Widget _hourlyForecast() {
  //   final List<Map<String, dynamic>> hours = [
  //     {"hour": "17:00", "temp": "20°C", "rain": "0%"},
  //     {"hour": "18:00", "temp": "21°C", "rain": "1%"},
  //     {"hour": "19:00", "temp": "22°C", "rain": "2%"},
  //     {"hour": "20:00", "temp": "23°C", "rain": "3%"},
  //   ];

  //   return SizedBox(
  //     height: 120,
  //     child: ListView.separated(
  //       scrollDirection: Axis.horizontal,
  //       itemCount: hours.length,
  //       separatorBuilder: (_, __) => const SizedBox(width: 12),
  //       itemBuilder: (_, index) {
  //         final data = hours[index];
  //         return Container(
  //           width: 80,
  //           padding: const EdgeInsets.all(12),
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(12),
  //             boxShadow: const [
  //               BoxShadow(color: Colors.black12, blurRadius: 4)
  //             ],
  //           ),
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text(data["hour"],
  //                   style: const TextStyle(fontWeight: FontWeight.bold)),
  //               const SizedBox(height: 6),
  //               const Icon(Icons.wb_cloudy, color: Colors.blue),
  //               const SizedBox(height: 6),
  //               Text(data["temp"]),
  //               Text(data["rain"], style: const TextStyle(color: Colors.blue)),
  //             ],
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

  Widget _hourlyForecast() {
  if (forecastList == null || forecastList!.isEmpty) {
    return const Center(child: Text("Aucune prévision horaire disponible"));
  }

  final now = DateTime.now();

  final upcoming = forecastList!.where((entry) {
    final date = DateTime.parse(entry["dt_txt"]).toLocal();
    return date.isAfter(now);
  }).take(8).toList();

  if (upcoming.isEmpty) {
    return const Center(child: Text("Aucune donnée horaire à venir"));
  }

  return SizedBox(
    height: 130, // Hauteur ajustée
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: upcoming.length,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (_, index) {
        final data = upcoming[index];
        final date = DateTime.parse(data["dt_txt"]).toLocal();
        final hour = "${date.hour.toString().padLeft(2, '0')}:00";
        final temp = "${data["main"]["temp"].round()}°C";
        final rain = "${((data["pop"] ?? 0.0) * 100).round()}%";
        final iconCode = data["weather"][0]["icon"];

        return Container(
          width: 80,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                hour,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Image.network(
                "https://openweathermap.org/img/wn/$iconCode@2x.png",
                width: 28,
                height: 28,
                errorBuilder: (_, __, ___) => const Icon(Icons.cloud, color: Colors.grey, size: 28),
              ),
              Text(
                temp,
                style: const TextStyle(fontSize: 14),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.grain, size: 12, color: Colors.blue),
                  const SizedBox(width: 2),
                  Text(
                    rain,
                    style: const TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ),
  );
}



  Widget _dailyForecast() {
  if (forecastList == null) {
    return const Text("Aucune donnée disponible");
  }

  // Grouper les données de forecast par jour (yyyy-MM-dd)
  Map<String, List<dynamic>> dailyGroups = {};

  for (var entry in forecastList!) {
    final date = DateTime.parse(entry["dt_txt"]);
    final key = "${date.year}-${date.month}-${date.day}";
    dailyGroups.putIfAbsent(key, () => []).add(entry);
  }

  final today = DateTime.now();
  final days = dailyGroups.entries
      .where((e) {
        final date = DateTime.parse(e.value.first["dt_txt"]);
        return date.day != today.day || date.month != today.month;
      })
      .take(5) // Max 5 jours de prévision
      .toList();

  return Column(
    children: days.map((data) {
      final entries = data.value;

      final date = DateTime.parse(entries.first["dt_txt"]);
      final dayName = ["Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", "Vendredi", "Samedi"][date.weekday % 7];

      final min = entries.map((e) => e["main"]["temp_min"] as num).reduce((a, b) => a < b ? a : b).round();
      final max = entries.map((e) => e["main"]["temp_max"] as num).reduce((a, b) => a > b ? a : b).round();
      final iconCode = entries.first["weather"][0]["icon"];
      final rainChance = ((entries.map((e) => e["pop"] ?? 0.0).reduce((a, b) => a + b) / entries.length) * 100).round();

      return Card(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          leading: Image.network("https://openweathermap.org/img/wn/$iconCode@2x.png", width: 40),
          title: Text(dayName),
          subtitle: Text("Min: $min° / Max: $max°"),
          trailing: Text("$rainChance%", style: const TextStyle(color: Colors.blue)),
        ),
      );
    }).toList(),
  );
}

}
