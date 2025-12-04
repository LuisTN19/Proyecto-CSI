import 'package:flutter/material.dart';

typedef GuardarPlatoCallback = void Function(
    String nombre,
    String descripcion,
    List<String> ingredientes,
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
  String _nombre = "";
  String _descripcion = "";
  String _ingredientesTexto = "";
  String _tiempo = "";
  String _calorias = "";
  double _estrellas = 3.0;



  void _guardarPlato() {
    if (_nombre.isNotEmpty) {

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

  Widget _buildSelectorEstrellas() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        IconData icono = Icons.star_border;
        if (_estrellas >= index + 1) {
          icono = Icons.star;
        } else if (_estrellas >= index + 0.5) {
          icono = Icons.star_half;
        }

        return IconButton(
          icon: Icon(icono, color: Colors.orange, size: 32),
          onPressed: () {
            setState(() {
              double valorPulsado = index + 1.0;

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

  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Nuevo Plato"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // NOMBRE
            TextField(
              autofocus: true,
              decoration: const InputDecoration(
                labelText: "Nombre del plato",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.restaurant),
              ),
              onChanged: (val) => _nombre = val,
            ),
            const SizedBox(height: 15),

            // DESCRIPCIÓN
            TextField(
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: "Descripción",
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => _descripcion = val,
            ),
            const SizedBox(height: 15),

            // Tiempo y Calorías
            Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Tiempo",
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
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.local_fire_department),
                    ),
                    onChanged: (val) => _calorias = val,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // INGREDIENTES
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

            // ESTRELLAS
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