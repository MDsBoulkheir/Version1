import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hasad_app/models/detection_result.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des prédictions'),
        backgroundColor: const Color(0xFF55C39D),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Vider l’historique',
            onPressed: () async {
              final box = Hive.box<DetectionResult>('detection_results');
              if (box.isNotEmpty) {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirmer la suppression'),
                    content: const Text('Voulez-vous vraiment supprimer tout l’historique ?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
                      TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Supprimer')),
                    ],
                  ),
                );
                if (confirm == true) {
                  await box.clear();
                }
              }
            },
          )
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<DetectionResult>('detection_results').listenable(),
        builder: (context, Box<DetectionResult> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text("Aucune prédiction enregistrée."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: box.length,
            itemBuilder: (context, index) {
              final result = box.getAt(index);
              if (result == null) return const SizedBox();

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(result.imagePath),
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 80),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              result.label,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              result.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 13),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "📅 ${result.date.day}/${result.date.month}/${result.date.year} - ${result.date.hour}:${result.date.minute.toString().padLeft(2, '0')}",
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
