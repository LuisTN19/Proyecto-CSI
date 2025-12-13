import 'package:flutter/material.dart';

import '../../../core/widgets/menu_inferior_widget.dart';
import '../widgets/crear_plato_widget.dart';

import '../services/comidas_service.dart';
import '../services/cesta_service.dart';



class DetallePlatoView extends StatefulWidget {
  //atribuots que recibe esta vista, tienen el valor que le pasa comidas_view
  final int id;
  final String? imagenUrl;
  final String nombre;
  final bool esFavorito;
  final double estrellas;
  final String descripcion;
  final List<String> ingredientes;
  final String tiempo;
  final String calorias;

  DetallePlatoView({super.key, required this.id, this.imagenUrl, required this.nombre, required this.esFavorito, required this.estrellas, required this.descripcion, required this.ingredientes, required this.tiempo, required this.calorias,});

  @override
  State<DetallePlatoView> createState() => _DetallePlatoViewState();
}

class _DetallePlatoViewState extends State<DetallePlatoView> {

  //Variables locales, para poder ver los cambio al editar
  String? _imagenUrl;
  late String _nombre;  //late: pq se inicializarán más tarde, en el inistate
  late bool _estaEnFavoritos;
  late double _estrellas;
  late String _descripcion;
  late List<String> _ingredientes;
  late String _tiempo;
  late String _calorias;


  @override
  void initState() {
    super.initState();
    //Inicialziamos als variables locales con los datos que nos llegan
    _imagenUrl = widget.imagenUrl; // widget pq llega desde fuera, en el paquete widget, en ningun momento se define en el state
    _nombre = widget.nombre;
    _estaEnFavoritos = widget.esFavorito;
    _estrellas = widget.estrellas;
    _descripcion = widget.descripcion;
    _ingredientes = List.from(widget.ingredientes);
    _tiempo = widget.tiempo;
    _calorias = widget.calorias;
  }

  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return MenuInferiorWidget(

      //************************************************************************
      appBar: AppBar(
        title: Text(_nombre),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            color: Colors.white,
            onPressed: _editarPlato,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            color: Colors.red,
            onPressed: () {
              _borrarPlato(context);
            },
          ),
        ],
      ),

      //************************************************************************
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
                  child: _imagenUrl != null && _imagenUrl!.isNotEmpty
                      ? Image.network(
                    _imagenUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.restaurant_menu, size: 100, color: Colors.orange);
                    },
                  )
                      : const Icon(Icons.restaurant_menu, size: 100, color: Colors.orange),
                ),
              ),

              const SizedBox(height: 24),

              // TÍTULO Y CORAZÓN
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Flexible(
                    child: Text(
                      _nombre,
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

              // ESTRELLAS -> funcion
              _buildEstrellasReales(),

              const SizedBox(height: 24),

              // DESCRIPCIÓN
              const Text(
                "Descripción",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _descripcion,
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
                      for (var ing in _ingredientes) {
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
                children: _ingredientes.map((ing) => ActionChip(
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

              // Tiempo, calorías
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [

                    Column(
                      children: [
                        const Icon(Icons.access_time, color: Colors.orange, size: 28),
                        const SizedBox(height: 4),
                        Text(_tiempo, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),

                    Column(
                      children: [
                        const Icon(Icons.local_fire_department, color: Colors.orange, size: 28),
                        const SizedBox(height: 4),
                        Text(_calorias, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),

                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------

  void _cambiarFavorito() async {
    bool nuevoEstado = !_estaEnFavoritos;
    setState(() {
      _estaEnFavoritos = nuevoEstado;
    });
    await ComidasService().putFAV(widget.id, {'favorito': nuevoEstado});
  }

  //----------------------------------------------------------------------------

  Widget _buildEstrellasReales() {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      IconData icon;
      if (_estrellas >= i) {
        icon = Icons.star;
      } else if (_estrellas >= i - 0.5) {
        icon = Icons.star_half;
      } else {
        icon = Icons.star_border;
      }
      stars.add(Icon(icon, color: Colors.amber, size: 24));
    }
    return Row(children: stars);
  }

  //----------------------------------------------------------------------------

  void _editarPlato() {
    showDialog(
      context: context,
      builder: (dialogContext) => CrearPlatoWidget(
        // Pasamos los datos actuales a la ventana
        inicialImagenUrl: _imagenUrl,
        inicialNombre: _nombre,
        inicialEstrellas: _estrellas,
        inicialDescripcion: _descripcion,
        inicialIngredientes: _ingredientes,
        inicialTiempo: _tiempo,
        inicialCalorias: _calorias,


        onGuardar: (nombre, desc, ingr, tiempo, cal, estrellas, imagen) async {
          bool exito = await ComidasService().putPLATO(
              widget.id, nombre, desc, ingr, tiempo, cal, estrellas, imagen
          );

          if (exito) {
            setState(() {
              // Actualizamos la vista al momento
              _nombre = nombre;
              _descripcion = desc;
              _ingredientes = ingr;
              _tiempo = tiempo;
              _calorias = cal;
              _estrellas = estrellas;
              // La imagen se actualizará si sales y entras o si refrescas, ya que la URL de internet tarda un pelín en cambiar o es la misma.
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Error al actualizar"), backgroundColor: Colors.red)
            );
          }
        },
      ),
    );
  }

  //----------------------------------------------------------------------------

  void _borrarPlato(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(    //le llamamos dialogContext para no confundirlo con el context de fuera
        title: const Text("¿Borrar plato?"),
        content: const Text("Este plato se eliminará permanentemente."),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),

          TextButton(
            child: const Text("Borrar", style: TextStyle(color: Colors.red)),
            onPressed: () async {
              //Cerramos el diálogo primero
              Navigator.pop(dialogContext);

              //Llamamos al servicio
              final service = ComidasService();
              bool exito = await service.deletePlato(widget.id);

              if (!mounted) return; //comprobar si la pantalla padre(detalle) sigue viva

              if (exito) {
                Navigator.pop(context, true); // Cierra la VISTA DETALLE (padre) para volver a la lista
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Error al eliminar"), backgroundColor: Colors.red)
                );
              }
            },
          ),
        ],
      ),
    );
  }
}