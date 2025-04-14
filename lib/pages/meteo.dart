import 'package:flutter/material.dart';

class MeteoPage extends StatelessWidget {
  const MeteoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _currentWeather(),
          const SizedBox(height: 16),
          _sectionTitle("Conditions actuelles"),
          _infoGrid([
            _infoCard("Ressenti", "24.5°C", Icons.thermostat),
            _infoCard("Humidité", "79%", Icons.water_drop),
            _infoCard("Vent", "28.2 km/h", Icons.air),
            _infoCard("Pression", "1011 hPa", Icons.speed),
          ]),
          const SizedBox(height: 16),
          _sectionTitle("Précipitations"),
          _infoGrid([
            _infoCard("Pluie (1h)", "0.0 mm", Icons.water),
            _infoCard("Neige (1h)", "0.0 mm", Icons.ac_unit),
            _infoCard("Risques de pluie", "40%", Icons.grain),
            _infoCard("Accum. 24h", "0.0 mm", Icons.house),
          ]),
          const SizedBox(height: 16),
          _sectionTitle("Indicateurs agricoles"),
          _infoGrid([
            _infoCard("Indice UV", "0.0", Icons.wb_sunny),
            _infoCard("Humidité du sol", "40%", Icons.eco),
            _infoCard("Point de rosée", "20.1°C", Icons.opacity),
            _infoCard("Humidité des feuilles", "79%", Icons.grass),
          ]),
          const SizedBox(height: 16),
          _sectionTitle("Conditions de culture"),
          _infoGrid([
            _infoCard("GDD", "14.0", Icons.device_thermostat),
            _infoCard("Évapotranspiration", "0.0 mm", Icons.invert_colors),
            _infoCard("Phase lunaire", "Pleine lune", Icons.nightlight),
            _infoCard("Visibilité", "10.0 km", Icons.visibility),
          ]),
          const SizedBox(height: 16),
          _sectionTitle("Prévisions horaires"),
          _hourlyForecast(),
          const SizedBox(height: 16),
          _sectionTitle("Prévisions sur 7 jours"),
          _dailyForecast(),
        ],
      ),
    );
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

  Widget _currentWeather() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: const [
          Text("Météo actuelle à Nouakchott",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Icon(Icons.cloud, color: Colors.blue, size: 48),
          Text("24.0°C",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
          Text("Nuages épars",
              style: TextStyle(fontSize: 16, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _hourlyForecast() {
    final List<Map<String, dynamic>> hours = [
      {"hour": "17:00", "temp": "20°C", "rain": "0%"},
      {"hour": "18:00", "temp": "21°C", "rain": "1%"},
      {"hour": "19:00", "temp": "22°C", "rain": "2%"},
      {"hour": "20:00", "temp": "23°C", "rain": "3%"},
    ];

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: hours.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          final data = hours[index];
          return Container(
            width: 80,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4)
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(data["hour"],
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                const Icon(Icons.wb_cloudy, color: Colors.blue),
                const SizedBox(height: 6),
                Text(data["temp"]),
                Text(data["rain"], style: const TextStyle(color: Colors.blue)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _dailyForecast() {
    final List<Map<String, dynamic>> days = [
      {
        "day": "Vendredi",
        "min": 18,
        "max": 22,
        "rain": "0%",
        "icon": Icons.wb_sunny
      },
      {
        "day": "Samedi",
        "min": 19,
        "max": 23,
        "rain": "5%",
        "icon": Icons.cloud
      },
      {
        "day": "Dimanche",
        "min": 20,
        "max": 24,
        "rain": "10%",
        "icon": Icons.wb_sunny
      },
      {
        "day": "Lundi",
        "min": 18,
        "max": 25,
        "rain": "15%",
        "icon": Icons.cloud_queue
      },
      {
        "day": "Mardi",
        "min": 19,
        "max": 22,
        "rain": "20%",
        "icon": Icons.wb_sunny
      },
      {
        "day": "Mercredi",
        "min": 18,
        "max": 23,
        "rain": "10%",
        "icon": Icons.cloud
      },
      {
        "day": "Jeudi",
        "min": 19,
        "max": 24,
        "rain": "0%",
        "icon": Icons.wb_sunny
      },
    ];

    return Column(
      children: days.map((data) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: Icon(data["icon"], color: Colors.blue),
            title: Text(data["day"]),
            subtitle: Text("Min: ${data["min"]}° / Max: ${data["max"]}°"),
            trailing:
                Text(data["rain"], style: const TextStyle(color: Colors.blue)),
          ),
        );
      }).toList(),
    );
  }
}
