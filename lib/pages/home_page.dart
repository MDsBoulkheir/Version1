import 'package:flutter/material.dart';
import 'package:hasad_app/pages/meteo_page.dart';
import 'package:hasad_app/pages/recommandation_details.dart';
import '../services/weather_service.dart';
import '../services/recommendation_service.dart';
import 'drawer_widget.dart';
import 'maladie_page.dart';
import 'package:hasad_app/pages/history_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  String? recommendationResult;

  @override
  void initState() {
    super.initState();
    loadMeteoAndPredict();
  }

  Future<void> loadMeteoAndPredict() async {
    try {
      final data = await WeatherService.getOpenWeatherData("Nouakchott");
      final lat = data["coord"]["lat"];
      final lon = data["coord"]["lon"];
      final tomorrow = await WeatherService.getTomorrowData(lat, lon);
      final soil = await WeatherService.getSoilMoisture(lat, lon);

      final prediction = await recommendationService.predict(
        temperature: (data["main"]["temp"] ?? 0).toDouble(),
        humiditeAir: (data["main"]["humidity"] ?? 0).toDouble(),
        humiditeSol: (soil ?? 0.0),
        pluieProb: (data["clouds"]["all"] ?? 0).toDouble(),
        uv: (tomorrow["uvIndex"] ?? 0).toDouble(),
        rosee: (tomorrow["dewPoint"] ?? 0).toDouble(),
        vent: (data["wind"]["speed"] ?? 0).toDouble(),
        visibilite: ((data["visibility"] ?? 10000) / 1000).toDouble(),
      );

      setState(() {
        recommendationResult = prediction;
      });
    } catch (e) {
      print("Erreur IA recommandation: $e");
      setState(() {
        recommendationResult = "Aucune recommandation disponible.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.blueGrey),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: const [
          Icon(Icons.language, color: Colors.blueGrey),
          SizedBox(width: 16),
          Icon(Icons.notifications_none, color: Colors.blueGrey),
          SizedBox(width: 16),
        ],
      ),
      body: _getSelectedPage(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: const Color(0xFF55C39D),
        unselectedItemColor: const Color.fromARGB(255, 96, 139, 100),
        onTap: (index) {
          setState(() => currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Accueil'),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt_outlined), label: 'Maladies'),
          BottomNavigationBarItem(
              icon: Icon(Icons.cloud_outlined), label: 'Météo'),
        ],
      ),
    );
  }

  Widget _getSelectedPage() {
    switch (currentIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return const PhotoPage();
      case 2:
        return const MeteoPage();
      default:
        return const SizedBox();
    }
  }

  Widget _buildHomeContent() {
    final recommandation = recommendationResult ?? "Chargement...";

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            color: Colors.green.shade50,
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading:
                  const Icon(Icons.notifications_active, color: Colors.green),
              title: const Text("Recommandation du jour"),
              subtitle: Text(recommandation),
              trailing: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const RecommandationDetailsPage()),
                  );
                },
                child: const Text("Plus de détails"),
              ),
            ),
          ),
          const Text(
            "Conditions météorologiques",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF4CA08C)),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.cyan,
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.all(30),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Nouakchott",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                Text("Aujourd'hui", style: TextStyle(color: Colors.white)),
                Text("ciel clair", style: TextStyle(color: Colors.white)),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text("19°C",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Support Intelligent de HasadAPP",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF4CA08C)),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _cardOption("Recommandations IA", Icons.insert_chart, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const RecommandationDetailsPage()),
                );
              }),
              const SizedBox(width: 10),
              _cardOption("Détection des maladies", Icons.image_search, () {
                setState(() => currentIndex = 1);
              }),
              const SizedBox(width: 10),
              _cardOption("Historique", Icons.history, () {
              Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryPage()),
                 );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cardOption(String title, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.blueGrey),
              const SizedBox(height: 10),
              Text(title, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
