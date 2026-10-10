import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../models/clasificacion_result.dart';

class ApiService {
  // En emulador Android: 10.0.2.2 apunta al localhost de tu PC
  // En dispositivo físico por USB/Wifi: usa la IP local de tu PC (ej. http://192.168.1.XX:5000)
  // Al desplegar en Render: se reemplaza por la URL de Render (https://....onrender.com)
  static const String baseUrl = 'http://127.0.0.1:5000';

  Future<ClasificacionResult> clasificarImagen(XFile imagen) async {
    final uri = Uri.parse('$baseUrl/api/clasificar');
    final request = http.MultipartRequest('POST', uri);

    final bytes = await imagen.readAsBytes();
    final multipartFile = http.MultipartFile.fromBytes(
      'image',
      bytes,
      filename: imagen.name.isNotEmpty ? imagen.name : 'mri_scan.jpg',
    );
    request.files.add(multipartFile);

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ClasificacionResult.fromJson(data);
    } else {
      throw Exception('Error del servidor (${response.statusCode}): ${response.body}');
    }
  }
}