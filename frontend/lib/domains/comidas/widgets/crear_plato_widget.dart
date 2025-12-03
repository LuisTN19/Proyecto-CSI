import 'package:flutter/material.dart';

// Definimos el callback con TODOS los datos que necesita tu plato
typedef GuardarPlatoCallback = void Function(
    String nombre,
    String descripcion,
    List<String> ingredientes, // Lo pasaremos como lista
    String tiempo,
    String calorias,
    double estrellas,
    );

class CrearPlatoWidget extends StatefulWidget {
  final GuardarPlatoCallback onGuardar;

  const CrearPlatoWidget({
    super.key,
    required this.onGuardar,
  });

  @override
  State<CrearPlatoWidget> createState() => _CrearPlatoWidgetState();
}

class _CrearPlatoWidgetState extends State<CrearPlatoWidget> {
  // --- VARIABLES DE ESTADO ---
  String _nombre = "";
  String _descripcion = "";
  String _ingredientesTexto = ""; // El usuario escribirá separado por comas
  String _tiempo = "";
  String _calorias = "";

  double _estrellas = 3.0; // Valor por defecto


  // FUNCIÓN GUARDAR
  void _guardarPlato() {
    if (_nombre.isNotEmpty) {
      // Convertimos el texto de ingredientes en una Lista
      // Ej: "Pollo, Arroz, Sal" -> ["Pollo", "Arroz", "Sal"]
      List<String> listaIngredientes = _ingredientesTexto.isNotEmpty
          ? _ingredientesTexto.split(',').map((e) => e.trim()).toList()
          : [];

      widget.onGuardar(
        _nombre,
        _descripcion,
        listaIngredientes,
        _tiempo,
        _calorias,
        _estrellas,
      );
      Navigator.pop(context);
    }
  }

  // Widget auxiliar para las estrellas interactivas
  /*Widget _buildSelectorEstrellas() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _estrellas ? Icons.star : Icons.star_border,
            color: Colors.orange,
            size: 32,
          ),
          onPressed: () {
            setState(() {
              _estrellas = index + 1;
            });
          },
        );
      }),
    );
  }*/
  Widget _buildSelectorEstrellas() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        // Lógica para saber qué icono pintar
        IconData icono = Icons.star_border;
        if (_estrellas >= index + 1) {
          icono = Icons.star;       // Llena
        } else if (_estrellas >= index + 0.5) {
          icono = Icons.star_half;  // Media
        }

        return IconButton(
          icon: Icon(icono, color: Colors.orange, size: 32),
          onPressed: () {
            setState(() {
              double valorPulsado = index + 1.0;

              // 💡 EL TRUCO:
              // Si pulso una estrella que ya tengo (ej: 4), la bajo a media (3.5).
              // Si no, la pongo entera.
              if (_estrellas == valorPulsado) {
                _estrellas = valorPulsado - 0.5;
              } else {
                _estrellas = valorPulsado;
              }
            });
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Nuevo Plato"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // 1. NOMBRE
            TextField(
              autofocus: true,
              decoration: const InputDecoration(
                labelText: "Nombre del plato",
                hintText: "Ej: Lentejas",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.restaurant),
              ),
              onChanged: (val) => _nombre = val,
            ),
            const SizedBox(height: 15),

            // 2. DESCRIPCIÓN
            TextField(
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Descripción",
                hintText: "Breve resumen...",
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => _descripcion = val,
            ),
            const SizedBox(height: 15),

            // 3. DATOS RÁPIDOS (Tiempo y Calorías en una fila)
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Tiempo",
                      hintText: "45 min",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.access_time),
                    ),
                    onChanged: (val) => _tiempo = val,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Kcal",
                      hintText: "450",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.local_fire_department),
                    ),
                    onChanged: (val) => _calorias = val,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // 5. INGREDIENTES
            TextField(
              decoration: const InputDecoration(
                labelText: "Ingredientes (separados por coma)",
                hintText: "Pollo, Arroz, Ajo...",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.shopping_basket),
              ),
              onChanged: (val) => _ingredientesTexto = val,
            ),
            const SizedBox(height: 15),

            // 6. ESTRELLAS
            const Text("Valoración:", style: TextStyle(fontWeight: FontWeight.bold)),
            _buildSelectorEstrellas(),
          ],
        ),
      ),

      // BOTONES
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: _guardarPlato,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
          child: const Text("Guardar"),
        ),
      ],
    );
  }
}