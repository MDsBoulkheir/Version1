import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hasad_app/plant_disease_model.dart';
import 'package:hasad_app/disease_descriptions.dart';


import 'package:hasad_app/models/detection_result.dart';
import 'package:hive/hive.dart';


class PhotoPage extends StatefulWidget {
  const PhotoPage({super.key});

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  PlantDiseaseModel? _model;
  String? _prediction;
  String? _description;

  @override
  void initState() {
    super.initState();
    _model = PlantDiseaseModel();
    _model!.loadModel(); // chargement du modèle IA
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context); // Ferme la bottom sheet
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _prediction = null;
        _description = null;
      });
      await _analyzeImage(); // 👈 on lance la prédiction dès que l’image est chargée
    }
  }

  // Future<void> _analyzeImage() async {
  //   if (_imageFile != null && _model != null) {
  //     final label = await _model!.predict(_imageFile!); // 🔁 modèle IA
  //     final desc = diseaseDescriptions[label] ?? "Aucune description disponible.";
  //     setState(() {
  //       _prediction = label;
  //       _description = desc;
  //     });
  //   }
  // }

//   Future<void> _analyzeImage() async {
//   if (_imageFile != null && _model != null) {
//     final label = await _model!.predict(_imageFile!);

//     // Message par défaut si l’image n’est pas valide
//     final desc = diseaseDescriptions[label] ??
//         (label == "Image non reconnue"
//             ? "L’image ne semble pas contenir une plante valide. Veuillez réessayer avec une photo claire de la feuille ou du fruit."
//             : "Aucune description disponible.");

//     setState(() {
//       _prediction = label;
//       _description = desc;
//     });
//   }
// }

Future<void> _analyzeImage() async {
  if (_imageFile != null && _model != null) {
    final label = await _model!.predict(_imageFile!);

    final desc = diseaseDescriptions[label] ??
        (label == "Image non reconnue"
            ? "L’image ne semble pas contenir une plante valide. Veuillez réessayer avec une photo claire de la feuille ou du fruit."
            : "Aucune description disponible.");

    setState(() {
      _prediction = label;
      _description = desc;
    });

    // ✅ Sauvegarde dans Hive
    final result = DetectionResult(
      label: label,
      description: desc,
      imagePath: _imageFile!.path,
      date: DateTime.now(),
    );

    final box = await Hive.openBox<DetectionResult>('detection_results');
    await box.add(result);
  }
}



  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined, size: 32),
              title: const Text('Prendre une photo', style: TextStyle(fontSize: 18)),
              onTap: () => _pickImage(ImageSource.camera),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.photo, size: 32),
              title: const Text('Choisir de la galerie', style: TextStyle(fontSize: 18)),
              onTap: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0, // cacher l’appbar
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Veuillez capter une image ou sélectionner de votre galerie pour un meilleur résultat.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _showImageSourceOptions,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF55C39D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                icon: const Icon(Icons.spa, color: Colors.white),
                label: const Text(
                  'Détecter les maladies',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 30),
              if (_imageFile != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.file(_imageFile!, height: 200),
                ),

              if (_prediction != null && _description != null) ...[
                const SizedBox(height: 20),
                // Text("Résultat : $_prediction",
                //     style: const TextStyle(
                //         fontWeight: FontWeight.bold, fontSize: 16)),
                // const SizedBox(height: 10),
                // Text(
                //   _description!,
                //   style: const TextStyle(fontSize: 14),
                //   textAlign: TextAlign.justify,
                // ),

                Container(
  padding: const EdgeInsets.all(16),
  margin: const EdgeInsets.symmetric(vertical: 12),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 8,
        offset: Offset(0, 4),
      ),
    ],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        _prediction == "Image non reconnue"
            ? "❗ Image non reconnue"
            : "🩺 Résultat : $_prediction",
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 12),
      Text(
        _description ?? "",
        style: const TextStyle(
          fontSize: 14,
          height: 1.5,
        ),
      ),
    ],
  ),
),

              ]
            ],
          ),
        ),
      ),
    );
  }
}
