import 'package:flutter/material.dart';

class CestaService {
  static final ValueNotifier<List<String>> itemsNotifier = ValueNotifier([]); //ValueNotifier para que la vista sepa cuándo repintarse


  static void agregar(String ingrediente) {
    List<String> listaActual = List.from(itemsNotifier.value);
    if (!listaActual.contains(ingrediente)) {
      listaActual.add(ingrediente);
      itemsNotifier.value = listaActual;
    }
  }

  static void eliminar(String ingrediente) {
    List<String> listaActual = List.from(itemsNotifier.value);
    listaActual.remove(ingrediente);
    itemsNotifier.value = listaActual;
  }

  static void limpiarCesta() {
    itemsNotifier.value = [];
  }
}