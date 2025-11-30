import 'package:flutter/material.dart'; // Aunque no se use directamente, es común en services
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/services/login_service.dart';
// Asegúrate de que tienes tus modelos Categoria y Movimiento si los usas

class FinanzasService {

  // Base URL para las rutas de la API de Laravel
  final String _baseUrl = 'http://10.0.2.2:8000/api';

  // --- FUNCIÓN DE AUTENTICACIÓN ---
  Map<String, String> _token() {
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${LoginService.apiToken}',
    };
  }

  // --------------------------------------------------------------------------
  // 1. OBTENER MOVIMIENTOS (GET /api/movimientos)
  // --------------------------------------------------------------------------

  Future<List<Map<String, dynamic>>> getMovimientos() async {
    try {
      final url = Uri.parse('$_baseUrl/movimientos');
      final respuesta = await http.get(
        url,
        headers: _token(),
      );

      if (respuesta.statusCode == 200) {
        List<dynamic> datos = jsonDecode(respuesta.body);

        // Mapeo básico de los campos requeridos
        return datos.map((item) {
          return {
            'id': item['id'],
            'nombre': item['nombre'],
            // Convertimos la cantidad a double de forma segura
            'cantidad': (item['cantidad'] as num).toDouble(),
            'fecha': item['fecha'],
            'esGasto': item['es_gasto'] as bool,
          };
        }).toList().cast<Map<String, dynamic>>();

      } else {
        print("Error ${respuesta.statusCode} al obtener movimientos.");
        return [];
      }
    } catch (e) {
      print("Excepción al obtener movimientos: $e");
      return [];
    }
  }


  // --------------------------------------------------------------------------
  // 2. CREAR MOVIMIENTO (POST /api/movimientos)
  // --------------------------------------------------------------------------

  Future<bool> postMovimiento({
    required String nombre,
    required double cantidad,
    required bool esGasto,
    required String fecha, // Formato 'YYYY-MM-DD'
    int? categoriaId, // Opcional (Siempre será null por ahora)
  }) async {
    try {
      // Body de la petición: solo los campos esenciales
      final Map<String, dynamic> body = {
        'nombre': nombre,
        // Enviar como string con 2 decimales para Laravel
        'cantidad': cantidad.toStringAsFixed(2),
        // Enviar booleanos como string '1' o '0' para la validación de Laravel
        'es_gasto': esGasto ? '1' : '0',
        'fecha': fecha,
      };

      final Map<String, String> headers = _token();
      headers['Content-Type'] = 'application/x-www-form-urlencoded';

      final url = Uri.parse('$_baseUrl/movimientos');
      final respuesta = await http.post(
        url,
        headers: _token(),
        body: body,
      );

      // La respuesta 201 Created indica éxito
      return respuesta.statusCode == 201;

    } catch (e) {
      print("Excepción al crear movimiento: $e");
      return false;
    }
  }

}