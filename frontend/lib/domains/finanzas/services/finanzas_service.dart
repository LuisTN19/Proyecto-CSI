import 'package:flutter/material.dart'; // Aunque no se use directamente, es común en services
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/services/login_service.dart';
// Asegúrate de que tienes tus modelos Categoria y Movimiento si los usas

class FinanzasService { // 💡 Cambiamos el nombre a MovimientoService

  // 💡 Ruta API para Movimientos
  final String _baseUrl = 'http://10.0.2.2:8000/api/movimientos';

  // 💡 Mantiene la misma lógica de token
  Map<String, String> _token() {
    return {
      'Accept': 'application/json',
      // ¡Importante!: Content-Type para enviar JSON/Formulario
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer ${LoginService.apiToken}',
    };
  }

  // --- 1. GET (OBTENER MOVIMIENTOS) ---------------------------------------------------------------------
  Future<List<Map<String, dynamic>>> getMovimientos() async {
    try {
      final respuesta = await http.get(
        Uri.parse(_baseUrl),
        headers: _token(),
      );

      if (respuesta.statusCode == 200) {
        // El backend devuelve directamente la lista de movimientos
        List<dynamic> datos = jsonDecode(respuesta.body);

        // Mapeamos los datos para asegurar los tipos y la estructura deseada
        return datos.map((item) {
          return {
            'id': item['id'],
            'nombre': item['nombre'],
            // Convertimos la cantidad de String/int a double
            'cantidad': (item['cantidad'] is String) ? double.parse(item['cantidad']) : item['cantidad'].toDouble(),
            // La fecha ya viene como string 'YYYY-MM-DD' de Laravel, que es lo que espera MovimientoCardWidget.
            'fecha': item['fecha'],
            // Laravel devuelve 0/1 o true/false para booleanos.
            'esGasto': item['es_gasto'] == 1 || item['es_gasto'] == true,
          };
        }).toList().cast<Map<String, dynamic>>();

      } else {
        print("Error ${respuesta.statusCode}: No autorizado o fallo al cargar movimientos");
        return [];
      }
    } catch (e) {
      print("Excepción al obtener movimientos: $e");
      return [];
    }
  }

  // --- 2. POST (CREAR MOVIMIENTO) --------------------------------------------------------------------
  Future<bool> postMovimiento(String nombre, double cantidad, String fecha, bool esGasto) async {
    try {
      final respuesta = await http.post(
        Uri.parse(_baseUrl),
        headers: _token(),
        // 💡 Datos a enviar al endpoint POST /movimientos
        body: {
          'nombre': nombre,
          // La cantidad la enviamos como String para el backend
          'cantidad': cantidad.toStringAsFixed(2),
          // La fecha debe ser 'YYYY-MM-DD' para Laravel. Asumo que ya la formateaste en Flutter.
          'fecha': fecha,
          // Convertimos el booleano a String '1' o '0' para el formulario URL-encoded
          'es_gasto': esGasto ? '1' : '0',
        },
      );

      print('Respuesta del servidor (POST): ${respuesta.statusCode}');
      if (respuesta.statusCode != 201) {
        print('Cuerpo del error: ${respuesta.body}');
      }

      // El backend devuelve 201 Created si tuvo éxito
      return respuesta.statusCode == 201;

    } catch (e) {
      print("Excepción al crear movimiento: $e");
      return false;
    }
  }
}