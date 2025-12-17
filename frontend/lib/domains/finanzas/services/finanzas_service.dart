import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../core/services/login_service.dart';


class FinanzasService {

  //final String _baseUrl = 'http://10.0.2.2:8000/api/movimientos';
  final String _baseUrl = 'http://192.168.1.170:8000/api/movimientos';

  Map<String, String> _token() {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
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
            'cantidad': (item['cantidad'] as num).toDouble(), //Laravel promete enviar un número (casts), solo nos aseguramos de que sea Double
            'fecha': item['fecha'], // La fecha ya viene como string 'YYYY-MM-DD' de Laravel, que es lo que espera MovimientoCardWidget.
            'esGasto': item['esGasto'] == 1 || item['esGasto'] == true,
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

  Future<List<Map<String, dynamic>>> getResumenMensual() async {
    try {
      final respuesta = await http.get(
        Uri.parse('$_baseUrl/resumen'),
        headers: _token(),
      );

      if (respuesta.statusCode == 200) {
        List<dynamic> datos = jsonDecode(respuesta.body);
        return datos.cast<Map<String, dynamic>>();
      }

      return [];
    } catch (e) {
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
        body: jsonEncode({
          'nombre': nombre,
          'cantidad': cantidad,
          'fecha': fecha,
          'esGasto': esGasto ? '1' : '0',
        }),
      );
      return respuesta.statusCode == 201;
    } catch (e) {
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

