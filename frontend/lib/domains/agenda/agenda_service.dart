import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart'; // Necesario para Colors.
import '../../../core/services/login_service.dart';


class AgendaService {

  // 💡 URL cambiada a 'eventos'
  final String _baseUrl = 'http://10.0.2.2:8000/api/eventos';

  Map<String, String> _token() {
    return {
      'Accept': 'application/json',
      // 💡 Usamos el token que está guardado en LoginService
      'Authorization': 'Bearer ${LoginService.apiToken}',
    };
  }

  // 1. GET (Cargar Eventos) ---------------------------------------------------
  Future<List<Map<String, dynamic>>> getEventos() async {
    try {
      final respuesta = await http.get(
        Uri.parse(_baseUrl),
        headers: _token(),
      );

      if (respuesta.statusCode == 200) {
        List<dynamic> datos = jsonDecode(respuesta.body);

        return datos.map((item) {
          // 💡 Adaptación de campos: 'titulo' y 'fecha'
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

  // 2. POST (Crear Evento) ----------------------------------------------------
  // Necesita el título y la fecha (que se enviará como String 'YYYY-MM-DD')
  Future<bool> postEvento(String titulo, String fecha) async {
    try {
      final respuesta = await http.post(
        Uri.parse(_baseUrl),
        headers: _token(),
        // 💡 Adaptación de campos: enviamos 'titulo' y 'fecha'
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

      // Laravel devuelve 201 Created si es exitoso
      return respuesta.statusCode == 201;
    } catch (e) {
      print('Excepción al enviar evento: $e');
      return false;
    }
  }
}