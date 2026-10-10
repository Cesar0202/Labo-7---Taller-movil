import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/clasificacion_result.dart';
import '../services/api_service.dart';

enum EstadoApp { inicial, cargando, exito, error }

class ClasificacionController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final ImagePicker _picker = ImagePicker();

  EstadoApp estado = EstadoApp.inicial;
  XFile? imagenSeleccionada;
  ClasificacionResult? resultado;
  String? mensajeError;

  Future<void> seleccionarImagen(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(source: source);
      if (file != null) {
        imagenSeleccionada = file;
        resultado = null;
        estado = EstadoApp.inicial;
        mensajeError = null;
        notifyListeners();
      }
    } catch (e) {
      mensajeError = 'Error al seleccionar imagen: $e';
      estado = EstadoApp.error;
      notifyListeners();
    }
  }

  Future<void> clasificar() async {
    if (imagenSeleccionada == null) return;

    estado = EstadoApp.cargando;
    mensajeError = null;
    notifyListeners();

    try {
      resultado = await _apiService.clasificarImagen(imagenSeleccionada!);
      estado = EstadoApp.exito;
    } catch (e) {
      mensajeError = e.toString();
      estado = EstadoApp.error;
    } finally {
      notifyListeners();
    }
  }

  void reiniciar() {
    imagenSeleccionada = null;
    resultado = null;
    estado = EstadoApp.inicial;
    mensajeError = null;
    notifyListeners();
  }
}