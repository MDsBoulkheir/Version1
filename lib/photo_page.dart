import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'plant_disease_model.dart';
import 'disease_descriptions.dart';

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
    _model!.loadModel();
  }

  Future<void> _pickImage(ImageSource source) async {
    Navigator.pop(context);
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
      await _analyzeImage();
    }
  }

Future<void> _analyzeImage() async {
  if (_imageFile != null && _model != null) {
    final label = await _model!.predict(_imageFile!);
    final desc = diseaseDescriptions[label] ?? "Aucune description disponible.";
    setState(() {
      _prediction = label;
      _description = desc;
    });
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
              title: const Text('Prendre une photo'),
              onTap: () => _pickImage(ImageSource.camera),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.photo, size: 32),
              title: const Text('Choisir de la galerie'),
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
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: Column(
            children: [
              const Text(
                'Veuillez capter une image ou sélectionner de votre galerie.',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _showImageSourceOptions,
                icon: const Icon(Icons.spa),
                label: const Text('Détecter les maladies'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF55C39D),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              if (_imageFile != null)
                Image.file(_imageFile!, height: 200),
if (_prediction != null && _description != null) ...[
  const SizedBox(height: 20),
  Text("Résultat : $_prediction",
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
  const SizedBox(height: 10),
  Text(_description!,
      style: const TextStyle(fontSize: 14),
      textAlign: TextAlign.justify),
]

            ],
          ),
        ),
      ),
    );
  }
}
