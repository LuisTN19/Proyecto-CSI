import 'package:flutter/material.dart';
import 'package:tugestor/domains/comidas/services/comidas_service.dart';
import '../../../core/widgets/menu_inferior_widget.dart';

import '../services/cesta_service.dart';


class DetallePlatoView extends StatefulWidget {

  final int id;
  final String nombre;
  final String? imagenUrl;
  final String descripcion;
  final List<String> ingredientes;
  final String tiempo;
  final String calorias;
  final double estrellas;
  final bool esFavorito;

  DetallePlatoView({
    super.key,
    required this.id,
    required this.nombre,
    this.imagenUrl,
    required this.descripcion,
    required this.ingredientes,
    required this.tiempo,
    required this.calorias,
    required this.estrellas,
    required this.esFavorito,
  });

  @override
  State<DetallePlatoView> createState() => _DetallePlatoViewState();
}

class _DetallePlatoViewState extends State<DetallePlatoView> {

  late bool _estaEnFavoritos;

  @override
  void initState() {
    super.initState();
    _estaEnFavoritos = widget.esFavorito;
  }

  void _cambiarFavorito() async {
    bool nuevoEstado = !_estaEnFavoritos;

    setState(() {
      _estaEnFavoritos = nuevoEstado;
    });

    await ComidasService().updatePlato(widget.id, {'favorito': nuevoEstado});
  }

  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return MenuInferiorWidget(

      appBar: AppBar(
        title: Text(widget.nombre),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            color: Colors.white,
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            color: Colors.red,
            onPressed: () {},
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // IMAGEN
              ClipRRect( // ClipRRect recorta la imagen para que tenga bordes redondeados
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                  ),
                  child: widget.imagenUrl != null && widget.imagenUrl!.isNotEmpty
                      ? Image.network(
                    widget.imagenUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.restaurant_menu, size: 100, color: Colors.orange);
                    },
                  )
                      : const Icon(Icons.restaurant_menu, size: 100, color: Colors.orange), // Si es null, mostramos icono
                ),
              ),

              const SizedBox(height: 24),

              // TÍTULO Y CORAZÓN
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      widget.nombre,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _estaEnFavoritos ? Icons.favorite : Icons.favorite_border,
                      color: Colors.orange,
                      size: 32,
                    ),
                    onPressed: _cambiarFavorito,
                  ),
                ],
              ),

              // 3. ESTRELLAS
              _buildEstrellasReales(),

              const SizedBox(height: 24),

              // DESCRIPCIÓN
              const Text(
                "Descripción",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                widget.descripcion,
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              ),

              const SizedBox(height: 24),

              // INGREDIENTES
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ingredientes",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  //
                  TextButton.icon(
                    icon: Icon(Icons.shopping_basket, size: 18, color: Colors.orange),
                    label: Text("Añadir todo", style: TextStyle(color: Colors.orange)),
                    onPressed: () {
                      for (var ing in widget.ingredientes) {
                        CestaService.agregar(ing);
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("¡Todos los ingredientes añadidos a la cesta!")),
                      );
                    },
                  )
                ],
              ),
              const SizedBox(height: 8),

              Wrap(
                spacing: 8.0,
                children: widget.ingredientes.map((ing) => ActionChip(
                  label: Text(ing),
                  backgroundColor: Colors.grey.shade800,
                  labelStyle: const TextStyle(color: Colors.white),
                  avatar: const Icon(Icons.add, size: 16, color: Colors.orange),

                  onPressed: () {
                    CestaService.agregar(ing);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text("Añadido: $ing"),
                          duration: Duration(milliseconds: 800)
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
                    _DatoIcono(Icons.access_time, widget.tiempo),
                    _DatoIcono(Icons.local_fire_department, widget.calorias),
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

  Widget _buildEstrellasReales() {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      IconData icon;
      if (widget.estrellas >= i) {
        icon = Icons.star;
      } else if (widget.estrellas >= i - 0.5) {
        icon = Icons.star_half;
      } else {
        icon = Icons.star_border;
      }
      stars.add(Icon(icon, color: Colors.amber, size: 24));
    }
    return Row(children: stars);
  }
}

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