import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../core/services/login_service.dart';


class AgendaService {

  final String _baseUrl = 'http://10.0.2.2:8000/api/eventos';

  Map<String, String> _token() {
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${LoginService.apiToken}',
    };
  }

  //----------------------------------------------------------------------------

  // GET
  Future<List<Map<String, dynamic>>> getEventos() async {
    try {
      final respuesta = await http.get(
        Uri.parse(_baseUrl),
        headers: _token(),
      );

      if (respuesta.statusCode == 200) {
        List<dynamic> datos = jsonDecode(respuesta.body);

        return datos.map((item) {
          return {
            'id': item['id'],
            'titulo': item['titulo'],
            'fecha': item['fecha'], // La fecha viene como string 'YYYY-MM-DD'
            // Podrías necesitar colores si quieres que sean fijos por evento (no aleatorios por carga)
            // 'color': Colors.green.shade100
          };
        }).toList().cast<Map<String, dynamic>>();
      } else {
        print("Error ${respuesta.statusCode}: No autorizado o fallo al obtener eventos");
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  //----------------------------------------------------------------------------

  // POST
  Future<bool> postEvento(String titulo, String fecha) async {
    try {
      final respuesta = await http.post(
        Uri.parse(_baseUrl),
        headers: _token(),
        body: {
          'titulo': titulo,
          'fecha': fecha,
        },
      );

      if (respuesta.statusCode != 201) {
        print('--- ERROR DE LARAVEL (${respuesta.statusCode}) ---');
        print('Cuerpo de la respuesta: ${respuesta.body}');
        print('-------------------------------------------');
      }

      return respuesta.statusCode == 201;
    } catch (e) {
      print('Excepción al enviar evento: $e');
      return false;
    }
  }

  //----------------------------------------------------------------------------

  // DELETE
  Future<bool> deleteEvento(int id) async {
    try {
      final respuesta = await http.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: _token(),
      );
      return respuesta.statusCode == 200 || respuesta.statusCode == 204;
    } catch (e) {
      return false;
    }
  }


}
