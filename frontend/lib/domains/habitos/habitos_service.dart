import 'package:flutter/material.dart'; // Para los colores
import 'dart:convert'; // Para traducir el JSON que viene de Laravel
import 'package:http/http.dart' as http; // El "teléfono" para llamar a la API

class HabitosService {

  // LA DIRECCIÓN DE TU CAMARERO (API LARAVEL)
  // Usamos 10.0.2.2 para que el emulador encuentre tu PC
  final String _baseUrl = 'http://10.0.2.2:8000/api/habitos';

  // -------------------------------------------------------------
  // 1. OBTENER LISTA (GET)
  // Pide todos los hábitos a la base de datos
  // -------------------------------------------------------------
  Future<List<Map<String, dynamic>>> getHabitos() async {
    try {
      final respuesta = await http.get(Uri.parse(_baseUrl));

      if (respuesta.statusCode == 200) {
        // Convertimos el texto JSON del servidor a una Lista
        List<dynamic> datos = jsonDecode(respuesta.body);

        // Transformamos cada dato para que Flutter lo entienda bien
        return datos.map((item) {
          return {
            'id': item['id'], // Guardamos el ID (¡Importante para editar/borrar!)
            'nombre': item['nombre'],
            // MySQL a veces devuelve 1/0 en vez de true/false, esto lo arregla:
            'completado': item['completado'] == 1 || item['completado'] == true,
            // Como en la BD no guardamos color, le ponemos uno bonito por defecto
            'color': Colors.blue.shade100
          };
        }).toList().cast<Map<String, dynamic>>();
      } else {
        print("Error del servidor: ${respuesta.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error de conexión al cargar: $e");
      return [];
    }
  }

  // -------------------------------------------------------------
  // 2. AÑADIR HÁBITO (POST)
  // Envía un nuevo hábito para guardarlo
  // -------------------------------------------------------------
  Future<bool> agregarHabito(String nombre) async {
    try {
      final respuesta = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Accept': 'application/json'}, // Importante para Laravel
        body: {
          'nombre': nombre,
          // 'completado' no hace falta enviarlo, Laravel lo pone false por defecto
        },
      );

      // Si devuelve 201 (Created), todo ha ido bien
      return respuesta.statusCode == 201;

    } catch (e) {
      print("Error al crear: $e");
      return false;
    }
  }

  // -------------------------------------------------------------
  // 3. MARCAR/DESMARCAR (PUT)
  // Actualiza si está completado o no
  // -------------------------------------------------------------
  Future<bool> toggleCompletado(int id, bool completadoActual) async {
    try {
      // Le decimos a Laravel: "Pon el estado CONTRARIO al que tiene ahora"
      final nuevoEstado = !completadoActual;

      final respuesta = await http.put(
        Uri.parse('$_baseUrl/$id'), // Añadimos el ID a la URL
        headers: {'Accept': 'application/json'}, // Para hablar JSON
        body: {
          'completado': nuevoEstado ? '1' : '0' // Enviamos 1 o 0
        },
      );

      return respuesta.statusCode == 200;

    } catch (e) {
      print("Error al actualizar: $e");
      return false;
    }
  }

  // -------------------------------------------------------------
  // 4. BORRAR (DELETE)
  // Elimina el hábito de la base de datos
  // -------------------------------------------------------------
  Future<bool> borrarHabito(int id) async {
    try {
      final respuesta = await http.delete(
          Uri.parse('$_baseUrl/$id')
      );

      return respuesta.statusCode == 200;

    } catch (e) {
      print("Error al borrar: $e");
      return false;
    }
  }
}