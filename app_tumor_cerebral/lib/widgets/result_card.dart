import 'package:flutter/material.dart';
import '../models/clasificacion_result.dart';

class ResultCard extends StatelessWidget {
  final ClasificacionResult result;

  const ResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final color = result.classColor;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5), width: 1.5),
      ),
      child: Column(
        children: [
          Icon(Icons.warning_amber_rounded, color: color, size: 48),
          const SizedBox(height: 8),
          Text(
            result.predictedClass.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            result.clinicalDescription,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }
}