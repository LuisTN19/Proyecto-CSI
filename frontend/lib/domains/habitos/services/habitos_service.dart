import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../../core/services/login_service.dart';


class HabitosService {

  //final String _baseUrl = 'http://10.0.2.2:8000/api/habitos';
  final String _baseUrl = 'http://192.168.1.170:8000/api/habitos';

  Map<String, String> _token() {
    return {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${LoginService.apiToken}',
    };
  }


  // GET------------------------------------------------------------------------
  Future<List<Map<String, dynamic>>> getHabitos() async {
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
            'nombre': item['nombre'],
            'esCompletado': item['esCompletado'] == 1 || item['esCompletado'] == true,
          };
        }).toList().cast<Map<String, dynamic>>();
      } else {
        print("Error ${respuesta.statusCode}: No autorizado o fallo");
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  //----------------------------------------------------------------------------

  // POST
  Future<bool> postHabito(String nombre) async {
    try {
      final respuesta = await http.post(
        Uri.parse(_baseUrl),
        headers: _token(),
        body: {'nombre': nombre},
      );
      return respuesta.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  //----------------------------------------------------------------------------

  // PUT
  Future<bool> putHabito(int id, bool completadoActual) async {
    try {
      final nuevoEstado = !completadoActual;

      final respuesta = await http.put(
        Uri.parse('$_baseUrl/$id'),
        headers: _token(),
        body: {
          'esCompletado': nuevoEstado ? '1' : '0'
        },
      );
      return respuesta.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  //----------------------------------------------------------------------------

  // DELETE
  Future<bool> deleteHabito(int id) async {
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