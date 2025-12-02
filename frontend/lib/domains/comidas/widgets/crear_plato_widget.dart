import 'package:flutter/material.dart';

// Definimos el callback con TODOS los datos que necesita tu plato
typedef GuardarPlatoCallback = void Function(
    String nombre,
    String descripcion,
    List<String> ingredientes, // Lo pasaremos como lista
    String tiempo,
    String calorias,
    String dificultad,
    int estrellas,
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

  String _dificultad = "Media"; // Valor por defecto
  int _estrellas = 3; // Valor por defecto

  // Lista de dificultades para los Chips
  final List<String> _nivelesDificultad = ["Fácil", "Media", "Difícil"];

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
        _dificultad,
        _estrellas,
      );
      Navigator.pop(context);
    }
  }

  // Widget auxiliar para las estrellas interactivas
  Widget _buildSelectorEstrellas() {
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

            // 4. DIFICULTAD (ChoiceChips)
            const Text("Dificultad:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: _nivelesDificultad.map((nivel) {
                final isSelected = _dificultad == nivel;
                return ChoiceChip(
                  label: Text(nivel),
                  selected: isSelected,
                  selectedColor: Colors.orange,
                  labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                  onSelected: (selected) {
                    if (selected) setState(() => _dificultad = nivel);
                  },
                );
              }).toList(),
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