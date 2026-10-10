import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../controllers/clasificacion_controller.dart';
import '../widgets/result_card.dart';
import '../widgets/probability_chart.dart';

class ClasificacionView extends StatelessWidget {
  const ClasificacionView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ClasificacionController>();

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Color(0xFF334155),
            child: Icon(Icons.psychology, color: Colors.white),
          ),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('BrainScan CNN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
            Text('Clasificador de tumores cerebrales', style: TextStyle(fontSize: 12, color: Colors.white54)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white70),
            onPressed: controller.reiniciar,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Contenedor de Imagen MRI
            Container(
              height: 260,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
              ),
              clipBehavior: Clip.antiAlias,
              child: controller.imagenSeleccionada == null
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate_outlined, size: 64, color: Colors.white30),
                        SizedBox(height: 12),
                        Text('Selecciona una imagen MRI', style: TextStyle(color: Colors.white70, fontSize: 15)),
                        SizedBox(height: 4),
                        Text('Galería o cámara', style: TextStyle(color: Colors.white38, fontSize: 12)),
                      ],
                    )
                  : kIsWeb
                      ? Image.network(controller.imagenSeleccionada!.path, fit: BoxFit.contain)
                      : Image.file(File(controller.imagenSeleccionada!.path), fit: BoxFit.contain),
            ),
            const SizedBox(height: 16),

            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.blueAccent),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => controller.seleccionarImagen(ImageSource.gallery),
                    icon: const Icon(Icons.folder_open),
                    label: const Text('Seleccionar Imagen'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: controller.imagenSeleccionada != null && controller.estado != EstadoApp.cargando
                        ? controller.clasificar
                        : null,
                    icon: const Icon(Icons.saved_search),
                    label: const Text('Clasificar Imagen'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Estados de Carga, Error y Éxito
            if (controller.estado == EstadoApp.cargando)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  children: [
                    CircularProgressIndicator(color: Colors.blueAccent),
                    SizedBox(height: 12),
                    Text('Analizando imagen con CNN...', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),

            if (controller.estado == EstadoApp.error)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.redAccent),
                ),
                child: Text(
                  controller.mensajeError ?? 'Ocurrió un error',
                  style: const TextStyle(color: Colors.redAccent),
                ),
              ),

            if (controller.estado == EstadoApp.exito && controller.resultado != null) ...[
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('Resultado', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              ResultCard(result: controller.resultado!),
              const SizedBox(height: 16),
              ProbabilityChart(result: controller.resultado!),
            ],
          ],
        ),
      ),
    );
  }
}