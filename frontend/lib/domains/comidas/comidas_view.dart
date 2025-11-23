import 'package:flutter/material.dart';
import 'platos_card_widget.dart';
import 'detalle_plato_view.dart';


class ComidasView extends StatefulWidget {
  const ComidasView({super.key});

  @override
  State<ComidasView> createState() => _ComidasViewState();
}

class _ComidasViewState extends State<ComidasView> {


  List<Map<String, dynamic>> lista_platos = [
    {'nombre': 'Pollo Asado', 'fav': true},
    {'nombre': 'Ensalada César', 'fav': false},
    {'nombre': 'Macarrones con Tomate', 'fav': false},
    {'nombre': 'Salmón a la Plancha', 'fav': true},
    {'nombre': 'Tortilla de Patatas', 'fav': true},
    {'nombre': 'Lentejas', 'fav': false},
  ];

  void _cambiarFavorito(int indice) {
    setState(() {
      lista_platos[indice]['fav'] = !lista_platos[indice]['fav'];
    });
  }



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2,
        child: Scaffold(

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

                          // EL FILTRO
                          IconButton(
                            icon: const Icon(Icons.tune),
                            onPressed: () {},
                          ),

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

                      //LISTA DE PLATOS
                      Expanded(
                        child: ListView.builder(
                          itemCount: lista_platos.length,

                          itemBuilder: (context, index) {
                            final plato = lista_platos[index];

                            return PlatoCardWidget(
                              nombre: plato['nombre'],
                              es_favorito: plato['fav'],
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetallePlatoView(
                                      nombre: plato['nombre'],
                                    ),
                                  ),
                                );
                              },
                              onFavoritoPressed: () {
                                _cambiarFavorito(index);
                              },

                            );
                          },
                        ),
                      ),

                    ],
                  ),
                ),


                const Center(child: Text("Lista de la compra")),                //PESTAÑA CESTA
              ]
          ),
          //....................................................................


          //....................................................................
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              print("Botón + pulsado en x");
            },
            backgroundColor: Colors.orange,
            child: const Icon(Icons.add, color: Colors.white),                  //BOTÓN +
          ),

          //para que se ponga en el centro:
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          //.....................................................................


          //....................................................................
          bottomNavigationBar: BottomAppBar(

            shape: const CircularNotchedRectangle(), //la muesca

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(                                                     //BOTÓN CASITA
                  icon: const Icon(Icons.home, size: 30),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),

                const SizedBox(width: 48),

                IconButton(                                                     //BOTÓN PERFIL
                  icon: const Icon(Icons.person_outline, size: 30),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          //....................................................................

        )
    );
  }
}