import 'package:flutter/material.dart';
import 'habitos_card_widget.dart';


class HabitosView extends StatefulWidget {
  const HabitosView({super.key});

  @override
  State<HabitosView> createState() => _HabitosViewState();
}


//------------------------------------------------------------------------------


class _HabitosViewState extends State<HabitosView> {

  //DATOS DE EJEMPLO
  final List<String> por_hacer = [
    'Meditar',
    'Beber agua 5L',
    'Hacer la cama',
  ];

  final List<String> completados = [
    'Leer 10 páginas'
  ];


  void _alPulsarHabito(String habito_pulsado, bool lo_estamos_completando) {
    setState(() {   //redibujar la pantalla
      if (lo_estamos_completando == true) {
        por_hacer.remove(habito_pulsado);
        completados.add(habito_pulsado);
      } else {
        completados.remove(habito_pulsado);
        por_hacer.add(habito_pulsado);
      }
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
                labelColor: Colors.red,
                indicatorColor: Colors.red,
                labelStyle: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: 'Por Hacer'),
                  Tab(text: 'Completados'),
                ]
            ),
          ),
          //....................................................................


          //....................................................................
          body: TabBarView(
            children: [

              ListView.builder(                                                 //PESTAÑA: Por Hacer
                itemCount: por_hacer.length,

                itemBuilder: (contexto_fila, indice) {
                  final String habito = por_hacer[indice];
                  return HabitosCardWidget(
                    habito: habito,
                    esta_completado: false,
                    al_pulsar_check: () {
                      _alPulsarHabito(habito, true); // true = lo estamos completando
                    },
                  );
                },
              ),


              ListView.builder(                                                 //PESTAÑA: Completados
                itemCount: completados.length,

                itemBuilder: (contexto_fila, indice) {
                  final String nombre_habito = completados[indice];
                  return HabitosCardWidget(
                    habito: nombre_habito,
                    esta_completado: true,

                    al_pulsar_check: () {
                      _alPulsarHabito(nombre_habito, false);
                    },
                  );
                },
              ),
            ],
          ),
          //....................................................................


          //....................................................................
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              print("Botón + pulsado en Hábitos");
            },
            backgroundColor: Colors.red,
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