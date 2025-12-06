import 'dart:convert'; // para jsonEncode y jsonDecode
import 'package:http/http.dart' as http;
import '../../../../core/services/login_service.dart';

class ComidasService {

  final String _baseUrl = 'http://10.0.2.2:8000/api/platos';

  Map<String, String> _token() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${LoginService.apiToken}',
    };
  }

  //----------------------------------------------------------------------------

  // GET
  Future<List<Map<String, dynamic>>> getPlatos() async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: _token(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data.map((item) {
          return {
            'id': item['id'],
            'nombre': item['nombre'],
            'descripcion': item['descripcion'] ?? "",
            'ingredientes': List<String>.from(item['ingredientes'] ?? []),
            'tiempo': item['tiempo'] ?? "",
            'calorias': item['calorias'] ?? "",
            'calificacion': (item['calificacion'] ?? 0).toDouble(),
            'favorito': item['favorito'] == 1 || item['favorito'] == true,
            'url': item['imagen_url'],
            'placeholderIcon': null,
          };
        }).toList().cast<Map<String, dynamic>>();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  //----------------------------------------------------------------------------

  // POST
  Future<bool> postPlato(Map<String, dynamic> platoData) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _token(),

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

  //----------------------------------------------------------------------------

  // PUT
  Future<bool> updatePlato(int id, Map<String, dynamic> datosActualizar) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/$id'),
        headers: _token(),
        body: jsonEncode(datosActualizar),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("Error PUT Plato: $e");
      return false;
    }
  }

  //----------------------------------------------------------------------------

  //DELETE
  Future<bool> deletePlato(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: _token(),
      );

      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print("Error DELETE Plato: $e");
      return false;
    }
  }
}

