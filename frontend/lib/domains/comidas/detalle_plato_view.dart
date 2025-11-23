import 'package:flutter/material.dart';

class DetallePlatoView extends StatelessWidget {

  final String nombre;

  // Datos simulados
  final String descripcion = "Un plato delicioso y tradicional, perfecto para cualquier ocasión. Se cocina a fuego lento para mantener todo el sabor.";
  final List<String> ingredientes = ["Pollo", "Aceite", "Ajo", "Sal", "Pimienta", "Laurel"];
  final String categoria = "Carnes";

  // Datos
  final String tiempo = "45 min";
  final String calorias = "450 kcal";
  final String dificultad = "Media";
  DetallePlatoView({
    super.key,
    required this.nombre,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(nombre),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () { print("Editar"); },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () { print("Borrar"); },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // FOTO
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.restaurant_menu, size: 100, color: Colors.orange),
              ),

              const SizedBox(height: 24),

              // TÍTULO Y CATEGORÍA
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      nombre,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Chip(
                    label: Text(categoria, style: const TextStyle(color: Colors.orange)),
                    backgroundColor: Colors.orange.shade50,
                    side: BorderSide.none,
                  ),
                ],
              ),

              // ESTRELLAS
              const Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 24),
                  Icon(Icons.star, color: Colors.amber, size: 24),
                  Icon(Icons.star, color: Colors.amber, size: 24),
                  Icon(Icons.star, color: Colors.amber, size: 24),
                  Icon(Icons.star_half, color: Colors.amber, size: 24),
                ],
              ),

              const SizedBox(height: 24),

              // DESCRIPCIÓN
              const Text(
                "Descripción",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                descripcion,
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),

              const SizedBox(height: 24),

              // INGREDIENTES
              const Text(
                "Ingredientes",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Wrap(
                spacing: 8.0,
                children: ingredientes.map((ing) => Chip(label: Text(ing))).toList(),
              ),

              const SizedBox(height: 32),

              // DATOS EXTRA
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _DatoIcono(Icons.access_time, tiempo),
                    _DatoIcono(Icons.local_fire_department, calorias),
                    // ¡VUELVE LA DIFICULTAD!
                    _DatoIcono(Icons.bar_chart, dificultad),
                  ],
                ),
              ),
              // -----------------------------------------

              const SizedBox(height: 40),

            ],
          ),
        ),
      ),
    );
  }
}

// --- WIDGET PRIVADO ---
class _DatoIcono extends StatelessWidget {
  final IconData icono;
  final String texto;

  const _DatoIcono(this.icono, this.texto);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icono, color: Colors.orange, size: 28),
        const SizedBox(height: 4),
        Text(texto, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }
}