import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../../../core/services/login_service.dart';

class CestaService {

  //final String _baseUrl = 'http://10.0.2.2:8000/api/cesta';
  final String _baseUrl = 'http://192.168.1.170:8000/api/cesta';


  //Ahora la lista guarda objetos con ID y Nombre, no solo texto : [{'id': 10, 'nombre': 'Leche'}, {'id': 11, 'nombre': 'Pan'}]
  //static (memoria global) para que la pestaña de Platos y la de Cesta compartan la misma lista
  static final ValueNotifier<List<Map<String, dynamic>>> itemsNotifier = ValueNotifier([]); //ValueNotifier para que la vista sepa cuándo repintarse

  Map<String, String> _token() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${LoginService.apiToken}',
    };
  }

  Future<void> getCesta() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl), headers: _token());

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        itemsNotifier.value = data.map((item) => {
          'id': item['id'],
          'nombre': item['nombre'],
        }).toList().cast<Map<String, dynamic>>();
      }
    } catch (e) {
      print("Error cargando cesta: $e");
    }
  }

  Future<void> postCesta(String nombreIngrediente) async {
    // Evitar duplicados
    bool existe = itemsNotifier.value.any((item) => item['nombre'] == nombreIngrediente);
    if (existe) return;

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _token(),
        body: jsonEncode({'nombre': nombreIngrediente}),
      );

      if (response.statusCode == 201) {
        await getCesta();
      }
    } catch (e) {
      print("Error añadiendo a cesta: $e");
    }
  }

  Future<void> deleteCesta(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: _token(),
      );

      if (response.statusCode == 200) {
        List<Map<String, dynamic>> listaActual = List.from(itemsNotifier.value);
        listaActual.removeWhere((item) => item['id'] == id);
        itemsNotifier.value = listaActual;
      }
    } catch (e) {
      print("Error eliminando de cesta: $e");
    }
  }

  Future<void> limpiarCesta() async {
    final lista = List.from(itemsNotifier.value);

    itemsNotifier.value = [];

    for (var item in lista) {
      try {
        await http.delete(
          Uri.parse('$_baseUrl/${item['id']}'),
          headers: _token(),
        );
      } catch (e) {
        print("Error borrando item ${item['id']}: $e");
      }
    }
    await getCesta();
  }
}