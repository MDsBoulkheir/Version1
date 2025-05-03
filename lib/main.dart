// import 'package:flutter/material.dart';
// import 'pages/home_page.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Hasad App',
//       debugShowCheckedModeBanner: false,
//       home: const HomePage(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hasad_app/models/detection_result.dart'; // adapte le chemin selon ton projet
import 'pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🐝 Initialisation de Hive
  await Hive.initFlutter();

  // Enregistrement de l'adaptateur
  Hive.registerAdapter(DetectionResultAdapter());

  // Ouverture de la boîte
  await Hive.openBox<DetectionResult>('detection_results');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hasad App',
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

