import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/services/login_service.dart';


class FinanzasService {

  final String _baseUrl = 'http://10.0.2.2:8000/api/movimientos';

  Map<String, String> _token() {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'Bearer ${LoginService.apiToken}',
    };
  }

  //----------------------------------------------------------------------------

  // GET
  Future<List<Map<String, dynamic>>> getMovimientos() async {
    try {
      final respuesta = await http.get(
        Uri.parse(_baseUrl),
        headers: _token(),
      );

      if (respuesta.statusCode == 200) {
        List<dynamic> datos = jsonDecode(respuesta.body);

        return datos.map((item) { //mapeamos los datos -> estructura deseada
          return {
            'id': item['id'],
            'nombre': item['nombre'],
            'cantidad': (item['cantidad'] is String) ? double.parse(item['cantidad']) : item['cantidad'].toDouble(),
            'fecha': item['fecha'], // La fecha ya viene como string 'YYYY-MM-DD' de Laravel, que es lo que espera MovimientoCardWidget.
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

  //----------------------------------------------------------------------------

  // POST
  Future<bool> postMovimiento(String nombre, double cantidad, String fecha, bool esGasto) async {
    try {
      final respuesta = await http.post(
        Uri.parse(_baseUrl),
        headers: _token(),
        body: {
          'nombre': nombre,
          'cantidad': cantidad.toStringAsFixed(2),
          'fecha': fecha,
          'es_gasto': esGasto ? '1' : '0',
        },
      );

      print('Respuesta del servidor (POST): ${respuesta.statusCode}');
      if (respuesta.statusCode != 201) {
        print('Cuerpo del error: ${respuesta.body}');
      }

      return respuesta.statusCode == 201;

    } catch (e) {
      print("Excepción al crear movimiento: $e");
      return false;
    }
  }

  //----------------------------------------------------------------------------

  // DELETE
  Future<bool> deleteMovimiento(int id) async {
    try {
      final respuesta = await http.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: _token(),
      );
      return respuesta.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

