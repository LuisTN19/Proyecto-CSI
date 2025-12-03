import 'dart:convert'; // Necesario para jsonEncode y jsonDecode
import 'package:http/http.dart' as http;
import '../../../../core/services/login_service.dart';

class PlatosService {

  // URL de tu API (Asegúrate de que el puerto 8000 es correcto)
  final String _baseUrl = 'http://10.0.2.2:8000/api/platos';

  // 💡 HEADERS: Importante 'Content-Type: application/json' para enviar arrays
  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${LoginService.apiToken}',
    };
  }

  // 1. GET (Obtener todos los platos)
  Future<List<Map<String, dynamic>>> getPlatos() async {
    try {
      print("📡 Lanzando petición GET a $_baseUrl...");

      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: _getHeaders(),
      );

      print("📡 Código de respuesta: ${response.statusCode}");

      if (response.statusCode == 200) {
        // Imprimimos el cuerpo crudo para ver qué envía Laravel
        print("📦 Cuerpo recibido: ${response.body}");

        final List<dynamic> data = jsonDecode(response.body);

        // Mapeamos
        final listado = data.map((item) {
          return {
            'id': item['id'],
            'nombre': item['nombre'],
            'descripcion': item['descripcion'] ?? "",
            // Ojo aquí, a veces Laravel envía null y explota el cast
            'ingredientes': List<String>.from(item['ingredientes'] ?? []),
            'tiempo': item['tiempo'] ?? "",
            'calorias': item['calorias'] ?? "",
            // Forzamos conversión a double por si llega como int o string
            'calificacion': (item['calificacion'] ?? 0).toDouble(),
            'favorito': item['favorito'] == 1 || item['favorito'] == true,
            'url': item['imagen_url'],
            'placeholderIcon': null,
          };
        }).toList().cast<Map<String, dynamic>>();

        print("✅ Platos procesados correctamente: ${listado.length}");
        return listado;
      } else {
        print("❌ Error del servidor: ${response.body}");
        return [];
      }
    } catch (e) {
      // ESTE ES EL PRINT MÁS IMPORTANTE
      print("💥 EXCEPCIÓN AL LEER PLATOS: $e");
      return [];
    }
  }

  // 2. POST (Crear plato)
  Future<bool> postPlato(Map<String, dynamic> platoData) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _getHeaders(),
        // 💡 IMPORTANTE: Usamos jsonEncode para enviar el array de ingredientes
        body: jsonEncode({
          'nombre': platoData['nombre'],
          'descripcion': platoData['descripcion'],
          'ingredientes': platoData['ingredientes'], // Lista de Strings
          'tiempo': platoData['tiempo'],
          'calorias': platoData['calorias'],
          'calificacion': platoData['calificacion'],
          'imagen_url': platoData['url'],
          // 'favorito' lo pone Laravel a false por defecto
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      print("Error POST Plato: $e");
      return false;
    }
  }

  // 3. PUT (Actualizar plato - ej: Favorito)
  Future<bool> updatePlato(int id, Map<String, dynamic> datosActualizar) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/$id'),
        headers: _getHeaders(),
        body: jsonEncode(datosActualizar),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Error PUT Plato: $e");
      return false;
    }
  }

  // Helper simple para asignar iconos si no hay foto (puedes mejorarlo)
  // Esto es solo visual para el frontend si no viene foto
  dynamic _getIconoPorNombre(String nombre) {
    // Aquí podrías poner lógica según el nombre, o devolver uno genérico
    return null; // Devolvemos null para que la vista decida o use el default
  }
}