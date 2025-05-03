import 'package:flutter/material.dart';

class RecommandationDetailsPage extends StatelessWidget {
  const RecommandationDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Détail de la recommandation")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("💡 Recommandation",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text(
              "L'humidité du sol est très basse dans votre région. "
              "Une irrigation est fortement recommandée pour éviter une sécheresse des cultures.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "📍 Conseil : privilégiez un arrosage tôt le matin ou en soirée.",
              style: TextStyle(color: Colors.blueGrey),
            ),
          ],
        ),
      ),
    );
  }
}
