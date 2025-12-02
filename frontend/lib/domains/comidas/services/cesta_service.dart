import 'package:flutter/material.dart';

class CestaService {
  // Usamos ValueNotifier para que la vista sepa cuándo repintarse
  static final ValueNotifier<List<String>> itemsNotifier = ValueNotifier([]);

  // Añadir ingrediente
  static void agregar(String ingrediente) {
    List<String> listaActual = List.from(itemsNotifier.value);
    if (!listaActual.contains(ingrediente)) {
      listaActual.add(ingrediente);
      itemsNotifier.value = listaActual; // ¡Esto avisa a la vista!
    }
  }

  // Borrar ingrediente
  static void eliminar(String ingrediente) {
    List<String> listaActual = List.from(itemsNotifier.value);
    listaActual.remove(ingrediente);
    itemsNotifier.value = listaActual;
  }

  // Borrar todo
  static void limpiarCesta() {
    itemsNotifier.value = [];
  }
}