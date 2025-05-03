import 'package:tflite_flutter/tflite_flutter.dart';


class RecommendationService {
  late Interpreter _interpreter;

  /// Initialisation du modèle TFLite
  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('models/conseil_agri_model.tflite');
      print('✅ Modèle TFLite chargé avec succès');
    } catch (e) {
      print('❌ Erreur chargement modèle : $e');
    }
  }

  /// Prédiction à partir des données météo
  Future<String> predict({
    required double temperature,
    required double humiditeAir,
    required double humiditeSol,
    required double pluieProb,
    required double uv,
    required double rosee,
    required double vent,
    required double visibilite,
  }) async {
    final input = [
      [temperature, humiditeAir, humiditeSol, pluieProb, uv, rosee, vent, visibilite]
    ]; // [1, 8]

    final output = List.filled(1 * 1, 0).reshape([1, 1]); // [1,1] pour classification binaire

    _interpreter.run(input, output);

    final result = output[0][0] as int;

    return result == 1
        ? "✅ Arroser est recommandé 🌱"
        : "⛔️ Aucun arrosage nécessaire aujourd’hui";
  }
}

final recommendationService = RecommendationService();
