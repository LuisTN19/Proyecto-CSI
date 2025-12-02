import 'package:flutter/material.dart';
import 'package:tugestor/core/widgets/menu_inferior_widget.dart';
import '../widgets/platos_card_widget.dart';
import 'detalle_plato_view.dart';
import '../services/cesta_service.dart';
import '../widgets/crear_plato_widget.dart';

class ComidasView extends StatefulWidget {
  const ComidasView({super.key});

  @override
  State<ComidasView> createState() => _ComidasViewState();
}

class _ComidasViewState extends State<ComidasView> {


  List<Map<String, dynamic>> lista_platos = [];
  final List<Map<String, dynamic>> _platosDeEjemplo = [
    {
      'nombre': 'Lentejas con verduras',
      'favorito': true,
      'url': 'https://picsum.photos/id/1084/100/100', // URL con imagen
      'placeholderIcon': Icons.restaurant,
    },
    {
      'nombre': 'Pollo al Curry',
      'favorito': false,
      'url': null, // Sin imagen, usará el ícono
      'placeholderIcon': Icons.home_work,
    },
    {
      'nombre': 'Ensalada de Quinoa',
      'favorito': true,
      'url': 'https://picsum.photos/id/1025/100/100',
      'placeholderIcon': Icons.local_dining,
    },
  ];

  void _cambiarFavorito(int indice) {
    setState(() {
      _platosDeEjemplo[indice]['favorito'] = !_platosDeEjemplo[indice]['favorito'];
    });
  }



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2,
        child: MenuInferiorWidget(

          colorMAS: Colors.orange,
          pulsarMAS: () => _abrirVentanaCrear(),

          //....................................................................
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
          //....................................................................


          //....................................................................
          body: TabBarView(
              children: [


                Padding(                                                        //PESTAÑA PLATOS
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [

                      Row(
                        children: [

                          // EL BUSCADOR
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

                      //LISTA DE PLATOS
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 20, bottom: 100),

                          itemCount: _platosDeEjemplo.length,
                          itemBuilder: (context, index) {
                            final plato = _platosDeEjemplo[index];

                            return PlatoCardWidget(
                              nombre: plato['nombre'] as String,
                              esFavorito: plato['favorito'] as bool,

                              // ✅ NUEVOS/REVERTIDOS ATRIBUTOS:
                              imagenUrl: plato['url'] as String?, // Puede ser nulo
                              placeholderIcon: plato['placeholderIcon'] as IconData, // Debe ser IconData

                              // ❌ ELIMINAMOS: calificacion: (plato['calificacion'] as int?) ?? 0,

                              onToggleFavorite: () {
                                _cambiarFavorito(index);
                              },

                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetallePlatoView(
                                      nombre: plato['nombre'],
                                      imagenUrl: plato['url'], // <--- ¡AÑADIR ESTO! (la clave de tu mapa de datos)
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


                ValueListenableBuilder<List<String>>(                           //PESTAÑA CESTA
                  valueListenable: CestaService.itemsNotifier,
                  builder: (context, listaCompra, child) {

                    // 1. Si está vacía, mostramos mensaje bonito
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

                    // 2. Si hay cosas, mostramos la lista con estilo oscuro
                    return Column(
                      children: [
                        // Cabecera opcional para borrar todo
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
                                  // Checkbox visual (no funcional, solo estético o para marcar)
                                  leading: Icon(Icons.radio_button_unchecked, color: Colors.orange.shade400),

                                  title: Text(
                                    item,
                                    style: const TextStyle(color: Colors.white, fontSize: 16),
                                  ),

                                  // Botón de basura para borrar este ítem concreto
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
      String dificultad,
      int estrellas) {

    setState(() {
      _platosDeEjemplo.add({
        'nombre': nombre,
        'favorito': false, // Por defecto no es favorito
        'url': null,       // Por defecto sin imagen (sale el placeholder)
        'placeholderIcon': Icons.restaurant, // Icono por defecto

        // Guardamos los datos extra para pasarlos luego al Detalle
        'descripcion': descripcion,
        'ingredientes': ingredientes,
        'tiempo': tiempo,
        'calorias': calorias,
        'dificultad': dificultad,
        'calificacion': estrellas,
      });
    });
  }
}