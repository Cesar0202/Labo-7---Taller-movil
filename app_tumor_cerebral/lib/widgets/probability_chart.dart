import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/clasificacion_result.dart';

class ProbabilityChart extends StatelessWidget {
  final ClasificacionResult result;

  const ProbabilityChart({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final classes = ['glioma', 'meningioma', 'notumor', 'pituitary'];
    final probs = result.probs;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Probabilidades por clase',
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                maxY: 1.0,
                barTouchData: BarTouchData(enabled: true),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 36,
                      getTitlesWidget: (val, meta) => Text(
                        '${(val * 100).toInt()}%',
                        style: const TextStyle(color: Colors.white54, fontSize: 10),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx >= 0 && idx < classes.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              classes[idx],
                              style: const TextStyle(color: Colors.white70, fontSize: 10),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                gridData: const FlGridData(show: true, drawVerticalLine: false),
                barGroups: List.generate(classes.length, (i) {
                  final className = classes[i];
                  final prob = probs[className] ?? 0.0;
                  final isMax = className == result.predictedClass;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: prob,
                        color: isMax ? result.classColor : Colors.blueGrey,
                        width: 24,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
          const Divider(color: Colors.white24, height: 30),
          const Text(
            'Detalles',
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...classes.map((cls) {
            final val = probs[cls] ?? 0.0;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.circle, size: 10, color: cls == result.predictedClass ? result.classColor : Colors.blueGrey),
                      const SizedBox(width: 8),
                      Text(cls, style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                  Text(
                    '${(val * 100).toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: cls == result.predictedClass ? result.classColor : Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}