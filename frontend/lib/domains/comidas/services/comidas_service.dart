import 'dart:convert'; // para jsonEncode y jsonDecode
import 'package:http/http.dart' as http;
import 'dart:io';

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
      final response = await http.get(    //petición get
          Uri.parse(_baseUrl),
          headers: _token()
      );

      //laravel

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        return data.map((item) {
          return {
            'id': item['id'],
            'nombre': item['nombre'],
            'descripcion': item['descripcion'] ?? "",

            'ingredientes': item['ingredientes'] != null    //laravel madará una lista de ingredientes
                ? List<String>.from(item['ingredientes'])
                : <String>[],

            'tiempo': item['tiempo'] ?? "",
            'calorias': item['calorias'] ?? "",
            'calificacion': (item['calificacion'] ?? 0).toDouble(),
            'favorito': item['favorito'] == true, // Laravel a veces manda 1/0 o true/false
            'url': item['imagen_url'],
          };
        }).toList().cast<Map<String, dynamic>>();     //convertir a listas.forzando q sean de tipo map como prometimos en la cabecera de la función
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  //----------------------------------------------------------------------------

  // POST
  Future<bool> postPlato(String nombre, String descripcion, List<String> ingredientes, String tiempo, String calorias, double estrellas, File? imagen) async {
    try {
      var uri = Uri.parse(_baseUrl);

      //Ya no podemos seguir enviadno un jsonEncode para subir las fotos, necesitamso una petición multipart (que mezcla texto y archivos)
      var request = http.MultipartRequest('POST', uri);   //petición multipart

      //cabeceras: tenemos que poner lo del _token() manualmente
      request.headers['Authorization'] = 'Bearer ${LoginService.apiToken}';
      request.headers['Accept'] = 'application/json';

      //campos
      request.fields['nombre'] = nombre;
      request.fields['descripcion'] = descripcion;
      request.fields['tiempo'] = tiempo;
      request.fields['calorias'] = calorias;
      request.fields['calificacion'] = estrellas.toString();
      request.fields['ingredientes'] = jsonEncode(ingredientes);  //tengo una lista ['Pollo', 'Arroz'], como la caja solo acepta texto, convertir a string usando jsonEncode -> "['Pollo', 'Arroz']"

      //archivo
      if (imagen != null) {
        request.files.add(await http.MultipartFile.fromPath('imagen', imagen.path));
      }

      var streamedResponse = await request.send();
      //laravel
      var response = await http.Response.fromStream(streamedResponse);

      return response.statusCode == 201 || response.statusCode == 200;

    } catch (e) {
      print("Error POST Plato: $e");
      return false;
    }
  }

  //----------------------------------------------------------------------------

  // PUT
  Future<bool> putFAV(int id, Map<String, dynamic> datosActualizar) async {
    try {
      final response = await http.put(    //peticion put
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

  //Laravel no acepta peticiones PUT con archivos -> POST pero con un campo oculto _method = PUT, de esta manera utilizmaos post para q el archivo se envie correctamente pero se redigirá a la funcion update del controlador
  Future<bool> putPLATO(
      int id,
      String nombre, String descripcion, List<String> ingredientes,
      String tiempo, String calorias, double estrellas,
      File? imagen // puede ser null
      ) async {
    try {
      // Usamos POST pero añadimos _method = PUT
      var uri = Uri.parse('$_baseUrl/$id?_method=PUT');

      var request = http.MultipartRequest('POST', uri); //petición multipart

      request.headers['Authorization'] = 'Bearer ${LoginService.apiToken}';
      request.headers['Accept'] = 'application/json';

      request.fields['nombre'] = nombre;
      request.fields['descripcion'] = descripcion;
      request.fields['tiempo'] = tiempo;
      request.fields['calorias'] = calorias;
      request.fields['calificacion'] = estrellas.toString();
      request.fields['ingredientes'] = jsonEncode(ingredientes);

      // Solo adjuntamos fichero si el usuario eligió uno NUEVO
      if (imagen != null) {
        request.files.add(await http.MultipartFile.fromPath('imagen', imagen.path));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      return response.statusCode == 200;
    } catch (e) {
      print("Error UPDATE Plato: $e");
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

