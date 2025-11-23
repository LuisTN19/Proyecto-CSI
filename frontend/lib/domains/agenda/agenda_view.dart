import 'package:flutter/material.dart';

class AgendaView extends StatelessWidget {
  const AgendaView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 3,
        child: Scaffold(

          //....................................................................
          appBar: AppBar(
            automaticallyImplyLeading: false, //sin flechita
            bottom: const TabBar(
                labelColor: Colors.green,
                indicatorColor: Colors.green,
                labelStyle: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: 'Horario'),
                  Tab(text: 'Tareas'),
                  Tab(text: 'Calendario'),
                ]
            ),
          ),
          //....................................................................


          //....................................................................
          body: TabBarView(
            children: [

            ],
          ),
          //....................................................................


          //....................................................................
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              print("Botón + pulsado en x");
            },
            backgroundColor: Colors.green,
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