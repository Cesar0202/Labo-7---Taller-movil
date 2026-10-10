import 'package:flutter/material.dart';

class ClasificacionResult {
  final String prediction;
  final String imageName;
  final Map<String, double> probs;

  ClasificacionResult({
    required this.prediction,
    required this.imageName,
    required this.probs,
  });

  factory ClasificacionResult.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> rawProbs = json['probs'] as Map<String, dynamic>;
    final Map<String, double> parsedProbs = rawProbs.map(
      (key, value) => MapEntry(key, (value as num).toDouble()),
    );

    return ClasificacionResult(
      prediction: json['prediction'] ?? '',
      imageName: json['image_name'] ?? '',
      probs: parsedProbs,
    );
  }

  String get predictedClass {
    if (probs.isEmpty) return 'notumor';
    return probs.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  Color get classColor {
    switch (predictedClass.toLowerCase()) {
      case 'glioma':
        return Colors.redAccent;
      case 'meningioma':
        return Colors.orangeAccent;
      case 'pituitary':
        return Colors.purpleAccent;
      case 'notumor':
      default:
        return Colors.greenAccent;
    }
  }

  String get clinicalDescription {
    switch (predictedClass.toLowerCase()) {
      case 'glioma':
        return 'Se detectó Glioma — tumor originado en células gliales.';
      case 'meningioma':
        return 'Se detectó Meningioma — tumor en las meninges cerebrales.';
      case 'pituitary':
        return 'Se detectó tumor Pituitario — adenoma en la glándula hipófisis.';
      case 'notumor':
      default:
        return 'No se detectó tumor en el escaneo MRI analizado.';
    }
  }
}