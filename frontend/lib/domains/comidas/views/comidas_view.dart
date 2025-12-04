import 'package:flutter/material.dart';

import '../../../core/widgets/menu_inferior_widget.dart';
import '../widgets/platos_card_widget.dart';
import 'detalle_plato_view.dart';
import '../widgets/crear_plato_widget.dart';

import '../services/cesta_service.dart';
import '../services/comidas_service.dart';


enum Orden { reciente, alfabetico, estrellas }

class ComidasView extends StatefulWidget {
  const ComidasView({super.key});

  @override
  State<ComidasView> createState() => _ComidasViewState();
}


class _ComidasViewState extends State<ComidasView> {

  List<Map<String, dynamic>> listaPlatos = [];  // todos los platos de la BD
  List<Map<String, dynamic>> _platosVisibles = [];  // platos q se ven por pantalla (búsqueda)

  final _service = ComidasService();

  //VARIABLES DE FILTROS
  String _busqueda = ""; // Lo que escribe el usuario
  Orden _ordenActual = Orden.reciente; // var para guardar el orden actual
  bool _soloFavoritos = false;
  //----------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() async {
    final datos = await _service.getPlatos();
    if (mounted) {
      setState(() {
        listaPlatos = datos;
        _aplicarBusqueda(); //para que respete el orden de busqueda actual
      });
    }
  }

  //----------------------------------------------------------------------------

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

                          Expanded( // BUSCADOR
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: 'Buscar...',
                                prefixIcon: const Icon(Icons.search),

                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                              ),

                              onChanged: (texto) {
                                _busqueda = texto; // Guardamos el texto
                                _aplicarBusqueda(); // Ejecutamos el filtro
                              },
                            ),
                          ),

                          const SizedBox(width: 8),


                          PopupMenuButton<Orden>( //ORDENAR
                            icon: Icon(Icons.swap_vert, color: Colors.white),
                            color: Colors.grey.shade800,

                            onSelected: (Orden nuevoOrden) {
                              _ordenActual = nuevoOrden;
                              _aplicarBusqueda();
                            },

                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: Orden.reciente,
                                child: Text("Más recientes", style: TextStyle(color: Colors.white)),
                              ),
                              const PopupMenuItem(
                                value: Orden.alfabetico,
                                child: Text("Alfabético (A-Z)", style: TextStyle(color: Colors.white)),
                              ),
                              const PopupMenuItem(
                                value: Orden.estrellas,
                                child: Text("Mejor valorados", style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),


                          IconButton( // FAVS
                            icon: Icon(_soloFavoritos ? Icons.favorite : Icons.favorite_border, color: Colors.red),
                            onPressed: () {
                              _soloFavoritos = !_soloFavoritos;
                              _aplicarBusqueda();
                            },
                          ),
                        ],
                      ),

                      const SizedBox(width: 25),


                      Expanded(                                //LISTA DE PLATOS
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 20, bottom: 100),

                          itemCount: _platosVisibles.length,
                          itemBuilder: (context, index) {
                            final plato = _platosVisibles[index];

                            return PlatoCardWidget(
                              imagenUrl: plato['url'],
                              nombre: plato['nombre'],
                              esFavorito: plato['favorito'],
                              estrellas: plato['calificacion'],
                              icono: Icons.restaurant,

                              onFav: () {
                                _cambiarFavorito(index);
                              },

                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetallePlatoView(
                                      id: plato['id'],
                                      nombre: plato['nombre'],
                                      imagenUrl: plato['url'],
                                      descripcion: plato['descripcion'] ?? "Sin descripción",
                                      ingredientes: List<String>.from(plato['ingredientes'] ?? []),
                                      tiempo: plato['tiempo'] ?? "N/A",
                                      calorias: plato['calorias'] ?? "N/A",
                                      estrellas: (plato['calificacion'] ?? 0).toDouble(),
                                      esFavorito: plato['favorito'],
                                    ),
                                  ),
                                );
                                _cargarDatos();
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
                              Text("Tienes ${listaCompra.length} productos", style: const TextStyle(color: Colors.white70, fontSize: 16)),
                              TextButton(
                                onPressed: () => CestaService.limpiarCesta(),
                                child: const Text("Borrar todo", style: TextStyle(color: Colors.redAccent, fontSize: 16)),
                              )
                            ],
                          ),
                        ),

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

                                  title: Text(
                                    item,
                                    style: const TextStyle(color: Colors.white, fontSize: 18),
                                  ),

                                  trailing: IconButton(
                                    icon: const Icon(Icons.close, color: Colors.orange),
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

  // POST
  void _crearPlato(String nombre, String descripcion, List<String> ingredientes, String tiempo, String calorias, double estrellas) async {

    Map<String, dynamic> nuevoPlato = {
      'nombre': nombre,
      'descripcion': descripcion,
      'ingredientes': ingredientes,
      'tiempo': tiempo,
      'calorias': calorias,
      'calificacion': estrellas,
      'url': null,
    };

    bool exito = await _service.postPlato(nuevoPlato);

    if (exito) {
      _cargarDatos();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Plato creado con éxito")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error al guardar"), backgroundColor: Colors.red));
    }
  }

  //----------------------------------------------------------------------------

  // PUT
  void _cambiarFavorito(int index) async {
    final plato = listaPlatos[index];
    bool nuevoEstado = !plato['favorito'];
    int idPlato = plato['id'];

    setState(() {
      listaPlatos[index]['favorito'] = nuevoEstado;
    });

    await _service.updatePlato(idPlato, {'favorito': nuevoEstado});
  }

  //----------------------------------------------------------------------------

  //FUNCIÓN TANTO PARA LA BÚSQUEDA, ORDENACIÓN Y FILTRO DE FAVs
  void _aplicarBusqueda() {
    setState(() {

      var listaTemporal = List<Map<String, dynamic>>.from(listaPlatos);

      //BUSQUEDA ************************************************
      if (_busqueda.isNotEmpty) {
        listaTemporal = listaTemporal.where((plato) {
          final nombre = plato['nombre'].toString().toLowerCase();
          final textoBusqueda = _busqueda.toLowerCase();
          return nombre.startsWith(textoBusqueda); //para que busque solo por como empieza
        }).toList();
      }

      //FAVORITOS *************************************************
      if (_soloFavoritos) {
        listaTemporal = listaTemporal.where((plato) {
          return plato['favorito'] == true || plato['favorito'] == 1;
        }).toList();
      }

      //ORDENACIÓN *************************************************
      switch (_ordenActual) {
        case Orden.alfabetico:
        // A -> Z (Ascendente: a contra b)
          listaTemporal.sort((a, b) {
            String nombreA = a['nombre'].toString().toLowerCase();
            String nombreB = b['nombre'].toString().toLowerCase();
            return nombreA.compareTo(nombreB);
          });
          break;

        case Orden.estrellas:
        // 5 -> 0 (Descendente: b contra a)
          listaTemporal.sort((a, b) {
            double ratingA = (a['calificacion'] ?? 0).toDouble();
            double ratingB = (b['calificacion'] ?? 0).toDouble();
            return ratingB.compareTo(ratingA);
          });
          break;

        case Orden.reciente:
        // ID más alto primero (Descendente: b contra a)
          listaTemporal.sort((a, b) {
            int idA = a['id'];
            int idB = b['id'];
            return idB.compareTo(idA);
          });
          break;
      }
      
      _platosVisibles = listaTemporal;
    });
  }

}