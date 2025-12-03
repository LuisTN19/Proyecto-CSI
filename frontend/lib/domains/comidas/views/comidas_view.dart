import 'package:flutter/material.dart';

import '../../../core/widgets/menu_inferior_widget.dart';
import '../widgets/platos_card_widget.dart';
import 'detalle_plato_view.dart';
import '../widgets/crear_plato_widget.dart';

import '../services/cesta_service.dart';
import '../services/comidas_service.dart';


class ComidasView extends StatefulWidget {
  const ComidasView({super.key});

  @override
  State<ComidasView> createState() => _ComidasViewState();
}


class _ComidasViewState extends State<ComidasView> {



  final PlatosService _service = PlatosService(); // 💡 1. Instancia del servicio

  // 💡 2. Lista vacía al inicio (borra tu lista _platosDeEjemplo con datos falsos)
  List<Map<String, dynamic>> _misPlatos = [];

  // 💡 3. Cargar datos al iniciar
  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  // 💡 4. Función para pedir los platos a Laravel
  void _cargarDatos() async {
    final datos = await _service.getPlatos();
    if (mounted) {
      setState(() {
        _misPlatos = datos;
      });
    }
  }

  //----------------------------------------------------------------------------

  void _cambiarFavorito(int index) async {
    final plato = _misPlatos[index];
    bool nuevoEstado = !plato['favorito'];
    int idPlato = plato['id']; // Necesitamos el ID que viene de Laravel

    // 1. Cambio visual inmediato (Optimista)
    setState(() {
      _misPlatos[index]['favorito'] = nuevoEstado;
    });

    // 2. Enviar cambio al Backend
    // Enviamos solo el campo que cambia
    await _service.updatePlato(idPlato, {'favorito': nuevoEstado});

    // Opcional: _cargarDatos(); // Si quieres asegurar sincronización total
  }



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2,
        child: MenuInferiorWidget(

          colorMAS: Colors.orange,
          pulsarMAS: () => _abrirVentanaCrear(),

          //********************************************************************

          appBar: AppBar(
            automaticallyImplyLeading: false, //sin flechita
            bottom: const TabBar(
                labelColor: Colors.orange,
                indicatorColor: Colors.orange,
                labelStyle: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: 'Platos'),
                  Tab(text: 'Cesta'),
                ]
            ),
          ),

          //********************************************************************

          body: TabBarView(
              children: [


                Padding(                                                        //PESTAÑA PLATOS
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [

                      Row(
                        children: [

                          // BUSCADOR
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Buscar...',
                                prefixIcon: const Icon(Icons.search),

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          // ORDENAR
                          IconButton(
                            icon: const Icon(Icons.swap_vert),
                            onPressed: () {},
                          ),

                          // FAVS
                          IconButton(
                            icon: const Icon(Icons.favorite_border),
                            color: Colors.red,
                            onPressed: () {},
                          ),
                        ],
                      ),

                      const SizedBox(width: 25),


                      Expanded(                                //LISTA DE PLATOS
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 20, bottom: 100),

                          itemCount: _misPlatos.length,
                          itemBuilder: (context, index) {
                            final plato = _misPlatos[index];

                            return PlatoCardWidget(
                              nombre: plato['nombre'],
                              esFavorito: plato['favorito'],
                              imagenUrl: plato['url'],
                              placeholderIcon: Icons.restaurant,


                              onToggleFavorite: () {
                                _cambiarFavorito(index);
                              },


                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetallePlatoView(
                                      nombre: plato['nombre'],
                                      imagenUrl: plato['url'],
                                      descripcion: plato['descripcion'] ?? "Sin descripción",
                                      ingredientes: List<String>.from(plato['ingredientes'] ?? []),
                                      tiempo: plato['tiempo'] ?? "N/A",
                                      calorias: plato['calorias'] ?? "N/A",
                                      estrellas: (plato['calificacion'] ?? 0).toDouble(),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        )
                      ),

                    ],
                  ),
                ),

                //..............................................................

                ValueListenableBuilder<List<String>>(                           //PESTAÑA CESTA
                  valueListenable: CestaService.itemsNotifier,
                  builder: (context, listaCompra, child) {

                    if (listaCompra.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_basket_outlined, size: 80, color: Colors.grey.shade800),
                            const SizedBox(height: 20),
                            const Text("Tu cesta está vacía", style: TextStyle(color: Colors.grey, fontSize: 18)),
                          ],
                        ),
                      );
                    }

                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Tienes ${listaCompra.length} productos", style: const TextStyle(color: Colors.white70)),
                              TextButton(
                                onPressed: () => CestaService.limpiarCesta(),
                                child: const Text("Borrar todo", style: TextStyle(color: Colors.redAccent)),
                              )
                            ],
                          ),
                        ),

                        // La Lista
                        Expanded(
                          child: ListView.builder(
                            itemCount: listaCompra.length,
                            itemBuilder: (context, index) {
                              final item = listaCompra[index];

                              return Card(
                                color: Colors.grey.shade900,
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                child: ListTile(
                                  leading: Icon(Icons.radio_button_unchecked, color: Colors.orange.shade400),

                                  title: Text(
                                    item,
                                    style: const TextStyle(color: Colors.white, fontSize: 16),
                                  ),

                                  trailing: IconButton(
                                    icon: const Icon(Icons.close, color: Colors.grey),
                                    onPressed: () => CestaService.eliminar(item),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ]
          ),
        )
    );
  }

  //----------------------------------------------------------------------------

  void _abrirVentanaCrear() {
    showDialog(
      context: context,
      builder: (context) {
        return CrearPlatoWidget(
          onGuardar: _crearPlato,
        );
      },
    );
  }

  void _crearPlato(
      String nombre,
      String descripcion,
      List<String> ingredientes,
      String tiempo,
      String calorias,
      double estrellas) async { // 💡 Ahora es async

    // Preparamos el mapa de datos para enviar
    Map<String, dynamic> nuevoPlato = {
      'nombre': nombre,
      'descripcion': descripcion,
      'ingredientes': ingredientes,
      'tiempo': tiempo,
      'calorias': calorias,
      'calificacion': estrellas,
      'url': null, // Por ahora null, luego podrías añadir subir foto
    };

    // 💡 LLAMADA AL SERVICIO
    bool exito = await _service.postPlato(nuevoPlato);

    if (exito) {
      _cargarDatos(); // Si se guardó bien, recargamos la lista del servidor
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Plato creado con éxito")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error al guardar"), backgroundColor: Colors.red));
    }
  }
}