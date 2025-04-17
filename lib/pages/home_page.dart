import 'package:flutter/material.dart';
import 'package:hasad_app/pages/meteo.dart';
import 'package:hasad_app/pages/meteo_page.dart';
import 'drawer_widget.dart';
import 'maladie_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;

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
        selectedItemColor: Color(0xFF55C39D),
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

  /// Affiche la page sélectionnée selon l'onglet
  Widget _getSelectedPage() {
    switch (currentIndex) {
      case 0:
        return _buildHomeContent(); // Accueil
      case 1:
        return const PhotoPage(); // Détection des maladies
      case 2:
        return const MeteoPage(); // page météo
      default:
        return const SizedBox();
    }
  }

  /// Contenu de l'accueil (onglet 0)
  Widget _buildHomeContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                Text("9 Avril", style: TextStyle(color: Colors.white)),
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
                // Future: Naviguer vers recommandations
              }),
              const SizedBox(width: 10),
              _cardOption("Détection des maladies", Icons.image_search, () {
                setState(
                    () => currentIndex = 1); // Aller vers la page photo.dart
              }),
            ],
          ),
        ],
      ),
    );
  }

  /// Carte avec icône et titre
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
