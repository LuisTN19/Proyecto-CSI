import 'package:flutter/material.dart';
import 'package:tugestor/core/widgets/menu_inferior_widget.dart'; // Ajusta la ruta si es necesario

import '../services/cesta_service.dart';
class DetallePlatoView extends StatelessWidget {

  final String nombre;
  final String? imagenUrl; // 💡 1. NUEVO: Recibimos la URL de la imagen (opcional)

  final String descripcion;
  final List<String> ingredientes;
  final String tiempo;
  final String calorias;
  final double estrellas;


  DetallePlatoView({
    super.key,
    required this.nombre,
    this.imagenUrl, // 💡 2. AÑADIDO AL CONSTRUCTOR
    required this.descripcion,
    required this.ingredientes,
    required this.tiempo,
    required this.calorias,
    required this.estrellas,
  });

  @override
  Widget build(BuildContext context) {
    return MenuInferiorWidget(

      appBar: AppBar(
        title: Text(nombre),
        //backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            color: Colors.white,
            onPressed: () { print("Editar"); },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            color: Colors.red,
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

              // 💡 3. FOTO CON LÓGICA (Si hay URL ? Foto : Icono)
              ClipRRect( // ClipRRect recorta la imagen para que tenga bordes redondeados
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    // Si no hay imagen, usamos el naranja claro de fondo.
                    // Si hay imagen, el Image.network la tapará, así que no importa.
                    color: Colors.orange.shade100,
                  ),
                  child: imagenUrl != null && imagenUrl!.isNotEmpty
                      ? Image.network(
                    imagenUrl!,
                    fit: BoxFit.cover, // La imagen llena todo el hueco
                    errorBuilder: (context, error, stackTrace) {
                      // Si la URL falla (ej: 404), mostramos el icono de reserva
                      return const Icon(Icons.restaurant_menu, size: 100, color: Colors.orange);
                    },
                  )
                      : const Icon(Icons.restaurant_menu, size: 100, color: Colors.orange), // Si es null, mostramos icono
                ),
              ),

              const SizedBox(height: 24),

              // TÍTULO
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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ingredientes", // Título original
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  // 💡 BOTÓN MÁGICO PARA AÑADIR TODO DE UNA VEZ
                  TextButton.icon(
                    icon: Icon(Icons.shopping_basket, size: 18, color: Colors.orange),
                    label: Text("Añadir todo", style: TextStyle(color: Colors.orange)),
                    onPressed: () {
                      for (var ing in ingredientes) {
                        CestaService.agregar(ing); // Añade a la lista global
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("¡Todos los ingredientes añadidos a la cesta!")),
                      );
                    },
                  )
                ],
              ),
              const SizedBox(height: 8),

// CHIPS CLICABLES INDIVIDUALES
              Wrap(
                spacing: 8.0,
                children: ingredientes.map((ing) => ActionChip( // 💡 CAMBIO: ActionChip
                  label: Text(ing),
                  backgroundColor: Colors.grey.shade800,
                  labelStyle: const TextStyle(color: Colors.white),
                  avatar: const Icon(Icons.add, size: 16, color: Colors.orange), // Un + visual
                  onPressed: () {
                    // 💡 LÓGICA: Añadir solo este ingrediente
                    CestaService.agregar(ing);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Añadido: $ing"),
                          duration: Duration(milliseconds: 800) // Rápido para no molestar
                      ),
                    );
                  },
                )).toList(),
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
                  ],
                ),
              ),

              const SizedBox(height: 40),

            ],
          ),
        ),
      ),
    );
  }
}

// --- WIDGET PRIVADO (Igual que antes) ---
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