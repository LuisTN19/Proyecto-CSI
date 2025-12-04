import 'package:flutter/material.dart';

// Mixin -> clase que permite reutilizar métodos y propiedades en otras clases mediante la palabra with
mixin SelectionMixin<T extends StatefulWidget> on State<T> {

  Set<int> seleccionados = {};

  bool get haySeleccion => seleccionados.isNotEmpty;

  void multiSeleccion(int id) {
    setState(() {
      if (seleccionados.contains(id)) {
        seleccionados.remove(id);
      } else {
        seleccionados.add(id);
      }
    });
  }

  void limpiarSeleccion() {
    setState(() {
      seleccionados.clear();
    });
  }
}